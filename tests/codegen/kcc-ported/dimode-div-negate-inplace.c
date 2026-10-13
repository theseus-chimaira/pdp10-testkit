/* codegen-kcc-policy-only: yes */
/* Original KCC instruction assertion migration. */
/* codegen-require-regex: "DIDIV.*N" "DIDIV.*D" "SKIPE" */
/* codegen-forbid-regex: "DIDIV.*N0" "DIDIV.*D0" "DIDIV.*MR0" "DIDIV.*MQ0" */
long long q(long long a, long long b) { return a / b; }
long long r(long long a, long long b) { return a % b; }
