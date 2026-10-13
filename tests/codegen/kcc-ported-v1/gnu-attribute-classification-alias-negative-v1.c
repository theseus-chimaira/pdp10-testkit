/* codegen-kcc-expect-compile-fail: yes */
/* codegen-kcc-diagnostic-require-regex: "GNU attribute .* is not supported" */
extern int x(void) __attribute__((alias("y")));
