typedef int Sint;
typedef unsigned int uSint;
typedef long long Dint;

typedef Sint (*sfn_t)(Sint, Sint, Sint, Sint, Sint, Sint);
typedef Dint (*dfn_t)(Dint, Dint, Dint);

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

static Dint gda;
static Dint gdb;
static Dint gdc;
static Dint saved_di;

static Sint ext_sint_impl(a, b, c, d, e, f)
Sint a;
Sint b;
Sint c;
Sint d;
Sint e;
Sint f;
{
  return a + b + c + d + e + f + 100;
}

static Dint ext_dint_impl(a, b, c)
Dint a;
Dint b;
Dint c;
{
  gda = a;
  gdb = b;
  gdc = c;
  return b;
}

static sfn_t volatile ps = ext_sint_impl;
static dfn_t volatile pd = ext_dint_impl;

static void
fail(id, got)
uSint id;
uSint got;
{
  semantic_fail_id = id;
  semantic_sink = got;
}

static int
check_si(got, expect, id)
Sint got;
Sint expect;
uSint id;
{
  if (got != expect)
    {
      fail(id, (uSint)got);
      return 0;
    }
  return 1;
}

static int
check_word(p, off, expect, id)
Dint *p;
int off;
uSint expect;
uSint id;
{
  uSint *w;

  w = (uSint *)p;
  if (w[off] != expect)
    {
      fail(id, w[off]);
      return 0;
    }
  return 1;
}

static void
set_pair(p, hi, lo)
Dint *p;
uSint hi;
uSint lo;
{
  uSint *w;

  w = (uSint *)p;
  w[0] = hi;
  w[1] = lo;
}

static Sint
many_si_args(a, b, c, d, e, f, g, h)
Sint a;
Sint b;
Sint c;
Sint d;
Sint e;
Sint f;
Sint g;
Sint h;
{
  Sint x;
  Sint y;

  x = ps(a, b, c, d, e, f);
  y = ps(c, d, e, f, g, h);
  return x + y + a + h;
}

static Sint
local_pressure(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint l0;
  Sint l1;
  Sint l2;
  Sint l3;
  Sint l4;
  Sint l5;

  l0 = a + 1;
  l1 = b + 2;
  l2 = c + 3;
  l3 = l0 + l1;
  l4 = l2 + l3;
  l5 = ps(l0, l1, l2, l3, l4, a);

  return l5 + l4 + l3 + l2 + l1 + l0;
}

static Dint
many_di_args(a, b, c, d)
Dint a;
Dint b;
Dint c;
Dint d;
{
  Dint x;
  Dint y;

  x = pd(a, b, c);
  y = pd(b, c, d);
  saved_di = x;
  return y;
}

int
main()
{
  Dint a;
  Dint b;
  Dint c;
  Dint d;
  Dint r;

  semantic_fail_id = 0;
  semantic_sink = (uSint)051;

  if (!check_si(many_si_args(1, 2, 3, 4, 5, 6, 7, 8), 263, 012000))
    return (int)semantic_fail_id;

  if (!check_si(local_pressure(10, 20, 30), 440, 012001))
    return (int)semantic_fail_id;

  set_pair(&a, (uSint)0101, (uSint)0102);
  set_pair(&b, (uSint)0201, (uSint)0202);
  set_pair(&c, (uSint)0301, (uSint)0302);
  set_pair(&d, (uSint)0401, (uSint)0402);

  r = many_di_args(a, b, c, d);

  if (!check_word(&saved_di, 0, (uSint)0201, 012002)) return (int)semantic_fail_id;
  if (!check_word(&saved_di, 1, (uSint)0202, 012003)) return (int)semantic_fail_id;

  if (!check_word(&r, 0, (uSint)0301, 012004)) return (int)semantic_fail_id;
  if (!check_word(&r, 1, (uSint)0302, 012005)) return (int)semantic_fail_id;

  if (!check_word(&gda, 0, (uSint)0201, 012006)) return (int)semantic_fail_id;
  if (!check_word(&gda, 1, (uSint)0202, 012007)) return (int)semantic_fail_id;

  if (!check_word(&gdb, 0, (uSint)0301, 012010)) return (int)semantic_fail_id;
  if (!check_word(&gdb, 1, (uSint)0302, 012011)) return (int)semantic_fail_id;

  if (!check_word(&gdc, 0, (uSint)0401, 012012)) return (int)semantic_fail_id;
  if (!check_word(&gdc, 1, (uSint)0402, 012013)) return (int)semantic_fail_id;

  semantic_fail_id = 0;
  semantic_sink = (uSint)1;
  return 0;
}
