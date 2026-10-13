/* codegen-kcc-expect-compile-fail: yes */
/* codegen-kcc-preprocess: source */
/* codegen-kcc-diagnostic-require-regex: "Ellipsis\\ must\\ end\\ macro\\ formal\\ parameter\\ list" */
#define BAD(a, ..., b) a
