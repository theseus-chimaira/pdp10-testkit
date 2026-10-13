/* Normalized KCC assembly assertions. */
/* codegen-require-regex: "DIADD" "DISUB" */
/* codegen-forbid-regex: "SETZ" "LSH.*-43" */
typedef long long Dint;

Dint addpair(a, b)
Dint a, b;
{
    return a + b;
}

Dint subpair(a, b)
Dint a, b;
{
    return a - b;
}
