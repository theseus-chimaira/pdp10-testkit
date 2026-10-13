/* Verify packed 9-bit multidimensional char indexing by behavior.
 * Unlike the imported assembly-pattern check, this accepts all equivalent
 * instruction sequences and observes both indices and pointer decay. */
volatile int __test_exit;
volatile int fail_id;
volatile int got;
#include "pdp10-gcc-multidim-char-20261012.c"
int main(void)
{
    char *p;
    set_array(2, 13, 021);
    set_array(3, 13, 043);
    set_array(2, 14, 065);
    set_row(9, 102, 077);
    got = get_array(2, 13);
    if (got != 021) { fail_id = 1; return 1; }
    got = get_array(3, 13);
    if (got != 043) { fail_id = 2; return 2; }
    got = get_array(2, 14);
    if (got != 065) { fail_id = 3; return 3; }
    got = get_array(9, 102);
    if (got != 077) { fail_id = 4; return 4; }
    p = row_array(2);
    got = p[13];
    if (got != 021) { fail_id = 5; return 5; }
    return 0;
}
