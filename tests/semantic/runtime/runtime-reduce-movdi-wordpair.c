typedef unsigned int uSint;
typedef long long Dint;

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

static Dint ga = (Dint)012345;
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
load_dint(p)
Dint *p;
{
  return *p;
}

static void
store_dint(p, x)
Dint *p;
Dint x;
{
  *p = x;
}

int
main()
{
  Dint x;
  uSint *w;

  semantic_fail_id = 0;
  semantic_sink = (uSint)031;

  w = (uSint *)&ga;
  w[0] = (uSint)0123456;
  w[1] = (uSint)0654321;

  x = load_dint(&ga);
  store_dint(&gb, x);

  if (!check_word(&gb, 0, (uSint)0123456, 02000)) return (int)semantic_fail_id;
  if (!check_word(&gb, 1, (uSint)0654321, 02001)) return (int)semantic_fail_id;

  gc = gb;

  if (!check_word(&gc, 0, (uSint)0123456, 02002)) return (int)semantic_fail_id;
  if (!check_word(&gc, 1, (uSint)0654321, 02003)) return (int)semantic_fail_id;

  semantic_fail_id = 0;
  semantic_sink = (uSint)1;
  return 0;
}
