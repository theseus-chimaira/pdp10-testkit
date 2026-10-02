/* flag: -O2 */
/*
 * PDP-10 GCC semantic sentry: subword return-value promotion ABI.
 *
 * This is deliberately a runtime test, not merely an assembly-shape test.
 * It checks that callee return value, caller-side promotion, sign/zero
 * extension, volatile memory reload, true indirect function-pointer calls,
 * and pass-through return functions agree for PDP-10 byte/halfword-sized
 * integer types.
 */

#include "insns.h"
#define NOINLINE __attribute__ ((noinline))

typedef signed char schar_t;
typedef unsigned char uchar_t;
typedef short short18_t;
typedef unsigned short ushort18_t;

typedef Qint qint_t;
typedef uQint uqint_t;
typedef Hint hint_t;
typedef uHint uhint_t;
typedef Sint sint_t;
typedef uSint usint_t;

typedef char6 char6_t;
typedef uchar6 uchar6_t;
typedef char7 char7_t;
typedef uchar7 uchar7_t;
typedef char8 char8_t;
typedef uchar8 uchar8_t;
typedef char9 char9_t;
typedef uchar9 uchar9_t;
typedef short16 short16_t;
typedef ushort16 ushort16_t;

volatile int __test_exit;
volatile int semantic_fail_id;
volatile int semantic_sink;
volatile int return_promote_seed;

static int
check_int (got, want, id)
     int got;
     int want;
     int id;
{
  semantic_sink = got;
  if (got != want)
    {
      semantic_fail_id = id;
      return 0;
    }
  return 1;
}

