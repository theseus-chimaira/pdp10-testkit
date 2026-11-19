typedef unsigned long int st;
typedef unsigned long long dt;
typedef union
{
  dt d;
  struct
  {
    st h, l;
  }
  s;
} t_be;

typedef union
{
  dt d;
  struct
  {
    st l, h;
  }
  s;
} t_le;

#define df(f, t) \
int \
f (t afh, t bfh) \
{ \
  t hh; \
  t hp, lp, dp, m; \
  st ad, bd; \
  int s; \
  s = 0; \
  ad = afh.s.h - afh.s.l; \
  bd = bfh.s.l - bfh.s.h; \
  if (bd > bfh.s.l) \
    { \
      bd = -bd; \
      s = ~s; \
    } \
  lp.d = (dt) afh.s.l * bfh.s.l; \
  hp.d = (dt) afh.s.h * bfh.s.h; \
  dp.d = (dt) ad *bd; \
  dp.d ^= s; \
  hh.d = hp.d + hp.s.h + lp.s.h + dp.s.h; \
  m.d = (dt) lp.s.h + hp.s.l + lp.s.l + dp.s.l; \
  return hh.s.l + m.s.l; \
}

df(f_le, t_le)
df(f_be, t_be)


/* PDP10 original 960416-1.c exact Karatsuba function bodies.
 * ABI reference: unsigned long=36, unsigned long long=71,
 * physical continuation word holds low35 and copies top sign bit.
 * Decimal values derive independently from Python modulo 2^36/2^71.
 * Original unsigned arithmetic and return-by-value union are tested;
 * unrelated vacuous 32/32-bit preconditions are removed.
 */
extern void abort(void);
volatile unsigned int fail_id;
static volatile dt first_v1, second_v1;

int
main(void)
{
    t_be be_first_v1, be_second_v1;
    t_le le_first_v1, le_second_v1;
    st actual_v1;
    /* Case 1: independent be oracle 34359738367 (36-bit unsigned). */
    first_v1 = 34359738368ULL;
    second_v1 = 34359738368ULL;
    be_first_v1.d = first_v1;
    be_second_v1.d = second_v1;
    actual_v1 = (st)f_be(be_first_v1, be_second_v1);
    if (actual_v1 != 34359738367UL) {
        fail_id = 1;
        abort();
    }
    /* Case 2: independent le oracle 1 (36-bit unsigned). */
    first_v1 = 34359738368ULL;
    second_v1 = 34359738368ULL;
    le_first_v1.d = first_v1;
    le_second_v1.d = second_v1;
    actual_v1 = (st)f_le(le_first_v1, le_second_v1);
    if (actual_v1 != 1UL) {
        fail_id = 2;
        abort();
    }
    /* Case 3: independent be oracle 207343379 (36-bit unsigned). */
    first_v1 = 9998683939653ULL;
    second_v1 = 38139310012560ULL;
    be_first_v1.d = first_v1;
    be_second_v1.d = second_v1;
    actual_v1 = (st)f_be(be_first_v1, be_second_v1);
    if (actual_v1 != 207343379UL) {
        fail_id = 3;
        abort();
    }
    /* Case 4: independent le oracle 4 (36-bit unsigned). */
    first_v1 = 9998683939653ULL;
    second_v1 = 38139310012560ULL;
    le_first_v1.d = first_v1;
    le_second_v1.d = second_v1;
    actual_v1 = (st)f_le(le_first_v1, le_second_v1);
    if (actual_v1 != 4UL) {
        fail_id = 4;
        abort();
    }
    /* Case 5: independent be oracle 1233522441 (36-bit unsigned). */
    first_v1 = 18760417358933ULL;
    second_v1 = 858995700548ULL;
    be_first_v1.d = first_v1;
    be_second_v1.d = second_v1;
    actual_v1 = (st)f_be(be_first_v1, be_second_v1);
    if (actual_v1 != 1233522441UL) {
        fail_id = 5;
        abort();
    }
    /* Case 6: independent le oracle 17 (36-bit unsigned). */
    first_v1 = 18760417358933ULL;
    second_v1 = 858995700548ULL;
    le_first_v1.d = first_v1;
    le_second_v1.d = second_v1;
    actual_v1 = (st)f_le(le_first_v1, le_second_v1);
    if (actual_v1 != 17UL) {
        fail_id = 6;
        abort();
    }
    return 0;
}
