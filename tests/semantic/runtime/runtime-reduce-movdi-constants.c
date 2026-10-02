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

/* 2^36 + 012345 in default 71-bit DImode: high=2, low=012345. */
static Dint
ret_c1()
{
  return (Dint)68719482085LL;
}

/* 2^51 + 012345 in default 71-bit DImode: high=0200000, low=012345. */
static Dint
ret_c2()
{
  return (Dint)2251799813690597LL;
}

/* 2^36 - 1 in default 71-bit DImode: high=1, low=0377777777777. */
static Dint
ret_c3()
{
  return (Dint)68719476735LL;
}

static void
store_c1(p)
Dint *p;
{
  *p = (Dint)68719482085LL;
}

static void
store_c2(p)
Dint *p;
{
  *p = (Dint)2251799813690597LL;
}

static void
store_c3(p)
Dint *p;
{
  *p = (Dint)68719476735LL;
}

int
main()
{
  Dint x;

  semantic_fail_id = 0;
  semantic_sink = (uSint)035;

  x = ret_c1();
  ga = x;
  if (!check_word(&ga, 0, (uSint)2, 04000)) return (int)semantic_fail_id;
  if (!check_word(&ga, 1, (uSint)012345, 04001)) return (int)semantic_fail_id;

  x = ret_c2();
  gb = x;
  if (!check_word(&gb, 0, (uSint)0200000, 04002)) return (int)semantic_fail_id;
  if (!check_word(&gb, 1, (uSint)012345, 04003)) return (int)semantic_fail_id;

  x = ret_c3();
  gc = x;
  if (!check_word(&gc, 0, (uSint)1, 04004)) return (int)semantic_fail_id;
  if (!check_word(&gc, 1, (uSint)0377777777777, 04005)) return (int)semantic_fail_id;

  store_c1(&ga);
  if (!check_word(&ga, 0, (uSint)2, 04006)) return (int)semantic_fail_id;
  if (!check_word(&ga, 1, (uSint)012345, 04007)) return (int)semantic_fail_id;

  store_c2(&gb);
  if (!check_word(&gb, 0, (uSint)0200000, 04010)) return (int)semantic_fail_id;
  if (!check_word(&gb, 1, (uSint)012345, 04011)) return (int)semantic_fail_id;

  store_c3(&gc);
  if (!check_word(&gc, 0, (uSint)1, 04012)) return (int)semantic_fail_id;
  if (!check_word(&gc, 1, (uSint)0377777777777, 04013)) return (int)semantic_fail_id;

  semantic_fail_id = 0;
  semantic_sink = (uSint)1;
  return 0;
}
