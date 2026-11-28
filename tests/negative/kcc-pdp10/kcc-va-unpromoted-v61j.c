/* Invalid GNU variadic builtin use. */
int f(__builtin_va_list ap) { return __builtin_va_arg(ap, short); }
