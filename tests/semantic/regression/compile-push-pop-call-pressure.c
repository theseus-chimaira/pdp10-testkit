typedef int Sint;
typedef unsigned int uSint;
typedef long long Dint;

extern Sint ext_sint(Sint, Sint, Sint, Sint, Sint, Sint);
extern Dint ext_dint(Dint, Dint, Dint);

Sint
many_si_args(a, b, c, d, e, f, g, h)
Sint a;
Sint b;
Sint c;
Sint d;
Sint e;
Sint f;
Sint g;
Sint h;
{
  Sint x;
  Sint y;

  x = ext_sint(a, b, c, d, e, f);
  y = ext_sint(c, d, e, f, g, h);
  return x + y + a + h;
}

Dint
many_di_args(a, b, c, d)
Dint a;
Dint b;
Dint c;
Dint d;
{
  Dint x;
  Dint y;

  x = ext_dint(a, b, c);
  y = ext_dint(b, c, d);
  return x;
}

Sint
local_pressure(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint l0;
  Sint l1;
  Sint l2;
  Sint l3;
  Sint l4;
  Sint l5;

  l0 = a + 1;
  l1 = b + 2;
  l2 = c + 3;
  l3 = l0 + l1;
  l4 = l2 + l3;
  l5 = ext_sint(l0, l1, l2, l3, l4, a);
  return l5 + l4 + l3 + l2 + l1 + l0;
}
