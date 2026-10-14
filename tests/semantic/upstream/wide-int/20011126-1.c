/* Bare-metal semantic result: nonzero main return signals failure. */
volatile int __test_exit;
/* Produced a overflow in ifcvt.c, causing S to contain 0xffffffff7fffffff.  */

int a = 1;

int main ()
{
  long long s;

  s = a;
  if (s < 0)
    s = -2147483648LL;
  else
    s = 2147483647LL;

  if (s < 0)
    return 1;

  return 0;
}
