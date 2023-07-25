/* SPDX-License-Identifier: GPL-2.0 */
#include <stddef.h>
#include <linux/bpf.h>
#include <linux/in.h>
#include <linux/if_ether.h>
#include <linux/if_packet.h>
#include <linux/ipv6.h>
#include <linux/ip.h>
#include <linux/icmp.h>
#include <linux/icmpv6.h>
#include <linux/udp.h>
#include <linux/tcp.h>
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_endian.h>
//#include "../common/xdp_stats_kern_user.h"

/* Header cursor to keep track of current parsing position */
struct hdr_cursor {
	void *pos;
};

struct datarec {
	__u64 rx_packets;
	//__u64 rx_bytes;
};

/* Packet parsing helpers.
 *
 * Each helper parses a packet header, including doing bounds checking, and
 * returns the type of its contents if successful, and -1 otherwise.
 *
 * For Ethernet and IP headers, the content type is the type of the payload
 * (h_proto for Ethernet, nexthdr for IPv6), for ICMP it is the ICMP type field.
 * All return values are in host byte order.
 */

#ifndef VLAN_MAX_DEPTH
#define VLAN_MAX_DEPTH 2
#endif

enum hdr_types {
	VLAN = 0,
	IPV4,
	ICMP,
	UDP,
	TCP,
};


struct bpf_map_def SEC("maps") xdp_hdr_map = {
	.type        = BPF_MAP_TYPE_PERCPU_ARRAY,
	.key_size    = sizeof(__u32),
	.value_size  = sizeof(struct datarec),
	.max_entries = 5,
};

struct vlan_hdr {
        __be16 h_vlan_TCI;
        __be16 h_vlan_encapsulated_proto;
};

static __always_inline int proto_is_vlan(__u16 h_proto)
{
	return !!(h_proto == bpf_htons(ETH_P_8021Q) || h_proto == bpf_htons(ETH_P_8021AD));
}

static __always_inline int parse_VLAN(struct hdr_cursor *nh,
				      void *data_end,
				      struct ethhdr **ethhdr)
{
	struct ethhdr *eth = nh->pos;
	struct vlan_hdr *vlh;
	__u16 h_proto;
	int i;

	int hdrsize = sizeof(*eth);
	if(nh->pos + hdrsize > data_end)
		return -1;

	nh->pos += hdrsize;
	*ethhdr = eth;

	vlh = nh->pos;
	h_proto = eth->h_proto;

	#pragma unroll
	for (i=0; i < VLAN_MAX_DEPTH; i++){
		if(!proto_is_vlan(h_proto)) break;

		if (vlh + 1 > data_end) break;

		h_proto = vlh->h_vlan_encapsulated_proto;
		vlh++;
	}

	nh->pos = vlh;
	return h_proto;	
}


static __always_inline int parse_ipv4hdr(struct hdr_cursor *nh,
					 void *data_end,
					 struct iphdr **iphdr)
{
	struct iphdr *iph = nh->pos;
	int hdrsize;

	if (iph + 1 > data_end)
		return -1;

	hdrsize = iph->ihl * 4;

	/* Sanity check packet field is valid */
	if(hdrsize < sizeof(*iph))
		return -1;

	/* Variable-length IPv4 header, need to use byte-based arithmetic */
	if (nh->pos + hdrsize > data_end)
		return -1;

	nh->pos += hdrsize;
	*iphdr = iph;

	return iph->protocol;
}


static __always_inline int parse_icmphdr(struct hdr_cursor *nh,
					 void *data_end,
					 struct icmphdr **icmphdr)
{
	struct icmphdr *icmph = nh->pos;

	if(icmph + 1 > data_end)
		return -1;

	nh -> pos = icmph + 1;
	*icmphdr = icmph;

	return icmph->type;
}


/* parse the udp header and return length of udp payload */
static __always_inline int parse_udphdr(struct hdr_cursor *nh,
					void *data_end,
					struct udphdr **udphdr)
{
	int len;
	struct udphdr *h = nh->pos;

	if(h+1 > data_end)
		return -1;

	len = bpf_ntohs(h->len) - sizeof(struct udphdr);
	if(len < 0)
		return -1;
	
	nh -> pos = h+1;
	*udphdr = h;

	return len;
}

