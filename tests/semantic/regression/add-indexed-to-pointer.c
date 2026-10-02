#include "insns.h"

/*
 * Pointer plus/minus indexed value pressure.
 *
 * File:
 *   misc/add-indexed-to-pointer.c
 *
 * This is a misc coverage test, not a single instruction-pattern test.
 *
 * It covers ordinary C pointer arithmetic of the form:
 *
 *   ptr + index
 *   ptr - index
 *
 * where the index is commonly loaded from memory.  This is important
 * on PDP-10 because word pointers and byte pointers have very different
 * lowering paths.
 *
 * Word-sized objects should normally reduce to address arithmetic.
 * Byte-sized objects may need byte-pointer adjustment.  On PDP-6/KA10
 * this must not require ADJBP; the backend has fallback code based on
 * word adjustment plus IBP stepping.
 */

extern Sint f(void);
extern uSint uf(void);
extern void clobber(void);

static Sint idx_ga;
static Sint idx_gb;
static volatile Sint idx_vga;
static Sint idx_buf[16];

static uSint uidx_ga;
static volatile uSint uidx_vga;
static uSint uidx_buf[16];

static Sint word_buf[64];
static uSint uword_buf[64];
static Qint q_buf[64];
static uQint uq_buf[64];
static Hint h_buf[64];
static uHint uh_buf[64];

struct idx_pair {
  Sint a;
  Sint b;
};

struct ptr_pair {
  Sint *a;
  Sint *b;
};

struct byte_ptr_pair {
  Qint *a;
  uQint *b;
};

static struct idx_pair idx_gp;
static struct ptr_pair ptr_gp;
static struct byte_ptr_pair byte_ptr_gp;

/*
 * Original small test.
 */

static Sint *
add(a, e)
Sint *a;
Sint *e;
{
  return a + *e;
}

static Sint *
sub(a, e)
Sint *a;
Sint *e;
{
  return a - *e;
}

/*
 * Word pointer plus/minus memory index.
 */

static Sint *
add_mem_index(p, e)
Sint *p;
Sint *e;
{
  return p + *e;
}

static Sint *
sub_mem_index(p, e)
Sint *p;
Sint *e;
{
  return p - *e;
}

static Sint *
add_volatile_mem_index(p, e)
Sint *p;
volatile Sint *e;
{
  return p + *e;
}

static Sint *
sub_volatile_mem_index(p, e)
Sint *p;
volatile Sint *e;
{
  return p - *e;
}

static Sint *
add_global_index(p)
Sint *p;
{
  return p + idx_ga;
}

static Sint *
sub_global_index(p)
Sint *p;
{
  return p - idx_ga;
}

static Sint *
add_volatile_global_index(p)
Sint *p;
{
  return p + idx_vga;
}

static Sint *
sub_volatile_global_index(p)
Sint *p;
{
  return p - idx_vga;
}

static Sint *
add_array_index(p, i)
Sint *p;
Sint i;
{
  return p + idx_buf[i & 017];
}

static Sint *
sub_array_index(p, i)
Sint *p;
Sint i;
{
  return p - idx_buf[i & 017];
}

static Sint *
add_struct_index(p, ip)
Sint *p;
struct idx_pair *ip;
{
  return p + ip->a;
}

static Sint *
sub_struct_index(p, ip)
Sint *p;
struct idx_pair *ip;
{
  return p - ip->b;
}

static Sint *
add_global_struct_index(p)
Sint *p;
{
  return p + idx_gp.a;
}

static Sint *
sub_global_struct_index(p)
Sint *p;
{
  return p - idx_gp.b;
}

/*
 * Word pointer plus/minus register index.
 */

static Sint *
add_reg_index(p, n)
Sint *p;
Sint n;
{
  return p + n;
}

static Sint *
sub_reg_index(p, n)
Sint *p;
Sint n;
{
  return p - n;
}

static Sint *
add_unsigned_reg_index(p, n)
Sint *p;
uSint n;
{
  return p + n;
}

static Sint *
sub_unsigned_reg_index(p, n)
Sint *p;
uSint n;
{
  return p - n;
}

static Sint *
add_call_index(p)
Sint *p;
{
  return p + f();
}

