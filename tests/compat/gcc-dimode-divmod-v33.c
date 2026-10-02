typedef long long int71_v33;
typedef unsigned long long uint71_v33;
volatile int __test_exit;
volatile int71_v33 s_a_v33 = (int71_v33)-12345;
volatile int71_v33 s_b_v33 = (int71_v33)37;
volatile uint71_v33 u_a_v33 = (uint71_v33)012345670123ULL;
volatile uint71_v33 u_b_v33 = (uint71_v33)0755ULL;

int
main(void)
{
    int71_v33 sq;
    int71_v33 sr;
    uint71_v33 uq;
    uint71_v33 ur;

    sq = s_a_v33 / s_b_v33;
    sr = s_a_v33 % s_b_v33;
    uq = u_a_v33 / u_b_v33;
    ur = u_a_v33 % u_b_v33;
    if (sq != (int71_v33)-333)
        return 1;
    if (sr != (int71_v33)-24)
        return 2;
    if (uq * u_b_v33 + ur != u_a_v33)
        return 3;
    if (ur >= u_b_v33)
        return 4;
    return 0;
}
