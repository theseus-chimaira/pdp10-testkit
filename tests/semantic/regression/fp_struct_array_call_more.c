volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;

struct fpbox {
    float f;
    double d;
    int tag;
};

static void set_box(b, tag, f, d)
struct fpbox *b;
int tag;
float f;
double d;
{
    b->tag = tag;
    b->f = f + (float)tag;
    b->d = d - (double)tag;
}

static int sum_box(b)
struct fpbox *b;
{
    return b->tag + (int)b->f + (int)b->d;
}

static int mix_boxes(b, n)
struct fpbox *b;
int n;
{
    int i;
    int sum;
    sum = 0;
    for (i = 0; i < n; ++i)
        sum += sum_box(&b[i]);
    return sum;
}

int main()
{
    struct fpbox b[3];
    fail_id = 0;
    set_box(&b[0], 1, 2.5f, 10.0);
    set_box(&b[1], -2, 5.5f, 7.0);
    set_box(&b[2], 3, -1.0f, 20.0);
    got = sum_box(&b[0]);
    if (got != 13) { fail_id = 1; return 1; }
    got1 = sum_box(&b[1]);
    if (got1 != 10) { fail_id = 2; return 1; }
    got2 = mix_boxes(b, 3);
    if (got2 != 45) { fail_id = 3; return 1; }
    b[1] = b[2];
    b[1].f = b[1].f + 4.0f;
    b[1].d = b[1].d / 2.0;
    got3 = mix_boxes(b, 3);
    if (got3 != 52) { fail_id = 4; return 1; }
    return 0;
}
