/* codegen-kcc-check: "dimode-div-register-fast" */
/* codegen-kcc-policy-only: yes */
long long sq(long long a, long long b) { return a / b; }
long long sr(long long a, long long b) { return a % b; }
unsigned long long uq(unsigned long long a, unsigned long long b) { return a / b; }
unsigned long long ur(unsigned long long a, unsigned long long b) { return a % b; }
void dq(long long *p, long long b) { *p = *p / b; }
void dr(long long *p, long long b) { *p = *p % b; }
long long pressure(long long a, long long b, long c, long d, long e)
{
    register long x = c;
    register long y = d;
    register long z = e;
    long long q = a / b;
    return q + x + y + z;
}
