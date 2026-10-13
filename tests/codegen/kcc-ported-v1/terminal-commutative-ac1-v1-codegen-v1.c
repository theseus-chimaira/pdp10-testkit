/* codegen-kcc-check: "terminal-commutative-ac1-v1" */
volatile int __test_exit;

int add_ab(a, b) int a, b; { return a + b; }
int add_ba(a, b) int a, b; { return b + a; }
int and_ba(a, b) int a, b; { return b & a; }
int or_ba(a, b) int a, b; { return b | a; }
int xor_ba(a, b) int a, b; { return b ^ a; }
int mul_ab(a, b) int a, b; { return a * b; }
int mul_ba(a, b) int a, b; { return b * a; }
int sub_ba(a, b) int a, b; { return b - a; }
unsigned usub_ba(a, b) unsigned a, b; { return b - a; }

int main(void)
{
        if (add_ab(7, 5) != 12 || add_ba(7, 5) != 12)
                return 1;
        if (and_ba(074, 052) != (074 & 052))
                return 2;
        if (or_ba(074, 052) != (074 | 052))
                return 3;
        if (xor_ba(074, 052) != (074 ^ 052))
                return 4;
        if (mul_ab(-7, 5) != -35 || mul_ba(-7, 5) != -35)
                return 5;
        if (sub_ba(7, 5) != -2)
                return 6;
        if (usub_ba(7U, 5U) != (unsigned)(5U - 7U))
                return 7;
        return 0;
}
