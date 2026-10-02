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
mkd(hi, lo)
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
sra_var(a, n)
Dint a;
Sint n;
{
  return a >> n;
}

Dint
sra_1(a)
Dint a;
{
  return a >> 1;
}

Dint
sra_36(a)
Dint a;
{
  return a >> 36;
}

int
main()
{
  Dint x;

  __test_exit = 0;
  semantic_fail_id = 0;
  semantic_sink = 0;

  x = mkd(-1, 0);

  /*
   * Canonical 71-bit result:
   *   [-1, 0] >> 1 => [-1, 0600000000000]
   */
  check_pair(07100, sra_1(x), -1, 0600000000000);
  if (semantic_fail_id) return 0;

  check_pair(07110, sra_var(x, 1), -1, 0600000000000);
  if (semantic_fail_id) return 0;

  check_pair(07120, sra_36(x), -1, 0777777777777);
  if (semantic_fail_id) return 0;

  check_pair(07130, sra_var(x, 36), -1, 0777777777777);
  if (semantic_fail_id) return 0;

  semantic_fail_id = 0;
  semantic_sink = 1;
  __test_exit = 0;

  return 0;
}
