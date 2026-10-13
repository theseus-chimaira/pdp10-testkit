/* Preserves the original KCC assembly checks. */
/* codegen-kcc-check: "dimode-div-reuse-bit-temp" */
unsigned long long f(unsigned long long a, unsigned long long b)
{
    return a / b;
}
