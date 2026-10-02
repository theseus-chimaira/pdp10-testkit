typedef unsigned int uSint;
typedef long long Dint;

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

static Dint ga;
static Dint gb;
static Dint gc;

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

static Dint
id_dint(x)
Dint x;
{
  return x;
}

static Dint
second_dint(a, b)
Dint a;
Dint b;
{
  ga = a;
  return b;
}

static void
store_three(a, b, c)
Dint a;
Dint b;
Dint c;
{
  ga = a;
  gb = b;
  gc = c;
}

int
main()
{
  Dint a;
  Dint b;
  Dint c;
  Dint x;
  uSint *w;

  semantic_fail_id = 0;
  semantic_sink = (uSint)033;

  w = (uSint *)&a;
  w[0] = (uSint)010001;
  w[1] = (uSint)010002;

  w = (uSint *)&b;
  w[0] = (uSint)020001;
  w[1] = (uSint)020002;

  w = (uSint *)&c;
  w[0] = (uSint)030001;
  w[1] = (uSint)030002;

  x = id_dint(a);
  if (!check_word(&x, 0, (uSint)010001, 03000)) return (int)semantic_fail_id;
  if (!check_word(&x, 1, (uSint)010002, 03001)) return (int)semantic_fail_id;

  x = second_dint(a, b);
  if (!check_word(&ga, 0, (uSint)010001, 03002)) return (int)semantic_fail_id;
  if (!check_word(&ga, 1, (uSint)010002, 03003)) return (int)semantic_fail_id;
  if (!check_word(&x, 0, (uSint)020001, 03004)) return (int)semantic_fail_id;
  if (!check_word(&x, 1, (uSint)020002, 03005)) return (int)semantic_fail_id;

  store_three(a, b, c);
  if (!check_word(&ga, 0, (uSint)010001, 03006)) return (int)semantic_fail_id;
  if (!check_word(&ga, 1, (uSint)010002, 03007)) return (int)semantic_fail_id;
  if (!check_word(&gb, 0, (uSint)020001, 03010)) return (int)semantic_fail_id;
  if (!check_word(&gb, 1, (uSint)020002, 03011)) return (int)semantic_fail_id;
  if (!check_word(&gc, 0, (uSint)030001, 03012)) return (int)semantic_fail_id;
  if (!check_word(&gc, 1, (uSint)030002, 03013)) return (int)semantic_fail_id;

  semantic_fail_id = 0;
  semantic_sink = (uSint)1;
  return 0;
}
