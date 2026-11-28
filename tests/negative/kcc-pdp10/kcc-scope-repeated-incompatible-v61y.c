extern int a[];
int f(void) { extern int a[4]; extern int a[5]; return 0; }
