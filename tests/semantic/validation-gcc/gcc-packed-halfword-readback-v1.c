/*
 * PDP-10 packed 18-bit field extraction across 36-bit word boundaries.
 *
 * An 18-bit short may occupy the right half of a 36-bit word after a
 * preceding packed long.  Both direct static access and access through
 * a pointer to a stack-resident packed aggregate must preserve the
 * original field position.  The aligned next field must also remain
 * correct.  This intentionally does not test the distinct nested
 * nine-bit character optimization bug in upstream 20010518-2.c.
 *
 * C89 except for the GCC target's GNU packed attribute.
 */
typedef struct packed_halfword_record_v1 {
    short a;
    long b;
    short c;
    short d;
    char tail[6];
} __attribute__((packed)) packed_halfword_record_v1;

static volatile packed_halfword_record_v1 static_v1 = {
    1, 2, 3, 4, { 0 }
};
static const packed_halfword_record_v1 initial_v1 = {
    1, 2, 3, 4, { 0 }
};

int
main(void)
{
    volatile packed_halfword_record_v1 local;
    volatile packed_halfword_record_v1 *p = &local;

    if (static_v1.a != 1)
        return 11;
    if (static_v1.b != 2)
        return 12;
    if (static_v1.c != 3)
        return 13;
    if (static_v1.d != 4)
        return 14;

    *p = initial_v1;
    if (p->a != 1)
        return 21;
    if (p->b != 2)
        return 22;
    if (p->c != 3)
        return 23;
    if (p->d != 4)
        return 24;
    return 0;
}