static Sint *
sub_call_index(p)
Sint *p;
{
  return p - f();
}

static Sint *
add_after_call(p, e)
Sint *p;
Sint *e;
{
  Sint n;

  n = *e;
  clobber();
  return p + n;
}

static Sint *
sub_after_call(p, e)
Sint *p;
Sint *e;
{
  Sint n;

  n = *e;
  clobber();
  return p - n;
}

/*
 * Constant word-pointer offsets.
 */

static Sint *
add_const_0(p)
Sint *p;
{
  return p + 0;
}

static Sint *
add_const_1(p)
Sint *p;
{
  return p + 1;
}

static Sint *
add_const_2(p)
Sint *p;
{
  return p + 2;
}

static Sint *
add_const_7(p)
Sint *p;
{
  return p + 7;
}

static Sint *
add_const_0100(p)
Sint *p;
{
  return p + 0100;
}

static Sint *
sub_const_1(p)
Sint *p;
{
  return p - 1;
}

static Sint *
sub_const_2(p)
Sint *p;
{
  return p - 2;
}

static Sint *
sub_const_7(p)
Sint *p;
{
  return p - 7;
}

static Sint *
sub_const_0100(p)
Sint *p;
{
  return p - 0100;
}

/*
 * Base pointer loaded from memory/global.
 */

static Sint *
add_to_loaded_pointer(pp, e)
Sint **pp;
Sint *e;
{
  return *pp + *e;
}

static Sint *
sub_from_loaded_pointer(pp, e)
Sint **pp;
Sint *e;
{
  return *pp - *e;
}

static Sint *
add_to_global_pointer(e)
Sint *e;
{
  return ptr_gp.a + *e;
}

static Sint *
sub_from_global_pointer(e)
Sint *e;
{
  return ptr_gp.b - *e;
}

static Sint *
add_loaded_pointer_reg(pp, n)
Sint **pp;
Sint n;
{
  return *pp + n;
}

static Sint *
sub_loaded_pointer_reg(pp, n)
Sint **pp;
Sint n;
{
  return *pp - n;
}

/*
 * Store resulting word pointers.
 */

static void
store_add_ptr(dst, p, e)
Sint **dst;
Sint *p;
Sint *e;
{
  *dst = p + *e;
}

static void
store_sub_ptr(dst, p, e)
Sint **dst;
Sint *p;
Sint *e;
{
  *dst = p - *e;
}

static Sint *
store_add_ptr_return(dst, p, e)
Sint **dst;
Sint *p;
Sint *e;
{
  return *dst = p + *e;
}

static Sint *
store_sub_ptr_return(dst, p, e)
Sint **dst;
Sint *p;
Sint *e;
{
  return *dst = p - *e;
}

static void
store_add_global_ptr(p, e)
Sint *p;
Sint *e;
{
  ptr_gp.a = p + *e;
}

static void
store_sub_global_ptr(p, e)
Sint *p;
Sint *e;
{
  ptr_gp.b = p - *e;
}

/*
 * Use dereferenced result so the address computation feeds a memory
 * access.
 */

static Sint
load_add_mem_index(p, e)
Sint *p;
Sint *e;
{
  return *(p + *e);
}

static Sint
load_sub_mem_index(p, e)
Sint *p;
Sint *e;
{
  return *(p - *e);
}

static void
store_through_add_mem_index(p, e, v)
Sint *p;
Sint *e;
Sint v;
{
  *(p + *e) = v;
}

static void
store_through_sub_mem_index(p, e, v)
Sint *p;
Sint *e;
Sint v;
{
  *(p - *e) = v;
}

static Sint
load_add_global_index(p)
Sint *p;
{
  return *(p + idx_ga);
}

static Sint
load_sub_global_index(p)
Sint *p;
{
  return *(p - idx_ga);
}

static void
store_add_global_index(p, v)
Sint *p;
Sint v;
{
  *(p + idx_ga) = v;
}

static void
store_sub_global_index(p, v)
Sint *p;
Sint v;
{
  *(p - idx_ga) = v;
}

/*
 * Array bases.
 */

static Sint *
word_base_add_index(e)
Sint *e;
{
  return word_buf + *e;
}

