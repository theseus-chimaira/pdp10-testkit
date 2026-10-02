#include "insns.h"

/*
 * Immediate constant coverage for PDP-6/166 and KA10.
 *
 * This file is deliberately ordinary C.  It tries to make GCC choose
 * immediate forms and immediate-friendly halfword/test forms from
 * constants in the right half, constants in the left half, complements
 * of right-half constants, and small compare constants.
 */

#define RH_MASK        0777777
#define LH_MASK        0777777000000
#define RH_A           0000000123456
#define RH_B           0000000765432
#define RH_ONE         0000000000001
#define RH_BIG         0000000777776
#define LH_ONE         000001000000
#define LH_A           0123456000000
#define LH_B           0765432000000
#define SIGN_BIT       0400000000000
#define ALL_ONES       0777777777777

static Sint gi;
static uSint gu;
static volatile Sint vgi;
static volatile uSint vgu;
static Hint gh;
static uHint guh;
static Qint gq;
static uQint guq;

#define BINCONST(NAME, OP, C) \
static Sint NAME ## _reg (Sint x) { return x OP C; } \
static Sint NAME ## _mem (Sint *p) { return *p OP C; } \
static Sint NAME ## _glob (Sint x) { gi = gi OP C; return gi + x; } \
static Sint NAME ## _vol (Sint x) { vgi = vgi OP C; return vgi + x; }

BINCONST (addi_1,        +, RH_ONE)
BINCONST (addi_rha,      +, RH_A)
BINCONST (addi_rhmax,    +, RH_MASK)
BINCONST (subi_1,        -, RH_ONE)
BINCONST (subi_rha,      -, RH_A)
BINCONST (subi_rhmax,    -, RH_MASK)
BINCONST (imuli_2,       *, 2)
BINCONST (imuli_7,       *, 7)
BINCONST (imuli_rha,     *, RH_A)
BINCONST (iori_1,        |, RH_ONE)
BINCONST (iori_rha,      |, RH_A)
BINCONST (andi_1,        &, RH_ONE)
BINCONST (andi_rha,      &, RH_A)
BINCONST (andi_rhmask,   &, RH_MASK)
BINCONST (xori_1,        ^, RH_ONE)
BINCONST (xori_rha,      ^, RH_A)
BINCONST (xori_rhmask,   ^, RH_MASK)

#define UNCONST(NAME, EXPR) \
static Sint NAME ## _reg (Sint x) { return (EXPR); } \
static Sint NAME ## _mem (Sint *p) { Sint x = *p; return (EXPR); } \
static Sint NAME ## _glob (void) { Sint x = gi; gi = (EXPR); return gi; } \
static Sint NAME ## _vol (void) { Sint x = vgi; vgi = (EXPR); return vgi; }

UNCONST (eqvi_rha,     ~(x ^ RH_A))
UNCONST (eqvi_rhmask,  ~(x ^ RH_MASK))
UNCONST (orcmi_rha,    x | ~RH_A)
UNCONST (orcmi_rhmask, x | ~RH_MASK)
UNCONST (orcbi_rha,    ~x | ~RH_A)
UNCONST (orcbi_rhmask, ~x | ~RH_MASK)
UNCONST (andcmi_rha,   x & ~RH_A)
UNCONST (andcmi_mask,  x & ~RH_MASK)
UNCONST (andcbi_rha,   ~x & ~RH_A)
UNCONST (andcbi_mask,  ~x & ~RH_MASK)

#define LHCONST(NAME, EXPR) \
static Sint NAME ## _reg (Sint x) { return (EXPR); } \
static Sint NAME ## _mem (Sint *p) { Sint x = *p; return (EXPR); } \
static Sint NAME ## _glob (Sint x) { gi = (EXPR); return gi; } \
static Sint NAME ## _vol (Sint x) { vgi = (EXPR); return vgi; }

LHCONST (tlo_one,        x | LH_ONE)
LHCONST (tlo_a,          x | LH_A)
LHCONST (tlc_one,        x ^ LH_ONE)
LHCONST (tlc_a,          x ^ LH_A)
LHCONST (tlz_one,        x & ~LH_ONE)
LHCONST (tlz_a,          x & ~LH_A)
LHCONST (hllz_mask,      x & LH_MASK)
LHCONST (hrrz_mask,      x & RH_MASK)
LHCONST (hrlo_like,      (x & LH_MASK) | RH_MASK)
LHCONST (hrro_like,      (x & RH_MASK) | LH_MASK)
LHCONST (sign_toggle,    x ^ SIGN_BIT)
LHCONST (sign_set,       x | SIGN_BIT)
LHCONST (sign_clear,     x & ~SIGN_BIT)

static Sint movei_zero (void) { return 0; }
static Sint movei_one (void) { return 1; }
static Sint movei_rha (void) { return RH_A; }
static Sint movei_rhmax (void) { return RH_MASK; }
static Sint movni_one (void) { return -1; }
static Sint movni_rha (void) { return -RH_A; }
static Sint movni_rhmax (void) { return -RH_MASK; }
static Sint movsi_one (void) { return LH_ONE; }
static Sint movsi_a (void) { return LH_A; }
static Sint hrroi_rha (void) { return ~RH_A; }
static Sint hrloi_a (void) { return LH_A | RH_MASK; }
static Sint seto_const (void) { return -1; }
static Sint allones_const (void) { return ALL_ONES; }

