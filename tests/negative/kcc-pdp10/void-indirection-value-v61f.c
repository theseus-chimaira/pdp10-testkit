/* A void expression cannot supply an integer value. */
int f(void *p)
{
    return *p;
}
