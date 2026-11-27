/* A nonconstant pointer forces the runtime aggregate initializer. */
static int calls;
static int data[] = { 41, 42, 0 };
static int *get(void) { ++calls; return data; }
int main(void)
{
    int *p[] = { L"abc", get(), L"xyz" };
    if (calls != 1 || p[1] != data) return 1;
    if (p[0][2] != 'c' || p[0][3] != 0) return 2;
    if (p[2][2] != 'z' || p[2][3] != 0) return 3;
    return 0;
}
