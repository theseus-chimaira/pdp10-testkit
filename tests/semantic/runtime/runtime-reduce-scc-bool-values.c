typedef unsigned int uSint;
typedef int Sint;

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

static void
fail(id, got)
uSint id;
uSint got;
{
  semantic_fail_id = id;
  semantic_sink = got;
}

static int
check(got, expect, id)
int got;
int expect;
uSint id;
{
  if (got != expect)
    {
      fail(id, (uSint)got);
      return 0;
    }
  return 1;
}

static int eqv(a, b) Sint a; Sint b; { return a == b; }
static int nev(a, b) Sint a; Sint b; { return a != b; }
static int ltv(a, b) Sint a; Sint b; { return a < b; }
static int lev(a, b) Sint a; Sint b; { return a <= b; }
static int gtv(a, b) Sint a; Sint b; { return a > b; }
static int gev(a, b) Sint a; Sint b; { return a >= b; }

static int
bool_mix(a, b, c)
Sint a;
Sint b;
Sint c;
{
  int x;
  int y;

  x = (a < b);
  y = (b == c);
  return x + y + (a != c);
}

int
main()
{
  semantic_fail_id = 0;
  semantic_sink = (uSint)041;

  if (!check(eqv(5, 5), 1, 06000)) return (int)semantic_fail_id;
  if (!check(eqv(5, 6), 0, 06001)) return (int)semantic_fail_id;

  if (!check(nev(5, 6), 1, 06002)) return (int)semantic_fail_id;
  if (!check(nev(5, 5), 0, 06003)) return (int)semantic_fail_id;

  if (!check(ltv(-1, 1), 1, 06004)) return (int)semantic_fail_id;
  if (!check(ltv(1, -1), 0, 06005)) return (int)semantic_fail_id;

  if (!check(lev(-1, -1), 1, 06006)) return (int)semantic_fail_id;
  if (!check(lev(2, 1), 0, 06007)) return (int)semantic_fail_id;

  if (!check(gtv(7, 3), 1, 06010)) return (int)semantic_fail_id;
  if (!check(gtv(3, 7), 0, 06011)) return (int)semantic_fail_id;

  if (!check(gev(7, 7), 1, 06012)) return (int)semantic_fail_id;
  if (!check(gev(6, 7), 0, 06013)) return (int)semantic_fail_id;

  if (!check(bool_mix(1, 2, 2), 3, 06014)) return (int)semantic_fail_id;
  if (!check(bool_mix(3, 2, 2), 2, 06015)) return (int)semantic_fail_id;

  semantic_fail_id = 0;
  semantic_sink = (uSint)1;
  return 0;
}
