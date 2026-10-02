/* codegen-require-regex: '(?ms)^zero_pair:\s*$\s*\.space\s+8\s*$' */
/* codegen-forbid-regex: '(?ms)^zero_pair:\s*$\s*\.space\s+2\s*$' */

struct pair {
        unsigned long first;
        unsigned long second;
};

struct pair zero_pair = { 0, 0 };
unsigned long following_word;
