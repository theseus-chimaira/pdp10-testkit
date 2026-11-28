int f(void) { { extern int x; x = 1; } { extern int x; x = 2; } return x; }
