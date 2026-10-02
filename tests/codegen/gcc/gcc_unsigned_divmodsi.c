/* codegen-require-regex: '(?ms)^gcc_udiv6:.*?^\s*divi\s+[0-9]+,6\s*$' */
/* codegen-require-regex: '(?ms)^gcc_umod6:.*?^\s*divi\s+[0-9]+,6\s*$' */
/* codegen-forbid-regex: '525252525253' */

unsigned int
gcc_udiv6(unsigned int value)
{
        return value / 6U;
}

unsigned int
gcc_umod6(unsigned int value)
{
        return value % 6U;
}
