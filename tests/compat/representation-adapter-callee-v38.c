#include "representation-adapter-v38.h"

daimos_word16_t
ai16v38(daimos_word16_t v)
{
    daimos_int16_t x = DAIMOS_I16_FROM_WORD(v);
    return DAIMOS_I16_TO_WORD(x);
}

daimos_uword16_t
au16v38(daimos_uword16_t v)
{
    daimos_uint16_t x = DAIMOS_U16_FROM_WORD(v);
    return DAIMOS_U16_TO_WORD(x);
}

daimos_word18_t
ai18v38(daimos_word18_t v)
{
    daimos_int18_t x = DAIMOS_I18_FROM_WORD(v);
    return DAIMOS_I18_TO_WORD(x);
}

daimos_uword18_t
au18v38(daimos_uword18_t v)
{
    daimos_uint18_t x = DAIMOS_U18_FROM_WORD(v);
    return DAIMOS_U18_TO_WORD(x);
}

raw72_t
ar72v38(raw72_t v)
{
    raw72_t r;
    r.hi = v.lo;
    r.lo = v.hi;
    return r;
}
