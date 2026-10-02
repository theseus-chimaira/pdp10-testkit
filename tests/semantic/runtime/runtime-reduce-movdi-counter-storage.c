typedef unsigned int uSint;
typedef long long Dint;

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

static Dint counter;
static Dint saved;

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

static Dint
get_counter()
{
  return counter;
}

static void
put_counter(x)
Dint x;
{
  counter = x;
}

static void
save_counter()
{
  saved = counter;
}

int
main()
{
  Dint x;

  semantic_fail_id = 0;
  semantic_sink = (uSint)037;

  set_pair(&counter, (uSint)0123, (uSint)0456);

  x = get_counter();
  if (!check_word(&x, 0, (uSint)0123, 05000)) return (int)semantic_fail_id;
  if (!check_word(&x, 1, (uSint)0456, 05001)) return (int)semantic_fail_id;

  set_pair(&x, (uSint)0777777, (uSint)0377777777777);
  put_counter(x);
  if (!check_word(&counter, 0, (uSint)0777777, 05002)) return (int)semantic_fail_id;
  if (!check_word(&counter, 1, (uSint)0377777777777, 05003)) return (int)semantic_fail_id;

  save_counter();
  if (!check_word(&saved, 0, (uSint)0777777, 05004)) return (int)semantic_fail_id;
  if (!check_word(&saved, 1, (uSint)0377777777777, 05005)) return (int)semantic_fail_id;

  semantic_fail_id = 0;
  semantic_sink = (uSint)1;
  return 0;
}
