typedef unsigned int uSint;
typedef long long Dint;
typedef unsigned long long uDint;

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

static Dint ashl1(x) Dint x; { return x << 1; }
static Dint ashl18(x) Dint x; { return x << 18; }
static Dint ashr1(x) Dint x; { return x >> 1; }
static Dint ashr18(x) Dint x; { return x >> 18; }

static uDint lshr1(x) uDint x; { return x >> 1; }
static uDint lshr18(x) uDint x; { return x >> 18; }

static Dint ashl_var(x, n) Dint x; int n; { return x << n; }
static Dint ashr_var(x, n) Dint x; int n; { return x >> n; }
static uDint lshr_var(x, n) uDint x; int n; { return x >> n; }

int
main()
{
  Dint x;
  Dint y;
  uDint ux;
  uDint uy;

  semantic_fail_id = 0;
  semantic_sink = (uSint)047;

  set_pair(&x, (uSint)0, (uSint)1);
  y = ashl1(x);
  if (!check_word(&y, 0, (uSint)0, 011000)) return (int)semantic_fail_id;
  if (!check_word(&y, 1, (uSint)2, 011001)) return (int)semantic_fail_id;

  y = ashl18(x);
  if (!check_word(&y, 0, (uSint)0, 011002)) return (int)semantic_fail_id;
  if (!check_word(&y, 1, (uSint)01000000, 011003)) return (int)semantic_fail_id;

  set_pair(&x, (uSint)0, (uSint)2);
  y = ashr1(x);
  if (!check_word(&y, 0, (uSint)0, 011004)) return (int)semantic_fail_id;
  if (!check_word(&y, 1, (uSint)1, 011005)) return (int)semantic_fail_id;

  set_pair(&x, (uSint)0, (uSint)01000000);
  y = ashr18(x);
  if (!check_word(&y, 0, (uSint)0, 011006)) return (int)semantic_fail_id;
  if (!check_word(&y, 1, (uSint)1, 011007)) return (int)semantic_fail_id;

  set_pair((Dint *)&ux, (uSint)0, (uSint)2);
  uy = lshr1(ux);
  if (!check_word((Dint *)&uy, 0, (uSint)0, 011010)) return (int)semantic_fail_id;
  if (!check_word((Dint *)&uy, 1, (uSint)1, 011011)) return (int)semantic_fail_id;

  set_pair((Dint *)&ux, (uSint)0, (uSint)01000000);
  uy = lshr18(ux);
  if (!check_word((Dint *)&uy, 0, (uSint)0, 011012)) return (int)semantic_fail_id;
  if (!check_word((Dint *)&uy, 1, (uSint)1, 011013)) return (int)semantic_fail_id;

  set_pair(&x, (uSint)0, (uSint)1);
  y = ashl_var(x, 18);
  if (!check_word(&y, 0, (uSint)0, 011014)) return (int)semantic_fail_id;
  if (!check_word(&y, 1, (uSint)01000000, 011015)) return (int)semantic_fail_id;

  set_pair(&x, (uSint)0, (uSint)01000000);
  y = ashr_var(x, 18);
  if (!check_word(&y, 0, (uSint)0, 011016)) return (int)semantic_fail_id;
  if (!check_word(&y, 1, (uSint)1, 011017)) return (int)semantic_fail_id;

  set_pair((Dint *)&ux, (uSint)0, (uSint)01000000);
  uy = lshr_var(ux, 18);
  if (!check_word((Dint *)&uy, 0, (uSint)0, 011020)) return (int)semantic_fail_id;
  if (!check_word((Dint *)&uy, 1, (uSint)1, 011021)) return (int)semantic_fail_id;

  semantic_fail_id = 0;
  semantic_sink = (uSint)1;
  return 0;
}
