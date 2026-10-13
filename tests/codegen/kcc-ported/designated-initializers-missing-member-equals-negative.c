/* codegen-kcc-expect-compile-fail: yes */
/* codegen-kcc-diagnostic-require-regex: "=\\ required\\ after\\ designator" */
struct S { int a; }; struct S s = { .a 1 };
