volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct big {
    char lead[4];
    short mid[8];
    char tail[12];
};

int main()
{
    struct big b0;
    int i;
    fail_id = 0;
    for (i = 0; i < 4; ++i)
        b0.lead[i] = (char)(17 + i);
    for (i = 0; i < 8; ++i)
        b0.mid[i] = (short)(17 + 4 + i);
    for (i = 0; i < 12; ++i)
        b0.tail[i] = (char)(17 + 12 + i);
    got = b0.lead[3] + b0.mid[7] + b0.tail[5] + b0.tail[11];
    if (got != 122) { fail_id = 1; return 1; }
    return 0;
}
