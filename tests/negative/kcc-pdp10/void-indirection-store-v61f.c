/* A void lvalue cannot be assigned an object value. */
void f(void *p, void *q)
{
    *p = *q;
}
