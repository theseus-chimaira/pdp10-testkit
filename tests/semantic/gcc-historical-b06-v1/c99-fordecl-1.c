/* GCC historical batch06: C99 for-declaration lexical scope.
 * Compiler mode/portability distinctions and KCC applicability:
 * docs/GCC-C-BATCH06-REVIEW-20261117-v1.md.
 */
/* Test for C99 declarations in for loops.  */
/* Origin: Joseph Myers <jsm28@cam.ac.uk> */

extern void abort (void);
extern void exit (int);

int
main (void)
{
  int j = 0;
  int i = -1;
  for (int i = 1; i <= 10; i++)
    j += i;
  if (j != 55)
    abort ();
  if (i != -1)
    abort ();
  j = 0;
  for (auto int i = 1; i <= 10; i++)
    j += i;
  if (j != 55)
    abort ();
  if (i != -1)
    abort ();
  j = 0;
  for (register int i = 1; i <= 10; i++)
    j += i;
  if (j != 55)
    abort ();
  if (i != -1)
    abort ();
  exit (0);
}
