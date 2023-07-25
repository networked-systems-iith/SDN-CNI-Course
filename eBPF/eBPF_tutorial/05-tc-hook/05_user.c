/*
	Xflow_ringbuf_test_user : User-space program to load and consume the flow record entries of the ring-buffer
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <getopt.h>
#include <stdbool.h>
#include <math.h>
#include <locale.h>
#include <unistd.h>
#include <time.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <signal.h>
#include <stdint.h>

#include <bpf/bpf.h>
#include <bpf/libbpf.h>
#include <sys/resource.h>

#include <net/if.h>
#include <linux/if_ether.h>
#include <linux/if_link.h> /* depend on kernel-headers installed */
#include <linux/bpf.h>

#include "../common/common_user_bpf_xdp.h"
#include "../common/common_params.h"
#include "../common/xdp_stats_kern_user.h"
#include "../common/common_defines.h"

#define TASK_COMM_LEN 16
#define MAX_FILENAME_LEN 512
#define TC_HOOK_EXISTS
static volatile bool exiting = false;
//struct bpf_tc_hook my_egress_tc_hook;
struct bpf_tc_hook my_ingress_tc_hook;

//struct bpf_tc_opts my_egress_tc_opts;
struct bpf_tc_opts my_ingress_tc_opts;

char iface[32];
//unsigned int ifindex = 65535;
unsigned int ifindex = 8;
uint64_t pkt_counter = 0;


char xflow_pin_base_dir[] =  "/sys/fs/bpf/";
char packet_counter_map_name[] = "packet_counter_map";
/*struct event {
    int pid;
    char comm[TASK_COMM_LEN];
    char filename[MAX_FILENAME_LEN];
};
*/
static void tc_cleanup () {
    int err;
/*    err = bpf_tc_hook_destroy(&my_egress_tc_hook);
    if (err != 0) {
        fprintf(stderr, "Failed to destroy tc hook, err=%s\n", strerror(err));
        printf("failed to destroye hooks\n");
    }*/
    err = bpf_tc_hook_destroy(&my_ingress_tc_hook);
    if (err != 0) {
        fprintf(stderr, "Failed to destroy tc hook, err=%s\n", strerror(err));
        printf("failed to destroye hooks\n");
    }
    printf("Destroyed all hooks\n");
}
void map_cleanup()
{
	int packet_counter_map;
	int i = 0;
	struct datarec *value;
	packet_counter_map = open_bpf_map_file(xflow_pin_base_dir, packet_counter_map_name, NULL);

	printf("\ncalling clean up");
	for (i = 0; i < 4; i++)
	{
		if(bpf_map_lookup_elem(packet_counter_map, &i, value) != 0)
		{

			fprintf(stderr,"ERR: map lookup\n");

		}
		else
		{
			value->rx_packets = 0;
			bpf_map_update_elem(packet_counter_map, &i, value, BPF_ANY);
		}
	}
}


static void sig_handler(int sig) {
    printf("Cleaning up..\n");
    tc_cleanup();
    map_cleanup();
    exiting = true;
    exit(1);
}

void bump_memlock_rlimit(void) {
    struct rlimit rlim_new = {
        .rlim_cur = RLIM_INFINITY,
        .rlim_max = RLIM_INFINITY,
    };

    if (setrlimit(RLIMIT_MEMLOCK, &rlim_new))
    {
        fprintf(stderr, "Failed to increase RLIMIT_MEMLOCK limit!\n");
        exit(1);
    }
}

void  print_usage(){
	printf("./05_user -i <interface> \n");
}


static const struct option long_options[] = {
	{"interface", required_argument,       0,  'i' },
	{0,           0, NULL,  0   }
};

int parse_params(int argc, char *argv[]) {
    int opt= 0;
    int long_index =0;

    while ((opt = getopt_long(argc, argv,"i:",
                   long_options, &long_index )) != -1) {
      switch (opt) {
		  case 'i' :
		  	strncpy(iface, optarg, 32);
			ifindex = if_nametoindex(iface);
		  	break;
		  default:
		  	print_usage();
		  	exit(EXIT_FAILURE);
        }
    }
    return 0;
}

void print_counter( )
{
    int packet_counter_map;
    int i = 0;
    struct datarec *value;
    packet_counter_map = open_bpf_map_file(xflow_pin_base_dir, packet_counter_map_name, NULL);
    
    while (1)
    {
	    for (i = 0; i < 4; i++)
	    {
		    if(bpf_map_lookup_elem(packet_counter_map, &i, value) != 0)
		    {

			    fprintf(stderr,"ERR: map lookup\n");

		    }
		    else
		    {
			    switch(i) {
				    case 0: printf("IP packet count is %llu\n", value->rx_packets);
					    break;
				    case 1: printf("ICMP packet count is %llu\n", value->rx_packets);
					    break;
				    case 2: printf("UDP packet count is %llu\n", value->rx_packets);
					    break;
				    case 3: printf("TCP packet count is %llu\n", value->rx_packets);
					    break;
				    default: break;
			    }
		    }
	    }

	    printf("\n===================================================\n");
	    sleep(5);
    }
}


