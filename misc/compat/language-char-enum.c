enum daimos_small_enum {
    DAIMOS_ENUM_ZERO = 0,
    DAIMOS_ENUM_ONE = 1,
    DAIMOS_ENUM_NEGATIVE = -1,
    DAIMOS_ENUM_WORD_MAX = 0377777777777
};

static int
check_chars(void)
{
    char plain;
    signed char signed_value;
    unsigned char unsigned_value;

    plain = -1;
    signed_value = -1;
    unsigned_value = 0777;

    if (sizeof(char) != 1)
        return 1;
    if (plain != 0777)
        return 2;
    if (signed_value >= 0)
        return 3;
    if (unsigned_value != 0777)
        return 4;
    if ((plain + 1) != 01000)
        return 5;
    return 0;
}

static int
check_enums(void)
{
    enum daimos_small_enum value;

    if (sizeof(enum daimos_small_enum) != sizeof(int))
        return 10;
    value = DAIMOS_ENUM_NEGATIVE;
    if (value != -1)
        return 11;
    value = DAIMOS_ENUM_WORD_MAX;
    if ((int)value != 0377777777777)
        return 12;
    return 0;
}

int
main(void)
{
    int result;

    result = check_chars();
    if (result != 0)
        return result;
    return check_enums();
}
