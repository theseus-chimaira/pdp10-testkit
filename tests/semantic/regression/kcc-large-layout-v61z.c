/* Large types need no actual allocation. sizeof and offsetof are
 * C-byte counts, whereas a word pointer converted to integer is a
 * word address. Use native CHAR_BIT and compile-time byte offsets. */
#include <stddef.h>
#include <limits.h>
#define N ((1UL << (CHAR_BIT*sizeof(size_t)-5))-256)
struct huge { short a[N]; int b,c,d,e; };
union huge_union { int a; char b[N]; };
struct small { short a[254]; int b; };
int main(void)
{
    if (sizeof(union huge_union) != N) return 1;
    if (sizeof(struct huge) != N*sizeof(short)+4*sizeof(int)) return 2;
    if (_KCC_offsetof(struct huge,b) != N*sizeof(short)) return 3;
    if (_KCC_offsetof(struct small,b) != 254*sizeof(short)) return 4;
    return 0;
}
