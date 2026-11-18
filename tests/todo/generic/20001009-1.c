int a,b;
main()
{
  int c=-2;
#if defined(__PDP10__) || defined(__pdp10__)
  int d=0x1fe;
#else
  int d=0xfe;
#endif
  int e=a&1;
  int f=b&2;
  if ((char)(c|(e&f)) == (char)d)
    return 0;
  else
    abort();
}
