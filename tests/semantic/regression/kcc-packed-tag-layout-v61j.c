/* Aggregate type identity is the tag and qualifiers, not the current
 * mutable word count. A prefix packed attribute belongs to the tag. */
struct later;
static volatile struct later *vp;
static const struct later *cp;
struct __attribute__((packed)) later { char c; unsigned long n; };
static volatile struct later obj[2] = {{1, 0777777777777UL}, {2, 0400000000000UL}};
struct ordinary;
static const struct ordinary *op;
struct ordinary { int x, y, z; };
static struct ordinary plain = {1, 2, 3};
struct suffix { unsigned char a, b, c; } __attribute__((packed));
static const struct suffix lit = {1, 2, 3};
volatile unsigned fail_id;
int main(void)
{
    fail_id = 1;
    if (sizeof(struct later) != 5 || sizeof(*vp) != 5 || sizeof(*cp) != 5 || sizeof(obj) != 10)
        return 1;
    vp = obj;
    cp = (const struct later *)obj;
    if (vp[0].c != 1 || vp[0].n != 0777777777777UL || cp[1].c != 2 || cp[1].n != 0400000000000UL)
        return 2;
    vp[1].n = 0123456701234UL;
    if (obj[1].n != 0123456701234UL || obj[0].n != 0777777777777UL || obj[1].c != 2)
        return 3;
    fail_id = 2;
    op = &plain;
    if (sizeof(*op) != 12 || op->z != 3) return 4;
    if (sizeof(lit) != 3 || lit.c != 3) return 5;
    fail_id = 0;
    return 0;
}
