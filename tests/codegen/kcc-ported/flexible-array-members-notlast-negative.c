/* codegen-kcc-expect-compile-fail: yes */
/* codegen-kcc-diagnostic-require-regex: "Flexible\\ array\\ member\\ must\\ be\\ last\\ in\\ struct" */
struct S { int n; char data[]; int x; };
