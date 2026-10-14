/* Validate the raw PDP-10 byte-pointer ABI from both KCC and GCC.
 * The cast exposes the target's one-word byte-pointer representation;
 * it is intentionally not a portable ISO C interface.
 */
#include <p10bytes-v2.h>

extern void abort(void);

static unsigned char a[44], b[44];

int main(void)
{
    unsigned int i;
    p10_byte_pointer_v2 pa, pb;

    for (i = 0; i < 44; ++i) {
        a[i] = (unsigned char)(i + 129U);
        b[i] = 0;
    }
    pa = (p10_byte_pointer_v2)a;
    pb = (p10_byte_pointer_v2)b;
    if (p10bcopy_v2(pb, pa, 44U) != pb) abort();
    if (p10bcmp_v2(pa, pb, 44U) != 0) abort();
    if (p10bfill_v2(pb, 0377U, 44U) != pb) abort();
    for (i = 0; i < 44; ++i)
        if (b[i] != (unsigned char)0377) abort();
    if (p10bcmp_v2(pa, pb, 44U) == 0) abort();
    if (p10bcopy_v2(pb, pa, 0U) != pb) abort();
    if (p10bcmp_v2(pa, pb, 0U) != 0) abort();
    return 0;
}
