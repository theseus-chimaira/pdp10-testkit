/* Nonvacuous PDP-6 companion for GNU 20020227-1.c.
 * The char preceding a packed complex float makes the access
 * unaligned. Verify both complex components and the neighboring char
 * after writing the source via a separate function.
 */

typedef __complex__ float complex_float_v1;
struct packed_complex_v1 {
    char c;
    complex_float_v1 f;
} __attribute__((packed));

volatile unsigned int fail_id;
extern void abort(void);

static void
readback_v1(const struct packed_complex_v1 *p)
{
    if (p->c != 42) {
        fail_id = 1;
        abort();
    }
    if (__real__ p->f != 1.0F) {
        fail_id = 2;
        abort();
    }
    if (__imag__ p->f != 0.0F) {
        fail_id = 3;
        abort();
    }
}

static void
write_and_test_v1(void)
{
    struct packed_complex_v1 data;

    data.f = 1.0F;
    data.c = 42;
    readback_v1(&data);
}

int
main(void)
{
    write_and_test_v1();
    return 0;
}
