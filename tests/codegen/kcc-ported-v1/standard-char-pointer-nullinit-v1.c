/* codegen-kcc-policy-only: yes */
/* Preserved compilation-only null pointer check. */
char *global_null = (void *)0;
int f(void)
{
    char *local_null = (void *)0;
    return global_null == local_null;
}
