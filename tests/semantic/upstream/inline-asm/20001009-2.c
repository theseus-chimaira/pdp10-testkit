int b=1;
int foo()
{
  int a;
  int c;
#if defined(__PDP10__) || defined(__pdp10__)
  a=0x1ff;
#else
  a=0xff;
#endif
  for (;b;b--)
  {
    c=1;
    asm(""::"r"(c));
    c=(signed char)a;
  }
  if (c!=-1)
    abort();
  return c;
}
int main()
{
  foo();
  return 0;
}
