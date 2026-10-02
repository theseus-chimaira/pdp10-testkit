/* cmpdi-sentry.c - DImode comparison compile/shape sentry for PDP-10 GCC/KCC.
   C89-compatible source.  ASCII only.  */

#include "insns.h"

volatile Dint cmpdi_s_sink;
volatile uDint cmpdi_u_sink;
volatile int cmpdi_i_sink;

static int
cmpdi_yes (void)
{
  cmpdi_i_sink += 1;
  return 1;
}

static int
cmpdi_no (void)
{
  cmpdi_i_sink += 2;
  return 0;
}

Dint
cmpdi_keep_s (x)
Dint x;
{
  cmpdi_s_sink = x;
  return cmpdi_s_sink;
}

uDint
cmpdi_keep_u (x)
uDint x;
{
  cmpdi_u_sink = x;
  return cmpdi_u_sink;
}

int sdi_eq_bool (a, b) Dint a; Dint b; { return a == b; }
int sdi_ne_bool (a, b) Dint a; Dint b; { return a != b; }
int sdi_lt_bool (a, b) Dint a; Dint b; { return a < b; }
int sdi_le_bool (a, b) Dint a; Dint b; { return a <= b; }
int sdi_gt_bool (a, b) Dint a; Dint b; { return a > b; }
int sdi_ge_bool (a, b) Dint a; Dint b; { return a >= b; }

int udi_eq_bool (a, b) uDint a; uDint b; { return a == b; }
int udi_ne_bool (a, b) uDint a; uDint b; { return a != b; }
int udi_lt_bool (a, b) uDint a; uDint b; { return a < b; }
int udi_le_bool (a, b) uDint a; uDint b; { return a <= b; }
int udi_gt_bool (a, b) uDint a; uDint b; { return a > b; }
int udi_ge_bool (a, b) uDint a; uDint b; { return a >= b; }

int
sdi_eq_branch (a, b)
Dint a;
Dint b;
{
  if (a == b)
    return cmpdi_yes ();
  return cmpdi_no ();
}

int
sdi_ne_branch (a, b)
Dint a;
Dint b;
{
  if (a != b)
    return cmpdi_yes ();
  return cmpdi_no ();
}

int
sdi_lt_branch (a, b)
Dint a;
Dint b;
{
  if (a < b)
    return cmpdi_yes ();
  return cmpdi_no ();
}

int
sdi_le_branch (a, b)
Dint a;
Dint b;
{
  if (a <= b)
    return cmpdi_yes ();
  return cmpdi_no ();
}

int
sdi_gt_branch (a, b)
Dint a;
Dint b;
{
  if (a > b)
    return cmpdi_yes ();
  return cmpdi_no ();
}

int
sdi_ge_branch (a, b)
Dint a;
Dint b;
{
  if (a >= b)
    return cmpdi_yes ();
  return cmpdi_no ();
}

int
udi_eq_branch (a, b)
uDint a;
uDint b;
{
  if (a == b)
    return cmpdi_yes ();
  return cmpdi_no ();
}

int
udi_ne_branch (a, b)
uDint a;
uDint b;
{
  if (a != b)
    return cmpdi_yes ();
  return cmpdi_no ();
}

int
udi_lt_branch (a, b)
uDint a;
uDint b;
{
  if (a < b)
    return cmpdi_yes ();
  return cmpdi_no ();
}

int
udi_le_branch (a, b)
uDint a;
uDint b;
{
  if (a <= b)
    return cmpdi_yes ();
  return cmpdi_no ();
}

int
udi_gt_branch (a, b)
uDint a;
uDint b;
{
  if (a > b)
    return cmpdi_yes ();
  return cmpdi_no ();
}

int
udi_ge_branch (a, b)
uDint a;
uDint b;
{
  if (a >= b)
    return cmpdi_yes ();
  return cmpdi_no ();
}

int sdi_eq_m1 (a) Dint a; { return a == (Dint)-1; }
int sdi_lt_0 (a) Dint a; { return a < (Dint)0; }
int sdi_ge_0 (a) Dint a; { return a >= (Dint)0; }

int udi_eq_allones (a) uDint a; { return a == ~(uDint)0; }
int udi_lt_high36 (a) uDint a; { return a < ((uDint)1 << 35); }
int udi_ge_high40 (a) uDint a; { return a >= ((uDint)1 << 40); }

int
cmpdi_sentry_all (a, b, ua, ub)
Dint a;
Dint b;
uDint ua;
uDint ub;
{
  int ok;

  ok = 1;
  ok &= sdi_eq_bool (a, b) == sdi_eq_branch (a, b);
  ok &= sdi_ne_bool (a, b) == sdi_ne_branch (a, b);
  ok &= sdi_lt_bool (a, b) == sdi_lt_branch (a, b);
  ok &= sdi_le_bool (a, b) == sdi_le_branch (a, b);
  ok &= sdi_gt_bool (a, b) == sdi_gt_branch (a, b);
  ok &= sdi_ge_bool (a, b) == sdi_ge_branch (a, b);

  ok &= udi_eq_bool (ua, ub) == udi_eq_branch (ua, ub);
  ok &= udi_ne_bool (ua, ub) == udi_ne_branch (ua, ub);
  ok &= udi_lt_bool (ua, ub) == udi_lt_branch (ua, ub);
  ok &= udi_le_bool (ua, ub) == udi_le_branch (ua, ub);
  ok &= udi_gt_bool (ua, ub) == udi_gt_branch (ua, ub);
  ok &= udi_ge_bool (ua, ub) == udi_ge_branch (ua, ub);

  cmpdi_s_sink = a + b;
  cmpdi_u_sink = ua + ub;
  return ok;
}
