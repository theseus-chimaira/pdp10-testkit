/* PR c/3444: integer promotions must precede XOR and sign extension.
   PDP-10 adaptation: 9-bit char, 18-bit short, 36-bit int.
   The original 8/16/32-bit guard made this test vacuous here. */

extern void abort(void);
extern void exit(int);

signed char c = (signed char) 0xffffffff;

int foo(void)
{
  return (unsigned short) c ^ (signed char) 0x99999999;
}

int main(void)
{
#if defined(__pdp10__)
  /* (unsigned short)-1 is 0777777 (18 bits).  The other operand
     truncates to signed 9-bit -103; promotion to 36-bit int extends
     its sign BEFORE XOR.  High 18 bits therefore remain set. */
  if ((unsigned char)-1 != 0777 || sizeof(short) != 2 ||
      sizeof(int) != 4 || foo() != (int) 0777777000146L)
    abort();
#else
  if ((unsigned char)-1 != 0xff || sizeof(short) != 2 ||
      sizeof(int) != 4)
    exit(0);
  if (foo() != (int) 0xffff0066)
    abort();
#endif
  exit(0);
}
