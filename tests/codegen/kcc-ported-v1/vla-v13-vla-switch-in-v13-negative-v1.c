/* codegen-expect-compile-fail: yes */
/* codegen-kcc-expect-compile-fail: yes */
/* codegen-kcc-diagnostic-require-regex: "Switch\\ label\\ enters\\ scope\\ of\\ variable\\ length\\ array" */
int f(int n, int x)
{
    switch (x) {
        int a[n];
    case 1:
        a[0] = 1;
        return a[0];
    }
    return 0;
}
