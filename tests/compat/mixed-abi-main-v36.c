#include "mixed-abi-v36.h"

int
main(void)
{
    int sp0, sp1;
    struct a1v36 a1;
    struct a2v36 a2;
    struct a3v36 a3;
    struct a4v36 a4;
    char b[3];
    char *p;
    float f;
    double d;

    sp0 = abi_get_sp();

    a1 = mk1v36(10);
    if (a1.a != 10)
        return 1;
    a2 = mk2v36(20);
    if (a2.a != 20 || a2.b != 21)
        return 2;
    a3 = mk3v36(30);
    if (a3.a != 30 || a3.b != 31 || a3.c != 32)
        return 3;
    a4 = mk4v36(40);
    if (a4.a != 40 || a4.b != 41 || a4.c != 42 || a4.d != 43)
        return 4;

    f = faddv36(2.5F);
    if (f != 3.5F)
        return 5;
    d = daddv36(2.5);
    if (d != 3.5)
        return 6;

    b[0] = 'A';
    b[1] = 'B';
    b[2] = 'C';
    p = bpnextv36(&b[0]);
    if (p != &b[1] || bpvalv36(p) != 'B')
        return 7;

    sp1 = abi_get_sp();
    if (sp0 != sp1)
        return 8;

    return 0;
}
