/* codegen-forbid-form: POP_AC_AC */
volatile int sink;
static int sum_stack(a)
int a;
{
    int local[6];
    int i;
    int s;
    s = 0;
    for (i = 0; i < 6; ++i) {
        local[i] = a + i;
        s += local[i];
    }
    return s;
}
int main()
{
    sink = sum_stack(3);
    return sink == 33 ? 0 : 1;
}
