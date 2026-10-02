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

int
main()
{
  Dint a;
  Dint b;

  __test_exit = 0;
  semantic_fail_id = 0;
  semantic_sink = 0;

  /*
   * Canonical 71-bit low35 behavior.
   *
   * 0377777777777 + 1 carries into the high word and
   * becomes low word 0.
   */
  a = mkpair(0, 0377777777777);
  b = mkpair(0, 1);
  check_pair(02000, add_di(a, b), 1, 0);
  if (semantic_fail_id) return 0;

  /*
   * Real low-word carry:
   *   [0, 0377777777777] + [0, 1] = [1, 0]
   */
  a = mkpair(0, 0377777777777);
  b = mkpair(0, 1);
  check_pair(02010, add_di(a, b), 1, 0);
  if (semantic_fail_id) return 0;

  /*
   * Real low-word borrow:
   *   [1, 0] - [0, 1] = [0, 0377777777777]
   */
  a = mkpair(1, 0);
  b = mkpair(0, 1);
  check_pair(02020, sub_di(a, b), 0, 0377777777777);
  if (semantic_fail_id) return 0;

  /*
   * Borrow with small visible low-word delta:
   *   [1, 0123] - [0, 0456] = [0, 0377777777445]
   */
  a = mkpair(1, 0123);
  b = mkpair(0, 0456);
  check_pair(02030, sub_di(a, b), 0, 0377777777445);
  if (semantic_fail_id) return 0;

  /*
   * Carry into an existing high word:
   *   [0123, 0377777777777] + [0456, 1] = [0602, 0]
   */
  a = mkpair(0123, 0377777777777);
  b = mkpair(0456, 1);
  check_pair(02040, add_di(a, b), 0602, 0);
  if (semantic_fail_id) return 0;

  /*
   * Borrow from an existing high word:
   *   [0602, 0] - [0456, 1] = [0123, 0377777777777]
   */
  a = mkpair(0602, 0);
  b = mkpair(0456, 1);
  check_pair(02050, sub_di(a, b), 0123, 0377777777777);
  if (semantic_fail_id) return 0;

  semantic_fail_id = 0;
  semantic_sink = 1;
  __test_exit = 0;

  return 0;
}
