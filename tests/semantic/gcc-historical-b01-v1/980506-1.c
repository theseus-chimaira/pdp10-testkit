/* GCC execute/980506-1.c: goto around null-pointer clearing. */
struct decision {
    char enforce_mode;
    struct decision *next;
};
static volatile int reached_end;
static void clear_modes(struct decision *p)
{
    goto blah;
foo:
    p->enforce_mode = 0;
blah:
    if (p)
        goto foo;
    reached_end = 1;
}
int main(void)
{
    clear_modes((struct decision *)0);
    return reached_end != 1;
}
