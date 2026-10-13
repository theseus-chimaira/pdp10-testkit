#ifndef MIXED_LAYOUT_EDGE_V31_H
#define MIXED_LAYOUT_EDGE_V31_H

struct abi_edge_v31 {
    unsigned int a:17;
    signed int b:8;
    unsigned int :0;
    int *p;
    unsigned int c:20;
    unsigned int d:20;
};

struct abi_inner_v31 {
    int a;
    unsigned int b:9;
    unsigned int c:9;
};

struct abi_outer_v31 {
    int lead;
    struct abi_inner_v31 v[2];
    int *p;
    int tail;
};

extern struct abi_edge_v31 abi_edge_global_v31;
extern struct abi_outer_v31 abi_outer_global_v31;
extern int abi_check_layout_v31(struct abi_edge_v31, struct abi_outer_v31);
extern int abi_check_globals_v31(void);

#endif
