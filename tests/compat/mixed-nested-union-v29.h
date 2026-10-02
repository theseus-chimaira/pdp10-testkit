#ifndef MIXED_NESTED_UNION_V29_H
#define MIXED_NESTED_UNION_V29_H

typedef long long abi_i71_v29;

struct abi_pair_v29 {
    int left;
    int right;
};

union abi_wide_union_v29 {
    abi_i71_v29 wide;
    struct abi_pair_v29 words;
};

struct abi_nested_v29 {
    int head;
    struct abi_pair_v29 pair;
    union abi_wide_union_v29 value;
    int tail;
};

extern int abi_union_words_v29(union abi_wide_union_v29, int);
extern int abi_nested_sum_v29(int, struct abi_nested_v29, int);

#endif
