/* Exact large-index data relocation from deferred GCC index-1.c.
 * A real static 40-element object and subtraction of 100000L are
 * required. Do not replace the array with an arithmetic shortcut.
 */

static int values_v1[40] = {
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
    10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35, 36, 37, 38, 39
};

static volatile long index_v1;
volatile unsigned int fail_id;
extern void abort(void);

static int
lookup_v1(long n)
{
    return values_v1[n - 100000L];
}

int
main(void)
{
    index_v1 = 100030L;
    if (lookup_v1(index_v1) != 30) {
        fail_id = 1;
        abort();
    }
    index_v1 = 100000L;
    if (lookup_v1(index_v1) != 0) {
        fail_id = 2;
        abort();
    }
    index_v1 = 100039L;
    if (lookup_v1(index_v1) != 39) {
        fail_id = 3;
        abort();
    }
    return 0;
}
