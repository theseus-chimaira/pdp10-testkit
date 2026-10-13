/* codegen-kcc-expect-compile-fail: yes */
/* codegen-kcc-diagnostic-require-regex: "GNU attribute .* is not supported" */
void x(void) __attribute__((constructor));
