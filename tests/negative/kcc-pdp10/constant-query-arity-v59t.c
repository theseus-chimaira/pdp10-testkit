/* A constant query takes exactly one expression. */
int invalid_query(void)
{
    return __builtin_constant_p() + __builtin_constant_p(1, 2);
}
