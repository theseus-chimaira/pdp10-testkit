/* GCC historical: C-level noreturn and mixed long/double calls.
 * See docs/GCC-C-BATCH02-REVIEW-20261117-v1.md for the
 * exact source-level oracle, target gating, and compiler scope.
 */
extern void abort(void);

void die (long) __attribute__ ((noreturn));

void die (long e)
{
  abort ();
  for (;;);
}

long foo (double i)
{
  if (i != 2.0)
    abort ();
  return 26;
}

long bar (long i, double x)
{
  if (x < 0) die (1);
  return foo (x);
}

int main(void)
{
  return bar(0, 2.0) != 26;
}
