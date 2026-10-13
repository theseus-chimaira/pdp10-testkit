/* codegen-expect-compile-fail: yes */
/* codegen-kcc-expect-compile-fail: yes */
/* codegen-kcc-diagnostic-require-regex: "Variable\\ length\\ array\\ must\\ have\\ automatic\\ storage\\ duration" */
int f(int n)
{
    static int a[n];
    return a[0];
}
