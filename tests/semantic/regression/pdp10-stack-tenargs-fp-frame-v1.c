/*
 * Nonvacuous PDP-10 counterpart for the original 980605-1.c.
 *
 * This test deliberately uses a large local 9-bit-byte array.  Unlike
 * the original's unused ar[] array, the volatile entries must occupy a
 * real frame and survive an intervening ten-argument function call.
 *
 * The original ar[] is 100000 9-bit bytes (25000 native 36-bit words).
 * Preserve that exact size, including its high offset, rather than using
 * a small marker array that would not test the original frame extent.
 *
 * A separate check preserves the original 20 sequential getval calls,
 * the double-to-unsigned-short conversion of 17.0, and the total 227.
 * Finally, the real target sprintf must write "227\n" and its NUL.
 *
 * The original historical source is not modified or replaced.
 */

extern void abort(void);
extern int sprintf(char *, const char *, ...);

static volatile int next_value_v1 = 1;
static char formatted_v1[32];

static int
getval_v1(void)
{
    int value;

    value = next_value_v1;
    next_value_v1 = value + 1;
    return value;
}

static int
ten_values_v1(unsigned short short_value,
              int a, int b, int c, int d, int e,
              int f, int g, int h, int i, int j)
{
    if (short_value != 17)
        abort();
    return short_value + a + b + c + d + e + f + g + h + i + j;
}

static int
second_stage_v1(double input)
{
    int a, b, c, d, e, f, g, h, i, j;
    unsigned short converted;

    a = getval_v1();
    b = getval_v1();
    c = getval_v1();
    d = getval_v1();
    e = getval_v1();
    f = getval_v1();
    g = getval_v1();
    h = getval_v1();
    i = getval_v1();
    j = getval_v1();
    converted = (unsigned short)input;
    return ten_values_v1(converted, a, b, c, d, e, f, g, h, i, j);
}

int
main(void)
{
    volatile unsigned char frame_v1[100000];
    unsigned int index_v1;
    unsigned int checksum_v1;
    int a, b, c, d, e, f, g, h, i, j;
    int total_v1;

    /* Exercise 128 separated offsets, including the far end of the frame. */
    for (index_v1 = 0; index_v1 < 100000; index_v1 += 256)
        frame_v1[index_v1] = (unsigned char)(index_v1 / 256 + 5);
    frame_v1[99999] = (unsigned char)0x155;

    a = getval_v1();
    b = getval_v1();
    c = getval_v1();
    d = getval_v1();
    e = getval_v1();
    f = getval_v1();
    g = getval_v1();
    h = getval_v1();
    i = getval_v1();
    j = getval_v1();

    total_v1 = a + b + c + d + e + f + g + h + i + j;
    total_v1 += second_stage_v1(17.0);

    if (total_v1 != 227 || next_value_v1 != 21)
        abort();

    /* Sum of 5..395 = 391*5 + (390*391)/2 = 78200. */
    checksum_v1 = 0;
    for (index_v1 = 0; index_v1 < 100000; index_v1 += 256)
        checksum_v1 += frame_v1[index_v1];
    if (checksum_v1 != 78200 || frame_v1[0] != 5 ||
            frame_v1[99840] != 395 || frame_v1[99999] != 0x155)
        abort();

    if (sprintf(formatted_v1, "%d\n", total_v1) != 4 ||
            formatted_v1[0] != '2' || formatted_v1[1] != '2' ||
            formatted_v1[2] != '7' || formatted_v1[3] != '\n' ||
            formatted_v1[4] != '\0')
        abort();

    return 0;
}
