/* Invalid GNU variadic builtin use. */
void f(int x) { __builtin_va_list ap; __builtin_va_start(ap, x); }
