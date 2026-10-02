typedef int Sint;
typedef long long Dint;
typedef unsigned long long uDint;

volatile Sint __test_exit;
volatile Sint semantic_fail_id;
volatile Sint semantic_sink;

volatile Dint gdcheck;
volatile uDint gucheck;

void
fail(id, got)
Sint id;
Sint got;
{
  semantic_fail_id = id;
  semantic_sink = got;
}

void
check_dpair(id, value, want_hi, want_lo)
Sint id;
Dint value;
Sint want_hi;
Sint want_lo;
{
  Sint *p;

  gdcheck = value;
  p = (Sint *)&gdcheck;

  if (p[0] != want_hi) {
    fail(id, p[0]);
    return;
  }

  if (p[1] != want_lo) {
    fail(id + 1, p[1]);
    return;
  }
}

void
check_upair(id, value, want_hi, want_lo)
Sint id;
uDint value;
Sint want_hi;
Sint want_lo;
{
  Sint *p;

  gucheck = value;
  p = (Sint *)&gucheck;

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
dmul(a, b)
Dint a;
Dint b;
{
  return a * b;
}

uDint
umul(a, b)
uDint a;
uDint b;
{
  return a * b;
}

int
main()
{
  Dint da;
  Dint db;
  uDint ua;
  uDint ub;

  __test_exit = 0;
  semantic_fail_id = 0;
  semantic_sink = 0;

  da = (Dint)0123;
  db = (Dint)0456;

  check_dpair(06300, dmul(da, db), 0, 060752);
  if (semantic_fail_id) return 0;

  check_dpair(06310, dmul((Dint)0, db), 0, 0);
  if (semantic_fail_id) return 0;

  check_dpair(06320, dmul((Dint)1, db), 0, 0456);
  if (semantic_fail_id) return 0;

  check_dpair(06330, dmul((Dint)-1, db), -1, 0777777777322);
  if (semantic_fail_id) return 0;

  check_dpair(06340, dmul((Dint)-2, (Dint)0123), -1, 0777777777532);
  if (semantic_fail_id) return 0;

  ua = (uDint)0123;
  ub = (uDint)0456;

  check_upair(06400, umul(ua, ub), 0, 060752);
  if (semantic_fail_id) return 0;

  check_upair(06410, umul((uDint)0, ub), 0, 0);
  if (semantic_fail_id) return 0;

  check_upair(06420, umul((uDint)1, ub), 0, 0456);
  if (semantic_fail_id) return 0;

  semantic_fail_id = 0;
  semantic_sink = 1;
  __test_exit = 0;

  return 0;
}
