typedef unsigned long long uDint;
typedef int Sint;

uDint
rotl1(x)
uDint x;
{
  return (x << 1) | (x >> 70);
}

uDint
rotr1(x)
uDint x;
{
  return (x >> 1) | (x << 70);
}

uDint
rotl18(x)
uDint x;
{
  return (x << 18) | (x >> 53);
}

uDint
rotr18(x)
uDint x;
{
  return (x >> 18) | (x << 53);
}

uDint
rotl_var(x, n)
uDint x;
Sint n;
{
  return (x << n) | (x >> (71 - n));
}

uDint
rotr_var(x, n)
uDint x;
Sint n;
{
  return (x >> n) | (x << (71 - n));
}
