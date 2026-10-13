/* codegen-kcc-expect-compile-fail: yes */
/* codegen-kcc-diagnostic-require-regex: "GNU attribute .* is not supported" */
int x __attribute__((visibility("hidden")));
