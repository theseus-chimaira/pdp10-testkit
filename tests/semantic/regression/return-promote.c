#include "insns.h"

/* return-promote.c - PDP-10 return-value promotion ABI test.

   This is a semantic test for PROMOTE_FUNCTION_RETURN / FUNCTION_VALUE.
   It deliberately checks subword function results across a real call
   boundary, then immediately uses the result as an int in the caller.

   return_promote_all(seed) returns 1 on pass, 0 on failure.
   main() returns 0 on pass, or the failing case number on failure.
*/

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint return_promote_fail_id;
volatile uSint return_promote_sink;

#define DECL_TEST(NAME, TYPE)                                      \
  NOINLINE TYPE ret_##NAME (x)                                    \
       int x;                                                     \
  {                                                              \
    return (TYPE) x;                                             \
  }                                                              \
  NOINLINE int direct_##NAME (x)                                  \
       int x;                                                     \
  {                                                              \
    return (int) ret_##NAME (x);                                 \
  }                                                              \
  NOINLINE int compare_##NAME (x)                                 \
       int x;                                                     \
  {                                                              \
    TYPE y;                                                      \
    y = ret_##NAME (x);                                          \
    return y == (TYPE) x;                                        \
  }                                                              \
  NOINLINE void sink_##NAME (x)                                   \
       int x;                                                     \
  {                                                              \
    TYPE y;                                                      \
    y = ret_##NAME (x);                                          \
    return_promote_sink = (uSint) y;                              \
  }

DECL_TEST (plain_char, char)
DECL_TEST (signed_char, signed char)
DECL_TEST (unsigned_char, unsigned char)
DECL_TEST (plain_short, short)
DECL_TEST (signed_short, signed short)
DECL_TEST (unsigned_short, unsigned short)
DECL_TEST (char6, char6)
DECL_TEST (uchar6, uchar6)
DECL_TEST (char7, char7)
DECL_TEST (uchar7, uchar7)
DECL_TEST (char8, char8)
DECL_TEST (uchar8, uchar8)
DECL_TEST (char9, char9)
DECL_TEST (uchar9, uchar9)
DECL_TEST (short16, short16)
DECL_TEST (ushort16, ushort16)
DECL_TEST (short18, short18)
DECL_TEST (ushort18, ushort18)
DECL_TEST (Qint, Qint)
DECL_TEST (sQint, sQint)
DECL_TEST (uQint, uQint)
DECL_TEST (Hint, Hint)
DECL_TEST (uHint, uHint)
DECL_TEST (Sint, Sint)
DECL_TEST (uSint, uSint)

