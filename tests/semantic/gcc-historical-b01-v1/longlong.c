/* GCC execute/longlong.c: unsigned wide byte extraction. */
/* 72-bit long long still preserves the original 64-bit bit operations. */
typedef unsigned long long uint64;
static unsigned long pars;
static uint64 b[32];
static uint64 *r = b;
static void alpha_ep_extbl_i_eq_0(void)
{
    unsigned int rb, ra, rc;
    uint64 temp;
    rb = ((unsigned long)pars >> 27) & 0x1fUL;
    ra = ((unsigned int)pars >> 5) & 0x1fUL;
    rc = ((unsigned int)pars >> 0) & 0x1fUL;
    temp = (r[ra] >> ((r[rb] & 0x7) << 3)) & 0xffULL;
    if (rc != 31)
        r[rc] = temp;
}
int main(void)
{
    b[17] = 0x0000000000303882ULL;
    b[2] = 0x534f4f4c494d000aULL;
    pars = 0x88000042UL;
    alpha_ep_extbl_i_eq_0();
    return b[2] != 0x4dULL;
}
