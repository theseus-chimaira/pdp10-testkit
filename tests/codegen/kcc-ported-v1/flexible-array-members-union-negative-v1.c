/* codegen-kcc-expect-compile-fail: yes */
/* codegen-kcc-diagnostic-require-regex: "Flexible\\ array\\ member\\ not\\ allowed\\ in\\ union" */
union U { int n; char data[]; };
