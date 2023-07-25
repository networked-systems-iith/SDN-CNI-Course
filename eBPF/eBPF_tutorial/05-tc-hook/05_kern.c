#include <stddef.h>
#include <stdbool.h>
#include <linux/pkt_cls.h>
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <linux/ptrace.h>
#include <linux/version.h>
#include <iproute2/bpf_elf.h>
#include <linux/in.h>
#include <linux/if_ether.h>
#include <linux/if_packet.h>
#include <linux/ipv6.h>
#include <linux/ip.h>
#include <linux/icmp.h>
#include <linux/icmpv6.h>
#include <linux/udp.h>
#include <linux/tcp.h>
#include <bpf/bpf_endian.h>

//#include "common.h"

#define RET 0
#define IP_PKT 0
#define ICMP_PKT 1
#define UDP_PKT 2 
#define TCP_PKT 3
struct datarec {
    __u32 rx_packets;
};
struct {
	__uint(type, BPF_MAP_TYPE_ARRAY);
	__type(key, __u32);
	__type(value, struct datarec);
	__uint(max_entries, 4);
	__uint(pinning, LIBBPF_PIN_BY_NAME);
} packet_counter_map SEC (".maps");

SEC("packet_counter")
int parse_pkt(struct __sk_buff *skb)
{
    void *data = (void *)(long)skb->data;
    void *data_end = (void *)(long)skb->data_end;
    struct datarec *rec;
    __u32 key = 0;

    if(data < data_end)
    {
        struct ethhdr *eth = data;
        if (data + sizeof(*eth) > data_end)
            return TC_ACT_SHOT;

        if (bpf_htons(eth->h_proto) != 0x0800) {
            bpf_printk("Received non IP packet with eth thype = %x", bpf_htons(eth->h_proto));
            return TC_ACT_UNSPEC;
        }


        struct iphdr *iph = data + sizeof(*eth);
        if (data + sizeof(*eth) + sizeof(*iph) > data_end)
            return TC_ACT_SHOT;

        bpf_printk("Received IP pkt with ip_src=%x, ip_dst=%x, proto=%d", bpf_htonl(iph->saddr), bpf_htonl(iph->daddr), iph->protocol);
        key = IP_PKT;
        rec = bpf_map_lookup_elem(&packet_counter_map, &key);
        if(rec == NULL)
        {
            return TC_ACT_SHOT;
        }
        rec->rx_packets = rec->rx_packets + 1;

        /* send only TCP packets*/
        if (iph->protocol == 0x6) 
        {
            struct tcphdr *tcph = data + sizeof(*eth) + sizeof(*iph);
            if (data + sizeof(*eth) + sizeof(*iph) + sizeof(*tcph) > data_end)
                return TC_ACT_SHOT;
            bpf_printk("Received TCP pkt with l4_sport=%d, l4_dport=%d", bpf_htons(tcph->source), bpf_htons(tcph->dest));
            key = TCP_PKT;
            rec = bpf_map_lookup_elem(&packet_counter_map, &key);
            if(rec == NULL)
            {
                return TC_ACT_SHOT;
            }
            rec->rx_packets = rec->rx_packets + 1;

        }
        else if (iph->protocol == 0x11)
        {
           struct udphdr *udph = data + sizeof(*eth) + sizeof(*iph);
           if (data + sizeof(*eth) + sizeof(*iph) + sizeof(*udph) > data_end)
               return TC_ACT_SHOT;
           bpf_printk("Received UDP pkt with l4_sport=%d, l4_dport=%d", bpf_htons(udph->source), bpf_htons(udph->dest));
           key = UDP_PKT;
           rec = bpf_map_lookup_elem(&packet_counter_map, &key);
           if(rec == NULL)
           {
               return TC_ACT_SHOT;
           }

           rec->rx_packets = rec->rx_packets + 1;
        }
        else if (iph->protocol == 0x01)
        {
            bpf_printk("Received ICMP packet");
            key = ICMP_PKT;
            rec = bpf_map_lookup_elem(&packet_counter_map, &key);
            if(rec == NULL)
            {
                return TC_ACT_SHOT;
            }

            rec->rx_packets = rec->rx_packets + 1;
        }

        return RET;
    }
    return RET;

}
char _license[] SEC("license") = "GPL";
