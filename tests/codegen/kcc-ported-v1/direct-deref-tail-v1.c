/* KCC codegen assertion migrated from legacy shell. */
/* codegen-require-regex: "(?ims)^direct:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*jrst\\s+foo\\s*$" "(?ims)^indirect:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?^\\s*pushj\\s+17,0\\([0-7]+\\)\\s*$" */
extern int foo();
typedef int (*fn_t)();

int direct(a, b)
int a, b;
{
    return (*foo)(a, b);
}

int indirect(fn, a, b)
fn_t fn;
int a, b;
{
    return (*fn)(a, b);
}
