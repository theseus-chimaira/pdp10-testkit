/* Invalid GNU variadic builtin use. */
struct incomplete;
void f(__builtin_va_list ap) { __builtin_va_arg(ap, struct incomplete); }
