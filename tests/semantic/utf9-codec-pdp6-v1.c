/* Strict UTF-8 -> UTF-9 freestanding smoke test, C99. */
#include "utf9-codec-v1.h"

static const unsigned char input[] = {
    0x41, 0xc3, 0xbf, 0xce, 0x91, 0xf0, 0x90, 0x8c, 0xb0
};

int main(void)
{
    unsigned int output[10];
    unsigned long scalar = 0;
    size_t written = 0, consumed = 0;
    if (p10_utf8_to_utf9_v1(input, sizeof input, output, 10, &written) ||
        written != 7 || output[0] != 0x41 || output[1] != 0xff ||
        output[2] != 0x103 || output[3] != 0x91 ||
        output[4] != 0x101 || output[5] != 0x103 ||
        output[6] != 0x30) return 1;
    if (p10_utf9_decode_v1(output + 4, 3, &scalar, &consumed) ||
        scalar != 0x10330UL || consumed != 3) return 2;
    return 0;
}
