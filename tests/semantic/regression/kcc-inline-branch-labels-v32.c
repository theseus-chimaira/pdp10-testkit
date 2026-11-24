/* KCC v32: constant function-address comparisons and reachable labels.
 *
 * Even in -n mode an identically named function designator compares
 * equal, and an unreachable return tail must not be emitted.  But a
 * label in a later or nonselected branch can still be entered by goto.
 */

static int
left_v32(void)
{
    return 4;
}

static int
right_v32(void)
{
    return 8;
}

static int
branch_into_else_v32(int enter)
{
    if (enter)
        goto target;
    if (1)
        return 7;
    else
target:
        return 9;
}

static int
branch_past_return_v32(int enter)
{
    if (enter)
        goto after;
    return 12;
after:
    return 14;
}

int
main(void)
{
    if (left_v32 != left_v32 || right_v32 != right_v32)
        return 1;
    if (branch_into_else_v32(0) != 7)
        return 2;
    if (branch_into_else_v32(1) != 9)
        return 3;
    if (branch_past_return_v32(0) != 12)
        return 4;
    if (branch_past_return_v32(1) != 14)
        return 5;
    return 0;
}
