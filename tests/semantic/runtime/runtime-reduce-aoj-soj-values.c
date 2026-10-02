typedef unsigned int uSint;
typedef int Sint;

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

static Sint g;

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

static Sint
preinc_local(x)
Sint x;
{
  ++x;
  return x;
}

static Sint
postinc_local(x)
Sint x;
{
  Sint y;

  y = x++;
  return y + x;
}

static Sint
predec_local(x)
Sint x;
{
  --x;
  return x;
}

static Sint
postdec_local(x)
Sint x;
{
  Sint y;

  y = x--;
  return y + x;
}

static Sint
inc_global()
{
  ++g;
  return g;
}

static Sint
dec_global()
{
  --g;
  return g;
}

static Sint
inc_branch(x)
Sint x;
{
  ++x;
  if (x == 0)
    return 11;
  if (x > 0)
    return 22;
  return 33;
}

static Sint
dec_branch(x)
Sint x;
{
  --x;
  if (x == 0)
    return 44;
  if (x < 0)
    return 55;
  return 66;
}

int
main()
{
  semantic_fail_id = 0;
  semantic_sink = (uSint)043;

  if (!check(preinc_local(4), 5, 07000)) return (int)semantic_fail_id;
  if (!check(postinc_local(4), 9, 07001)) return (int)semantic_fail_id;

  if (!check(predec_local(4), 3, 07002)) return (int)semantic_fail_id;
  if (!check(postdec_local(4), 7, 07003)) return (int)semantic_fail_id;

  g = 10;
  if (!check(inc_global(), 11, 07004)) return (int)semantic_fail_id;
  if (!check(inc_global(), 12, 07005)) return (int)semantic_fail_id;

  g = 10;
  if (!check(dec_global(), 9, 07006)) return (int)semantic_fail_id;
  if (!check(dec_global(), 8, 07007)) return (int)semantic_fail_id;

  if (!check(inc_branch(-1), 11, 07010)) return (int)semantic_fail_id;
  if (!check(inc_branch(0), 22, 07011)) return (int)semantic_fail_id;
  if (!check(inc_branch(-3), 33, 07012)) return (int)semantic_fail_id;

  if (!check(dec_branch(1), 44, 07013)) return (int)semantic_fail_id;
  if (!check(dec_branch(0), 55, 07014)) return (int)semantic_fail_id;
  if (!check(dec_branch(3), 66, 07015)) return (int)semantic_fail_id;

  semantic_fail_id = 0;
  semantic_sink = (uSint)1;
  return 0;
}
