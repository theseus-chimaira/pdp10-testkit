typedef int Sint;
typedef long long Dint;
typedef unsigned long long uDint;

volatile Sint __test_exit;
volatile Sint semantic_fail_id;
volatile Sint semantic_sink;

volatile Dint gdleft;
volatile Dint gdright;
volatile uDint guleft;
volatile uDint guright;

void
fail(id, got)
Sint id;
Sint got;
{
  semantic_fail_id = id;
  semantic_sink = got;
}

void
check_dsame(id, a, b)
Sint id;
Dint a;
Dint b;
{
  Sint *pa;
  Sint *pb;

  gdleft = a;
  gdright = b;

  pa = (Sint *)&gdleft;
  pb = (Sint *)&gdright;

  if (pa[0] != pb[0]) {
    fail(id, pa[0]);
    return;
  }

  if (pa[1] != pb[1]) {
    fail(id + 1, pa[1]);
    return;
  }
}

void
check_usame(id, a, b)
Sint id;
uDint a;
uDint b;
{
  Sint *pa;
  Sint *pb;

  guleft = a;
  guright = b;

  pa = (Sint *)&guleft;
  pb = (Sint *)&guright;

  if (pa[0] != pb[0]) {
    fail(id, pa[0]);
    return;
  }

  if (pa[1] != pb[1]) {
    fail(id + 1, pa[1]);
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

uDint
mku(hi, lo)
Sint hi;
Sint lo;
{
  Sint *p;
  uDint x;

  p = (Sint *)&x;
  p[0] = hi;
  p[1] = lo;
  return x;
}

Dint sra_var(a, n) Dint a; Sint n; { return a >> n; }
Dint sra_1(a) Dint a; { return a >> 1; }
Dint sra_35(a) Dint a; { return a >> 35; }
Dint sra_36(a) Dint a; { return a >> 36; }
Dint sra_37(a) Dint a; { return a >> 37; }

uDint srl_var(a, n) uDint a; Sint n; { return a >> n; }
uDint srl_1(a) uDint a; { return a >> 1; }
uDint srl_35(a) uDint a; { return a >> 35; }
uDint srl_36(a) uDint a; { return a >> 36; }
uDint srl_37(a) uDint a; { return a >> 37; }

uDint sll_var(a, n) uDint a; Sint n; { return a << n; }
uDint sll_1(a) uDint a; { return a << 1; }
uDint sll_35(a) uDint a; { return a << 35; }
uDint sll_36(a) uDint a; { return a << 36; }
uDint sll_37(a) uDint a; { return a << 37; }

int
main()
{
  Dint dn1;
  Dint dn2;
  Dint dp;
  uDint u1;
  uDint u2;
  uDint u3;

  __test_exit = 0;
  semantic_fail_id = 0;
  semantic_sink = 0;

  dn1 = mkd(-1, 0);
  dn2 = mkd(-1, -2);
  dp = mkd(0123, 0456);

  u1 = mku(1, 0);
  u2 = mku(0, 1);
  u3 = mku(0123, 0456);

  check_dsame(06000, sra_1(dn1), sra_var(dn1, 1));
  if (semantic_fail_id) return 0;

  check_dsame(06010, sra_35(dn1), sra_var(dn1, 35));
  if (semantic_fail_id) return 0;

  check_dsame(06020, sra_36(dn1), sra_var(dn1, 36));
  if (semantic_fail_id) return 0;

  check_dsame(06030, sra_37(dn1), sra_var(dn1, 37));
  if (semantic_fail_id) return 0;

  check_dsame(06040, sra_1(dn2), sra_var(dn2, 1));
  if (semantic_fail_id) return 0;

  check_dsame(06050, sra_35(dp), sra_var(dp, 35));
  if (semantic_fail_id) return 0;

  check_usame(06100, srl_1(u1), srl_var(u1, 1));
  if (semantic_fail_id) return 0;

  check_usame(06110, srl_35(u1), srl_var(u1, 35));
  if (semantic_fail_id) return 0;

  check_usame(06120, srl_36(u1), srl_var(u1, 36));
  if (semantic_fail_id) return 0;

  check_usame(06130, srl_37(u1), srl_var(u1, 37));
  if (semantic_fail_id) return 0;

  check_usame(06140, srl_1(u3), srl_var(u3, 1));
  if (semantic_fail_id) return 0;

  check_usame(06150, srl_35(u3), srl_var(u3, 35));
  if (semantic_fail_id) return 0;

  check_usame(06200, sll_1(u2), sll_var(u2, 1));
  if (semantic_fail_id) return 0;

  check_usame(06210, sll_35(u2), sll_var(u2, 35));
  if (semantic_fail_id) return 0;

  check_usame(06220, sll_36(u2), sll_var(u2, 36));
  if (semantic_fail_id) return 0;

  check_usame(06230, sll_37(u2), sll_var(u2, 37));
  if (semantic_fail_id) return 0;

  check_usame(06240, sll_1(u3), sll_var(u3, 1));
  if (semantic_fail_id) return 0;

  check_usame(06250, sll_35(u3), sll_var(u3, 35));
  if (semantic_fail_id) return 0;

  semantic_fail_id = 0;
  semantic_sink = 1;
  __test_exit = 0;

  return 0;
}
