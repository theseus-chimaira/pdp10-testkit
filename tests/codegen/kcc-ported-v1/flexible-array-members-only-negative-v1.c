/* codegen-kcc-expect-compile-fail: yes */
/* codegen-kcc-diagnostic-require-regex: "Flexible\\ array\\ member\\ in\\ otherwise\\ empty\\ struct" */
struct S { char data[]; };
