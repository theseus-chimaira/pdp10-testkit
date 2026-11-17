/* Historical GCC packed 36-bit bitfield narrowing and inline call.
 * The original oracle and cross-compiler eligibility are recorded in
 * docs/GCC-C-BATCH03-REVIEW-20261117-v1.md.
 */
/* PR c/6223
   This testcase ICEd in internal check because a constant was not truncated
   for its mode.  */

typedef struct
{
  unsigned a : 16;
  unsigned b : 16;
  unsigned c : 5;
  unsigned d : 2;
  unsigned e : 1;
  unsigned f : 4;
  unsigned g : 1;
  unsigned h : 1;
  unsigned i : 1;
  unsigned j : 1;
} T;

inline void
foo (T *x, unsigned int y)
{
  if ((x->j = (y >= 0x100000)))
    y >>= 12;
  x->a = y;
  x->f = (y >> 16);
}

void __attribute__((noinline))
bar (T *x)
{
}

void
baz (unsigned int x, unsigned char y)
{
  T t;

  foo (&t, x - 1);
  t.e = 1;
  t.c = y;
  t.g = 0;
  t.h = 0;
  t.i = (y & 0x40) != 0;
  if (x == 1)
    foo (&t, 1);
  bar (&t);
}
