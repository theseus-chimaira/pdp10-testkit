/* Preserves the original KCC assembly checks. */
/* codegen-kcc-check: "dimode-div-helper-cost" */
long long d1(long long a, long long b) { return a / b; }
long long d2(long long a, long long b, long long c) { return a / b + a / c; }
long long d4(long long a, long long b, long long c, long long d,
             long long e) { return a / b + a / c + a / d + a / e; }
long long d8(long long a, long long b, long long c, long long d,
             long long e, long long f, long long g, long long h,
             long long i) {
    return a / b + a / c + a / d + a / e
         + a / f + a / g + a / h + a / i;
}
