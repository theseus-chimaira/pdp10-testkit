/* codegen-kcc-policy-only: yes */
/* codegen-require-regex: "(?im)^helper:" */
/* codegen-kcc-diagnostic-count-regex: "1:\[Warning\] inline function given attribute noinline" "2:\[Warning\] return statement in noreturn function" */
extern void die(void) __attribute__((__noreturn__));
static inline void __attribute__((__noinline__)) helper(void) { }
__attribute__((noreturn)) void bad(void) { return; }
_Noreturn void bad2(void) { return; }
void use(void) { helper(); die(); }