static Sint *
word_base_sub_index(e)
Sint *e;
{
  return word_buf + 32 - *e;
}

static Sint
word_base_load_add(e)
Sint *e;
{
  return *(word_buf + *e);
}

static Sint
word_base_load_sub(e)
Sint *e;
{
  return *(word_buf + 32 - *e);
}

static void
word_base_store_add(e, v)
Sint *e;
Sint v;
{
  *(word_buf + *e) = v;
}

static void
word_base_store_sub(e, v)
Sint *e;
Sint v;
{
  *(word_buf + 32 - *e) = v;
}

static uSint *
uword_base_add_index(e)
Sint *e;
{
  return uword_buf + *e;
}

static uSint *
uword_base_sub_index(e)
Sint *e;
{
  return uword_buf + 32 - *e;
}

static uSint
uword_base_load_add(e)
Sint *e;
{
  return *(uword_buf + *e);
}

/*
 * Byte-sized pointer arithmetic: Qint/uQint.
 */

static Qint *
qadd_mem_index(p, e)
Qint *p;
Sint *e;
{
  return p + *e;
}

static Qint *
qsub_mem_index(p, e)
Qint *p;
Sint *e;
{
  return p - *e;
}

static uQint *
uqadd_mem_index(p, e)
uQint *p;
Sint *e;
{
  return p + *e;
}

static uQint *
uqsub_mem_index(p, e)
uQint *p;
Sint *e;
{
  return p - *e;
}

static Qint *
qadd_reg_index(p, n)
Qint *p;
Sint n;
{
  return p + n;
}

static Qint *
qsub_reg_index(p, n)
Qint *p;
Sint n;
{
  return p - n;
}

static Qint *
qadd_global_index(p)
Qint *p;
{
  return p + idx_ga;
}

static Qint *
qsub_global_index(p)
Qint *p;
{
  return p - idx_ga;
}

static Qint *
qadd_const_1(p)
Qint *p;
{
  return p + 1;
}

static Qint *
qadd_const_2(p)
Qint *p;
{
  return p + 2;
}

static Qint *
qadd_const_3(p)
Qint *p;
{
  return p + 3;
}

static Qint *
qadd_const_4(p)
Qint *p;
{
  return p + 4;
}

static Qint *
qsub_const_1(p)
Qint *p;
{
  return p - 1;
}

static Qint *
qsub_const_2(p)
Qint *p;
{
  return p - 2;
}

static Qint *
qsub_const_3(p)
Qint *p;
{
  return p - 3;
}

static Qint *
qsub_const_4(p)
Qint *p;
{
  return p - 4;
}

static Qint
qload_add_mem_index(p, e)
Qint *p;
Sint *e;
{
  return *(p + *e);
}

static Qint
qload_sub_mem_index(p, e)
Qint *p;
Sint *e;
{
  return *(p - *e);
}

static void
qstore_add_mem_index(p, e, v)
Qint *p;
Sint *e;
Qint v;
{
  *(p + *e) = v;
}

static void
qstore_sub_mem_index(p, e, v)
Qint *p;
Sint *e;
Qint v;
{
  *(p - *e) = v;
}

static Qint *
qbase_add_index(e)
Sint *e;
{
  return q_buf + *e;
}

static Qint *
qbase_sub_index(e)
Sint *e;
{
  return q_buf + 32 - *e;
}

static Qint
qbase_load_add(e)
Sint *e;
{
  return *(q_buf + *e);
}

static void
qbase_store_add(e, v)
Sint *e;
Qint v;
{
  *(q_buf + *e) = v;
}

static uQint *
uqbase_add_index(e)
Sint *e;
{
  return uq_buf + *e;
}

static uQint *
uqbase_sub_index(e)
Sint *e;
{
  return uq_buf + 32 - *e;
}

static uQint
uqbase_load_add(e)
Sint *e;
{
  return *(uq_buf + *e);
}

/*
 * Halfword pointer arithmetic: Hint/uHint.
 */

static Hint *
hadd_mem_index(p, e)
Hint *p;
Sint *e;
{
  return p + *e;
}

static Hint *
hsub_mem_index(p, e)
Hint *p;
Sint *e;
{
  return p - *e;
}

