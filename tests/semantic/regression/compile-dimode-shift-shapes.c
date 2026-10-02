typedef long long Dint;
typedef unsigned long long uDint;
typedef int Sint;

Dint
ashl1(x)
Dint x;
{
  return x << 1;
}

Dint
ashl18(x)
Dint x;
{
  return x << 18;
}

Dint
ashr1(x)
Dint x;
{
  return x >> 1;
}

Dint
ashr18(x)
Dint x;
{
  return x >> 18;
}

uDint
lshr1(x)
uDint x;
{
  return x >> 1;
}

uDint
lshr18(x)
uDint x;
{
  return x >> 18;
}

Dint
ashl_var(x, n)
Dint x;
Sint n;
{
  return x << n;
}

Dint
ashr_var(x, n)
Dint x;
Sint n;
{
  return x >> n;
}

uDint
lshr_var(x, n)
uDint x;
Sint n;
{
  return x >> n;
}
