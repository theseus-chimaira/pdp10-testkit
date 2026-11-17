/* Historical GCC signed/unsigned short assignment and store.
 * The original oracle and cross-compiler eligibility are recorded in
 * docs/GCC-C-BATCH03-REVIEW-20261117-v1.md.
 */
/* This testcase failed on i686 because (const_int -1) was changed into
   (const_int 0xffff) when storing it into SImode pseudo, but was not
   converted back to (const_int -1) when returning from store_expr,
   eventhough target was (subreg:HI (reg/v:SI indx)).  But (const_int 0xffff)
   is not valid general_operand in HImode.  */

void
foo (unsigned short *cp)
{
  unsigned short indx;

  /* PDP-10 short is 18 bits; retain the all-ones narrowing boundary. */
  *cp = indx = 0777777U;
}
