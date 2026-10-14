/* codegen-kcc-check: "dimode-negative-power2" */
/* codegen-kcc-policy-only: yes */
long long d1(long long x) { return x / -2LL; }
long long d34(long long x) { return x / -(1LL << 34); }
long long d35(long long x) { return x / -(1LL << 35); }
long long d36(long long x) { return x / -(1LL << 36); }
long long d70(long long x) { return x / -(1LL << 70); }
long long m1(long long x) { return x % -2LL; }
long long m34(long long x) { return x % -(1LL << 34); }
long long m35(long long x) { return x % -(1LL << 35); }
long long m36(long long x) { return x % -(1LL << 36); }
long long m70(long long x) { return x % -(1LL << 70); }
