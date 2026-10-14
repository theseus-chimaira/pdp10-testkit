/* codegen-kcc-check: "dimode-unsigned-wide-power2" */
/* codegen-kcc-policy-only: yes */
typedef unsigned long long U;
U d35(U x) { return x / (1ULL << 35); }
U d36(U x) { return x / (1ULL << 36); }
U d70(U x) { return x / (1ULL << 70); }
U m35(U x) { return x % (1ULL << 35); }
U m36(U x) { return x % (1ULL << 36); }
U m70(U x) { return x % (1ULL << 70); }
