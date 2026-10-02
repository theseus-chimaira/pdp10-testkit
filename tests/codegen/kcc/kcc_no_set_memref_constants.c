/* codegen-forbid-form: SET_MEMREF SETZ_MEMREF SETO_MEMREF JFCL1 POP_AC_AC */
volatile int ga;
volatile int gb;
volatile int sink;
static int z(a)
int a;
{
    return a ? ga : 0;
}
static int o(a)
int a;
{
    return a ? -1 : gb;
}
int main()
{
    ga = 7;
    gb = 11;
    sink = z(0) + o(1);
    return sink == -1 ? 0 : 1;
}
