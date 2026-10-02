typedef int Sint;
typedef unsigned int uSint;
typedef long long Dint;
typedef unsigned long long uDint;

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

static Dint ga = (Dint)012345;
static Dint gb;
static Dint gd_arr[4] = {
  (Dint)1,
  (Dint)2,
  (Dint)3,
  (Dint)4
};

static void
fail(id, got)
uSint id;
uSint got;
{
  semantic_fail_id = id;
  semantic_sink = got;
}

static int
check_sint(got, expect, id)
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

static Dint
load_dint(p)
Dint *p;
{
  Dint x;
  x = *p;
  return x;
}

static void
store_dint(p, x)
Dint *p;
Dint x;
{
  *p = x;
}

static Dint
copy_dint(dst, src)
Dint *dst;
Dint *src;
{
  Dint x;
  x = *src;
  *dst = x;
  return *dst;
}

static Dint
array_load(i)
int i;
{
  Dint x;
  x = gd_arr[i & 3];
  return x;
}

static void
array_store(i, x)
int i;
Dint x;
{
  gd_arr[i & 3] = x;
}

int
main()
{
  Dint x;
  Dint local[4];

  semantic_fail_id = 0;
  semantic_sink = (uSint)027;

  local[0] = (Dint)10;
  local[1] = (Dint)20;
  local[2] = (Dint)30;
  local[3] = (Dint)40;

  x = load_dint(&ga);
  if (!check_sint((Sint)x, (Sint)012345, 01000)) return (int)semantic_fail_id;

  store_dint(&gb, x);
  if (!check_sint((Sint)gb, (Sint)012345, 01001)) return (int)semantic_fail_id;

  x = copy_dint(&local[2], &local[1]);
  if (!check_sint((Sint)x, (Sint)20, 01002)) return (int)semantic_fail_id;
  if (!check_sint((Sint)local[2], (Sint)20, 01003)) return (int)semantic_fail_id;

  x = array_load(2);
  if (!check_sint((Sint)x, (Sint)3, 01004)) return (int)semantic_fail_id;

  array_store(3, x);
  if (!check_sint((Sint)gd_arr[3], (Sint)3, 01005)) return (int)semantic_fail_id;

  semantic_fail_id = 0;
  semantic_sink = (uSint)1;
  return 0;
}
