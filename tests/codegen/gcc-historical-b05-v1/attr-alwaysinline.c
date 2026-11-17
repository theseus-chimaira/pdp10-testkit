/* GCC historical batch05: Forced inlining at -O0, no sabrina in assembly.
 * Original compiler mode and KCC suitability are recorded in
 * docs/GCC-C-BATCH05-REVIEW-20261117-v1.md.
 */
/* codegen-forbid-regex: "sabrina" */
/* Test always_inline attribute, which forces inlining of functions
   even at no optimization.  */
/* Origin: Aldy Hernandez <aldyh@redhat.com>.  */

static inline int sabrina (void) __attribute__((always_inline));

static inline int sabrina (void)
{
  return 13;
}

int bar (void)
{
  return sabrina () + 68;
}

/* { dg-final { scan-assembler-not "sabrina" } } */