#define MAKE_RETURN_TEST(TYPE, NAME)                                      \
  NOINLINE TYPE ret_##NAME (x)                                            \
       int x;                                                             \
  {                                                                       \
    return (TYPE) x;                                                      \
  }                                                                       \
                                                                          \
  NOINLINE TYPE pass_##NAME (x)                                           \
       int x;                                                             \
  {                                                                       \
    return ret_##NAME (x);                                                \
  }                                                                       \
                                                                          \
  typedef TYPE (*fp_##NAME##_t) (int);                                     \
  static volatile TYPE slot_##NAME;                                       \
  static fp_##NAME##_t volatile fp_slot_##NAME;                           \
                                                                          \
  static int check_##NAME (x, want, base)                                  \
       int x;                                                             \
       int want;                                                          \
       int base;                                                          \
  {                                                                       \
    int got;                                                              \
                                                                          \
    got = (int) ret_##NAME (x);                                           \
    if (!check_int (got, want, base + 0))                                  \
      return 0;                                                           \
                                                                          \
    slot_##NAME = ret_##NAME (x + return_promote_seed);                   \
    got = (int) slot_##NAME;                                              \
    if (!check_int (got, want, base + 1))                                  \
      return 0;                                                           \
                                                                          \
    fp_slot_##NAME = ret_##NAME;                                          \
    got = (int) (*fp_slot_##NAME) (x + return_promote_seed);              \
    if (!check_int (got, want, base + 2))                                  \
      return 0;                                                           \
                                                                          \
    got = (int) pass_##NAME (x + return_promote_seed);                    \
    if (!check_int (got, want, base + 3))                                  \
      return 0;                                                           \
                                                                          \
    return 1;                                                             \
  }

MAKE_RETURN_TEST (char, char_plain)
MAKE_RETURN_TEST (schar_t, schar)
MAKE_RETURN_TEST (uchar_t, uchar)
MAKE_RETURN_TEST (short18_t, short18)
MAKE_RETURN_TEST (ushort18_t, ushort18)
MAKE_RETURN_TEST (qint_t, qint)
MAKE_RETURN_TEST (uqint_t, uqint)
MAKE_RETURN_TEST (hint_t, hint)
MAKE_RETURN_TEST (uhint_t, uhint)
MAKE_RETURN_TEST (sint_t, sint)
MAKE_RETURN_TEST (usint_t, usint)
MAKE_RETURN_TEST (char6_t, char6)
MAKE_RETURN_TEST (uchar6_t, uchar6)
MAKE_RETURN_TEST (char7_t, char7)
MAKE_RETURN_TEST (uchar7_t, uchar7)
MAKE_RETURN_TEST (char8_t, char8)
MAKE_RETURN_TEST (uchar8_t, uchar8)
MAKE_RETURN_TEST (char9_t, char9)
MAKE_RETURN_TEST (uchar9_t, uchar9)
MAKE_RETURN_TEST (short16_t, short16)
MAKE_RETURN_TEST (ushort16_t, ushort16)

int
runtime_return_promote_all ()
{
  int char_plain_want;

  return_promote_seed = 0;

  /* Plain char signedness is target policy.  Test it, but do not assume it. */
  char_plain_want = ((char) 0777 < 0) ? -1 : 0777;
  if (!check_char_plain (0777, char_plain_want, 0100)) return 0;
  if (!check_char_plain (0123, 0123, 0104)) return 0;

  /* Ordinary C 9-bit char-family types. */
  if (!check_schar  (0777, -1,   0110)) return 0;
  if (!check_schar  (-7,   -7,   0114)) return 0;
  if (!check_uchar  (0777, 0777, 0120)) return 0;
  if (!check_uchar  (-7,   0771, 0124)) return 0;

  /* Ordinary short is HImode/18-bit on this target. */
  if (!check_short18  (0777777, -1,      0130)) return 0;
  if (!check_short18  (-7,      -7,      0134)) return 0;
  if (!check_ushort18 (0777777, 0777777, 0140)) return 0;
  if (!check_ushort18 (-7,      0777771, 0144)) return 0;

  /* Explicit GCC machine modes. */
  if (!check_qint  (0777,    -1,      0150)) return 0;
  if (!check_qint  (-7,      -7,      0154)) return 0;
  if (!check_uqint (0777,    0777,    0160)) return 0;
  if (!check_uqint (-7,      0771,    0164)) return 0;
  if (!check_hint  (0777777, -1,      0170)) return 0;
  if (!check_hint  (-7,      -7,      0174)) return 0;
  if (!check_uhint (0777777, 0777777, 0200)) return 0;
  if (!check_uhint (-7,      0777771, 0204)) return 0;

  /* SImode is full-word, but keep it in the ABI sentry as a control. */
  if (!check_sint  (-7,     -7,     0210)) return 0;
  if (!check_sint  (012345, 012345, 0214)) return 0;
  if (!check_usint (012345, 012345, 0220)) return 0;

  /* PDP-10 explicit byte/halfword-sized integer types. */
  if (!check_char6   (077,     -1,      0230)) return 0;
  if (!check_char6   (-7,      -7,      0234)) return 0;
  if (!check_uchar6  (077,     077,     0240)) return 0;
  if (!check_uchar6  (-7,      071,     0244)) return 0;

  if (!check_char7   (0177,    -1,      0250)) return 0;
  if (!check_char7   (-7,      -7,      0254)) return 0;
  if (!check_uchar7  (0177,    0177,    0260)) return 0;
  if (!check_uchar7  (-7,      0171,    0264)) return 0;

  if (!check_char8   (0377,    -1,      0270)) return 0;
  if (!check_char8   (-7,      -7,      0274)) return 0;
  if (!check_uchar8  (0377,    0377,    0300)) return 0;
  if (!check_uchar8  (-7,      0371,    0304)) return 0;

  if (!check_char9   (0777,    -1,      0310)) return 0;
  if (!check_char9   (-7,      -7,      0314)) return 0;
  if (!check_uchar9  (0777,    0777,    0320)) return 0;
  if (!check_uchar9  (-7,      0771,    0324)) return 0;

  if (!check_short16  (0177777, -1,       0330)) return 0;
  if (!check_short16  (-7,      -7,       0334)) return 0;
  if (!check_ushort16 (0177777, 0177777,  0340)) return 0;
  if (!check_ushort16 (-7,      0177771,  0344)) return 0;

  semantic_sink = 0123;
  return 1;
}

int
main ()
{
  semantic_fail_id = 0;
  semantic_sink = 0;

  if (!runtime_return_promote_all ())
    return semantic_fail_id;

  semantic_fail_id = 0;
  semantic_sink = 0123;
  return 0;
}
