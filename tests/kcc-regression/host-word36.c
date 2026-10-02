/* Host-width regression: these values require a full PDP-10 word. */
#define LH_MASK 0777777000000L
#define TAG_FLAG (0200000L << 18)
#define UNV_END 0373737373737L

unsigned long
word_mask(unsigned long v)
{
    return (v & LH_MASK) | TAG_FLAG;
}

int
is_unv_end(unsigned long v)
{
    return v == UNV_END;
}

long
signed_word(void)
{
    return 0400000000000L;
}
