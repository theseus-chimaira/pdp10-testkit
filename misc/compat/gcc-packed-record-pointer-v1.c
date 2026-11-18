/* GCC PDP-10 packed three-character record read/write regression.
 * Cover a pointer into an array, mutation through that pointer, pointer
 * advancement across a 36-bit word, and static rechecks of all six bytes.
 * This must execute under -O0, -O1, -O2 and -Os on all four PDP-10 CPUs.
 */
volatile int __test_exit;
struct packed3 {
    unsigned char a;
    unsigned char b;
    unsigned char c;
} __attribute__((packed));
static struct packed3 values[4];
static int __attribute__((noinline)) write_check(struct packed3 *p)
{
    p->a = 11;
    p->b = 12;
    p->c = 13;
    if (p->a != 11) return 1;
    if (p->b != 12) return 2;
    if (p->c != 13) return 3;
    ++p;
    p->a = 21;
    p->b = 22;
    p->c = 23;
    if (p->a != 21) return 4;
    if (p->b != 22) return 5;
    if (p->c != 23) return 6;
    return 0;
}
int main(void)
{
    int code;
    if (sizeof(struct packed3) != 3) return 10;
    if (sizeof(values) != 12) return 11;
    code = write_check(values + 1);
    if (code != 0) return 20 + code;
    if (values[1].a != 11) return 31;
    if (values[1].b != 12) return 32;
    if (values[1].c != 13) return 33;
    if (values[2].a != 21) return 34;
    if (values[2].b != 22) return 35;
    if (values[2].c != 23) return 36;
    return 0;
}
