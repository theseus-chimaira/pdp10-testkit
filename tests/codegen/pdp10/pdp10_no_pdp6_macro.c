/* codegen-policy: pdp10 profile excludes PDP-6 but remains non-native PDP-10 portable code. */
/* codegen-require-macro: __PDP10_PDP10__ */
/* codegen-forbid-macro: __PDP10_166__ */
volatile int __test_exit;
volatile int fail_id;
int main()
{
#if defined(__PDP10_PDP10__) && !defined(__PDP10_166__)
    return 0;
#else
    fail_id = 1;
    return 1;
#endif
}
