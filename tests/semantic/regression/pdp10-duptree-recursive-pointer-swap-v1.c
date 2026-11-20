/*
 * Compiler-semantic oracle for the reachable path of 20020406-1.c.
 *
 * The original program calls malloc/calloc/printf, none of which is
 * supplied by the installed compiler freestanding libc.  Use genuine
 * static structures instead of inventing an allocator or console.
 *
 * Preserve the exact DUPFFexgcd argument order, recursive call with
 * reversed pointer-to-pointer output slots, degree comparison and
 * early return through f->coeffs[0].  The original algebraic path
 * beyond this return is unreachable for the historical input and is
 * deliberately not fabricated here.
 */

extern void abort(void);

typedef unsigned int FFelem;

struct DUPFFstruct {
    int maxdeg;
    int deg;
    FFelem *coeffs;
};

typedef struct DUPFFstruct *DUPFF;

static volatile unsigned int invocation_count_v1;
static DUPFF *first_slot_v1[2];
static DUPFF *second_slot_v1[2];
static DUPFF first_arg_v1[2];
static DUPFF second_arg_v1[2];
volatile int fail_id;

#define CHECK_V1(expr, code) do { \
    if (!(expr)) { fail_id = (code); abort(); } \
} while (0)

int
DUPFFdeg(const DUPFF f)
{
    return f->deg;
}

DUPFF
DUPFFexgcd(DUPFF *fcofac, DUPFF *gcofac, const DUPFF f, const DUPFF g)
{
    unsigned int call_number = invocation_count_v1++;

    CHECK_V1(call_number < 2, 1);
    first_slot_v1[call_number] = fcofac;
    second_slot_v1[call_number] = gcofac;
    first_arg_v1[call_number] = f;
    second_arg_v1[call_number] = g;

    if (DUPFFdeg(f) < DUPFFdeg(g))
        return DUPFFexgcd(gcofac, fcofac, g, f);
    CHECK_V1(DUPFFdeg(f) == 2, 2);
    CHECK_V1(DUPFFdeg(g) == 1, 3);
    if (f->coeffs[0] == 0)
        return f;

    /* The historical input never reaches the unfinished algebra. */
    CHECK_V1(0, 4);
    return (DUPFF)0;
}

int
main(void)
{
    FFelem f_coeffs[2];
    FFelem g_coeffs[3];
    struct DUPFFstruct f_data;
    struct DUPFFstruct g_data;
    DUPFF f;
    DUPFF g;
    DUPFF cf;
    DUPFF cg;
    DUPFF result;

    f = &f_data;
    g = &g_data;
    f_coeffs[0] = 0;
    f_coeffs[1] = 1;
    g_coeffs[0] = 0;
    g_coeffs[1] = 0;
    g_coeffs[2] = 1;

    f->coeffs = f_coeffs;
    f->maxdeg = 1;
    f->deg = 1;
    g->coeffs = g_coeffs;
    g->maxdeg = 2;
    g->deg = 2;

    cf = f;
    cg = g;
    result = DUPFFexgcd(&cf, &cg, f, g);

    CHECK_V1(invocation_count_v1 == 2, 5);
    CHECK_V1(first_slot_v1[0] == &cf, 6);
    CHECK_V1(second_slot_v1[0] == &cg, 7);
    CHECK_V1(first_slot_v1[1] == &cg, 8);
    CHECK_V1(second_slot_v1[1] == &cf, 9);
    CHECK_V1(first_arg_v1[0] == f, 10);
    CHECK_V1(second_arg_v1[0] == g, 11);
    CHECK_V1(first_arg_v1[1] == g, 12);
    CHECK_V1(second_arg_v1[1] == f, 13);
    CHECK_V1(result == g, 14);
    CHECK_V1(cf == f, 15);
    CHECK_V1(cg == g, 16);
    CHECK_V1(f->deg == 1 && g->deg == 2, 17);
    CHECK_V1(f->maxdeg == 1 && g->maxdeg == 2, 18);
    CHECK_V1(f_coeffs[0] == 0 && f_coeffs[1] == 1, 19);
    CHECK_V1(g_coeffs[0] == 0 && g_coeffs[1] == 0 && g_coeffs[2] == 1, 20);

    return 0;
}
