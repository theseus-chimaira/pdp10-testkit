/* codegen-require: ADJSP */
/*
 * KS10-specific: hardware Adjust Stack Pointer.
 *
 * ADJSP (opcode 0105) is part of the KL10 instruction set the KS10
 * implements; it adds a signed count to both halves of the stack
 * pointer AC in one instruction.  Allocating and releasing a local
 * stack frame on the KS10 therefore uses ADJSP, whereas PDP-6/KA10/KI10
 * must adjust AC17 with ADD/SUB of a "n,,n" halfword constant.  Only
 * the ks10 native column can satisfy this requirement.
 *
 * Both kcc -x=ks10 and pdp10-gcc -march=ks10 emit ADJSP here.
 */
extern void ks10_use(int *);

int
ks10_stack_frame(int n)
{
    int big[64];
    int i;

    for (i = 0; i < 64; i++)
        big[i] = n + i;
    ks10_use(big);
    return big[n & 63];
}
