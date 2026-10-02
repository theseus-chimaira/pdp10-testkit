typedef int Sint;
typedef unsigned int uSint;
typedef long long Dint;
typedef unsigned long long uDint;

volatile Sint __test_exit;
volatile Sint semantic_fail_id;
volatile Sint semantic_sink;

volatile Dint ga;
volatile Dint gb;
volatile Dint gc;

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

Sint
signed_cmp_pack(a, b)
Dint a;
Dint b;
{
  Sint r;

  r = 0;
  if (a == b) r = r + 1;
  if (a != b) r = r + 2;
  if (a < b)  r = r + 4;
  if (a <= b) r = r + 8;
  if (a > b)  r = r + 16;
  if (a >= b) r = r + 32;

  return r;
}

Sint
unsigned_cmp_pack(a, b)
uDint a;
uDint b;
{
  Sint r;

  r = 0;
  if (a == b) r = r + 1;
  if (a != b) r = r + 2;
  if (a < b)  r = r + 4;
  if (a <= b) r = r + 8;
  if (a > b)  r = r + 16;
  if (a >= b) r = r + 32;

  return r;
}

Sint
signed_bool_sum(a, b)
Dint a;
Dint b;
{
  return (a == b)
       + ((a != b) << 1)
       + ((a < b) << 2)
       + ((a <= b) << 3)
       + ((a > b) << 4)
       + ((a >= b) << 5);
}

Sint
unsigned_bool_sum(a, b)
uDint a;
uDint b;
{
  return (a == b)
       + ((a != b) << 1)
       + ((a < b) << 2)
       + ((a <= b) << 3)
       + ((a > b) << 4)
       + ((a >= b) << 5);
}

int
main()
{
  Dint a;
  Dint b;
  Dint n;

  __test_exit = 0;
  semantic_fail_id = 0;
  semantic_sink = 0;

  a = (Dint)0123;
  b = (Dint)0456;
  n = -((Dint)0123);

  ga = a;
  gb = b;
  gc = n;

  /*
   * Encoding:
   * eq=1, ne=2, lt=4, le=8, gt=16, ge=32
   */
  check_si(04000, signed_cmp_pack(a, a), 051);
  if (semantic_fail_id) return 0;

  check_si(04001, signed_cmp_pack(a, b), 016);
  if (semantic_fail_id) return 0;

  check_si(04002, signed_cmp_pack(b, a), 062);
  if (semantic_fail_id) return 0;

  check_si(04003, signed_cmp_pack(n, a), 016);
  if (semantic_fail_id) return 0;

  check_si(04004, signed_cmp_pack(a, n), 062);
  if (semantic_fail_id) return 0;

  check_si(04010, signed_bool_sum(a, a), 051);
  if (semantic_fail_id) return 0;

  check_si(04011, signed_bool_sum(a, b), 016);
  if (semantic_fail_id) return 0;

  check_si(04012, signed_bool_sum(b, a), 062);
  if (semantic_fail_id) return 0;

  check_si(04013, signed_bool_sum(n, a), 016);
  if (semantic_fail_id) return 0;

  check_si(04014, signed_bool_sum(a, n), 062);
  if (semantic_fail_id) return 0;

  check_si(04020, unsigned_cmp_pack((uDint)a, (uDint)a), 051);
  if (semantic_fail_id) return 0;

  check_si(04021, unsigned_cmp_pack((uDint)a, (uDint)b), 016);
  if (semantic_fail_id) return 0;

  check_si(04022, unsigned_cmp_pack((uDint)b, (uDint)a), 062);
  if (semantic_fail_id) return 0;

  check_si(04030, unsigned_bool_sum((uDint)a, (uDint)a), 051);
  if (semantic_fail_id) return 0;

  check_si(04031, unsigned_bool_sum((uDint)a, (uDint)b), 016);
  if (semantic_fail_id) return 0;

  check_si(04032, unsigned_bool_sum((uDint)b, (uDint)a), 062);
  if (semantic_fail_id) return 0;

  semantic_fail_id = 0;
  semantic_sink = 1;
  __test_exit = 0;

  return 0;
}
