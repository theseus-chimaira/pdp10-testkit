/* GCC historical batch06: C99 __func__ has distinct object identity.
 * Compiler mode/portability distinctions and KCC applicability:
 * docs/GCC-C-BATCH06-REVIEW-20261117-v1.md.
 */
/* Test for C99 __func__: not merging with string literals.  */
/* Origin: Joseph Myers <jsm28@cam.ac.uk> */

extern void abort (void);
extern void exit (int);

int
main (void)
{
  if ("main" == __func__)
    abort ();
  else
    exit (0);
}
