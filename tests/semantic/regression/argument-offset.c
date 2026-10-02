#include "insns.h"

/*
 * Argument offset and late-argument access pressure.
 *
 * File:
 *   misc/argument-offset.c
 *
 * This is a misc ABI/code-generation test, not a single instruction
 * pattern test.
 *
 * It stresses:
 *   - scalar arguments beyond the register-argument window
 *   - QI/HI promoted arguments
 *   - DImode arguments, including register/stack boundary pressure
 *   - mixed-width argument lists
 *   - pointer arguments after many scalar arguments
 *   - struct arguments large enough to advance the argument cursor
 *
 * The default current PDP-10 backend uses a finite register parameter
 * window.  Arguments after that must be found at the correct stack
 * offsets.  Multiword arguments such as Dint/uDint are especially
 * useful because they advance the argument cursor by more than one
 * word and may cross the register/stack boundary with different
 * -mregparm settings.
 */

extern Sint f(void);
extern uSint uf(void);
extern void clobber(void);

static Sint arg_sink;
static Dint darg_sink;
static uDint udarg_sink;

struct small_arg {
  Sint a;
  Sint b;
};

struct mixed_arg {
  Qint a;
  Hint b;
  Sint c;
};

struct big_arg {
  Sint a;
  Sint b;
  Sint c;
  Sint d;
  Sint e;
};

static struct small_arg small_global;
static struct mixed_arg mixed_global;
static struct big_arg big_global;

/*
 * Original shape, kept compactly.  These eight-argument functions
 * read e/f/g/h, which should be beyond the four-register default and
 * beyond the old small register windows.
 */

#define ARG8(T, X)                                              \
static T arg8##T##X(a, b, c, d, e, f, g, h)                     \
T a;                                                            \
T b;                                                            \
T c;                                                            \
T d;                                                            \
T e;                                                            \
T f;                                                            \
T g;                                                            \
T h;                                                            \
{                                                               \
  return X;                                                     \
}

ARG8(uQint, e)
ARG8(uQint, f)
ARG8(uQint, g)
ARG8(uQint, h)

ARG8(Qint, e)
ARG8(Qint, f)
ARG8(Qint, g)
ARG8(Qint, h)

ARG8(uHint, e)
ARG8(uHint, f)
ARG8(uHint, g)
ARG8(uHint, h)

ARG8(Hint, e)
ARG8(Hint, f)
ARG8(Hint, g)
ARG8(Hint, h)

ARG8(uSint, e)
ARG8(uSint, f)
ARG8(uSint, g)
ARG8(uSint, h)

ARG8(Sint, e)
ARG8(Sint, f)
ARG8(Sint, g)
ARG8(Sint, h)

ARG8(Dint, c)
ARG8(Dint, d)
ARG8(Dint, e)
ARG8(Dint, f)
ARG8(Dint, g)
ARG8(Dint, h)

ARG8(uDint, c)
ARG8(uDint, d)
ARG8(uDint, e)
ARG8(uDint, f)
ARG8(uDint, g)
ARG8(uDint, h)

/*
 * Ten-argument scalar forms.  These go farther down the incoming
 * argument area and catch off-by-one stack offsets.
 */

#define ARG10(T, X)                                             \
static T arg10##T##X(a, b, c, d, e, f, g, h, i, j)              \
T a;                                                            \
T b;                                                            \
T c;                                                            \
T d;                                                            \
T e;                                                            \
T f;                                                            \
T g;                                                            \
T h;                                                            \
T i;                                                            \
T j;                                                            \
{                                                               \
  return X;                                                     \
}

ARG10(Sint, e)
ARG10(Sint, f)
ARG10(Sint, g)
ARG10(Sint, h)
ARG10(Sint, i)
ARG10(Sint, j)

ARG10(uSint, e)
ARG10(uSint, f)
ARG10(uSint, g)
ARG10(uSint, h)
ARG10(uSint, i)
ARG10(uSint, j)

ARG10(Qint, e)
ARG10(Qint, f)
ARG10(Qint, g)
ARG10(Qint, h)
ARG10(Qint, i)
ARG10(Qint, j)

