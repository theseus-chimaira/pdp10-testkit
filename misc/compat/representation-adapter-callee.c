#include "representation-adapter.h"

pdp10_word16_t
ai16v38(pdp10_word16_t v)
{
    pdp10_int16_t x = PDP10_I16_FROM_WORD(v);
    return PDP10_I16_TO_WORD(x);
}

pdp10_uword16_t
au16v38(pdp10_uword16_t v)
{
    pdp10_uint16_t x = PDP10_U16_FROM_WORD(v);
    return PDP10_U16_TO_WORD(x);
}

pdp10_word18_t
ai18v38(pdp10_word18_t v)
{
    pdp10_int18_t x = PDP10_I18_FROM_WORD(v);
    return PDP10_I18_TO_WORD(x);
}

pdp10_uword18_t
au18v38(pdp10_uword18_t v)
{
    pdp10_uint18_t x = PDP10_U18_FROM_WORD(v);
    return PDP10_U18_TO_WORD(x);
}

raw72_t
ar72v38(raw72_t v)
{
    raw72_t r;
    r.hi = v.lo;
    r.lo = v.hi;
    return r;
}
