/* PDP-6 freestanding memcmp: aligned word path, unaligned byte path,
 * bounded tails, and first-mismatch ordering in each word position.
 */
#include <string.h>

extern void abort(void);

static unsigned char a[80], b[80];

int main(void)
{
    unsigned int i, off1, off2, len, mismatch;

    for (off1 = 0; off1 < 4; ++off1) {
        for (off2 = 0; off2 < 4; ++off2) {
            for (len = 0; len <= 32; ++len) {
                for (i = 0; i < 80; ++i) {
                    a[i] = (unsigned char)(i * 11U + 133U);
                    b[i] = (unsigned char)(i * 11U + 133U);
                }
                for (i = 0; i < len; ++i)
                    b[off2+i] = a[off1+i];
                if (memcmp(a+off1, b+off2, len) != 0)
                    abort();
                for (mismatch = 0; mismatch < len; ++mismatch) {
                    unsigned char old = b[off2+mismatch];
                    b[off2+mismatch] = (unsigned char)(old + 1U);
                    if (memcmp(a+off1, b+off2, len) >= 0)
                        abort();
                    if (memcmp(b+off2, a+off1, len) <= 0)
                        abort();
                    b[off2+mismatch] = old;
                }
            }
        }
    }
    return 0;
}
