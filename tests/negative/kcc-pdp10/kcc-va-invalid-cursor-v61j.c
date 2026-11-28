/* Invalid GNU variadic builtin use. */
int f(int x) { return __builtin_va_arg(x, int); }
