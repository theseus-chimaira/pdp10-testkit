typedef int Sint;
typedef long long Dint;

volatile Sint __test_exit;
volatile Sint semantic_fail_id;
volatile Sint semantic_sink;

volatile Dint gcheck;

void
fail(id, got)
Sint id;
Sint got;
{
  semantic_fail_id = id;
  semantic_sink = got;
}

void
check_pair(id, value, want_hi, want_lo)
Sint id;
Dint value;
Sint want_hi;
Sint want_lo;
{
  Sint *p;

  gcheck = value;
  p = (Sint *)&gcheck;

  if (p[0] != want_hi) {
    fail(id, p[0]);
    return;
  }

  if (p[1] != want_lo) {
    fail(id + 1, p[1]);
    return;
  }
}

Dint
mkpair(hi, lo)
Sint hi;
Sint lo;
{
  Sint *p;
  Dint x;

  p = (Sint *)&x;
  p[0] = hi;
  p[1] = lo;
  return x;
}

Dint
and_di(a, b)
Dint a;
Dint b;
{
  return a & b;
}

Dint
ior_di(a, b)
Dint a;
Dint b;
{
  return a | b;
}

Dint
xor_di(a, b)
Dint a;
Dint b;
{
  return a ^ b;
}

Dint
not_di(a)
Dint a;
{
  return ~a;
}

int
main()
{
  Dint a;
  Dint b;

  __test_exit = 0;
  semantic_fail_id = 0;
  semantic_sink = 0;

  a = mkpair(012345670123, 076543210765);
  b = mkpair(070707070707, 007070707070);

  check_pair(03000, and_di(a, b), 010305070103, 006040200060);
  if (semantic_fail_id) return 0;

  check_pair(03010, ior_di(a, b), 072747670727, 077573717775);
  if (semantic_fail_id) return 0;

  check_pair(03020, xor_di(a, b), 062442600624, 071533517715);
  if (semantic_fail_id) return 0;

  check_pair(03030, not_di(mkpair(0, 0)), -1, -1);
  if (semantic_fail_id) return 0;

  check_pair(03040, not_di(mkpair(-1, -1)), 0, 0);
  if (semantic_fail_id) return 0;

  check_pair(03050, and_di(mkpair(-1, 0), mkpair(0123, -1)), 0123, 0);
  if (semantic_fail_id) return 0;

  check_pair(03060, ior_di(mkpair(0, -1), mkpair(0123, 0456)), 0123, 0377777777777);
  if (semantic_fail_id) return 0;

  semantic_fail_id = 0;
  semantic_sink = 1;
  __test_exit = 0;

  return 0;
}
