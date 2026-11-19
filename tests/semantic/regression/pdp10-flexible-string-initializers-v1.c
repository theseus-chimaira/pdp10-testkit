/* Isolate flexible-array initializer regression in 20010924-1.c.
 * The original has separate pointer/fixed-array baselines. A failure
 * in the baseline pointer currently hides the two GNU extension tests.
 * Check only the original a3/a4 flexible-array initializer intent.
 * Do not access a presumed trailing NUL beyond the flexible member.
 */

extern void abort(void);
volatile unsigned int fail_id;

struct flex_string_v1 { char c; char p[]; };

static struct flex_string_v1 a3_v1 = {'o', "wx"};
static struct flex_string_v1 a4_v1 = {'9', {'e', 'b'}};

int
main(void)
{
    if (a3_v1.c != 'o' || a3_v1.p[0] != 'w' ||
        a3_v1.p[1] != 'x') {
        fail_id = 1;
        abort();
    }
    if (a4_v1.c != '9' || a4_v1.p[0] != 'e' ||
        a4_v1.p[1] != 'b') {
        fail_id = 2;
        abort();
    }
    return 0;
}
