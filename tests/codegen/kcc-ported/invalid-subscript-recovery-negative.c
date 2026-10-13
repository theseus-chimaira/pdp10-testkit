/* codegen-expect-compile-fail: yes */
/* codegen-kcc-expect-compile-fail: yes */
/* codegen-kcc-diagnostic-require-regex: "Array\\ or\\ pointer\\ type\\ required" */
int bad_subscript(void)
{
    int value;

    return value[0];
}