static uHint *
uhadd_mem_index(p, e)
uHint *p;
Sint *e;
{
  return p + *e;
}

static uHint *
uhsub_mem_index(p, e)
uHint *p;
Sint *e;
{
  return p - *e;
}

static Hint *
hadd_reg_index(p, n)
Hint *p;
Sint n;
{
  return p + n;
}

static Hint *
hsub_reg_index(p, n)
Hint *p;
Sint n;
{
  return p - n;
}

static Hint *
hadd_global_index(p)
Hint *p;
{
  return p + idx_ga;
}

static Hint *
hsub_global_index(p)
Hint *p;
{
  return p - idx_ga;
}

static Hint *
hadd_const_1(p)
Hint *p;
{
  return p + 1;
}

static Hint *
hadd_const_2(p)
Hint *p;
{
  return p + 2;
}

static Hint *
hadd_const_3(p)
Hint *p;
{
  return p + 3;
}

static Hint *
hsub_const_1(p)
Hint *p;
{
  return p - 1;
}

static Hint *
hsub_const_2(p)
Hint *p;
{
  return p - 2;
}

static Hint *
hsub_const_3(p)
Hint *p;
{
  return p - 3;
}

static Hint
hload_add_mem_index(p, e)
Hint *p;
Sint *e;
{
  return *(p + *e);
}

static Hint
hload_sub_mem_index(p, e)
Hint *p;
Sint *e;
{
  return *(p - *e);
}

static void
hstore_add_mem_index(p, e, v)
Hint *p;
Sint *e;
Hint v;
{
  *(p + *e) = v;
}

static void
hstore_sub_mem_index(p, e, v)
Hint *p;
Sint *e;
Hint v;
{
  *(p - *e) = v;
}

static Hint *
hbase_add_index(e)
Sint *e;
{
  return h_buf + *e;
}

static Hint *
hbase_sub_index(e)
Sint *e;
{
  return h_buf + 32 - *e;
}

static Hint
hbase_load_add(e)
Sint *e;
{
  return *(h_buf + *e);
}

static void
hbase_store_add(e, v)
Sint *e;
Hint v;
{
  *(h_buf + *e) = v;
}

static uHint *
uhbase_add_index(e)
Sint *e;
{
  return uh_buf + *e;
}

static uHint *
uhbase_sub_index(e)
Sint *e;
{
  return uh_buf + 32 - *e;
}

static uHint
uhbase_load_add(e)
Sint *e;
{
  return *(uh_buf + *e);
}

/*
 * char pointer forms.  These follow the target char byte size and are
 * useful for the default 9-bit character mode.
 */

static char *
cadd_mem_index(p, e)
char *p;
Sint *e;
{
  return p + *e;
}

static char *
csub_mem_index(p, e)
char *p;
Sint *e;
{
  return p - *e;
}

static char *
cadd_reg_index(p, n)
char *p;
Sint n;
{
  return p + n;
}

static char *
csub_reg_index(p, n)
char *p;
Sint n;
{
  return p - n;
}

static char *
cadd_global_index(p)
char *p;
{
  return p + idx_ga;
}

static char *
csub_global_index(p)
char *p;
{
  return p - idx_ga;
}

static char
cload_add_mem_index(p, e)
char *p;
Sint *e;
{
  return *(p + *e);
}

static char
cload_sub_mem_index(p, e)
char *p;
Sint *e;
{
  return *(p - *e);
}

static void
cstore_add_mem_index(p, e, v)
char *p;
Sint *e;
char v;
{
  *(p + *e) = v;
}

static void
cstore_sub_mem_index(p, e, v)
char *p;
Sint *e;
char v;
{
  *(p - *e) = v;
}

/*
 * Mixed expressions around the index.
 */

static Sint *
add_index_plus_1(p, e)
Sint *p;
Sint *e;
{
  return p + (*e + 1);
}

static Sint *
sub_index_plus_1(p, e)
Sint *p;
Sint *e;
{
  return p - (*e + 1);
}

static Sint *
add_index_minus_1(p, e)
Sint *p;
Sint *e;
{
  return p + (*e - 1);
}

static Sint *
sub_index_minus_1(p, e)
Sint *p;
Sint *e;
{
  return p - (*e - 1);
}

