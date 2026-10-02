#include "insns.h"

extern int71_t abi_mixed_va_one(int, ...);
extern int abi_mixed_va_mix(int, ...);

int
main(void)
{
	int71_t x;

	x = 4;
	if (abi_mixed_va_one(7, x) != 11)
		return 1;
	if (abi_mixed_va_mix(1, 2, x, 3) != 10)
		return 2;
	return 0;
}
