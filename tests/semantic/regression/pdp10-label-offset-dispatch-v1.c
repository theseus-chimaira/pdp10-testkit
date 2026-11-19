/* GNU label-offset computed goto for upstream 920302-1.c.
 * Reproduce its order y,x,y,z and compare the generated "xyxyz"
 * without depending on hosted strcpy/strcmp/exit implementations.
 * This source deliberately uses GCC label-address arithmetic.
 */

static short offsets_v1[3];
static char buffer_v1[10];
static short sequence_v1[4];
volatile unsigned int fail_id;
extern void abort(void);

static void
execute_v1(const short *instructions)
{
    void *base = &&label_x_v1;
    static void *labels[] = {&&label_x_v1, &&label_y_v1,
                             &&label_z_v1};
    char *bp = buffer_v1;
    int i;

    if (instructions == (const short *)0) {
        for (i = 0; i < 3; i++)
            offsets_v1[i] = (short)(labels[i] - base);
        return;
    }
label_x_v1:
    *bp++ = 'x';
    goto *(base + *instructions++);
label_y_v1:
    *bp++ = 'y';
    goto *(base + *instructions++);
label_z_v1:
    *bp++ = 'z';
    *bp = 0;
}

int
main(void)
{
    static const char expected_v1[] = "xyxyz";
    int i;

    execute_v1((const short *)0);
    sequence_v1[0] = offsets_v1[1];
    sequence_v1[1] = offsets_v1[0];
    sequence_v1[2] = offsets_v1[1];
    sequence_v1[3] = offsets_v1[2];
    execute_v1(sequence_v1);
    for (i = 0; i < 6; i++) {
        if (buffer_v1[i] != expected_v1[i]) {
            fail_id = (unsigned int)i + 1U;
            abort();
        }
    }
    return 0;
}
