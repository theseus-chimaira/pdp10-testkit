#include "insns.h"

int71_t
abi_va_one(int tag, ...)
{
	__builtin_va_list ap;
	int71_t x;
	__builtin_va_start(ap, tag);
	x = __builtin_va_arg(ap, int71_t);
	__builtin_va_end(ap);
	return x + tag;
}

int71_t
abi_call_va_one(int71_t x)
{
	return abi_va_one(7, x);
}

int
abi_va_mix(int tag, ...)
{
	__builtin_va_list ap;
	int a, c;
	int71_t b;
	__builtin_va_start(ap, tag);
	a = __builtin_va_arg(ap, int);
	b = __builtin_va_arg(ap, int71_t);
	c = __builtin_va_arg(ap, int);
	__builtin_va_end(ap);
	return tag + a + (int)b + c;
}

int
abi_call_va_mix(int71_t x)
{
	return abi_va_mix(1, 2, x, 3);
}
