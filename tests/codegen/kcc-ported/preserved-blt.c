/* codegen-kcc-check: "preserved-blt" */
/* codegen-kcc-policy-only: yes */
extern int sink4(int, int, int, int);
extern void usep(int *);

int keep4(int a, int b, int c, int d)
{
    int x = a + 1;
    int y = b + 2;
    int z = c + 3;
    int w = d + 4;

    sink4(a, b, c, d);
    return x + y + z + w + a + b + c + d;
}

int keep3(int a, int b, int c)
{
    int x = a + 1;
    int y = b + 2;
    int z = c + 3;

    sink4(a, b, c, 0);
    return x + y + z + a + b + c;
}

int keep4_auto(int a, int b, int c, int d)
{
    int local;

    usep(&local);
    sink4(a, b, c, d);
    return a + b + c + d + local;
}
