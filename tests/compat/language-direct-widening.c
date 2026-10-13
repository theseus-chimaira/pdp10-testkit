typedef unsigned long long u71;
typedef long long i71;
union U71 { u71 value; struct { unsigned int high, low; } word; };
union I71 { i71 value; struct { int high; unsigned int low; } word; };
volatile unsigned int source_u;
volatile int source_i;
int main(void)
{
    union U71 u;
    union I71 i;
    source_u = 0400000000000U;
    u.value = (u71)source_u;
    if (u.word.high != 1U || u.word.low != 0U) return 1;
    source_i = -1;
    i.value = (i71)source_i;
    if (i.word.high != -1 || i.word.low != 0777777777777U) return 2;
    source_i = 1;
    i.value = (i71)source_i;
    if (i.word.high != 0 || i.word.low != 1U) return 3;
    return 0;
}
