/* codegen-kcc-policy-only: yes */
/* Preserve the original rejection of SKIPA -1 followed by JRST. */
/* codegen-forbid-regex: "(?im)^\\s*skipa\\s+1,\\[-1\\]\\s*\\n\\s*jrst\\s+" */
unsigned slots[32];
unsigned startv[1];

int f(unsigned start)
{
    unsigned total;
    unsigned i;

    total = startv[0];
    if (total >= 16U)
        return -1;
    for (i = total; i > start; i--)
        slots[i] = slots[i - 1U];
    return 0;
}
