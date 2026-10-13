/* Original KCC instruction assertion migration. */
/* codegen-require-regex: "(?im)^\\s*addi\\s+2,1\\s*$" "(?ims)\\A(?:(?!^\\s*movem\\s+[0-7]+,0\\(1\\)\\s*$).)*^\\s*movem\\s+[0-7]+,0\\(1\\)\\s*$\\n(?:(?!^\\s*movem\\s+[0-7]+,0\\(1\\)\\s*$).)*\\Z" */
void f(p, x)
unsigned long *p;
unsigned long x;
{
    *p = x;
    x += 1;
    *p = x;
}
