int g(void)
{
    { extern int a[4]; a[0]=1; }
    { extern int a[]; return sizeof(a); }
}
