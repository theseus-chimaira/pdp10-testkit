#include "insns.h"

int71_t
abi_mixed_va_one(int tag, ...)
{
	__builtin_va_list ap;
	int71_t x;

	__builtin_va_start(ap, tag);
	x = __builtin_va_arg(ap, int71_t);
	__builtin_va_end(ap);
	return x + tag;
}

int
abi_mixed_va_mix(int tag, ...)
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
