/* codegen-kcc-check: "dimode-addsub-registers" */
/* codegen-kcc-policy-only: yes */
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

Dint sub_store_mem(out, ap, bp)
Dint *out, *ap, *bp;
{
    *out = *ap - *bp;
    return *out;
}
