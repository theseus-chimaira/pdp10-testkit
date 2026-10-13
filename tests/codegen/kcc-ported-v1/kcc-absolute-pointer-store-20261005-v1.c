/* codegen-kcc-policy-only: yes */
/* codegen-kcc-extra: "-Pgnu99" "-m=gas" */
/* codegen-require-regex: "(?im)^\\s*movem\\s+[0-7]+,056$" */
/* codegen-forbid-regex: "(?im)^\\s*movem\\s+[0-7]+,0\\([0-7]+\\)$" */
/* Regression: direct-memory RCONST must not CSE with immediate RCONST. */
typedef unsigned long word_t;
extern word_t source_word;

void
test(void)
{
        *(word_t *)(unsigned long)057 = *(word_t *)(unsigned long)056;
        *(word_t *)(unsigned long)056 = source_word;
}
