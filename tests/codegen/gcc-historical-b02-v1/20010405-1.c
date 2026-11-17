/* GCC historical: inline double local static compile-only regression.
 * See docs/GCC-C-BATCH02-REVIEW-20261117-v1.md for the
 * exact source-level oracle, target gating, and compiler scope.
 */
__inline__ double bar(double *x)
{
  static double a;
  a = *x >= 0 ? *x : -*x;
  return a;
}

int main(void)
{
  extern double bar();
  double a;
  static double b;
  int r;
  for (r = 1; r < 3; r++) {
    a = 1.0;
    b = bar(&a);
  }
  return 0;
}
