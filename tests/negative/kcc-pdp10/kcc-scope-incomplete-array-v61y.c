extern int a[];
int f(void) { { extern int a[4]; } return sizeof(a); }