ARG10(Hint, e)
ARG10(Hint, f)
ARG10(Hint, g)
ARG10(Hint, h)
ARG10(Hint, i)
ARG10(Hint, j)

/*
 * DImode with enough arguments to pressure both all-stack and partial
 * register/stack cases under different -mregparm settings.
 */

static Dint
darg_c(a, b, c, d, e, f)
Dint a;
Dint b;
Dint c;
Dint d;
Dint e;
Dint f;
{
  return c;
}

static Dint
darg_d(a, b, c, d, e, f)
Dint a;
Dint b;
Dint c;
Dint d;
Dint e;
Dint f;
{
  return d;
}

static Dint
darg_e(a, b, c, d, e, f)
Dint a;
Dint b;
Dint c;
Dint d;
Dint e;
Dint f;
{
  return e;
}

static Dint
darg_f(a, b, c, d, e, f)
Dint a;
Dint b;
Dint c;
Dint d;
Dint e;
Dint f;
{
  return f;
}

static uDint
udarg_c(a, b, c, d, e, f)
uDint a;
uDint b;
uDint c;
uDint d;
uDint e;
uDint f;
{
  return c;
}

static uDint
udarg_d(a, b, c, d, e, f)
uDint a;
uDint b;
uDint c;
uDint d;
uDint e;
uDint f;
{
  return d;
}

static uDint
udarg_e(a, b, c, d, e, f)
uDint a;
uDint b;
uDint c;
uDint d;
uDint e;
uDint f;
{
  return e;
}

static uDint
udarg_f(a, b, c, d, e, f)
uDint a;
uDint b;
uDint c;
uDint d;
uDint e;
uDint f;
{
  return f;
}

/*
 * Use late arguments in expressions, not only as plain returns.
 */

static Sint
late_add_e(a, b, c, d, e, f, g, h)
Sint a;
Sint b;
Sint c;
Sint d;
Sint e;
Sint f;
Sint g;
Sint h;
{
  return e + f;
}

static Sint
late_sub_g_h(a, b, c, d, e, f, g, h)
Sint a;
Sint b;
Sint c;
Sint d;
Sint e;
Sint f;
Sint g;
Sint h;
{
  return g - h;
}

static Sint
late_mix_e_h(a, b, c, d, e, f, g, h)
Sint a;
Sint b;
Sint c;
Sint d;
Sint e;
Sint f;
Sint g;
Sint h;
{
  return (e + h) ^ (f - g);
}

static uSint
ulate_mix_e_h(a, b, c, d, e, f, g, h)
uSint a;
uSint b;
uSint c;
uSint d;
uSint e;
uSint f;
uSint g;
uSint h;
{
  return (e + h) ^ (f - g);
}

static Sint
late_qi_sum(a, b, c, d, e, f, g, h)
Qint a;
Qint b;
Qint c;
Qint d;
Qint e;
Qint f;
Qint g;
Qint h;
{
  return e + f + g + h;
}

static Sint
late_uqi_sum(a, b, c, d, e, f, g, h)
uQint a;
uQint b;
uQint c;
uQint d;
uQint e;
uQint f;
uQint g;
uQint h;
{
  return e + f + g + h;
}

static Sint
late_hi_sum(a, b, c, d, e, f, g, h)
Hint a;
Hint b;
Hint c;
Hint d;
Hint e;
Hint f;
Hint g;
Hint h;
{
  return e + f + g + h;
}

static Sint
late_uhi_sum(a, b, c, d, e, f, g, h)
uHint a;
uHint b;
uHint c;
uHint d;
uHint e;
uHint f;
uHint g;
uHint h;
{
  return e + f + g + h;
}

/*
 * Dint expression pressure without division.  Keep this about
 * argument locations, not DImode arithmetic bugs.
 */

static Dint
late_dint_select(a, b, c, d, e, f)
Dint a;
Dint b;
Dint c;
Dint d;
Dint e;
Dint f;
{
  if (c == d)
    return e;
  return f;
}

static Dint
late_dint_store(a, b, c, d, e, f)
Dint a;
Dint b;
Dint c;
Dint d;
Dint e;
Dint f;
{
  darg_sink = e;
  return f;
}

static uDint
late_udint_store(a, b, c, d, e, f)
uDint a;
uDint b;
uDint c;
uDint d;
uDint e;
uDint f;
{
  udarg_sink = e;
  return f;
}

