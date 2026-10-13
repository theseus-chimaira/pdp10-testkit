/* codegen-kcc-expect-compile-fail: yes */
/* codegen-kcc-diagnostic-require-regex: "Flexible\\ or\\ incomplete\\ array\\ member\\ cannot\\ be\\ initialized" */
struct S { int n; char data[]; }; struct S s = { 1, { 2, 3 } };
