#ifndef DAIMOS_WIDE_CONVERT_V1_H
#define DAIMOS_WIDE_CONVERT_V1_H

typedef long long daimos_int71_t;
typedef unsigned long long daimos_uint71_t;

#define DAIMOS_WORD35_MASK 0377777777777U
#define DAIMOS_WORD36_TOP 0400000000000U

union daimos_u71_words_v1 {
    daimos_uint71_t value;
    struct {
        unsigned int high;
        unsigned int low;
    } word;
};

static daimos_uint71_t
daimos_u36_to_u71(unsigned int value)
{
    union daimos_u71_words_v1 result;

    result.word.high = value >> 35;
    result.word.low = value & DAIMOS_WORD35_MASK;
    return result.value;
}

static unsigned int
daimos_u71_to_u36(daimos_uint71_t value)
{
    union daimos_u71_words_v1 source;

    source.value = value;
    return (source.word.low & DAIMOS_WORD35_MASK) |
           ((source.word.high & 1U) << 35);
}

static int
daimos_i71_to_i36(daimos_int71_t value)
{
    return (int)daimos_u71_to_u36((daimos_uint71_t)value);
}

#endif