/*
 * Mixed-width argument cursor pressure.
 */

static Sint
mix_q_h_s_e(a, b, c, d, e, f, g, h)
Qint a;
Hint b;
Sint c;
Qint d;
Sint e;
Hint f;
Qint g;
Sint h;
{
  return e;
}

static Sint
mix_q_h_s_f(a, b, c, d, e, f, g, h)
Qint a;
Hint b;
Sint c;
Qint d;
Sint e;
Hint f;
Qint g;
Sint h;
{
  return f;
}

static Sint
mix_q_h_s_g(a, b, c, d, e, f, g, h)
Qint a;
Hint b;
Sint c;
Qint d;
Sint e;
Hint f;
Qint g;
Sint h;
{
  return g;
}

static Sint
mix_q_h_s_h(a, b, c, d, e, f, g, h)
Qint a;
Hint b;
Sint c;
Qint d;
Sint e;
Hint f;
Qint g;
Sint h;
{
  return h;
}

static Sint
mix_d_s_q_e(a, b, c, d, e, f, g)
Dint a;
Sint b;
Qint c;
Hint d;
Sint e;
Dint f;
Sint g;
{
  return e;
}

static Dint
mix_d_s_q_f(a, b, c, d, e, f, g)
Dint a;
Sint b;
Qint c;
Hint d;
Sint e;
Dint f;
Sint g;
{
  return f;
}

static Sint
mix_d_s_q_g(a, b, c, d, e, f, g)
Dint a;
Sint b;
Qint c;
Hint d;
Sint e;
Dint f;
Sint g;
{
  return g;
}

static Sint
mix_s_d_s_e(a, b, c, d, e, f)
Sint a;
Dint b;
Sint c;
Dint d;
Sint e;
Sint f;
{
  return e;
}

static Dint
mix_s_d_s_d(a, b, c, d, e, f)
Sint a;
Dint b;
Sint c;
Dint d;
Sint e;
Sint f;
{
  return d;
}

static Sint
mix_s_d_s_f(a, b, c, d, e, f)
Sint a;
Dint b;
Sint c;
Dint d;
Sint e;
Sint f;
{
  return f;
}

/*
 * Pointer arguments after many scalar arguments.
 */

static Sint *
ptr_arg_e(a, b, c, d, e, f, g, h)
Sint a;
Sint b;
Sint c;
Sint d;
Sint *e;
Sint *f;
Sint *g;
Sint *h;
{
  return e;
}

static Sint *
ptr_arg_f(a, b, c, d, e, f, g, h)
Sint a;
Sint b;
Sint c;
Sint d;
Sint *e;
Sint *f;
Sint *g;
Sint *h;
{
  return f;
}

static Sint *
ptr_arg_g(a, b, c, d, e, f, g, h)
Sint a;
Sint b;
Sint c;
Sint d;
Sint *e;
Sint *f;
Sint *g;
Sint *h;
{
  return g;
}

static Sint *
ptr_arg_h(a, b, c, d, e, f, g, h)
Sint a;
Sint b;
Sint c;
Sint d;
Sint *e;
Sint *f;
Sint *g;
Sint *h;
{
  return h;
}

static Sint
ptr_load_e(a, b, c, d, e, f, g, h)
Sint a;
Sint b;
Sint c;
Sint d;
Sint *e;
Sint *f;
Sint *g;
Sint *h;
{
  return *e;
}

static Sint
ptr_load_h(a, b, c, d, e, f, g, h)
Sint a;
Sint b;
Sint c;
Sint d;
Sint *e;
Sint *f;
Sint *g;
Sint *h;
{
  return *h;
}

static void
ptr_store_g(a, b, c, d, e, f, g, h, v)
Sint a;
Sint b;
Sint c;
Sint d;
Sint *e;
Sint *f;
Sint *g;
Sint *h;
Sint v;
{
  *g = v;
}

static Qint *
qptr_arg_h(a, b, c, d, e, f, g, h)
Sint a;
Sint b;
Sint c;
Sint d;
Qint *e;
Qint *f;
Qint *g;
Qint *h;
{
  return h;
}

