/* Preserves the original KCC assembly checks. */
/* codegen-kcc-diagnostic-forbid-regex: "\\[(Advisory|Note|Warning|Error)\\]|warnings? detected|errors? detected" */
static int
first(p)
const unsigned long *p;
{
        return *p != 0;
}

int
test()
{
        unsigned long a[1];

        a[0] = 1;
        return first(&a[0]);
}
