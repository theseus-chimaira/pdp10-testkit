/* PDP-6 BLT regression for large aligned and unaligned standard C byte
 * transfers and fills.  Guards catch extra writes at either boundary.
 */
#include <string.h>
extern void abort(void);
static unsigned char src[280], dst[280];
int main(void)
{
    unsigned int i, n;
    for (i = 0; i < 280; ++i) src[i] = (unsigned char)(i * 7U + 31U);
    for (n = 16; n < 260; n += 11) {
        memset(dst, 0123, 280);
        memcpy(dst + 4, src + 4, n);
        for (i = 0; i < 280; ++i)
            if (dst[i] != (i >= 4 && i < n + 4 ? src[i] : (unsigned char)0123)) abort();
        memset(dst + 3, 0377, n);
        for (i = 0; i < 280; ++i)
            if (dst[i] != (i >= 3 && i < n + 3 ? (unsigned char)0377 :
                           (i >= 4 && i < n + 4 ? src[i] : (unsigned char)0123))) abort();
    }
    return 0;
}
