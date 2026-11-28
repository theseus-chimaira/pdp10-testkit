/* Lexical bindings must not replace the identity of a linked object
 * or function. No duplicate storage or assembler symbol is permitted. */
int external = 3;
static int internal = 4;
static int callee(int n) { return n+17; }
extern int array[];
static int earlier(void)
{
    extern int late;
    late += 2;
    return late;
}
static int later(void)
{
    extern int late;
    {
        int late = 41;
        {
            extern int late;
            extern int late;
            late += 3;
        }
        if (late != 41) return -1;
    }
    return late;
}
int main(void)
{
    int external = 11;
    int internal = 12;
    int callee = 13;
    {
        extern int external;
        extern int internal;
        int callee(int);
        extern int array[4];
        int *p = &external;
        if (*p != 3 || internal != 4 || callee(5) != 22) return 1;
        if (sizeof(array) != 4*sizeof(int)) return 2;
        *p = 21;
        internal = 22;
        array[3] = 23;
        {
            int external = 31;
            {
                extern int external;
                if (external != 21) return 3;
                external = 32;
            }
            if (external != 31) return 4;
        }
        if (external != 32 || array[3] != 23) return 5;
    }
    if (external != 11 || internal != 12 || callee != 13) return 6;
    if (earlier() != 9 || later() != 12) return 7;
    return 0;
}
int late = 7;
int array[4];
