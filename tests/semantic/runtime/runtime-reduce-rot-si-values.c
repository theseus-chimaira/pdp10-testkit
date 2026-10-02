typedef unsigned int uSint;

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
uSint got;
uSint expect;
uSint id;
{
  if (got != expect)
    {
      fail(id, got);
      return 0;
    }
  return 1;
}

static uSint rotl1(x) uSint x; { return (x << 1) | (x >> 35); }
static uSint rotr1(x) uSint x; { return (x >> 1) | (x << 35); }

static uSint rotl9(x) uSint x; { return (x << 9) | (x >> 27); }
static uSint rotr9(x) uSint x; { return (x >> 9) | (x << 27); }

static uSint rotl18(x) uSint x; { return (x << 18) | (x >> 18); }
static uSint rotr18(x) uSint x; { return (x >> 18) | (x << 18); }

int
main()
{
  semantic_fail_id = 0;
  semantic_sink = (uSint)045;

  if (!check(rotl1((uSint)0400000000000), (uSint)1, 010000)) return (int)semantic_fail_id;
  if (!check(rotr1((uSint)1), (uSint)0400000000000, 010001)) return (int)semantic_fail_id;

  if (!check(rotl9((uSint)1), (uSint)01000, 010002)) return (int)semantic_fail_id;
  if (!check(rotr9((uSint)01000), (uSint)1, 010003)) return (int)semantic_fail_id;

  if (!check(rotl18((uSint)1), (uSint)01000000, 010004)) return (int)semantic_fail_id;
  if (!check(rotr18((uSint)01000000), (uSint)1, 010005)) return (int)semantic_fail_id;

  if (!check(rotl18((uSint)0777777777777), (uSint)0777777777777, 010006)) return (int)semantic_fail_id;
  if (!check(rotr18((uSint)0777777777777), (uSint)0777777777777, 010007)) return (int)semantic_fail_id;

  semantic_fail_id = 0;
  semantic_sink = (uSint)1;
  return 0;
}
