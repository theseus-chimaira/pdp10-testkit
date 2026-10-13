typedef int Sint;
typedef long long Dint;
typedef unsigned long long uDint;

volatile Sint __test_exit;
volatile Sint semantic_fail_id;
volatile Sint semantic_sink;

/* Representation checks must not introduce a signed/unsigned conversion.
 * Such a conversion is a separate semantic operation and can change the
 * normalized low-word sign bit. */
volatile Dint gdcheck;
volatile Dint gdwant;
volatile uDint gucheck;
volatile uDint guwant;

void
fail(id, got)
Sint id;
Sint got;
{
  semantic_fail_id = id;
  semantic_sink = got;
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

void
check_usame(id, value, want)
Sint id;
uDint value;
uDint want;
{
  Sint *pv;
  Sint *pw;

  gucheck = value;
  guwant = want;
  pv = (Sint *)&gucheck;
  pw = (Sint *)&guwant;

  if (pv[0] != pw[0]) {
    fail(id, pv[0]);
    return;
  }

  if (pv[1] != pw[1]) {
    fail(id + 1, pv[1]);
    return;
  }
}

void
check_dsame(id, value, want)
Sint id;
Dint value;
Dint want;
{
  Sint *pv;
  Sint *pw;

  gdcheck = value;
  gdwant = want;
  pv = (Sint *)&gdcheck;
  pw = (Sint *)&gdwant;

  if (pv[0] != pw[0]) {
    fail(id, pv[0]);
    return;
  }

  if (pv[1] != pw[1]) {
    fail(id + 1, pv[1]);
    return;
  }
}

uDint
udivv(a, b)
uDint a;
uDint b;
{
  return a / b;
}

uDint
umodv(a, b)
uDint a;
uDint b;
{
  return a % b;
}

Dint
divv(a, b)
Dint a;
Dint b;
{
  return a / b;
}

Dint
modv(a, b)
Dint a;
Dint b;
{
  return a % b;
}

int
main()
{
  uDint un;
  uDint ud;
  uDint uw;
  Dint sn;
  Dint sd;
  Dint dw;

  __test_exit = 0;
  semantic_fail_id = 0;
  semantic_sink = 0;

  un = mku(01234567, 0265432123456);
  ud = mku(0123, 04567);
  uw = mku(00, 010035);
  check_usame(07000, udivv(un, ud), uw);
  if (semantic_fail_id) return 0;
  uw = mku(020, 0265364022263);
  check_usame(07010, umodv(un, ud), uw);
  if (semantic_fail_id) return 0;

  un = mku(07, 0377777777777);
  ud = mku(02, 01234567);
  uw = mku(00, 03);
  check_usame(07020, udivv(un, ud), uw);
  if (semantic_fail_id) return 0;
  uw = mku(01, 0377774051632);
  check_usame(07030, umodv(un, ud), uw);
  if (semantic_fail_id) return 0;

  un = mku(0123456, 0654321);
  ud = mku(077, 012345);
  uw = mku(00, 01247);
  check_usame(07040, udivv(un, ud), uw);
  if (semantic_fail_id) return 0;
  uw = mku(024, 0377762766556);
  check_usame(07050, umodv(un, ud), uw);
  if (semantic_fail_id) return 0;

  un = mku(0377777777777, 0377777777776);
  ud = mku(012345, 06701234567);
  uw = mku(00, 030401775);
  check_usame(07060, udivv(un, ud), uw);
  if (semantic_fail_id) return 0;
  uw = mku(04223, 0222046750143);
  check_usame(07070, umodv(un, ud), uw);
  if (semantic_fail_id) return 0;

  un = mku(1, 0);
  ud = mku(0, 3);
  uw = mku(00, 0125252525252);
  check_usame(07100, udivv(un, ud), uw);
  if (semantic_fail_id) return 0;
  uw = mku(00, 02);
  check_usame(07110, umodv(un, ud), uw);
  if (semantic_fail_id) return 0;

  sn = mkd(-05346, 0371076656331);
  sd = mkd(077, 012345);
  dw = mkd(0777777777777, 0377777777724);
  check_dsame(07120, divv(sn, sd), dw);
  if (semantic_fail_id) return 0;
  dw = mkd(0777777777756, 0371077572065);
  check_dsame(07130, modv(sn, sd), dw);
  if (semantic_fail_id) return 0;

  sn = mkd(012345, 06701234567);
  sd = mkd(-0100, 0377777765433);
  dw = mkd(0777777777777, 0377777777654);
  check_dsame(07140, divv(sn, sd), dw);
  if (semantic_fail_id) return 0;
  dw = mkd(071, 06677457123);
  check_dsame(07150, modv(sn, sd), dw);
  if (semantic_fail_id) return 0;

  sn = mkd(-05346, 0371076656331);
  sd = mkd(-0100, 0377777765433);
  dw = mkd(00, 054);
  check_dsame(07160, divv(sn, sd), dw);
  if (semantic_fail_id) return 0;
  dw = mkd(0777777777756, 0371077572065);
  check_dsame(07170, modv(sn, sd), dw);
  if (semantic_fail_id) return 0;

  sn = mkd(0400000000000, 0);
  sd = mkd(0, 3);
  dw = mkd(0652525252525, 0125252525253);
  check_dsame(07200, divv(sn, sd), dw);
  if (semantic_fail_id) return 0;
  dw = mkd(0777777777777, 0377777777777);
  check_dsame(07210, modv(sn, sd), dw);
  if (semantic_fail_id) return 0;



  /* Extra v14 closure edges. */
  un = mku(01, 00);
  ud = mku(02, 05);
  uw = mku(00, 00);
  check_usame(07220, udivv(un, ud), uw);
  if (semantic_fail_id) return 0;
  uw = mku(01, 00);
  check_usame(07230, umodv(un, ud), uw);
  if (semantic_fail_id) return 0;

  un = mku(012345, 0377777777776);
  ud = mku(012345, 0377777777776);
  uw = mku(00, 01);
  check_usame(07240, udivv(un, ud), uw);
  if (semantic_fail_id) return 0;
  uw = mku(00, 00);
  check_usame(07250, umodv(un, ud), uw);
  if (semantic_fail_id) return 0;

  un = mku(01234567, 0365432107654);
  ud = mku(0123, 0377777777770);
  uw = mku(00, 07754);
  check_usame(07260, udivv(un, ud), uw);
  if (semantic_fail_id) return 0;
  uw = mku(07, 0365432207414);
  check_usame(07270, umodv(un, ud), uw);
  if (semantic_fail_id) return 0;

  un = mku(015652471, 0125252525316);
  ud = mku(00, 0123);
  uw = mku(0125252, 0124234213645);
  check_usame(07300, udivv(un, ud), uw);
  if (semantic_fail_id) return 0;
  uw = mku(00, 0117);
  check_usame(07310, umodv(un, ud), uw);
  if (semantic_fail_id) return 0;

  sn = mkd(-0400000000000, 00);
  sd = mkd(00, 05);
  dw = mkd(0714631463146, 0146314631464);
  check_dsame(07320, divv(sn, sd), dw);
  if (semantic_fail_id) return 0;
  dw = mkd(0777777777777, 0377777777774);
  check_dsame(07330, modv(sn, sd), dw);
  if (semantic_fail_id) return 0;

  un = mku(057, 0123);
  ud = mku(010, 00);
  uw = mku(00, 05);
  check_usame(07340, udivv(un, ud), uw);
  if (semantic_fail_id) return 0;
  uw = mku(07, 0123);
  check_usame(07350, umodv(un, ud), uw);
  if (semantic_fail_id) return 0;

  semantic_fail_id = 0;
  semantic_sink = 1;
  __test_exit = 0;

  return 0;
}
