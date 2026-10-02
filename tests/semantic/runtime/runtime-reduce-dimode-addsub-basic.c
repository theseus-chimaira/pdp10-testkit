typedef int Sint;
typedef long long Dint;

volatile Sint __test_exit;
volatile Sint semantic_fail_id;
volatile Sint semantic_sink;

volatile Dint ga;
volatile Dint gb;
volatile Dint gc;
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
add_di(a, b)
Dint a;
Dint b;
{
  return a + b;
}

Dint
sub_di(a, b)
Dint a;
Dint b;
{
  return a - b;
}

Dint
neg_di(a)
Dint a;
{
  return -a;
}

Dint
add3_di(a, b, c)
Dint a;
Dint b;
Dint c;
{
  return a + b + c;
}

Dint
sub_chain_di(a, b, c)
Dint a;
Dint b;
Dint c;
{
  return a - b - c;
}

int
main()
{
  Dint t;

  __test_exit = 0;
  semantic_fail_id = 0;
  semantic_sink = 0;

  ga = (Dint)0123;
  gb = (Dint)0456;
  gc = (Dint)0077;

  check_pair(01000, add_di(ga, gb), 0, 0601);
  if (semantic_fail_id) return 0;

  check_pair(01010, sub_di(gb, ga), 0, 0333);
  if (semantic_fail_id) return 0;

  check_pair(01020, add_di(neg_di(ga), ga), 0, 0);
  if (semantic_fail_id) return 0;

  check_pair(01030, sub_di(ga, neg_di(gb)), 0, 0601);
  if (semantic_fail_id) return 0;

  check_pair(01040, neg_di(neg_di(gb)), 0, 0456);
  if (semantic_fail_id) return 0;

  check_pair(01050, add3_di(ga, gb, gc), 0, 0700);
  if (semantic_fail_id) return 0;

  check_pair(01060, sub_chain_di((Dint)0700, gb, gc), 0, 0123);
  if (semantic_fail_id) return 0;

  t = sub_di(ga, gb);
  check_pair(01070, neg_di(t), 0, 0333);
  if (semantic_fail_id) return 0;

  semantic_fail_id = 0;
  semantic_sink = 1;
  __test_exit = 0;

  return 0;
}
