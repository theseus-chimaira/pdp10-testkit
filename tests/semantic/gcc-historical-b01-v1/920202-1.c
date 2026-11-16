/* GCC execute/920202-1.c: return path after flag assignment. */
static volatile int rule_text_needs_stack_pop = 0;
static int input_stack_pos = 1;
static int f(void)
{
    rule_text_needs_stack_pop = 1;
    if (input_stack_pos <= 0)
        return 1;
    return 0;
}
int main(void)
{
    if (f() != 0)
        return 1;
    if (rule_text_needs_stack_pop != 1)
        return 2;
    return 0;
}
