#ifndef MIXED_ABI_V36_H
#define MIXED_ABI_V36_H

struct a1v36 { int a; };
struct a2v36 { int a, b; };
struct a3v36 { int a, b, c; };
struct a4v36 { int a, b, c, d; };

struct a1v36 mk1v36(int);
struct a2v36 mk2v36(int);
struct a3v36 mk3v36(int);
struct a4v36 mk4v36(int);
float faddv36(float);
double daddv36(double);
char *bpnextv36(char *);
int bpvalv36(char *);
extern int abi_get_sp(void);

#endif
