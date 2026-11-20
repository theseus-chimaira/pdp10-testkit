/*
 * Real 36-bit unsigned integer / 27-bit PDP-10 float conversions, C89.
 *
 * Independently check normalizing and rounding unsigned integers,
 * including a tie-to-even case, and conversion back to unsigned.
 * Each input is volatile to force a runtime conversion, and the
 * expected constants are not computed through the tested cast.
 */

extern void abort(void);
volatile unsigned int fail_id;

static volatile unsigned int u_v1[] = {
    0U, 1U, 1024U, 134217729U, 134217731U,
    (~0U) >> 1, ~((~0U) >> 1), ~0U
};

static const float f_v1[] = {
    0.0F, 1.0F, 1024.0F, 134217728.0F, 134217732.0F,
    34359738368.0F, 34359738368.0F, 68719476736.0F
};

static volatile float fi_v1[] = {
    0.0F, 0.999F, 1.0F, 1.99F, 1024.0F, 34359738368.0F
};

static const unsigned int ur_v1[] = {
    0U, 0U, 1U, 1U, 1024U, ~((~0U) >> 1)
};

static float
u2f_v1(unsigned int u)
{
    return (float)u;
}

static unsigned int
f2u_v1(float f)
{
    return (unsigned int)f;
}

int
main(void)
{
    unsigned int i;
    if (sizeof(unsigned int) != 4 || sizeof(float) != 4) {
        fail_id = 1;
        abort();
    }
    for (i = 0; i < 8; ++i) {
        if (u2f_v1(u_v1[i]) != f_v1[i]) {
            fail_id = 16 + i + 1;
            abort();
        }
    }
    for (i = 0; i < 6; ++i) {
        if (f2u_v1(fi_v1[i]) != ur_v1[i]) {
            fail_id = 32 + i + 1;
            abort();
        }
    }
    return 0;
}
