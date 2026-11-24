/* Encoded pointers are not integer addresses. Check mixed integer sums,
   negative differences, single evaluation, and physical word boundaries. */
static unsigned char bytes[40];
static short halves[20];
static int words[10];
static volatile int calls, vi, vj;
volatile int fail_id;

static unsigned char *byte_at(int i) __attribute__((noinline));
static unsigned char *byte_at(int i)
{
    ++calls;
    return bytes + i;
}

static int diff(int n, unsigned char *a, unsigned char *b)
    __attribute__((noinline));
static int diff(int n, unsigned char *a, unsigned char *b)
{
    return n + (a - b) - 3;
}

int main(void)
{
    int i, j;
    unsigned char *a, *b;
    short *h, *k;
    int *w, *z;
    for (i = 0; i < 40; ++i)
        bytes[i] = (unsigned char)(i + 1);
    for (i = 0; i < 40; i += 3) {
        vi = i;
        for (j = 0; j <= 40; j += 4) {
            vj = j;
            a = bytes + vi;
            b = bytes + vj;
            if (a - b != i-j || b - a != j-i
                || diff(17, a, b) != 14+i-j) {
                fail_id = 1; return 1;
            }
        }
    }
    calls = 0;
    if (7 + (byte_at(3) - byte_at(17)) != -7 || calls != 2) {
        fail_id = 2; return 1;
    }
    a = bytes+5;
    b = bytes+19;
    if ((a++ - b++) != -14 || a != bytes+6 || b != bytes+20) {
        fail_id = 3; return 1;
    }
    vi = 7;
    vj = 14;
    h = halves+vi;
    k = halves+vj;
    if (h-k != -7 || k-h != 7) {
        fail_id = 4; return 1;
    }
    vi = 1;
    vj = 8;
    w = words+vi;
    z = words+vj;
    if (w-z != -7 || z-w != 7) {
        fail_id = 5; return 1;
    }
    if (bytes[4]+bytes[8]+bytes[12]+bytes[16] != 44
        || bytes[5]+bytes[9]+bytes[13] != 30) {
        fail_id = 6; return 1;
    }
    return 0;
}
