#include "mixed-abi-v36.h"

struct a1v36
mk1v36(int x)
{
    struct a1v36 r;
    r.a = x;
    return r;
}

struct a2v36
mk2v36(int x)
{
    struct a2v36 r;
    r.a = x;
    r.b = x + 1;
    return r;
}

struct a3v36
mk3v36(int x)
{
    struct a3v36 r;
    r.a = x;
    r.b = x + 1;
    r.c = x + 2;
    return r;
}

struct a4v36
mk4v36(int x)
{
    struct a4v36 r;
    r.a = x;
    r.b = x + 1;
    r.c = x + 2;
    r.d = x + 3;
    return r;
}

float
faddv36(float x)
{
    return x + 1.0F;
}

double
daddv36(double x)
{
    return x + 1.0;
}

char *
bpnextv36(char *p)
{
    return p + 1;
}

int
bpvalv36(char *p)
{
    return (unsigned char)*p;
}
