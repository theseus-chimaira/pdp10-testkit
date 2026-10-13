/* Preserved regression source from gnu-aligned-layout.sh. */
volatile int __test_exit;
struct a {
    char a;
    char b __attribute__((aligned(2)));
    char c;
};
struct b {
    char a;
    char b __attribute__((aligned(4)));
    char c;
};
struct c {
    char a;
    short b __attribute__((aligned(2)));
    char c;
};
struct d {
    char a;
    char b __attribute__((__aligned__(2)));
    char c;
};
struct e {
    char a;
    char b __attribute__((aligned));
    char c;
};
static int off_a_b(void) { struct a x; return (char *)&x.b - (char *)&x; }
static int off_a_c(void) { struct a x; return (char *)&x.c - (char *)&x; }
static int off_b_b(void) { struct b x; return (char *)&x.b - (char *)&x; }
static int off_b_c(void) { struct b x; return (char *)&x.c - (char *)&x; }
static int off_c_b(void) { struct c x; return (char *)&x.b - (char *)&x; }
static int off_c_c(void) { struct c x; return (char *)&x.c - (char *)&x; }
static int off_d_b(void) { struct d x; return (char *)&x.b - (char *)&x; }
static int off_e_b(void) { struct e x; return (char *)&x.b - (char *)&x; }
int main(void)
{
    if (sizeof(struct a) != 4 || off_a_b() != 2 || off_a_c() != 3) return 1;
    if (sizeof(struct b) != 8 || off_b_b() != 4 || off_b_c() != 5) return 2;
    if (sizeof(struct c) != 8 || off_c_b() != 2 || off_c_c() != 4) return 3;
    if (off_d_b() != 2) return 4;
    if (off_e_b() != 4) return 5;
    return 0;
}
