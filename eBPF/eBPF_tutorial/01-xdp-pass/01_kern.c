/* SPDX-License-Identifier: GPL-2.0 */
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>

SEC("xdp")
int  xdp_prog_simple(struct xdp_md *ctx)
{
	 bpf_printk("Hello World...!!!");
	 //Run "sudo cat /sys/kernel/debug/tracing/trace_pipe" to see the output for every received packet
	 return XDP_PASS;
	// return XDP_DROP;
}

char _license[] SEC("license") = "GPL";
