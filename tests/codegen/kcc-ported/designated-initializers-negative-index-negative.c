/* codegen-kcc-expect-compile-fail: yes */
/* codegen-kcc-diagnostic-require-regex: "Array\\ designator\\ index\\ must\\ not\\ be\\ negative" */
int a[3] = { [-1] = 1 };
