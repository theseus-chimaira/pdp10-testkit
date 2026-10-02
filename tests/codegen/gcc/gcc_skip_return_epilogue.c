/* codegen-require-regex: '(?ms)^gcc_skip_return_epilogue:.*?^\s*jrst\s+%L[0-9]+\s*$\s*(?:^%L[0-9]+:\s*$\s*)?^\s*popj\s+17,\s*$' */

typedef unsigned long word_t;

static word_t *buffer;
static word_t buffer_words;

void
gcc_skip_return_epilogue(void)
{
        word_t *p;
        word_t i;

        if (buffer == 0)
                return;
        p = buffer;
        for (i = 0; i < buffer_words; i++)
                p[i] = 0;
}
