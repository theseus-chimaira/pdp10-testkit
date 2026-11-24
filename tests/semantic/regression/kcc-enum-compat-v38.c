/* GCC-compatible enum object signedness, int enumerator constants. */
typedef enum code { FIRST=0, LAST=222 } code;
typedef enum mixed { NEG=-34, POS=50 } mixed;
struct fields { code c:8; mixed m:8; };
static volatile struct fields f;
static volatile code c;
static volatile mixed m;
int main(void)
{
    f.c = LAST; f.m = NEG;
    if (f.c != 222 || f.m != -34) return 1;
    switch (f.c) { case LAST: break; default: return 2; }
    c = (code)-1; m = (mixed)-1;
    if (c < 0 || m >= 0) return 3;
    if (sizeof(code)!=sizeof(int) || sizeof(mixed)!=sizeof(int)) return 4;
    if (LAST - 223 >= 0 || FIRST - 1 >= 0) return 5;
    { enum code { MIN=-1, MAX=2 } v = MIN; if (v >= 0) return 6; }
    return 0;
}
