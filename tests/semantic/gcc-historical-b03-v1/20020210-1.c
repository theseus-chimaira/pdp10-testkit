/* Historical GCC five-argument call forwarding and fourth argument.
 * The original oracle and cross-compiler eligibility are recorded in
 * docs/GCC-C-BATCH03-REVIEW-20261117-v1.md.
 */
/* This used fail on H8/300 due to incorrect specification of pushi1.  */


extern void abort (void);
extern void exit (int);

void
bar (int a, int b, int c, int d, int e)
{
  if (d != 1)
    abort ();
}

void
foo (int a, int b, int c, int d, int e)
{
  bar (a, b, c, d, e);
}

int
main ()
{
  foo (0, 0, 0, 1, 2);
  exit (0);
}
