/* PDP-10 GCC v26: promoted SImode loads of 9-bit packed parameters.
 *
 * GCC formerly represented every unsigned-char field of a packed
 * by-value formal parameter as the same full-word SImode MEM.  At O0
 * MOVE and ADD read the whole word; at O1 and higher CSE also merged
 * different fields before the final output hook could recover them.
 * The backend must represent distinct 9-bit fields as ZERO_EXTRACT
 * (and signed fields as SIGN_EXTRACT) during RTL expansion.
 *
 * C89 plus the target-supported GNU packed/noinline attributes.
 */

volatile int __test_exit;
volatile int semantic_fail_id;
volatile int semantic_sink;

struct u3_v26 {
  unsigned char a0, a1, a2;
} __attribute__((packed));

struct u6_v26 {
  unsigned char a0, a1, a2, a3, a4, a5;
} __attribute__((packed));

struct u11_v26 {
  unsigned char a0, a1, a2, a3, a4, a5;
  unsigned char a6, a7, a8, a9, a10;
} __attribute__((packed));

struct u20_v26 {
  unsigned char a0, a1, a2, a3, a4, a5, a6, a7, a8, a9;
  unsigned char a10, a11, a12, a13, a14, a15, a16, a17, a18, a19;
} __attribute__((packed));

struct s3_v26 {
  signed char a0, a1, a2;
} __attribute__((packed));

static int sum3_v26(struct u3_v26 p) __attribute__((noinline));
static int sum6_v26(struct u6_v26 p) __attribute__((noinline));
static int sum11_v26(struct u11_v26 p) __attribute__((noinline));
static int sum20_v26(struct u20_v26 p) __attribute__((noinline));
static int signed_sum_v26(struct s3_v26 p) __attribute__((noinline));

static int
sum3_v26(struct u3_v26 p)
{
  return p.a0 + p.a1 + p.a2;
}

static int
sum6_v26(struct u6_v26 p)
{
  return p.a0 + p.a1 + p.a2 + p.a3 + p.a4 + p.a5;
}

static int
sum11_v26(struct u11_v26 p)
{
  return p.a0 + p.a1 + p.a2 + p.a3 + p.a4 + p.a5
    + p.a6 + p.a7 + p.a8 + p.a9 + p.a10;
}

static int
sum20_v26(struct u20_v26 p)
{
  return p.a0 + p.a1 + p.a2 + p.a3 + p.a4
    + p.a5 + p.a6 + p.a7 + p.a8 + p.a9
    + p.a10 + p.a11 + p.a12 + p.a13 + p.a14
    + p.a15 + p.a16 + p.a17 + p.a18 + p.a19;
}

static int
signed_sum_v26(struct s3_v26 p)
{
  return p.a0 + p.a1 + p.a2;
}

int
main(void)
{
  struct u3_v26 u3;
  struct u6_v26 u6;
  struct u11_v26 u11;
  struct u20_v26 u20;
  struct s3_v26 s3;
  int value;

  u3.a0 = 1; u3.a1 = 2; u3.a2 = 3;
  value = sum3_v26(u3);
  if (value != 6) {
    semantic_fail_id = 0100;
    semantic_sink = value;
    return 1;
  }

  u6.a0 = 4; u6.a1 = 5; u6.a2 = 6;
  u6.a3 = 7; u6.a4 = 8; u6.a5 = 9;
  value = sum6_v26(u6);
  if (value != 39) {
    semantic_fail_id = 0200;
    semantic_sink = value;
    return 2;
  }

  u11.a0 = 1; u11.a1 = 2; u11.a2 = 3; u11.a3 = 4;
  u11.a4 = 5; u11.a5 = 6; u11.a6 = 7; u11.a7 = 8;
  u11.a8 = 9; u11.a9 = 10; u11.a10 = 11;
  value = sum11_v26(u11);
  if (value != 66) {
    semantic_fail_id = 0300;
    semantic_sink = value;
    return 3;
  }

  u20.a0 = 1; u20.a1 = 2; u20.a2 = 3; u20.a3 = 4;
  u20.a4 = 5; u20.a5 = 6; u20.a6 = 7; u20.a7 = 8;
  u20.a8 = 9; u20.a9 = 10; u20.a10 = 11; u20.a11 = 12;
  u20.a12 = 13; u20.a13 = 14; u20.a14 = 15; u20.a15 = 16;
  u20.a16 = 17; u20.a17 = 18; u20.a18 = 19; u20.a19 = 20;
  value = sum20_v26(u20);
  if (value != 210) {
    semantic_fail_id = 0400;
    semantic_sink = value;
    return 4;
  }

  s3.a0 = -128; s3.a1 = 127; s3.a2 = -31;
  value = signed_sum_v26(s3);
  if (value != -32) {
    semantic_fail_id = 0500;
    semantic_sink = value;
    return 5;
  }

  semantic_sink = 1;
  return 0;
}
