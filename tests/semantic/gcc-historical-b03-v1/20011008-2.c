/* Historical GCC anonymous union promoted field alias runtime.
 * The original oracle and cross-compiler eligibility are recorded in
 * docs/GCC-C-BATCH03-REVIEW-20261117-v1.md.
 */
extern void abort(void);
extern void exit(int);

struct { union {int x; int y;}; int q; } b;
union { struct {int x;}; int q; } e;

main()
{
  b.y = 10;
  b.x = 15;
  if (b.y != 15)
    abort();

  e.x = 10;
  e.q = 15;
  if (e.x != 15)
    abort();

  exit(0);
}
