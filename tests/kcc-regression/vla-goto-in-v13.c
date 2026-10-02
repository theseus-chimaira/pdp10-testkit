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
