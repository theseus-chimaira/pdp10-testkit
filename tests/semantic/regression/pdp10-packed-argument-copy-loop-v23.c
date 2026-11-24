/* PDP-10 counted copy of packed by-value arguments, v23.
 *
 * The backend's BLKmode byte-copy expansion formerly separated the loop
 * counter decrement from the loop's back edge.  When an argument copy
 * was enclosed in a compiler libcall sequence, the decrement could
 * move before the loop, leaving an unbounded LDB/DPB/IBP loop.
 *
 * These callees deliberately do not inspect the packed fields.  That
 * isolates the copy-loop termination contract from the independent
 * packed-argument field extraction/ABI defects.  Their volatile side
 * effect proves each indirect call boundary was actually reached.
 * C89 source; no runtime library functions are needed.
 */

volatile int __test_exit;
volatile int semantic_fail_id;
volatile int semantic_sink;

struct packed3_v23 { unsigned char bytes[3]; } __attribute__((packed));
struct packed6_v23 { unsigned char bytes[6]; } __attribute__((packed));
struct packed11_v23 { unsigned char bytes[11]; } __attribute__((packed));
struct packed20_v23 { unsigned char bytes[20]; } __attribute__((packed));

static volatile int calls_v23;

int receive3_v23 (struct packed3_v23 x) __attribute__((noinline));
int receive6_v23 (struct packed6_v23 x) __attribute__((noinline));
int receive11_v23 (struct packed11_v23 x) __attribute__((noinline));
int receive20_v23 (struct packed20_v23 x) __attribute__((noinline));

int receive3_v23 (struct packed3_v23 x) { return ++calls_v23; }
int receive6_v23 (struct packed6_v23 x) { return ++calls_v23; }
int receive11_v23 (struct packed11_v23 x) { return ++calls_v23; }
int receive20_v23 (struct packed20_v23 x) { return ++calls_v23; }

int
main (void)
{
  struct packed3_v23 v3;
  struct packed6_v23 v6;
  struct packed11_v23 v11;
  struct packed20_v23 v20;
  int i;

  calls_v23 = 0;
  semantic_fail_id = 0;
  for (i = 0; i < 3; ++i) v3.bytes[i] = (unsigned char) (i + 1);
  for (i = 0; i < 6; ++i) v6.bytes[i] = (unsigned char) (i + 2);
  for (i = 0; i < 11; ++i) v11.bytes[i] = (unsigned char) (i + 3);
  for (i = 0; i < 20; ++i) v20.bytes[i] = (unsigned char) (i + 4);

  if (receive3_v23 (v3) != 1) { semantic_fail_id = 0100; return 1; }
  if (receive6_v23 (v6) != 2) { semantic_fail_id = 0200; return 2; }
  if (receive11_v23 (v11) != 3) { semantic_fail_id = 0300; return 3; }
  if (receive20_v23 (v20) != 4) { semantic_fail_id = 0400; return 4; }
  semantic_sink = calls_v23;
  return calls_v23 != 4;
}