static __always_inline int parse_tcphdr(struct hdr_cursor *nh,
					void *data_end,
					struct tcphdr **tcphdr)
{
	int len;
	struct tcphdr *h = nh->pos;
	
	if(h+1 > data_end)
		return -1;

	len = h->doff * 4;
	if(len < sizeof(*h))
		return -1;

	if(nh->pos + len > data_end)
		return -1;

	nh->pos += len;
	*tcphdr = h;

	return len;	
}



SEC("xdp_packet_counter")
int  xdp_parser_func(struct xdp_md *ctx)
{
	void *data_end = (void *)(long)ctx->data_end;
	void *data = (void *)(long)ctx->data;
	struct ethhdr *eth;
	struct iphdr *ip;
	struct icmphdr *icmp;
	struct udphdr *udp;
	struct tcphdr *tcp;

	//__u64 bytes_recvd = data_end - data;

	/* Default action XDP_PASS, imply everything we couldn't parse, or that
	 * we don't want to deal with, we just pass up the stack and let the
	 * kernel deal with it.
	 */
	__u32 action = XDP_PASS; /* Default action */

        /* These keep track of the next header type and iterator pointer */
	struct hdr_cursor nh;
	int nh_type;

	/* Start next header cursor position at data start */
	nh.pos = data;

	/* Packet parsing in steps: Get each header one at a time, aborting if
	 * parsing fails. Each helper function does sanity checking (is the
	 * header type in the packet correct?), and bounds checking.
	 */

	/* Assignment additions go below here */
	struct datarec *rec;

	// parsing VLAN 

	nh_type = parse_VLAN(&nh, data_end, &eth);
	int type = VLAN;
	
	if (nh_type>=0 && proto_is_vlan(eth -> h_proto))
	{

		rec = bpf_map_lookup_elem(&xdp_hdr_map, &type); 
		if (rec)
		{
			rec -> rx_packets++;
			//rec -> rx_bytes += bytes_recvd;
		}
	}
		
	// parsing IP
	
	nh_type = parse_ipv4hdr(&nh, data_end, &ip);

	type = IPV4;
        rec = bpf_map_lookup_elem(&xdp_hdr_map, &type);

	if(nh_type == IPPROTO_ICMP || nh_type == IPPROTO_UDP || nh_type == IPPROTO_TCP)
	{
        	if(rec)
        	{
                	rec -> rx_packets++;
                	//rec -> rx_bytes += bytes_recvd;
        	}
	}

	// checking whether ICMP, UDP or TCP
	switch(nh_type)
	{
		int len = 0;

		case IPPROTO_ICMP:

			nh_type = parse_icmphdr(&nh, data_end, &icmp);
		        if (nh_type != ICMP_ECHO)
                		goto out;
        		
			type = ICMP;
        		rec = bpf_map_lookup_elem(&xdp_hdr_map, &type);
        		if(rec)
        		{
                		rec -> rx_packets++;
               			//rec -> rx_bytes += bytes_recvd;

				/*
				 * Sequence number of icmp packet acts as a counter
                	         * if it is odd, then drop the packet. Else default action is to pass.
				 * If packet gets passed up the kernel, then it'll receive appropriate response.
				 */
				int seq_no = bpf_ntohs(icmp -> un.echo.sequence);	
	                        if(seq_no % 2 == 0)
        	                        action = XDP_DROP; 	
        		}
			
		break;
		
		case IPPROTO_UDP:
			
			len = parse_udphdr(&nh, data_end, &udp);
			if(len == -1)
				goto out;
			
			type = UDP;
			rec = bpf_map_lookup_elem(&xdp_hdr_map, &type);
			if(rec)
			{
				rec -> rx_packets++;
				//rec -> rx_bytes += bytes_recvd;
			}

		break;

		case IPPROTO_TCP:
			
			len = parse_tcphdr(&nh, data_end, &tcp);
			if(len == -1)
				goto out;

			type = TCP;
			rec = bpf_map_lookup_elem(&xdp_hdr_map, &type);
			if(rec)
			{
				rec -> rx_packets++;
				//rec -> rx_bytes += bytes_recvd;
			}
		
		break;

		default:
			goto out;

	}


out:
	return action;
}

char _license[] SEC("license") = "GPL";
