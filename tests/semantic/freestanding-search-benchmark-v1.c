/* Deterministic PDP-6 instruction-step search benchmark.
 * Build this file with exactly one of BENCH_STRSTR, BENCH_STRPBRK,
 * or BENCH_STRSPN.  Compare production assembler with the C reference
 * using the same compiler, workload and profile.
 *
 * No time-of-day services, heap, I/O, or target instrumentation needed.
 * A volatile checksum prevents dead-call elimination.
 */
#if defined(BENCH_STRSTR)
extern char *strstr(const char *, const char *);
#elif defined(BENCH_STRPBRK)
extern char *strpbrk(const char *, const char *);
#elif defined(BENCH_STRSPN)
extern unsigned int strspn(const char *, const char *);
#else
#error Define exactly one BENCH_STRSTR, BENCH_STRPBRK or BENCH_STRSPN
#endif

volatile int benchmark_checksum_v1;
volatile int benchmark_done_v1;
static char benchmark_text_v1[96];

int
main(void)
{
    int i;

    benchmark_checksum_v1 = 0;
    benchmark_done_v1 = 0;
    for (i = 0; i < 80; ++i)
        benchmark_text_v1[i] = 'a';
    benchmark_text_v1[80] = 'z';
    benchmark_text_v1[81] = 0;

    /* 16 calls: identical start/end state for both implementations.
     * Repeated-prefix strstr and linear rejected accept-set scans.
     * Each search crosses a PDP-6 word boundary many times.
     */
    for (i = 0; i < 16; ++i) {
#if defined(BENCH_STRSTR)
        if (strstr(benchmark_text_v1, "aaaaaz") == benchmark_text_v1 + 75)
#elif defined(BENCH_STRPBRK)
        if (strpbrk(benchmark_text_v1, "hijkz") == benchmark_text_v1 + 80)
#else
        if (strspn(benchmark_text_v1, "ab") == 80U)
#endif
            ++benchmark_checksum_v1;
    }
    benchmark_done_v1 = 1;
    return benchmark_checksum_v1 != 16;
}
