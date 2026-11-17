/* Historical GCC struct pointer store and increment from negative one.
 * The original oracle and cross-compiler eligibility are recorded in
 * docs/GCC-C-BATCH03-REVIEW-20261117-v1.md.
 */
/* PR optimization/5844
   This testcase was miscompiled because of an rtx sharing bug.  */

struct A
{
  struct A *a;
  int b;
};

struct B
{
  struct A *c;
  unsigned int d;
};

struct A p = { &p, -1 };
struct B q = { &p, 0 };

extern void abort (void);
extern void exit (int);

struct B *
foo (void)
{
  return &q;
}

void
bar (void)
{
  struct B *e = foo ();
  struct A *f = e->c;
  int g = f->b;

  if (++g == 0)
    {
      e->d++;
      e->c = f->a;
    }

  f->b = g;
}

int
main ()
{
  bar ();
  if (p.b != 0 || q.d != 1 || q.c != &p)
    abort ();
  exit (0);
}
