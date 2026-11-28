/* Invalid GNU variadic builtin use. */
void f(__builtin_va_list ap) { __builtin_va_copy(ap, 1); }
