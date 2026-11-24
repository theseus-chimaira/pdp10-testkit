/* Physical record strides and bit positions must not depend on the
   byte size of the selected member. Exercise static and automatic
   arrays, mixed signedness, nested constant field indices and a live
   variable subscript on both load and store paths. */
struct pair {
    signed char a;
    unsigned char b;
    short s;
};

struct rec {
    unsigned char a;
    short s;
    unsigned char b[4];
    int tail;
};

static struct pair pairs[4];
static struct rec records[4];
static volatile int index_value;
volatile int fail_id;

int main(void)
{
    struct rec local[4];
    int i, j;
    for (i = 0; i < 4; ++i) {
        pairs[i].a = (signed char)(-20 - i);
        pairs[i].b = (unsigned char)(0400 + i);
        pairs[i].s = (short)(-1000 - i);
        records[i].a = (unsigned char)(0410 + i);
        records[i].s = (short)(-2000 - i);
        records[i].b[0] = (unsigned char)(010 + i);
        records[i].b[1] = (unsigned char)(020 + i);
        records[i].b[2] = (unsigned char)(030 + i);
        records[i].b[3] = (unsigned char)(040 + i);
        records[i].tail = 10000 + i;
        local[i].a = (unsigned char)(0500 + i);
        local[i].s = (short)(-3000 - i);
        local[i].b[0] = (unsigned char)(060 + i);
        local[i].b[1] = (unsigned char)(070 + i);
        local[i].b[2] = (unsigned char)(0100 + i);
        local[i].b[3] = (unsigned char)(0110 + i);
        local[i].tail = 20000 + i;
    }
    for (i = 0; i < 4; ++i) {
        index_value = i;
        j = index_value;
        if (pairs[j].a != -20-i || pairs[j].b != 0400+i
            || pairs[j].s != -1000-i) {
            fail_id = 10+i; return 1;
        }
        if (records[j].a != 0410+i || records[j].s != -2000-i
            || records[j].b[0] != 010+i || records[j].b[1] != 020+i
            || records[j].b[2] != 030+i || records[j].b[3] != 040+i
            || records[j].tail != 10000+i) {
            fail_id = 20+i; return 1;
        }
        if (local[j].a != 0500+i || local[j].s != -3000-i
            || local[j].b[0] != 060+i || local[j].b[1] != 070+i
            || local[j].b[2] != 0100+i || local[j].b[3] != 0110+i
            || local[j].tail != 20000+i) {
            fail_id = 30+i; return 1;
        }
    }
    index_value = 1;
    j = index_value;
    records[j].b[2] = 0777;
    pairs[j].s = -123;
    if (records[1].b[1] != 021 || records[1].b[2] != 0777
        || records[1].b[3] != 041 || records[0].b[2] != 030
        || records[2].b[2] != 032 || pairs[1].a != -21
        || pairs[1].b != 0401 || pairs[1].s != -123
        || pairs[0].s != -1000 || pairs[2].s != -1002) {
        fail_id = 40; return 1;
    }
    return 0;
}
