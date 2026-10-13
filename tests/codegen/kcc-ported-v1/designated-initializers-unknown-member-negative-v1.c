/* codegen-kcc-expect-compile-fail: yes */
/* codegen-kcc-diagnostic-require-regex: "Unknown\\ struct/union\\ member\\ in\\ initializer" */
struct S { int a; }; struct S s = { .missing = 1 };
