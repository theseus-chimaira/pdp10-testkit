/* divmod-di-sentry.c - PDP-10 DImode division/modulo compile/shape sentry.
   C89-compatible source.  ASCII only.  */

#include "insns.h"

volatile Dint divmod_di_sink;

Dint
di_div_rr (a, b)
Dint a;
Dint b;
{
  return a / b;
}

Dint
di_mod_rr (a, b)
Dint a;
Dint b;
{
  return a % b;
}

Dint
di_div_const7 (a)
Dint a;
{
  return a / (Dint)7;
}

Dint
di_mod_const7 (a)
Dint a;
{
  return a % (Dint)7;
}

Dint
di_div_pow2 (a)
Dint a;
{
  return a / (Dint)8;
}

Dint
di_mod_pow2 (a)
Dint a;
{
  return a % (Dint)8;
}

Dint
di_divmod_identity (a, b)
Dint a;
Dint b;
{
  return (a / b) * b + (a % b);
}

Dint
di_divmod_mix (a, b)
Dint a;
Dint b;
{
  Dint q;
  Dint r;

  q = a / b;
  r = a % b;
  divmod_di_sink = q;
  return r;
}

int
divmod_di_compile_all (a, b)
Dint a;
Dint b;
{
  Dint x;

  x = di_div_rr (a, b);
  x ^= di_mod_rr (a, b);
  x ^= di_div_const7 (a);
  x ^= di_mod_const7 (a);
  x ^= di_div_pow2 (a);
  x ^= di_mod_pow2 (a);
  x ^= di_divmod_identity (a, b);
  x ^= di_divmod_mix (a, b);

  divmod_di_sink = x;
  return x != (Dint)0;
}
