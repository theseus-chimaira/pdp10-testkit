/* codegen-kcc-expect-compile-fail: yes */
/* codegen-kcc-preprocess: source */
/* codegen-kcc-diagnostic-require-regex: "__VA_ARGS__\\ may\\ only\\ appear\\ in\\ a\\ variadic\\ macro" */
#define BAD(a) __VA_ARGS__
