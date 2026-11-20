/*
 * Native PDP-10 aggregate-return ABI regression.
 *
 * The historical struct-ret-1.c compares formatting side effects but
 * never checks the returned X object.  This independent freestanding
 * oracle checks the returned bytes, tail byte, argument values, and
 * direct versus function-pointer calls.  No stdio or allocator.
 *
 * C89: byte counts are expressed using the target's own sizeof(char).
 * In particular this does not assume 8-bit chars or 32-bit ints.
 */

extern void abort(void);

typedef struct {
    double d;
    int i[3];
} B_v1;

typedef struct {
    char c[33];
    char c1;
} X_v1;

volatile unsigned int fail_id;
volatile unsigned int calls_v1;
static B_v1 input_a_v1 = {0.1, {1, 2, 3}};
static B_v1 input_b_v1 = {0.2, {5, 4, 3}};
static double input_double_v1 = 0.3;
static char input_char_v1 = 0177;

static void
check_v1(int ok, unsigned int id)
{
    if (!ok) {
        fail_id = id;
        abort();
    }
}

static X_v1
return_x_v1(B_v1 a, char b, double c, B_v1 d)
{
    static X_v1 original_v1 = {"return val", 'R'};
    X_v1 r;

    ++calls_v1;
    check_v1(a.d == input_a_v1.d, 1);
    check_v1(a.i[0] == 1 && a.i[1] == 2 && a.i[2] == 3, 2);
    check_v1(b == input_char_v1, 3);
    check_v1(c == input_double_v1, 4);
    check_v1(d.d == input_b_v1.d, 5);
    check_v1(d.i[0] == 5 && d.i[1] == 4 && d.i[2] == 3, 6);

    r = original_v1;
    r.c1 = b;
    /* Check boundary and tail bytes across the returned 36-bit words
       without an unnecessarily long loop in the guest. */
    r.c[12] = 'M';
    r.c[24] = 'N';
    r.c[32] = 'P';
    return r;
}

static X_v1 (*volatile call_v1)(B_v1, char, double, B_v1) =
    return_x_v1;

static void
check_x_v1(const X_v1 *p, unsigned int base)
{
    check_v1(p->c[0] == 'r' && p->c[1] == 'e', base);
    check_v1(p->c[9] == 'l', base + 1);
    check_v1(p->c[10] == 0, base + 2);
    check_v1(p->c[11] == 0, base + 3);
    check_v1(p->c[12] == 'M' && p->c[24] == 'N' &&
             p->c[32] == 'P', base + 4);
    check_v1(p->c1 == input_char_v1, base + 5);
}

int
main(void)
{
    X_v1 direct;
    X_v1 indirect;

    fail_id = 0;
    calls_v1 = 0;
    check_v1(sizeof(X_v1) >= 34, 10);

    direct = return_x_v1(input_a_v1, input_char_v1,
                         input_double_v1, input_b_v1);
    check_v1(calls_v1 == 1, 11);
    check_x_v1(&direct, 20);

    indirect = (*call_v1)(input_a_v1, input_char_v1,
                          input_double_v1, input_b_v1);
    check_v1(calls_v1 == 2, 12);
    check_x_v1(&indirect, 30);

    /* The returned objects must have independent caller storage. */
    direct.c[0] = 'Z';
    direct.c[32] = '?';
    direct.c1 = 'Z';
    check_x_v1(&indirect, 40);

    check_v1(direct.c[0] == 'Z' && direct.c[12] == 'M' &&
             direct.c[32] == '?' && direct.c1 == 'Z', 51);
    check_v1(fail_id == 0, 60);
    return 0;
}
