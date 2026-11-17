/* GCC historical batch06: C99 digraph token pasting and stringizing.
 * Compiler mode/portability distinctions and KCC applicability:
 * docs/GCC-C-BATCH06-REVIEW-20261117-v1.md.
 */
/* Test for recognition of digraphs: should be recognised in C94 and C99
   mode, but not in C90 mode.  Also check correct stringizing.
*/
/* Origin: Joseph Myers <jsm28@cam.ac.uk> */

#define str(x) xstr(x)
#define xstr(x) #x
#define foo(p, q) str(p %:%: q)

extern void abort (void);
extern int strcmp (const char *, const char *);

int
main (void)
{
  const char *t = foo (1, 2);
  const char *u = str (<:);
  if (strcmp (t, "12") || strcmp (u, "<:"))
    abort ();
  else
    return 0;
}
