/* PDP-6 UTF-9 strict codec boundary and invalid-input regression (C99). */
#include "utf9-codec-v1.h"

static int roundtrip(unsigned long cp)
{
    unsigned int data[3] = { 0, 0, 0 };
    unsigned long decoded = 0;
    size_t n = 0, used = 0;
    if (p10_utf9_encode_v1(cp, data, 3, &n)) return 1;
    if (p10_utf9_decode_v1(data, n, &decoded, &used)) return 2;
    return decoded != cp || used != n;
}

int main(void)
{
    static const unsigned long valid[] = {
        0, 0x7fUL, 0x80UL, 0xffUL, 0x100UL, 0x7ffUL,
        0x800UL, 0xd7ffUL, 0xe000UL, 0xffffUL,
        0x10000UL, 0x10330UL, 0x10ffffUL
    };
    static const unsigned char invalid_utf8[][4] = {
        {0x80, 0, 0, 0}, {0xc0, 0x80, 0, 0},
        {0xe0, 0x80, 0x80, 0}, {0xed, 0xa0, 0x80, 0},
        {0xf4, 0x90, 0x80, 0x80}, {0xf5, 0x80, 0x80, 0x80}
    };
    unsigned int output[3], invalid_nonets[3] = {0x100, 0x00, 0};
    unsigned long scalar;
    size_t i, count, consumed;
    for (i = 0; i < sizeof(valid)/sizeof(valid[0]); ++i)
        if (roundtrip(valid[i])) return 1;
    if (p10_utf9_encode_v1(0xd800UL, output, 3, &count) != -1 ||
        p10_utf9_encode_v1(0x110000UL, output, 3, &count) != -1)
        return 2;
    if (p10_utf9_decode_v1(invalid_nonets, 2, &scalar, &consumed) != -1)
        return 3;
    for (i = 0; i < sizeof(invalid_utf8)/sizeof(invalid_utf8[0]); ++i)
        if (p10_utf8_to_utf9_v1(invalid_utf8[i], 4, output, 3, &count) == 0)
            return 4;
    {   static const unsigned char text[] = {0x41, 0xce, 0x91};
        output[0] = output[1] = output[2] = 0x1ff;
        if (p10_utf8_to_utf9_v1(text, sizeof(text), output, 2, &count) != -2 ||
            count != 3 || output[0] != 0x1ff || output[1] != 0x1ff)
            return 5;
    }
    return 0;
}
