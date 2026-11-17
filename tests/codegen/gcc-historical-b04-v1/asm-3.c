/* GCC original inline-assembler percent-escape output regression.
 * codegen-require-regex: "(?m)^\s*foo%%bar\s*$"
 * Original scan-assembler oracle: see GCC-C-BATCH04-REVIEW-20261117-v1.md.
 */

void f()
{
  asm ("foo%%bar");
}
