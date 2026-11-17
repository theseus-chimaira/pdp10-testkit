/* Historical GCC unsigned long long bitfield assignment expression.
 * The original oracle and cross-compiler eligibility are recorded in
 * docs/GCC-C-BATCH03-REVIEW-20261117-v1.md.
 */
/* PR c++/4574
   This testcase ICEd because expand_and did not handle VOIDmode
   CONST_DOUBLE arguments.  */

struct A {
  unsigned long long b : 8;
  unsigned long long c : 18;
};

int main()
{
  struct A a;
  long long l;

  l = a.c = 0x123456789aULL;
  return 0;
}
