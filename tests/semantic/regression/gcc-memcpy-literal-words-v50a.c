/* A literal memcpy is a counted byte copy, not a string copy.
   Preserve every byte outside the selected range and return dest. */
#include <string.h>

static unsigned char buf[24];
static volatile unsigned char *observe = buf;
static unsigned char * volatile pointer;

int main(void)
{
    unsigned int i;
    for (i = 0; i < sizeof(buf); ++i)
        observe[i] = 0777;
    if (memcpy(buf, "A\000B\400\777C", 6) != buf)
        return 1;
    if (observe[0] != 'A' || observe[1] != 0 || observe[2] != 'B'
        || observe[3] != 0400 || observe[4] != 0777
        || observe[5] != 'C' || observe[6] != 0777)
        return 2;
    if (memcpy(buf + 8, "\001\002\003", 3) != buf + 8)
        return 3;
    if (observe[7] != 0777 || observe[8] != 1 || observe[9] != 2
        || observe[10] != 3 || observe[11] != 0777)
        return 4;
    pointer = buf + 13;
    if (memcpy(pointer, "X\000Y", 4) != buf + 13)
        return 5;
    if (observe[12] != 0777 || observe[13] != 'X'
        || observe[14] != 0 || observe[15] != 'Y'
        || observe[16] != 0 || observe[17] != 0777)
        return 6;
    return 0;
}
