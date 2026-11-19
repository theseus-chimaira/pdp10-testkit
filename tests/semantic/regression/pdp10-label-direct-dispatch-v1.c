/* Bounded GNU direct computed-goto control test, upstream 920302-1.c.
 * Before blaming short label offsets, establish that taking the
 * address of a local label and jumping directly to it works.
 * The exact original transition sequence is x, y, x, y, z.
 * Each repeated label checks its output bound before another jump.
 */

volatile unsigned int fail_id;
extern void abort(void);

static void
run_v1(char *output)
{
    static void *labels[3] = {&&label_x_v1, &&label_y_v1,
                              &&label_z_v1};
    static const unsigned int sequence[4] = {1U, 0U, 1U, 2U};
    unsigned int position = 0U;
    unsigned int next = 0U;

    goto *labels[0];
label_x_v1:
    if (position >= 5U || next >= 4U) {
        fail_id = 1;
        abort();
    }
    output[position++] = 'x';
    goto *labels[sequence[next++]];
label_y_v1:
    if (position >= 5U || next >= 4U) {
        fail_id = 2;
        abort();
    }
    output[position++] = 'y';
    goto *labels[sequence[next++]];
label_z_v1:
    if (position != 4U || next != 4U) {
        fail_id = 3;
        abort();
    }
    output[position++] = 'z';
    output[position] = 0;
}

int
main(void)
{
    static const char expected[6] = "xyxyz";
    char output[6];
    unsigned int i;

    run_v1(output);
    for (i = 0U; i < 6U; ++i) {
        if (output[i] != expected[i]) {
            fail_id = 4U + i;
            abort();
        }
    }
    return 0;
}
