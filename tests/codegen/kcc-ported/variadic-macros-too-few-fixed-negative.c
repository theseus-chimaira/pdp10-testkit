/* codegen-kcc-expect-compile-fail: yes */
/* codegen-kcc-preprocess: source */
/* codegen-kcc-diagnostic-require-regex: "at\\ least\\ 2\\ expected" */
#define BAD(a, b, ...) a
int x = BAD(1);
