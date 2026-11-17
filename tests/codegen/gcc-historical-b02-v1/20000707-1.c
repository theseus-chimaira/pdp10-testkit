/* GCC historical: GNU local label and computed-goto lowering.
 * See docs/GCC-C-BATCH02-REVIEW-20261117-v1.md for the
 * exact source-level oracle, target gating, and compiler scope.
 */

extern void foo(void *here);
extern inline void bar(void)
{
  __label__ here;
  foo(&&here);
here:
  ;
}

void baz(void)
{
  bar();
}