#define CHECK_ONE(NAME, TYPE, VALUE, ID)                           \
  do                                                              \
    {                                                             \
      int v_;                                                     \
      v_ = (VALUE);                                               \
      if (direct_##NAME (v_) != (int) ((TYPE) v_))                \
        {                                                         \
          return_promote_fail_id = (uSint) (ID);                  \
          return 0;                                               \
        }                                                         \
      if (!compare_##NAME (v_))                                   \
        {                                                         \
          return_promote_fail_id = (uSint) ((ID) + 1000);         \
          return 0;                                               \
        }                                                         \
      sink_##NAME (v_);                                           \
    }                                                             \
  while (0)

int
return_promote_all (seed)
     int seed;
{
  return_promote_fail_id = 0;
  return_promote_sink = (uSint) seed;

  CHECK_ONE (plain_char, char, -1, 1);
  CHECK_ONE (plain_char, char, 0, 2);
  CHECK_ONE (plain_char, char, 0377, 3);
  CHECK_ONE (plain_char, char, 0400, 4);

  CHECK_ONE (signed_char, signed char, -2, 5);
  CHECK_ONE (signed_char, signed char, -1, 6);
  CHECK_ONE (signed_char, signed char, 0, 7);
  CHECK_ONE (signed_char, signed char, 0377, 8);
  CHECK_ONE (signed_char, signed char, 0400, 9);

  CHECK_ONE (unsigned_char, unsigned char, 0, 10);
  CHECK_ONE (unsigned_char, unsigned char, 1, 11);
  CHECK_ONE (unsigned_char, unsigned char, 0377, 12);
  CHECK_ONE (unsigned_char, unsigned char, 0777, 13);

  CHECK_ONE (plain_short, short, -2, 14);
  CHECK_ONE (plain_short, short, -1, 15);
  CHECK_ONE (plain_short, short, 0177777, 16);
  CHECK_ONE (plain_short, short, 0200000, 17);

  CHECK_ONE (signed_short, signed short, -2, 18);
  CHECK_ONE (signed_short, signed short, -1, 19);
  CHECK_ONE (signed_short, signed short, 0177777, 20);
  CHECK_ONE (signed_short, signed short, 0200000, 21);

  CHECK_ONE (unsigned_short, unsigned short, 0, 22);
  CHECK_ONE (unsigned_short, unsigned short, 0177777, 23);
  CHECK_ONE (unsigned_short, unsigned short, 0377777, 24);

  CHECK_ONE (char6, char6, -33, 25);
  CHECK_ONE (char6, char6, -32, 26);
  CHECK_ONE (char6, char6, -1, 27);
  CHECK_ONE (char6, char6, 31, 28);
  CHECK_ONE (char6, char6, 32, 29);
  CHECK_ONE (uchar6, uchar6, 0, 30);
  CHECK_ONE (uchar6, uchar6, 63, 31);
  CHECK_ONE (uchar6, uchar6, 64, 32);

  CHECK_ONE (char7, char7, -65, 33);
  CHECK_ONE (char7, char7, -64, 34);
  CHECK_ONE (char7, char7, -1, 35);
  CHECK_ONE (char7, char7, 63, 36);
  CHECK_ONE (char7, char7, 64, 37);
  CHECK_ONE (uchar7, uchar7, 0, 38);
  CHECK_ONE (uchar7, uchar7, 127, 39);
  CHECK_ONE (uchar7, uchar7, 128, 40);

  CHECK_ONE (char8, char8, -129, 41);
  CHECK_ONE (char8, char8, -128, 42);
  CHECK_ONE (char8, char8, -1, 43);
  CHECK_ONE (char8, char8, 127, 44);
  CHECK_ONE (char8, char8, 128, 45);
  CHECK_ONE (uchar8, uchar8, 0, 46);
  CHECK_ONE (uchar8, uchar8, 255, 47);
  CHECK_ONE (uchar8, uchar8, 256, 48);

  CHECK_ONE (char9, char9, -257, 49);
  CHECK_ONE (char9, char9, -256, 50);
  CHECK_ONE (char9, char9, -1, 51);
  CHECK_ONE (char9, char9, 255, 52);
  CHECK_ONE (char9, char9, 256, 53);
  CHECK_ONE (uchar9, uchar9, 0, 54);
  CHECK_ONE (uchar9, uchar9, 511, 55);
  CHECK_ONE (uchar9, uchar9, 512, 56);

  CHECK_ONE (short16, short16, -32769, 57);
  CHECK_ONE (short16, short16, -32768, 58);
  CHECK_ONE (short16, short16, -1, 59);
  CHECK_ONE (short16, short16, 32767, 60);
  CHECK_ONE (short16, short16, 32768, 61);
  CHECK_ONE (ushort16, ushort16, 0, 62);
  CHECK_ONE (ushort16, ushort16, 65535, 63);
  CHECK_ONE (ushort16, ushort16, 65536, 64);

  CHECK_ONE (short18, short18, -0200001, 65);
  CHECK_ONE (short18, short18, -0200000, 66);
  CHECK_ONE (short18, short18, -1, 67);
  CHECK_ONE (short18, short18, 0177777, 68);
  CHECK_ONE (short18, short18, 0200000, 69);
  CHECK_ONE (ushort18, ushort18, 0, 70);
  CHECK_ONE (ushort18, ushort18, 0377777, 71);
  CHECK_ONE (ushort18, ushort18, 0400000, 72);

  CHECK_ONE (Qint, Qint, -257, 73);
  CHECK_ONE (Qint, Qint, -1, 74);
  CHECK_ONE (Qint, Qint, 256, 75);
  CHECK_ONE (sQint, sQint, -257, 76);
  CHECK_ONE (sQint, sQint, -1, 77);
  CHECK_ONE (sQint, sQint, 256, 78);
  CHECK_ONE (uQint, uQint, 0, 79);
  CHECK_ONE (uQint, uQint, 511, 80);
  CHECK_ONE (uQint, uQint, 512, 81);

  CHECK_ONE (Hint, Hint, -0200001, 82);
  CHECK_ONE (Hint, Hint, -1, 83);
  CHECK_ONE (Hint, Hint, 0177777, 84);
  CHECK_ONE (uHint, uHint, 0, 85);
  CHECK_ONE (uHint, uHint, 0377777, 86);
  CHECK_ONE (uHint, uHint, 0400000, 87);

  CHECK_ONE (Sint, Sint, -1, 88);
  CHECK_ONE (Sint, Sint, 1, 89);
  CHECK_ONE (uSint, uSint, 0, 90);
  CHECK_ONE (uSint, uSint, 1, 91);

  return_promote_fail_id = 0;
  return 1;
}

int
main ()
{
  if (return_promote_all (1))
    return 0;
  if (return_promote_fail_id != 0)
    return (int) return_promote_fail_id;
  return 0777777;
}
