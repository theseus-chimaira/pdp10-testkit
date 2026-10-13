/* codegen-kcc-check: "double-store-forward" */
/* codegen-kcc-policy-only: yes */
volatile double vd;

double forwarded(a, b)
double a, b;
{
    double d;

    d = a - b;
    if (d < 0.0)
        return -d;
    return d;
}

double volatile_reload(x)
double x;
{
    vd = x;
    return vd;
}
