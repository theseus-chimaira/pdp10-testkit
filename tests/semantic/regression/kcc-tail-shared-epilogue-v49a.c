/* A tail call can remove the final return sequence only when no
   earlier return or branch reaches it. Keep all paths observable. */
static volatile int sink;
static int callee(int v)
{
    sink = v;
    return v + 3;
}

static int tail_only(int v)
{
    volatile int local;
    local = v + 1;
    sink = local;
    return callee(v);
}

static int tail_or_return(int v)
{
    volatile int local;
    local = v + 1;
    if (v < 0)
        return local;
    return callee(v);
}

static int branch_return(int v)
{
    volatile int local;
    local = v * 2;
    if (v)
        goto out;
    return callee(v);
out:
    return local;
}

int main(void)
{
    if (tail_only(6) != 9 || sink != 6) return 1;
    if (tail_or_return(-4) != -3 || sink != 6) return 2;
    if (tail_or_return(7) != 10 || sink != 7) return 3;
    if (branch_return(4) != 8 || sink != 7) return 4;
    if (branch_return(0) != 3 || sink != 0) return 5;
    return 0;
}
