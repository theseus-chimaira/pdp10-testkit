typedef int Sint;
typedef long long Dint;
typedef unsigned long long uDint;

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
check_si(id, got, want)
Sint id;
Sint got;
Sint want;
{
  if (got != want) {
    fail(id, got);
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

Sint
slt(a, b)
Dint a;
Dint b;
{
  return a < b;
}

Sint
sgt(a, b)
Dint a;
Dint b;
{
  return a > b;
}

Sint
seq(a, b)
Dint a;
Dint b;
{
  return a == b;
}

Sint
ult(a, b)
uDint a;
uDint b;
{
  return a < b;
}

Sint
ugt(a, b)
uDint a;
uDint b;
{
  return a > b;
}

Sint
ueq(a, b)
uDint a;
uDint b;
{
  return a == b;
}

int
main()
{
  Dint z;
  Dint p1;
  Dint p2;
  Dint lowtop;
  Dint carry1;
  Dint n1;
  Dint n2;

  __test_exit = 0;
  semantic_fail_id = 0;
  semantic_sink = 0;

  z = mkpair(0, 0);
  p1 = mkpair(0, 1);
  p2 = mkpair(1, 0);
  lowtop = mkpair(0, 0377777777777);
  carry1 = mkpair(1, 0);
  n1 = mkpair(-1, 0377777777777);
  n2 = mkpair(-1, 0377777777776);

  check_si(05000, seq(z, z), 1);
  if (semantic_fail_id) return 0;

  check_si(05001, slt(z, p1), 1);
  if (semantic_fail_id) return 0;

  check_si(05002, slt(lowtop, carry1), 1);
  if (semantic_fail_id) return 0;

  check_si(05003, sgt(carry1, lowtop), 1);
  if (semantic_fail_id) return 0;

  check_si(05004, slt(n1, z), 1);
  if (semantic_fail_id) return 0;

  check_si(05005, sgt(z, n1), 1);
  if (semantic_fail_id) return 0;

  check_si(05006, slt(n2, n1), 1);
  if (semantic_fail_id) return 0;

  check_si(05007, sgt(n1, n2), 1);
  if (semantic_fail_id) return 0;

  check_si(05010, ueq((uDint)z, (uDint)z), 1);
  if (semantic_fail_id) return 0;

  check_si(05011, ult((uDint)z, (uDint)p1), 1);
  if (semantic_fail_id) return 0;

  check_si(05012, ult((uDint)lowtop, (uDint)carry1), 1);
  if (semantic_fail_id) return 0;

  check_si(05013, ugt((uDint)n1, (uDint)z), 1);
  if (semantic_fail_id) return 0;

  check_si(05014, ugt((uDint)n1, (uDint)p2), 1);
  if (semantic_fail_id) return 0;

  check_si(05015, ult((uDint)n2, (uDint)n1), 1);
  if (semantic_fail_id) return 0;

  semantic_fail_id = 0;
  semantic_sink = 1;
  __test_exit = 0;

  return 0;
}
