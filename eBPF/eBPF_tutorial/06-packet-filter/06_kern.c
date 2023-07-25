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

/* Header cursor to keep track of current parsing position */
struct hdr_cursor {
	void *pos;
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


SEC("xdp_packet_filter")
int  xdp_parser_func(struct xdp_md *ctx)
{
	void *data_end = (void *)(long)ctx->data_end;
	void *data = (void *)(long)ctx->data;
	struct ethhdr *eth;
	struct iphdr *ip;

	//__u64 bytes_recvd = data_end - data;

	/* Default action XDP_PASS, imply everything we couldn't parse, or that
	 * we don't want to deal with, we just pass up the stack and let the
	 * kernel deal with it.
	 */

        /* These keep track of the next header type and iterator pointer */
	struct hdr_cursor nh;
	int nh_type;

	/* Start next header cursor position at data start */
	nh.pos = data;

	/* Packet parsing in steps: Get each header one at a time, aborting if
	 * parsing fails. Each helper function does sanity checking (is the
	 * header type in the packet correct?), and bounds checking.
	 */

	// parsing VLAN 

	nh_type = parse_VLAN(&nh, data_end, &eth);
	
	// parsing IP
	
	nh_type = parse_ipv4hdr(&nh, data_end, &ip);

	if(nh_type == IPPROTO_TCP){
		bpf_printk("Dropping TCP packets...!!!");
		return XDP_DROP;
	}

	bpf_printk("PASSING packets...!!!");
	return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
