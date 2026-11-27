/* GNU member: value syntax uses ordinary designator semantics. */
struct record { int a, b, c; };
union choice { int i; long l; };
static struct record a = { b: 7, 9 };
static struct record b = { c: 12, .a = 3 };
static union choice u = { l: 23 };
static struct { struct { int x, y; }; int z; } anon =
    { y: 31, .x = 30, z: 32 };
static int value = 11;
int main(void)
{
    struct record local = { value, b: value + 1, value + 2 };
    union choice lu = { i: value, l: value + 3 };
    if (a.a || a.b != 7 || a.c != 9 || b.a != 3 || b.b || b.c != 12)
        return 1;
    if (u.l != 23 || lu.l != 14)
        return 2;
    if (anon.x != 30 || anon.y != 31 || anon.z != 32)
        return 3;
    if (local.a != 11 || local.b != 12 || local.c != 13)
        return 4;
    return 0;
}
