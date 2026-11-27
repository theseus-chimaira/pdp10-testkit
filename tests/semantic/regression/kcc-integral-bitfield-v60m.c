/* One-word bit-fields use declared signedness and target-width promotions. */
enum positive { ZERO, HIGH = 222 };
enum negative { MINUS = -3, PLUS = 3 };
struct fields {
    signed short a:5;
    unsigned short b:10;
    signed char c:4;
    unsigned char d:9;
    signed long e:32;
    unsigned long f:32;
    enum positive g:8;
    enum negative h:3;
    unsigned long full:36;
};
static struct fields saved = { -7, 0777, -3, 0401, -2, 0x87654321UL,
                               HIGH, MINUS, 0777777777777UL };
static volatile struct fields x;
int main(void)
{
    if (saved.a != -7 || saved.b != 0777 || saved.c != -3
        || saved.d != 0401 || saved.e != -2 || saved.f != 0x87654321UL
        || saved.g != HIGH || saved.h != MINUS
        || saved.full != 0777777777777UL)
        return 1;
    x.a = -5; x.b = 511; x.c = -2; x.d = 257;
    x.e = -123; x.f = 0x87654321UL; x.g = HIGH; x.h = MINUS;
    x.full = 0777777777777UL;
    if (x.a != -5 || x.b != 511 || x.c != -2 || x.d != 257
        || x.e != -123 || x.f != 0x87654321UL
        || x.g != HIGH || x.h != MINUS
        || x.full != 0777777777777UL)
        return 2;
    x.f = 0; x.full = 0; x.b = 0;
    if (x.f - 2 >= 0 || x.b - 2 >= 0 || x.full - 2U <= 0U)
        return 3;
    return 0;
}
