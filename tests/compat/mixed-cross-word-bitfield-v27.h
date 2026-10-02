#ifndef MIXED_CROSS_WORD_BITFIELD_V27_H
#define MIXED_CROSS_WORD_BITFIELD_V27_H

struct cross_word_bits_v27 {
    unsigned int a:20;
    unsigned int b:20;
    unsigned int c:20;
};

extern struct cross_word_bits_v27 cross_word_bits_v27;
extern int cross_word_check_v27(void);

#endif
