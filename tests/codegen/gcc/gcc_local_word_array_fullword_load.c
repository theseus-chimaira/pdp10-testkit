/* codegen-forbid-regex: '(?ms)^gcc_local_word_array_ful_ca3651:.*?^\\s*ldb\\s' */

struct local_words {
        unsigned long w[4];
};

extern void touch(struct local_words *);

int
gcc_local_word_array_ful_ca3651(unsigned long x)
{
        struct local_words s;

        s.w[1] = x;
        touch(&s);
        return s.w[1] == 0600000000000UL;
}
