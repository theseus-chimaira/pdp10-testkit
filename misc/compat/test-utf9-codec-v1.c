/* Host-side RFC 4042 codec validation; linked with utf9-codec-v1.c. */
#include <stdio.h>
#include "utf9-codec-v1.h"

static int check(unsigned long scalar, unsigned int a, unsigned int b,
                 unsigned int c, size_t length)
{
    unsigned int units[3] = { 0, 0, 0 };
    unsigned long decoded = ~0UL;
    size_t written = 0, consumed = 0;
    if (p10_utf9_encode_v1(scalar, units, 3, &written) || written != length ||
        units[0] != a || units[1] != b || units[2] != c ||
        p10_utf9_decode_v1(units, written, &decoded, &consumed) ||
        consumed != length || decoded != scalar) return 1;
    return 0;
}

int main(void)
{
    unsigned int malformed[][3] = {
        { 0x100, 0, 0 }, { 0x100, 0x01, 0 },
        { 0x100, 0x100, 0 }, { 0x101, 0x100, 0 },
        { 0x1d8, 0x00, 0 }, { 0x111, 0x100, 0 }
    };
    unsigned long value;
    size_t count, i;
    if (check(0, 0, 0, 0, 1) ||
        check(0x41, 0101, 0, 0, 1) ||
        check(0xff, 0377, 0, 0, 1) ||
        check(0x100, 0401, 0000, 0, 2) ||
        check(0x391, 0403, 0221, 0, 2) ||
        check(0xffff, 0777, 0377, 0, 2) ||
        check(0x10000, 0401, 0400, 0, 3) ||
        check(0x10330, 0401, 0403, 0060, 3) ||
        check(0x10ffff, 0420, 0777, 0377, 3)) return 1;
    for (i = 0; i < sizeof malformed / sizeof malformed[0]; ++i)
        if (p10_utf9_decode_v1(malformed[i], 2, &value, &count) == 0)
            return 2;
    if (p10_utf9_encode_v1(0xd800, malformed[0], 3, &count) == 0 ||
        p10_utf9_encode_v1(0x110000, malformed[0], 3, &count) == 0 ||
        p10_utf9_decode_v1(malformed[0], 0, &value, &count) != -2)
        return 3;
    for (value = 0; value <= 0x10ffffUL; ++value) {
        unsigned int units[3];
        unsigned long restored = 0;
        size_t written = 0, consumed = 0;
        if (value >= 0xd800UL && value <= 0xdfffUL) continue;
        if (p10_utf9_encode_v1(value, units, 3, &written) ||
            p10_utf9_decode_v1(units, written, &restored, &consumed) ||
            restored != value || consumed != written) return 4;
    }
    puts("UTF-9 codec v1: PASS");
    return 0;
}
