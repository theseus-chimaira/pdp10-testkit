/* kcc_modern_warning_directive.c - GNU #warning directive. */

#warning kcc accepts warning directives without failing

volatile int __test_exit;

int
main()
{
    __test_exit = 0;
    return 0;
}