static void store_movei (Sint *p) { *p = RH_A; }
static void store_movni (Sint *p) { *p = -RH_A; }
static void store_movsi (Sint *p) { *p = LH_A; }
static void store_seto (Sint *p) { *p = -1; }
static void store_zero (Sint *p) { *p = 0; }

#define CMPRET(NAME, OP, C) \
static Sint NAME ## _ret (Sint x) { return x OP C; } \
static Sint NAME ## _if (Sint x) { if (x OP C) return x + 1; return x - 1; } \
static Sint NAME ## _mem (Sint *p) { Sint x = *p; if (x OP C) *p = x + 1; else *p = x - 1; return *p; }

CMPRET (caie_zero, !=, 0)
CMPRET (cain_zero, ==, 0)
CMPRET (caie_one,  !=, 1)
CMPRET (cain_one,  ==, 1)
CMPRET (cail_rha,  <,  RH_A)
CMPRET (caile_rha, <=, RH_A)
CMPRET (caige_rha, >=, RH_A)
CMPRET (caig_rha,  >,  RH_A)
CMPRET (cail_rhmax,  <,  RH_MASK)
CMPRET (caile_rhmax, <=, RH_MASK)
CMPRET (caige_rhmax, >=, RH_MASK)
CMPRET (caig_rhmax,  >,  RH_MASK)

#define UCMPRET(NAME, OP, C) \
static Sint NAME ## _ret (uSint x) { return x OP (uSint)(C); } \
static uSint NAME ## _if (uSint x) { if (x OP (uSint)(C)) return x + 1; return x - 1; }

UCMPRET (ucai_lt_one,  <,  1)
UCMPRET (ucai_ge_one,  >=, 1)
UCMPRET (ucai_lt_rha,  <,  RH_A)
UCMPRET (ucai_ge_rha,  >=, RH_A)
UCMPRET (ucai_lt_sign, <,  SIGN_BIT)
UCMPRET (ucai_ge_sign, >=, SIGN_BIT)

static Sint addi_index (Sint *p, Sint i) { return p[i + 1] + p[i + RH_ONE]; }
static Sint addi_addr (Sint *p) { Sint *q = p + RH_ONE; return *q; }
static Sint subi_addr (Sint *p) { Sint *q = p - RH_ONE; return *q; }
static Sint movei_addr (Sint *p) { return *(p + 3); }

static Sint q_addi (Qint x) { return x + 3; }
static Sint q_andi (Qint x) { return x & 077; }
static Sint q_ori (Qint x) { return x | 017; }
static Sint q_xori (Qint x) { return x ^ 013; }
static Sint h_addi (Hint x) { return x + 3; }
static Sint h_andi (Hint x) { return x & 07777; }
static Sint h_ori (Hint x) { return x | 01234; }
static Sint h_xori (Hint x) { return x ^ 05670; }

static uSint uq_addi (uQint x) { return x + 3U; }
static uSint uq_andi (uQint x) { return x & 077U; }
static uSint uh_addi (uHint x) { return x + 3U; }
static uSint uh_andi (uHint x) { return x & 07777U; }

static Sint q_global (Qint x)
{
	gq = (Qint)(x + 1);
	guq = (uQint)(guq | 017);
	return (Sint)gq + (Sint)guq;
}

static Sint h_global (Hint x)
{
	gh = (Hint)(x + 1);
	guh = (uHint)(guh & 07777);
	return (Sint)gh + (Sint)guh;
}

static uSint unsigned_immediates (uSint x)
{
	gu = (gu + 1U) ^ RH_B;
	vgu = (vgu | RH_A) & ~RH_ONE;
	return (x + RH_A) ^ gu ^ vgu;
}

static Sint mixed_immediates (Sint x, Sint y)
{
	Sint a;
	Sint b;
	Sint c;

	a = (x + RH_A) ^ (y | RH_B);
	b = (a & ~RH_ONE) | LH_ONE;
	c = (b ^ LH_A) - RH_A;
	if (c != RH_BIG)
		c += 1;
	return c;
}

static Sint use_immediate_all (Sint x, Sint y, Sint *p)
{
	return addi_rha_reg (x)
	    + subi_rha_reg (x)
	    + imuli_7_reg (x)
	    + iori_rha_reg (x)
	    + andi_rhmask_reg (x)
	    + xori_rha_reg (x)
	    + eqvi_rha_reg (x)
	    + orcmi_rha_reg (x)
	    + andcmi_rha_reg (x)
	    + tlo_a_reg (x)
	    + tlc_a_reg (x)
	    + tlz_a_reg (x)
	    + caie_one_ret (y)
	    + caile_rha_ret (y)
	    + q_addi ((Qint)x)
	    + h_addi ((Hint)x)
	    + mixed_immediates (x, y)
	    + addi_index (p, y & 7);
}
