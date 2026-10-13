/* codegen-expect-compile-fail: yes */
/* codegen-kcc-expect-compile-fail: yes */
/* codegen-kcc-diagnostic-require-regex: "Goto\\ enters\\ scope\\ of\\ variable\\ length\\ array" */
int main(void)
{
    int n = 3;
    goto inside;
    {
        int a[n];
inside:
        a[0] = 1;
    }
    return 0;
}