static Hint *
hptr_arg_h(a, b, c, d, e, f, g, h)
Sint a;
Sint b;
Sint c;
Sint d;
Hint *e;
Hint *f;
Hint *g;
Hint *h;
{
  return h;
}

/*
 * Struct arguments.  These should advance the argument cursor by the
 * rounded object size and are useful around stack offset computation.
 */

static Sint
small_arg_c(a, b, c, d)
Sint a;
Sint b;
struct small_arg c;
Sint d;
{
  return c.a + c.b + d;
}

static Sint
small_arg_late(a, b, c, d, e, f)
Sint a;
Sint b;
Sint c;
Sint d;
struct small_arg e;
Sint f;
{
  return e.a + e.b + f;
}

static Sint
mixed_arg_late(a, b, c, d, e, f)
Sint a;
Sint b;
Sint c;
Sint d;
struct mixed_arg e;
Sint f;
{
  return e.a + e.b + e.c + f;
}

static Sint
big_arg_late(a, b, c, d, e, f)
Sint a;
Sint b;
Sint c;
Sint d;
struct big_arg e;
Sint f;
{
  return e.a + e.b + e.c + e.d + e.e + f;
}

static struct small_arg
return_small_arg_late(a, b, c, d, e)
Sint a;
Sint b;
Sint c;
Sint d;
struct small_arg e;
{
  return e;
}

static struct mixed_arg
return_mixed_arg_late(a, b, c, d, e)
Sint a;
Sint b;
Sint c;
Sint d;
struct mixed_arg e;
{
  return e;
}

static struct big_arg
return_big_arg_late(a, b, c, d, e)
Sint a;
Sint b;
Sint c;
Sint d;
struct big_arg e;
{
  return e;
}

/*
 * Store late struct arguments into globals to force full incoming
 * argument materialization.
 */

static void
store_small_arg_late(a, b, c, d, e)
Sint a;
Sint b;
Sint c;
Sint d;
struct small_arg e;
{
  small_global = e;
}

static void
store_mixed_arg_late(a, b, c, d, e)
Sint a;
Sint b;
Sint c;
Sint d;
struct mixed_arg e;
{
  mixed_global = e;
}

static void
store_big_arg_late(a, b, c, d, e)
Sint a;
Sint b;
Sint c;
Sint d;
struct big_arg e;
{
  big_global = e;
}

/*
 * Calls with many outgoing arguments.  ACCUMULATE_OUTGOING_ARGS means
 * the caller frame must reserve the right outgoing area size and place
 * each late outgoing argument correctly.
 */

static Sint
callee8_sint(a, b, c, d, e, f, g, h)
Sint a;
Sint b;
Sint c;
Sint d;
Sint e;
Sint f;
Sint g;
Sint h;
{
  return e + f + g + h;
}

static Dint
callee6_dint(a, b, c, d, e, f)
Dint a;
Dint b;
Dint c;
Dint d;
Dint e;
Dint f;
{
  return e;
}

static Sint
call8_sint(a, b, c, d, e, f, g, h)
Sint a;
Sint b;
Sint c;
Sint d;
Sint e;
Sint f;
Sint g;
Sint h;
{
  return callee8_sint(a, b, c, d, e, f, g, h);
}

static Sint
call8_sint_constants()
{
  return callee8_sint(1, 2, 3, 4, 5, 6, 7, 8);
}

static Sint
call8_sint_mixed(a, b)
Sint a;
Sint b;
{
  return callee8_sint(a, b, f(), 4, a + b, a - b, f(), 8);
}

static Dint
call6_dint(a, b, c, d, e, f)
Dint a;
Dint b;
Dint c;
Dint d;
Dint e;
Dint f;
{
  return callee6_dint(a, b, c, d, e, f);
}

static Dint
call6_dint_constants()
{
  return callee6_dint((Dint)1, (Dint)2, (Dint)3,
                      (Dint)4, (Dint)5, (Dint)6);
}

/*
 * Mixed outgoing calls.
 */

static Sint
callee_mixed(a, b, c, d, e, f, g, h)
Qint a;
Hint b;
Sint c;
Dint d;
Qint e;
Hint f;
Sint g;
Dint h;
{
  return a + b + c + e + f + g;
}

