#ifndef NEGATIVE_DIMODE_V32_H
#define NEGATIVE_DIMODE_V32_H

typedef long long abi_int71_v32;

extern volatile abi_int71_v32 abi_negative_global_v32;
int neg_reg_v32(abi_int71_v32 value);
int neg_split_v32(int a, int b, int c, abi_int71_v32 value);
int neg_stack_v32(int a, int b, int c, int d, abi_int71_v32 value);
int neg_global_v32(void);
int neg_tail_v32(abi_int71_v32 value);

#endif
