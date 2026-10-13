/* codegen-kcc-expect-compile-fail: yes */
/* codegen-kcc-diagnostic-require-regex: "Integral\\ constant\\ expected" */
int i; int a[3] = { [i] = 1 };
