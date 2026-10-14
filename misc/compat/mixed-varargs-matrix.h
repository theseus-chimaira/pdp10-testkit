#ifndef MIXED_VARARGS_MATRIX_V30_H
#define MIXED_VARARGS_MATRIX_V30_H

#include "insns.h"

/*
 * Mixed variadic ABI runtime matrix.  The caller/callee sources deliberately
 * use the compiler-native va_list traversal, while the external arguments are
 * restricted to representations proven common to KCC and GCC.
 */

#ifdef __GNUC__
#define ABI_VA_START_V30(AP, LAST) __builtin_stdarg_start((AP), (LAST))
#else
#define ABI_VA_START_V30(AP, LAST) __builtin_va_start((AP), (LAST))
#endif
#define ABI_VA_ARG_V30(AP, TYPE) __builtin_va_arg((AP), TYPE)
#define ABI_VA_END_V30(AP) __builtin_va_end((AP))

struct abi_va_pair_v30 {
    int a;
    int b;
};

extern int abi_va_matrix_v30(int, ...);
extern int abi_va_float_v30(int, ...);

#endif
