/* codegen-require: ADJBP */
/*
 * KS10-specific: hardware Adjust Byte Pointer.
 *
 * The KS10 (DECSYSTEM-2020) implements the KL10 instruction set in a
 * single 18-bit section, which includes ADJBP (opcode 0133 with a
 * non-zero AC field).  Adding a run-time integer to a char* therefore
 * compiles to a single ADJBP, where the PDP-6/KA10/KI10 backends must
 * fall back to the multi-instruction software byte-pointer-adjust
 * routine.  This test is selected only on the ks10 native column; the
 * earlier CPUs cannot satisfy the requirement and are marked
 * unsupported in TEST_MATRIX.tsv.
 *
 * Both kcc -x=ks10 and pdp10-gcc -march=ks10 emit ADJBP here.
 */
char *
ks10_charptr_adjust(char *p, int n)
{
    return p + n;
}
