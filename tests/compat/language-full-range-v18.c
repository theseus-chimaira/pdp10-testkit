#include "daimos-wide-convert-v1.h"

volatile unsigned int source_u36;
volatile daimos_uint71_t source_u71;
volatile daimos_int71_t source_i71;

int
main(void)
{
    daimos_uint71_t wide;
    unsigned int word;

    source_u36 = DAIMOS_WORD36_TOP;
    wide = daimos_u36_to_u71(source_u36);
    if (daimos_u71_to_u36(wide) != DAIMOS_WORD36_TOP) return 1;

    source_u71 = (daimos_uint71_t)1 << 35;
    word = daimos_u71_to_u36(source_u71);
    if (word != DAIMOS_WORD36_TOP) return 2;

    source_u71 = (daimos_uint71_t)1 << 36;
    if (daimos_u71_to_u36(source_u71) != 0U) return 3;

    source_i71 = (daimos_int71_t)-1;
    if (daimos_i71_to_i36(source_i71) != -1) return 4;

    return 0;
}
