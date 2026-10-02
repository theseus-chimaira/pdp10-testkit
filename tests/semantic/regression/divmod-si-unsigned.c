/* divmod-si-unsigned.c - unsigned int division/modulo sentry for PDP-10 GCC.

   Purpose:
     Verify that unsigned int division/modulo does not accidentally use
     XKL2-only UIDIV/UIMOD instructions on PDP-6/KA10.  For -march=166
     and -march=ka10, assembly should go through libgcc helpers instead.
     For -march=xkl2, the target may use the XKL2 UIDIV/UIMOD patterns.

   This file is C89 and ASCII only.  It is suitable both as an assembly
   shape test and as a simple runtime semantic test.
*/


volatile unsigned int divmod_si_unsigned_sink;
static volatile unsigned int divmod_si_unsigned_seven = 7U;

unsigned int
usidrr(a, b)
     unsigned int a;
     unsigned int b;
{
  return a / b;
}

unsigned int
usimrr(a, b)
     unsigned int a;
     unsigned int b;
{
  return a % b;
}

unsigned int
usidc7(a)
     unsigned int a;
{
  return a / divmod_si_unsigned_seven;
}

unsigned int
usimc7(a)
     unsigned int a;
{
  return a % divmod_si_unsigned_seven;
}

unsigned int
usidsi(a, b)
     unsigned int a;
     unsigned int b;
{
  unsigned int q;
  unsigned int r;

  q = a / b;
  r = a % b;
  return q * b + r;
}

unsigned int
usidmx(a, b)
     unsigned int a;
     unsigned int b;
{
  unsigned int q;
  unsigned int r;

  q = a / b;
  r = a % b;
  divmod_si_unsigned_sink = q;
  return r;
}

static int
expect_uint(got, want, code)
     unsigned int got;
     unsigned int want;
     int code;
{
  if (got != want)
    {
      divmod_si_unsigned_sink = (unsigned int) code;
      return 0;
    }
  return 1;
}

int
unsigned_divmod_si_all()
{
  if (!expect_uint(usidrr(100U, 7U), 14U, 1))
    return 0;
  if (!expect_uint(usimrr(100U, 7U), 2U, 2))
    return 0;
  if (!expect_uint(usidc7(100U), 14U, 3))
    return 0;
  if (!expect_uint(usimc7(100U), 2U, 4))
    return 0;
  if (!expect_uint(usidsi(12345U, 97U), 12345U, 5))
    return 0;
  if (!expect_uint(usidmx(12345U, 97U), 26U, 6))
    return 0;

  return 1;
}