static Sint *
add_index_from_sum(p, a, b)
Sint *p;
Sint a;
Sint b;
{
  return p + (a + b);
}

static Sint *
sub_index_from_sum(p, a, b)
Sint *p;
Sint a;
Sint b;
{
  return p - (a + b);
}

static Sint *
add_index_from_diff(p, a, b)
Sint *p;
Sint a;
Sint b;
{
  return p + (a - b);
}

static Sint *
sub_index_from_diff(p, a, b)
Sint *p;
Sint a;
Sint b;
{
  return p - (a - b);
}

static Qint *
qadd_index_plus_1(p, e)
Qint *p;
Sint *e;
{
  return p + (*e + 1);
}

static Qint *
qsub_index_plus_1(p, e)
Qint *p;
Sint *e;
{
  return p - (*e + 1);
}

static Hint *
hadd_index_plus_1(p, e)
Hint *p;
Sint *e;
{
  return p + (*e + 1);
}

static Hint *
hsub_index_plus_1(p, e)
Hint *p;
Sint *e;
{
  return p - (*e + 1);
}

/*
 * Comparisons and selection using adjusted pointers.
 */

static Sint
ptr_add_eq(p, e, q)
Sint *p;
Sint *e;
Sint *q;
{
  return p + *e == q;
}

static Sint
ptr_sub_eq(p, e, q)
Sint *p;
Sint *e;
Sint *q;
{
  return p - *e == q;
}

static Sint *
select_add_or_sub(p, e, flag)
Sint *p;
Sint *e;
Sint flag;
{
  if (flag)
    return p + *e;
  return p - *e;
}

static Sint *
select_two_adds(p, q, e)
Sint *p;
Sint *q;
Sint *e;
{
  if (*e < 0)
    return p + *e;
  return q + *e;
}

static Qint *
qselect_add_or_sub(p, e, flag)
Qint *p;
Sint *e;
Sint flag;
{
  if (flag)
    return p + *e;
  return p - *e;
}

static Hint *
hselect_add_or_sub(p, e, flag)
Hint *p;
Sint *e;
Sint flag;
{
  if (flag)
    return p + *e;
  return p - *e;
}

/*
 * Unsigned index variants.
 */

static Sint *
add_umem_index(p, e)
Sint *p;
uSint *e;
{
  return p + *e;
}

static Sint *
sub_umem_index(p, e)
Sint *p;
uSint *e;
{
  return p - *e;
}

static Sint *
add_uglobal_index(p)
Sint *p;
{
  return p + uidx_ga;
}

static Sint *
sub_uglobal_index(p)
Sint *p;
{
  return p - uidx_ga;
}

static Sint *
add_uarray_index(p, i)
Sint *p;
Sint i;
{
  return p + uidx_buf[i & 017];
}

static Sint *
sub_uarray_index(p, i)
Sint *p;
Sint i;
{
  return p - uidx_buf[i & 017];
}

static Qint *
qadd_umem_index(p, e)
Qint *p;
uSint *e;
{
  return p + *e;
}

static Qint *
qsub_umem_index(p, e)
Qint *p;
uSint *e;
{
  return p - *e;
}

/*
 * Call barriers with byte pointers.
 */

static Qint *
qadd_after_call(p, e)
Qint *p;
Sint *e;
{
  Sint n;

  n = *e;
  clobber();
  return p + n;
}

static Qint *
qsub_after_call(p, e)
Qint *p;
Sint *e;
{
  Sint n;

  n = *e;
  clobber();
  return p - n;
}

static Hint *
hadd_after_call(p, e)
Hint *p;
Sint *e;
{
  Sint n;

  n = *e;
  clobber();
  return p + n;
}

static Hint *
hsub_after_call(p, e)
Hint *p;
Sint *e;
{
  Sint n;

  n = *e;
  clobber();
  return p - n;
}

static char *
cadd_after_call(p, e)
char *p;
Sint *e;
{
  Sint n;

  n = *e;
  clobber();
  return p + n;
}

static char *
csub_after_call(p, e)
char *p;
Sint *e;
{
  Sint n;

  n = *e;
  clobber();
  return p - n;
}
