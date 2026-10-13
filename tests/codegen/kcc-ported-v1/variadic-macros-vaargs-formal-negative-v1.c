/* codegen-kcc-expect-compile-fail: yes */
/* codegen-kcc-preprocess: source */
/* codegen-kcc-diagnostic-require-regex: "__VA_ARGS__\\ is\\ reserved\\ for\\ variadic\\ macro\\ arguments" */
#define BAD(__VA_ARGS__) 1
