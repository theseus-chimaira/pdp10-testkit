typedef unsigned int uword_t;
typedef float dfloat_t __attribute__ ((mode (DF)));

union df_words {
        dfloat_t d;
        uword_t w[2];
};

volatile uword_t df_bitcast_hi;
volatile uword_t df_bitcast_lo;
volatile int __test_exit;

static void __attribute__ ((noinline))
capture_df(dfloat_t d)
{
        union df_words u;

        u.d = d;
        df_bitcast_hi = u.w[0];
        df_bitcast_lo = u.w[1];
}

int
main(void)
{
        union df_words u;

        u.w[0] = 0201400000000U;
        u.w[1] = 020000000000U;
        capture_df(u.d);

        __test_exit = (df_bitcast_hi == 0201400000000U
                       && df_bitcast_lo == 020000000000U) ? 0 : 1;
        return __test_exit;
}