int main(int argc, char *argv[])
{

    const char *bpf_file = "05_kern.o";
    struct bpf_object *obj;
    int prog_fd = -1;
//    int my_egress_prog_fd = -1;
    int my_ingress_prog_fd = -1;

//    struct bpf_program *egress_prog; struct bpf_program *ingress_prog;
    struct bpf_program *ingress_prog;
//    struct bpf_program *egress_prog;
    int err;
    //int interface_ifindex = 4;
    char error[32];
    
    if(parse_params(argc,argv)!=0) {
  		fprintf(stderr, "ERR: parsing params\n");
  		return EXIT_FAIL_OPTION;
	}

    printf("Running on interface idx-%d\n", ifindex);
/*
    memset(&my_egress_tc_hook, 0, sizeof(my_egress_tc_hook));
    my_egress_tc_hook.sz = sizeof(my_egress_tc_hook);
    my_egress_tc_hook.ifindex = ifindex;
    my_egress_tc_hook.attach_point = BPF_TC_EGRESS;
*/
    memset(&my_ingress_tc_hook, 0, sizeof(my_ingress_tc_hook));
    my_ingress_tc_hook.sz = sizeof(my_ingress_tc_hook);
    my_ingress_tc_hook.ifindex = ifindex;
    my_ingress_tc_hook.attach_point = BPF_TC_INGRESS;
/*
    err = bpf_tc_hook_create(&my_egress_tc_hook);
    if (err != 0)
    {
        if (err == -17) {
            //tc_hook already exisits
        } else {
            libbpf_strerror(err, error, 32);
            fprintf(stderr, "Failed to create tc hook err=%d, %s\n", err, error);
            return 1;
        }
    }
*/
    err = bpf_tc_hook_create(&my_ingress_tc_hook);
    if (err != 0)
    {
        if (err == -17) {
            //tc_hook already exisits
        } else {
            libbpf_strerror(err, error, 32);
            fprintf(stderr, "Failed to create tc hook err=%d, %s\n", err, error);
            return 1;
        }
    }
    /* Bump RLIMIT_MEMLOCK to create BPF maps */
    bump_memlock_rlimit();

    /* Clean handling of Ctrl-C */
    signal(SIGINT, sig_handler);
    signal(SIGTERM, sig_handler);

    err = bpf_prog_load(bpf_file, BPF_PROG_TYPE_SCHED_CLS, &obj, &prog_fd);
    if (err != 0) {
        fprintf(stderr, "Failed to load Program\n");
        return 1;
    }

    // Load egress/ingress sections

/*    egress_prog = bpf_object__find_program_by_title(obj, "xflow_rtt_egress");
    if (!egress_prog) {
        fprintf(stderr, "failed to find xflow_rtt_egress \n");
        return 1;
    }
    */
    ingress_prog = bpf_object__find_program_by_title(obj, "packet_counter");
    if (!ingress_prog) {
        fprintf(stderr, "failed to find packet_counter\n");
        return 1;
    }
/*
    my_egress_prog_fd = bpf_program__fd(egress_prog);
    if (my_egress_prog_fd <= 0) {
        fprintf(stderr, "ERR: bpf_program__fd egress failed\n");
        return 1;
    }
    */
    my_ingress_prog_fd = bpf_program__fd(ingress_prog);
    if (my_ingress_prog_fd <= 0) {
        fprintf(stderr, "ERR: bpf_program__fd ingress failed\n");
        return 1;
    }
/*
    memset(&my_egress_tc_opts, 0, sizeof(my_egress_tc_opts));
    my_egress_tc_opts.sz = sizeof(my_egress_tc_opts);
    my_egress_tc_opts.prog_fd = my_egress_prog_fd;
*/
    memset(&my_ingress_tc_opts, 0, sizeof(my_ingress_tc_opts));
    my_ingress_tc_opts.sz = sizeof(my_ingress_tc_opts);
    my_ingress_tc_opts.prog_fd = my_ingress_prog_fd;
/*
    err = bpf_tc_attach(&my_egress_tc_hook, &my_egress_tc_opts);
    if (err != 0) {
        fprintf(stderr, "Failed to attach tc program at egress\n");
        return 1;
    }
*/
    err = bpf_tc_attach(&my_ingress_tc_hook, &my_ingress_tc_opts);
    if (err != 0) {
        fprintf(stderr, "Failed to attach tc program at ingress\n");
        return 1;
    }
    printf("Attached %s program to tc hook point at ifindex:%d\n", bpf_file, ifindex);
    print_counter();

    return 0;
}
