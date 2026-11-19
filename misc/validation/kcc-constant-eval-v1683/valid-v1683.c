/* C89 constant-folding regression for PDP-10 KCC. */
enum { V1683_IDENTWDS = 0200, V1683_WORDS = 010000 };
enum { V1683_MIXED = (V1683_IDENTWDS + 3) * 2 };
enum { V1683_SHIFT = (1 << 8) | 07 };
enum { V1683_MAX = 0377777777776 + 1 };
typedef char v1683_check_ident[(V1683_IDENTWDS == 128) ? 1 : -1];
typedef char v1683_check_mixed[(V1683_MIXED == 262) ? 1 : -1];
typedef char v1683_check_shift[(V1683_SHIFT == 263) ? 1 : -1];
typedef char v1683_check_max[(V1683_MAX == 0377777777777) ? 1 : -1];
static int v1683_ident[V1683_IDENTWDS];
static int v1683_block[V1683_WORDS / 0400 + 1];
static int v1683_oct[(0100 + 020 + 03) * 02];
int v1683_constant_sizes(void)
{
    return (int)(sizeof(v1683_ident) / sizeof(v1683_ident[0])) +
           (int)(sizeof(v1683_block) / sizeof(v1683_block[0])) +
           (int)(sizeof(v1683_oct) / sizeof(v1683_oct[0]));
}
int v1683_constant_scalar(void)
{
    return V1683_MIXED + V1683_SHIFT - V1683_IDENTWDS;
}
