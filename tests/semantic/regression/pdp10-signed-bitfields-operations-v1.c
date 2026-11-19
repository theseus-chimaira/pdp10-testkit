/* GNU signed 52/53-bit bitfield XOR/OR and structure-return oracle.
 * Companion to deferred 991118-1.c and bf64-1.c.  Native signed
 * field values are sign-extended from 52/53 bits, NOT 64 bits.
 * Decimal expected values are independently computed with Python
 * arbitrary-precision two's-complement masking.
 */

struct field52_first_v1 {
    signed long long pad : 12;
    signed long long field : 52;
};
struct field52_last_v1 {
    signed long long field : 52;
    signed long long pad : 12;
};
struct field53_first_v1 {
    signed long long pad : 11;
    signed long long field : 53;
};
struct field53_last_v1 {
    signed long long field : 53;
    signed long long pad : 11;
};

static volatile signed long long xor52_v1;
static volatile signed long long xor53_v1;
static volatile signed long long or52_v1;
volatile unsigned int fail_id;
extern void abort(void);

static struct field52_first_v1
xor52_first_v1(struct field52_first_v1 x)
{
    x.field ^= xor52_v1;
    return x;
}

static struct field52_last_v1
xor52_last_v1(struct field52_last_v1 x)
{
    x.field ^= xor52_v1;
    return x;
}

static struct field53_first_v1
xor53_first_v1(struct field53_first_v1 x)
{
    x.field ^= xor53_v1;
    return x;
}

static struct field53_last_v1
xor53_last_v1(struct field53_last_v1 x)
{
    x.field ^= xor53_v1;
    return x;
}

static struct field52_first_v1
or52_first_v1(struct field52_first_v1 x)
{
    x.field |= or52_v1;
    return x;
}

static struct field52_last_v1
or52_last_v1(struct field52_last_v1 x)
{
    x.field |= or52_v1;
    return x;
}

int
main(void)
{
    struct field52_first_v1 a;
    struct field52_last_v1 b;
    struct field53_first_v1 c;
    struct field53_last_v1 d;

    xor52_v1 = 0x0008765412345678LL;
    xor53_v1 = 0x0018765412345678LL;
    or52_v1 = 0x0008765412345678LL;

    a.pad = 0x123;
    b.pad = 0x123;
    a.field = 0x123456789ABCDLL;
    b.field = 0x123456789ABCDLL;
    a = xor52_first_v1(a);
    b = xor52_last_v1(b);
    if (a.pad != 0x123 || a.field != -1876791358784075LL) {
        fail_id = 1;
        abort();
    }
    if (b.pad != 0x123 || b.field != -1876791358784075LL) {
        fail_id = 2;
        abort();
    }

    c.pad = 0x123;
    d.pad = 0x123;
    c.field = 0x1FFFF00000000LL;
    d.field = 0x1FFFF00000000LL;
    c = xor53_first_v1(c);
    d = xor53_last_v1(d);
    if (c.pad != 0x123 || c.field != -1818956999141768LL) {
        fail_id = 3;
        abort();
    }
    if (d.pad != 0x123 || d.field != -1818956999141768LL) {
        fail_id = 4;
        abort();
    }

    a.pad = 0x123;
    b.pad = 0x123;
    a.field = 0xFFF000FFF000FLL;
    b.field = 0xFFF000FFF000FLL;
    a = or52_first_v1(a);
    b = or52_last_v1(b);
    if (a.pad != 0x123 || a.field != -738197547393LL) {
        fail_id = 5;
        abort();
    }
    if (b.pad != 0x123 || b.field != -738197547393LL) {
        fail_id = 6;
        abort();
    }
    return 0;
}
