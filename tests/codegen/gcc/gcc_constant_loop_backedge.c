/* codegen-require-regex: '(?ms)^gcc_constant_loop_backedge:.*^%L[0-9]+:.*^\s*jrst\s+%L[0-9]+\s*$.*^\s*popj\s+17,\s*$' */

struct four_words {
        unsigned int count;
        unsigned long words[4];
};

void
gcc_constant_loop_backedge(struct four_words *value)
{
        unsigned int i;

        value->count = 0;
        for (i = 0; i < 4; i++)
                value->words[i] = 0;
}
