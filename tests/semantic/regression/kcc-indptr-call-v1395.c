/* KCC v1395: a destination pointer must survive an intervening call.
 * C89 test with actual observable stores for the compiler test matrix.
 * The separate host assembly-pattern test checks the optimized loop
 * shapes that the runtime assertion cannot prove by itself. */

static int values[5] = { 11, 22, 33, 44, 55 };
static int *slots[5];
static int *slots_nocall[5];
static int *global_ptr = values;
static int calls;

static int *
fetch_value(int index)
{
    calls++;
    return &values[index];
}

static void
fill_slots(void)
{
    int i;

    for (i = 0; i < 5; i++)
        slots[i] = fetch_value(i);
}

static void
fill_nocall(void)
{
    int i;

    for (i = 0; i < 5; i++)
        slots_nocall[i] = global_ptr;
}

int
main(void)
{
    int i;

    fill_slots();
    fill_nocall();
    if (calls != 5)
        return 1;
    for (i = 0; i < 5; i++) {
        if (slots[i] != &values[i] || *slots[i] != values[i])
            return 2;
        if (slots_nocall[i] != global_ptr)
            return 3;
    }
    return 0;
}
