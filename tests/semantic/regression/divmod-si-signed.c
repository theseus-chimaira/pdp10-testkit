/* divmod-si-signed.c - signed int division/modulo sentry for PDP-10 GCC.

   Purpose:
     Verify the ordinary signed int divsi3/modsi3 path before touching
     DImode division.  On PDP-6/KA10 this should use IDIV/IDIVI style
     code for signed int division and remainder, not an unsigned XKL-only
     operation and not a confused DImode SUBREG allocation.

   This file is C89 and ASCII only.  It is suitable both as an assembly
   shape test and as a simple runtime semantic test.
*/


volatile int divmod_si_signed_sink;

int
sidrr(a, b)
     int a;
     int b;
{
  return a / b;
}

int
simrr(a, b)
     int a;
     int b;
{
  return a % b;
}

int
sidc7(a)
     int a;
{
  return a / 7;
}

int
simc7(a)
     int a;
{
  return a % 7;
}

int
sidsi(a, b)
     int a;
     int b;
{
  int q;
  int r;

  q = a / b;
  r = a % b;
  return q * b + r;
}

int
sidmx(a, b)
     int a;
     int b;
{
  int q;
  int r;

  q = a / b;
  r = a % b;
  divmod_si_signed_sink = q;
  return r;
}

static int
expect_int(got, want, code)
     int got;
     int want;
     int code;
{
  if (got != want)
    {
      divmod_si_signed_sink = code;
      return 0;
    }
  return 1;
}

int
signed_divmod_si_all()
{
  if (!expect_int(sidrr(100, 7), 14, 1))
    return 0;
  if (!expect_int(simrr(100, 7), 2, 2))
    return 0;
  if (!expect_int(sidc7(100), 14, 3))
    return 0;
  if (!expect_int(simc7(100), 2, 4))
    return 0;
  if (!expect_int(sidsi(12345, 97), 12345, 5))
    return 0;
  if (!expect_int(sidmx(12345, 97), 26, 6))
    return 0;

  return 1;
}
