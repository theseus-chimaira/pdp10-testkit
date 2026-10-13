/* Ported KCC-specific assembler shape regression. */
/* codegen-require-regex: "(?im)^\s*aoja\s+1,%L[0-9]+" */
/* codegen-forbid-regex: "(?im)^\s*addi\s+1,1\s*\n\s*jrst\s+%L[0-9]+" */
int f(char *p, unsigned int n)
{
    unsigned int i;

    for (i = 0; i < n; ++i)
        if (p[i] == '\n')
            return (int)(i + 1U);
    return (int)n;
}
