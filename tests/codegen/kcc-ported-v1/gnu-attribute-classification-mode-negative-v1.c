/* codegen-kcc-expect-compile-fail: yes */
/* codegen-kcc-diagnostic-require-regex: "GNU attribute .* is not supported" */
typedef int x __attribute__((mode(SI)));
