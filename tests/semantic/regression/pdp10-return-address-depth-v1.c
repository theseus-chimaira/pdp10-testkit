/* Defined-call ABI subset of upstream 20010122-1.c.
 * Exercise GNU __builtin_return_address at depth zero and one, using
 * three variants of each call path, real noinline boundaries, and
 * runtime alloca. Avoid original undefined stack-pointer returns.
 */
extern void abort(void);
#define NOINLINE_V1 __attribute__((noinline))
volatile unsigned int fail_id;
static volatile unsigned int side_v1;
static void *returns0_v1[3];
static void *returns1_v1[3];
static void *returns2_v1[3];
static void *returns3_v1[3];
static void *saved_v1;

static void NOINLINE_V1
side_v1_function(void)
{
    side_v1++;
}

static void * NOINLINE_V1
probe0_v1(void)
{
    return __builtin_return_address(0);
}

static void * NOINLINE_V1
probe1_v1(void)
{
    side_v1_function();
    return __builtin_return_address(0);
}

static void * NOINLINE_V1
probe2_v1(void)
{
    void *addr = __builtin_return_address(0);
    side_v1_function();
    return addr;
}

static void *(*probes0_v1[3])(void) = {
    probe0_v1, probe1_v1, probe2_v1
};

static void NOINLINE_V1
call0_v1(int i)
{
    returns0_v1[i] = probes0_v1[i]();
}

static void * NOINLINE_V1
inner0_v1(void *p)
{
    side_v1 += (p != (void *)0);
    return __builtin_return_address(1);
}
static void * NOINLINE_V1
inner2_v1(void *p)
{
    void *addr = __builtin_return_address(1);
    side_v1_function();
    side_v1 += (p != (void *)0);
    return addr;
}
static void * NOINLINE_V1
probe3_v1(void)
{
    char *space = (char *)__builtin_alloca(4);
    space[0] = 1;
    return inner0_v1(space);
}
static void * NOINLINE_V1
probe4_v1(void)
{
    char *space = (char *)__builtin_alloca(4);
    space[0] = 2;
    return inner2_v1(space);
}
static void * NOINLINE_V1
probe5_v1(void)
{
    char *space = (char *)__builtin_alloca(4);
    space[0] = 3;
    return inner0_v1(space);
}
static void *(*probes1_v1[3])(void) = {
    probe3_v1, probe4_v1, probe5_v1
};
static void NOINLINE_V1
call1_v1(int i)
{
    returns1_v1[i] = probes1_v1[i]();
}

/* The original also exercises void-returning callees that communicate
 * the observed return address through a file-static pointer. */
static void NOINLINE_V1
store0_v1(void)
{
    saved_v1 = __builtin_return_address(0);
}
static void NOINLINE_V1
store1_v1(void)
{
    side_v1_function();
    saved_v1 = __builtin_return_address(0);
}
static void NOINLINE_V1
store2_v1(void)
{
    saved_v1 = __builtin_return_address(0);
    side_v1_function();
}
static void (*stored0_v1[3])(void) = {
    store0_v1, store1_v1, store2_v1
};
static void NOINLINE_V1
call2_v1(int i)
{
    stored0_v1[i]();
    returns2_v1[i] = saved_v1;
}

static void NOINLINE_V1
inner_store_v1(void *p)
{
    saved_v1 = __builtin_return_address(1);
    side_v1 += (p != (void *)0);
}
static void NOINLINE_V1
store3_v1(void)
{
    char *space = (char *)__builtin_alloca(4);
    space[0] = 1;
    inner_store_v1(space);
}
static void NOINLINE_V1
store4_v1(void)
{
    char *space = (char *)__builtin_alloca(4);
    space[0] = 2;
    inner_store_v1(space);
}
static void NOINLINE_V1
store5_v1(void)
{
    char *space = (char *)__builtin_alloca(4);
    space[0] = 3;
    inner_store_v1(space);
}
static void (*stored1_v1[3])(void) = {
    store3_v1, store4_v1, store5_v1
};
static void NOINLINE_V1
call3_v1(int i)
{
    stored1_v1[i]();
    returns3_v1[i] = saved_v1;
}

int
main(void)
{
    int i;
    for (i = 0; i < 3; ++i)
        call0_v1(i);
    if (!returns0_v1[0] || returns0_v1[0] != returns0_v1[1] ||
        returns0_v1[1] != returns0_v1[2]) {
        fail_id = 1;
        abort();
    }
    for (i = 0; i < 3; ++i)
        call1_v1(i);
    if (returns1_v1[0] != returns1_v1[1] ||
        returns1_v1[1] != returns1_v1[2]) {
        fail_id = 2;
        abort();
    }
    for (i = 0; i < 3; ++i)
        call2_v1(i);
    if (!returns2_v1[0] || returns2_v1[0] != returns2_v1[1] ||
        returns2_v1[1] != returns2_v1[2]) {
        fail_id = 3;
        abort();
    }
    for (i = 0; i < 3; ++i)
        call3_v1(i);
    if (returns3_v1[0] != returns3_v1[1] ||
        returns3_v1[1] != returns3_v1[2]) {
        fail_id = 4;
        abort();
    }
    if (side_v1 != 11U) {
        fail_id = 5;
        abort();
    }
    return 0;
}