static Sint
call_mixed(a, b, c, d, e, f, g, h)
Qint a;
Hint b;
Sint c;
Dint d;
Qint e;
Hint f;
Sint g;
Dint h;
{
  return callee_mixed(a, b, c, d, e, f, g, h);
}

static Sint
call_mixed_constants()
{
  return callee_mixed((Qint)1, (Hint)2, 3, (Dint)4,
                      (Qint)5, (Hint)6, 7, (Dint)8);
}

/*
 * Incoming late arguments with call barriers.
 */

static Sint
late_after_call_e(a, b, c, d, e, f, g, h)
Sint a;
Sint b;
Sint c;
Sint d;
Sint e;
Sint f;
Sint g;
Sint h;
{
  clobber();
  return e;
}

static Sint
late_after_call_h(a, b, c, d, e, f, g, h)
Sint a;
Sint b;
Sint c;
Sint d;
Sint e;
Sint f;
Sint g;
Sint h;
{
  clobber();
  return h;
}

static Dint
late_dint_after_call_e(a, b, c, d, e, f)
Dint a;
Dint b;
Dint c;
Dint d;
Dint e;
Dint f;
{
  clobber();
  return e;
}

static Dint
late_dint_after_call_f(a, b, c, d, e, f)
Dint a;
Dint b;
Dint c;
Dint d;
Dint e;
Dint f;
{
  clobber();
  return f;
}

/*
 * Branching on late arguments.
 */

static Sint
late_branch_e(a, b, c, d, e, f, g, h)
Sint a;
Sint b;
Sint c;
Sint d;
Sint e;
Sint f;
Sint g;
Sint h;
{
  if (e == 0)
    return f;
  return g;
}

static Sint
late_branch_h(a, b, c, d, e, f, g, h)
Sint a;
Sint b;
Sint c;
Sint d;
Sint e;
Sint f;
Sint g;
Sint h;
{
  if (h < 0)
    return e;
  return h;
}

static Sint
late_u_branch_h(a, b, c, d, e, f, g, h)
uSint a;
uSint b;
uSint c;
uSint d;
uSint e;
uSint f;
uSint g;
uSint h;
{
  if (h > e)
    return 1;
  return 0;
}

static Sint
late_dint_branch(a, b, c, d, e, f)
Dint a;
Dint b;
Dint c;
Dint d;
Dint e;
Dint f;
{
  if (e == f)
    return 1;
  return 0;
}

/*
 * Take addresses of local copies of late arguments.  This should force
 * stack slots or stores where the backend needs an addressable object.
 */

static Sint
late_address_copy_e(a, b, c, d, e, f, g, h)
Sint a;
Sint b;
Sint c;
Sint d;
Sint e;
Sint f;
Sint g;
Sint h;
{
  Sint *p;

  p = &e;
  return *p;
}

static Sint
late_address_copy_h(a, b, c, d, e, f, g, h)
Sint a;
Sint b;
Sint c;
Sint d;
Sint e;
Sint f;
Sint g;
Sint h;
{
  Sint *p;

  p = &h;
  return *p;
}

static Dint
late_dint_address_copy_e(a, b, c, d, e, f)
Dint a;
Dint b;
Dint c;
Dint d;
Dint e;
Dint f;
{
  Dint *p;

  p = &e;
  return *p;
}

/*
 * Volatile sinks to keep side effects visible.
 */

static void
sink_late_e(a, b, c, d, e, f, g, h)
Sint a;
Sint b;
Sint c;
Sint d;
Sint e;
Sint f;
Sint g;
Sint h;
{
  arg_sink = e;
}

static void
sink_late_h(a, b, c, d, e, f, g, h)
Sint a;
Sint b;
Sint c;
Sint d;
Sint e;
Sint f;
Sint g;
Sint h;
{
  arg_sink = h;
}

static void
sink_late_dint_e(a, b, c, d, e, f)
Dint a;
Dint b;
Dint c;
Dint d;
Dint e;
Dint f;
{
  darg_sink = e;
}

static void
sink_late_udint_f(a, b, c, d, e, f)
uDint a;
uDint b;
uDint c;
uDint d;
uDint e;
uDint f;
{
  udarg_sink = f;
}
