/* codegen-require-regex: '\.word\s+0414243212223' */
/* codegen-require-regex: '(?ms)^gcc_char6_index:.*?^\s*i?ldb\s' */

#define SIXBIT(name) (*((int *)((char6 *)(name))))

char6 gcc_char6_data[7] = "abc123";

int
gcc_char6_index(char6 *p)
{
        return p[2];
}

int
gcc_char6_sixbit(void)
{
        return SIXBIT("abc123");
}
