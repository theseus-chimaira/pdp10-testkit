/* Separate original GCC 20010924-1.c pointer/fixed-array baselines.
 * These are ordinary char/pointer initializers, distinct from the
 * flexible-array extension under test. Do not let any baseline
 * failure silently suppress the flexible-array assertions.
 */

extern void abort(void);
volatile unsigned int fail_id;
struct pointer_record_v1 { char c; char *p; };
struct array_record_v1 { char c; char p[2]; };
static struct pointer_record_v1 a1_v1 = {'4', "62"};
static struct array_record_v1 a2_v1 = {'v', "cq"};

int
main(void)
{
    if (a1_v1.c != '4' || a1_v1.p[0] != '6' ||
        a1_v1.p[1] != '2' || a1_v1.p[2] != 0) {
        fail_id = 1;
        abort();
    }
    if (a2_v1.c != 'v' || a2_v1.p[0] != 'c' ||
        a2_v1.p[1] != 'q') {
        fail_id = 2;
        abort();
    }
    return 0;
}
