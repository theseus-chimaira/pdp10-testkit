/* divmod-si-edge.c - PDP-10 SI div/mod edge sentry.
   C89, ASCII only.

   This complements the basic divmod-si tests.  It deliberately covers
   signed negative dividends/divisors and unsigned values with bit 35 set.
   Those are the cases that a positive-only / low-value shape test will miss.
 */


volatile int divmod_si_edge_sink;
static volatile unsigned int divmod_si_edge_seven = 7U;

int
sider(a, b)
     int a;
     int b;
{
  return a / b;
}

int
simer(a, b)
     int a;
     int b;
{
  return a % b;
}

int
sidec7(a)
     int a;
{
  return a / 7;
}

int
simec7(a)
     int a;
{
  return a % 7;
}

unsigned int
usider(a, b)
     unsigned int a;
     unsigned int b;
{
  return a / b;
}

unsigned int
usimer(a, b)
     unsigned int a;
     unsigned int b;
{
  return a % b;
}

unsigned int
uside7(a)
     unsigned int a;
{
  return a / divmod_si_edge_seven;
}

unsigned int
usime7(a)
     unsigned int a;
{
  return a % divmod_si_edge_seven;
}

static int
expect_int(got, want, tag)
     int got;
     int want;
     int tag;
{
  if (got != want)
    {
      divmod_si_edge_sink = tag;
      return 0;
    }
  return 1;
}

static int
expect_uint(got, want, tag)
     unsigned int got;
     unsigned int want;
     int tag;
{
  if (got != want)
    {
      divmod_si_edge_sink = tag;
      return 0;
    }
  return 1;
}

int
signed_divmod_si_edge_all()
{
  int ok;

  ok = 1;

  ok = ok && expect_int(sider(-98, 7), -14, 1);
  ok = ok && expect_int(simer(-98, 7), 0, 2);
  ok = ok && expect_int(sider(-98, -7), 14, 3);
  ok = ok && expect_int(simer(-98, -7), 0, 4);
  ok = ok && expect_int(sidec7(-98), -14, 5);
  ok = ok && expect_int(simec7(-98), 0, 6);
  ok = ok && expect_int(sidec7(-99), -14, 7);
  ok = ok && expect_int(simec7(-99), -1, 8);

  return ok;
}

int
unsigned_divmod_si_edge_all()
{
  int ok;

  ok = 1;

  ok = ok && expect_uint(usider(0400000000000U, 7U),
                         0044444444444U, 11);
  ok = ok && expect_uint(usimer(0400000000000U, 7U),
                         4U, 12);
  ok = ok && expect_uint(uside7(0400000000000U),
                         0044444444444U, 13);
  ok = ok && expect_uint(usime7(0400000000000U),
                         4U, 14);
  ok = ok && expect_uint(usider(0777777777777U, 7U),
                         0111111111111U, 15);
  ok = ok && expect_uint(usimer(0777777777777U, 7U),
                         0U, 16);
  ok = ok && expect_uint(uside7(0777777777777U),
                         0111111111111U, 17);
  ok = ok && expect_uint(usime7(0777777777777U),
                         0U, 18);

  return ok;
}

int
dsedga()
{
  return signed_divmod_si_edge_all() && unsigned_divmod_si_edge_all();
}
