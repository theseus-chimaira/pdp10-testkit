typedef long long int71_v34;
volatile int __test_exit;
extern int71_v34 kcc_div_v34(int71_v34, int71_v34);
extern int71_v34 kcc_mod_v34(int71_v34, int71_v34);
extern int71_v34 gcc_div_v34(int71_v34, int71_v34);
extern int71_v34 gcc_mod_v34(int71_v34, int71_v34);
int
main(void)
{
    int71_v34 a;
    int71_v34 b;
    a = (int71_v34)-12345;
    b = (int71_v34)37;
    if (kcc_div_v34(a, b) != (int71_v34)-333) return 1;
    if (kcc_mod_v34(a, b) != (int71_v34)-24) return 2;
    if (gcc_div_v34(a, b) != (int71_v34)-333) return 3;
    if (gcc_mod_v34(a, b) != (int71_v34)-24) return 4;
    return 0;
}
