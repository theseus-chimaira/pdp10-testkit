/* Automatic initialization and assignment have the same conversion. */
static int a[3] = { 11, 22, 33 };
static char b[6] = "abcde";
static int calls;
static int *get(void) { ++calls; return &a[1]; }
static int f(void) { return 73; }
int main(void)
{
    int i = get();
    unsigned long u = b + 2;
    unsigned long long w = a + 2;
    unsigned long long wide;
    int j = a;
    int k = f;
    int n = (int)&(struct S { int x; }){ 17 };
    wide = a + 2;
    if (calls != 1 || i != (int)&a[1]) return 1;
    if (u != (unsigned long)(b + 2)) return 2;
    if (w != wide || w != (unsigned long long)(a + 2)) return 3;
    if (j != (int)a || k != (int)f) return 4;
    if (((struct S *)n)->x != 17) return 5;
    return 0;
}
