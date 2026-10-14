/* codegen-kcc-check: "dimode-signed-wide-power2" */
/* codegen-kcc-policy-only: yes */
long long d35(long long x) { return x / (1LL << 35); }
long long d36(long long x) { return x / (1LL << 36); }
long long d70(long long x) { return x / (1LL << 70); }
long long m35(long long x) { return x % (1LL << 35); }
long long m36(long long x) { return x % (1LL << 36); }
long long m70(long long x) { return x % (1LL << 70); }
