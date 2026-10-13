/* codegen-kcc-expect-compile-fail: yes */
/* codegen-kcc-diagnostic-require-regex: "Array\\ designator\\ index\\ exceeds\\ array\\ bounds" */
int a[3] = { [3] = 1 };
