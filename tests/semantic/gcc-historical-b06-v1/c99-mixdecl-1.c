/* GCC historical batch06: C99 declarations after statements.
 * Compiler mode/portability distinctions and KCC applicability:
 * docs/GCC-C-BATCH06-REVIEW-20261117-v1.md.
 */
/* Test for C99 mixed declarations and code.  */
/* Origin: Joseph Myers <jsm28@cam.ac.uk> */

extern void abort (void);
extern void exit (int);

int
main (void)
{
  int i = 0;
  if (i != 0)
    abort ();
  i++;
  if (i != 1)
    abort ();
  int j = i;
  if (j != 1)
    abort ();
  struct foo { int i0; } k = { 4 };
  if (k.i0 != 4)
    abort ();
  exit (0);
}
