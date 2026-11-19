/* Independently evaluated 9/18/36-bit division and remainder oracles.
 * Derived from the original deferred arith-rand.c invariants.
 * Every operand is read through volatile storage. All divisors are
 * nonzero; the signed MIN/-1 overflow case is deliberately excluded.
 * The reference quotient truncates toward zero, remainder takes the
 * dividend sign, and expected values were computed with host integers.
 */

extern void abort(void);
volatile unsigned int fail_id;
static volatile signed char sc_lhs_v1, sc_rhs_v1;
static volatile unsigned char uc_lhs_v1, uc_rhs_v1;
static volatile signed short ss_lhs_v1, ss_rhs_v1;
static volatile unsigned short us_lhs_v1, us_rhs_v1;
static volatile signed int si_lhs_v1, si_rhs_v1;
static volatile unsigned int ui_lhs_v1, ui_rhs_v1;

static void
check_sc_v1(signed char a, signed char b, signed char expected_q, signed char expected_r,
             unsigned int case_number)
{
    signed char q, r;
    sc_lhs_v1 = a;
    sc_rhs_v1 = b;
    q = sc_lhs_v1 / sc_rhs_v1;
    r = sc_lhs_v1 % sc_rhs_v1;
    if (q != expected_q || r != expected_r) {
        fail_id = case_number;
        abort();
    }
}

static void
check_ss_v1(signed short a, signed short b, signed short expected_q, signed short expected_r,
             unsigned int case_number)
{
    signed short q, r;
    ss_lhs_v1 = a;
    ss_rhs_v1 = b;
    q = ss_lhs_v1 / ss_rhs_v1;
    r = ss_lhs_v1 % ss_rhs_v1;
    if (q != expected_q || r != expected_r) {
        fail_id = case_number;
        abort();
    }
}

static void
check_si_v1(signed int a, signed int b, signed int expected_q, signed int expected_r,
             unsigned int case_number)
{
    signed int q, r;
    si_lhs_v1 = a;
    si_rhs_v1 = b;
    q = si_lhs_v1 / si_rhs_v1;
    r = si_lhs_v1 % si_rhs_v1;
    if (q != expected_q || r != expected_r) {
        fail_id = case_number;
        abort();
    }
}

static void
check_uc_v1(unsigned char a, unsigned char b, unsigned char expected_q, unsigned char expected_r,
             unsigned int case_number)
{
    unsigned char q, r;
    uc_lhs_v1 = a;
    uc_rhs_v1 = b;
    q = uc_lhs_v1 / uc_rhs_v1;
    r = uc_lhs_v1 % uc_rhs_v1;
    if (q != expected_q || r != expected_r) {
        fail_id = case_number;
        abort();
    }
}

static void
check_us_v1(unsigned short a, unsigned short b, unsigned short expected_q, unsigned short expected_r,
             unsigned int case_number)
{
    unsigned short q, r;
    us_lhs_v1 = a;
    us_rhs_v1 = b;
    q = us_lhs_v1 / us_rhs_v1;
    r = us_lhs_v1 % us_rhs_v1;
    if (q != expected_q || r != expected_r) {
        fail_id = case_number;
        abort();
    }
}

static void
check_ui_v1(unsigned int a, unsigned int b, unsigned int expected_q, unsigned int expected_r,
             unsigned int case_number)
{
    unsigned int q, r;
    ui_lhs_v1 = a;
    ui_rhs_v1 = b;
    q = ui_lhs_v1 / ui_rhs_v1;
    r = ui_lhs_v1 % ui_rhs_v1;
    if (q != expected_q || r != expected_r) {
        fail_id = case_number;
        abort();
    }
}

int
main(void)
{
    check_sc_v1(255, 7, 36, 3, 1);
    check_sc_v1(-255, 7, -36, -3, 2);
    check_sc_v1(-256, 3, -85, -1, 3);
    check_sc_v1(-17, 5, -3, -2, 4);
    check_sc_v1(17, -5, -3, 2, 5);
    check_sc_v1(-17, -5, 3, -2, 6);
    check_ss_v1(131071, 7, 18724, 3, 7);
    check_ss_v1(-131071, 7, -18724, -3, 8);
    check_ss_v1(-131072, 3, -43690, -2, 9);
    check_ss_v1(-17, 5, -3, -2, 10);
    check_ss_v1(17, -5, -3, 2, 11);
    check_ss_v1(-17, -5, 3, -2, 12);
    check_si_v1(34359738367, 7, 4908534052, 3, 13);
    check_si_v1(-34359738367, 7, -4908534052, -3, 14);
    check_si_v1(-34359738368L, 3, -11453246122, -2, 15);
    check_si_v1(-17, 5, -3, -2, 16);
    check_si_v1(17, -5, -3, 2, 17);
    check_si_v1(-17, -5, 3, -2, 18);
    check_uc_v1(511, 7, 73, 0, 19);
    check_uc_v1(511, 3, 170, 1, 20);
    check_uc_v1(510, 17, 30, 0, 21);
    check_uc_v1(17, 5, 3, 2, 22);
    check_uc_v1(0, 3, 0, 0, 23);
    check_uc_v1(255, 1, 255, 0, 24);
    check_us_v1(262143, 7, 37449, 0, 25);
    check_us_v1(262143, 3, 87381, 0, 26);
    check_us_v1(262142, 17, 15420, 2, 27);
    check_us_v1(17, 5, 3, 2, 28);
    check_us_v1(0, 3, 0, 0, 29);
    check_us_v1(255, 1, 255, 0, 30);
    check_ui_v1(68719476735UL, 7, 9817068105, 0, 31);
    check_ui_v1(68719476735UL, 3, 22906492245, 0, 32);
    check_ui_v1(68719476734UL, 17, 4042322160, 14, 33);
    check_ui_v1(17, 5, 3, 2, 34);
    check_ui_v1(0, 3, 0, 0, 35);
    check_ui_v1(255, 1, 255, 0, 36);
    return 0;
}
