#ifndef MIXED_AGGREGATE_STACK_V28_H
#define MIXED_AGGREGATE_STACK_V28_H

struct abi_three_word_v28 {
    int a;
    int b;
    int c;
};

struct abi_four_word_v28 {
    int a;
    int b;
    int c;
    int d;
};

extern int abi_take_three_v28(int, struct abi_three_word_v28, int);
extern int abi_take_four_v28(int, struct abi_four_word_v28, int);

#endif
