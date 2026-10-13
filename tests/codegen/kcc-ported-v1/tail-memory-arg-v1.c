/* KCC source and original assembly policies. */
/* codegen-require-regex: "(?i)move\\s+1,rootvp" "(?i)jrst\\s+target" */
/* codegen-forbid-regex: "(?i)move\\s+[5-7],rootvp" */
extern int *rootvp;
extern int target(int *, int, int, int);

int wrap(int a, int b, int c)
{
    return target(rootvp, a, b, c);
}
