#include "insns.h"

/*
 * 32-bit insert into 36-bit storage coverage.
 *
 * A 32-bit scalar field is narrower than a PDP-10 word.  Stores and
 * copies must not accidentally become full-word clobbers when adjacent
 * bits or following packed fields share the containing word.
 */

struct word32_pair {
	uint32 lo;
	uint32 hi;
	uchar6 tag;
};

struct sword32_pair {
	int32 lo;
	int32 hi;
	char6 tag;
};

struct word32_mix {
	uchar6 pre;
	uint32 mid;
	uchar6 post;
};

struct sword32_mix {
	char6 pre;
	int32 mid;
	char6 post;
};

struct word32_bits {
	unsigned int left : 2;
	unsigned int mid : 32;
	unsigned int right : 2;
};

struct sword32_bits {
	int left : 2;
	int mid : 32;
	int right : 2;
};

struct word32_nested {
	uchar6 tag0;
	struct word32_mix inner;
	uint32 tail;
	uchar6 tag1;
};

union word32_union {
	uint32 u32;
	int32 s32;
	Sint word;
};

static struct word32_pair wp = { (uint32)1, (uint32)2, (uchar6)3 };
static struct sword32_pair swp = { (int32)-1, (int32)2, (char6)-3 };
static struct sword32_pair swp2 = { (int32)-11, (int32)12, (char6)-13 };
static struct word32_mix wm = { (uchar6)1, (uint32)2, (uchar6)3 };
static struct sword32_mix swm = { (char6)-1, (int32)2, (char6)-3 };
static struct word32_bits wb = { 1U, 012345670123U, 2U };
static struct sword32_bits swb = { -1, -12345, 1 };
static struct word32_nested wn;
static union word32_union wu;

static volatile struct word32_pair vwp;
static volatile struct word32_mix vwm;
static volatile struct word32_bits vwb;
static volatile uint32 vu32;
static volatile int32 vs32;

static uint32 wa[7];
static int32 sa[7];
static struct word32_pair wpa[4];
static struct word32_mix wma[4];

static uint32 *glo_p = &wp.lo;
static uint32 *ghi_p = &wp.hi;
static uint32 *garr_p = &wa[3];
static int32 *gslo_p = &swp.lo;
static uchar6 *gtag_p = &wp.tag;

static void
store_word32_low(x)
uint32 x;
{
	wp.lo = x;
}

static void
store_word32_high(x)
uint32 x;
{
	wp.hi = x;
}

static uint32
store_word32_low_ret(x)
uint32 x;
{
	return wp.lo = x;
}

static uint32
store_word32_high_ret(x)
uint32 x;
{
	return wp.hi = x;
}

static uint32
load_word32_low(void)
{
	return wp.lo;
}

static uint32
load_word32_high(void)
{
	return wp.hi;
}

static void
store_sword32_low(x)
int32 x;
{
	swp.lo = x;
}

static void
store_sword32_high(x)
int32 x;
{
	swp.hi = x;
}

static int32
load_sword32_low(void)
{
	return swp.lo;
}

static int32
load_sword32_high(void)
{
	return swp.hi;
}

static void
copy_word32_pair(d, s)
struct word32_pair *d;
struct word32_pair *s;
{
	d->lo = s->lo;
	d->hi = s->hi;
	d->tag = s->tag;
}

static void
copy_sword32_pair(d, s)
struct sword32_pair *d;
struct sword32_pair *s;
{
	d->lo = s->lo;
	d->hi = s->hi;
	d->tag = s->tag;
}

static void
store_word32_mixed(x, t)
uint32 x;
unsigned int t;
{
	wm.pre = (uchar6)t;
	wm.mid = x;
	wm.post = (uchar6)(t + 1U);
}

static void
store_sword32_mixed(x, t)
int32 x;
int t;
{
	swm.pre = (char6)t;
	swm.mid = x;
	swm.post = (char6)(t - 1);
}

static uint32
load_word32_mixed(void)
{
	return wm.mid + (uint32)wm.pre + (uint32)wm.post;
}

static int32
load_sword32_mixed(void)
{
	return swm.mid + (int32)swm.pre + (int32)swm.post;
}

static void
store_bits_mid(x)
uint32 x;
{
	wb.mid = x;
}

static uint32
load_bits_mid(void)
{
	return (uint32)wb.mid;
}

static unsigned int
preserve_bits_mid(x)
uint32 x;
{
	wb.left = 1U;
	wb.right = 2U;
	wb.mid = x;
	return wb.left + wb.right + (unsigned int)(wb.mid != 0U);
}

static void
store_sbits_mid(x)
int32 x;
{
	swb.mid = x;
}

static int
preserve_sbits_mid(x)
int32 x;
{
	swb.left = -1;
	swb.right = 1;
	swb.mid = x;
	return swb.left + swb.right + (swb.mid < 0);
}

static void
store_word32_array(i, x)
int i;
uint32 x;
{
	wa[i] = x;
}

static uint32
load_word32_array(i)
int i;
{
	return wa[i];
}

static void
store_sword32_array(i, x)
int i;
int32 x;
{
	sa[i] = x;
}

static int32
load_sword32_array(i)
int i;
{
	return sa[i];
}

static uint32
sum_word32_array(n)
int n;
{
	int i;
	uint32 s;

	s = 0;
	for (i = 0; i < n; i++)
		s += wa[i];
	return s;
}

static int32
sum_sword32_array(n)
int n;
{
	int i;
	int32 s;

	s = 0;
	for (i = 0; i < n; i++)
		s += sa[i];
	return s;
}

static void
store_word32_pointer(p, x)
uint32 *p;
uint32 x;
{
	*p = x;
}

static uint32
load_word32_pointer(p)
uint32 *p;
{
	return *p;
}

static uint32
store_word32_pointer_ret(p, x)
uint32 *p;
uint32 x;
{
	return *p = x;
}

static void
update_word32_pointer(p, x)
uint32 *p;
uint32 x;
{
	*p = *p + x;
}

static void
store_sword32_pointer(p, x)
int32 *p;
int32 x;
{
	*p = x;
}

static int32
load_sword32_pointer(p)
int32 *p;
{
	return *p;
}

static void
store_word32_indexed(p, i, x)
uint32 *p;
int i;
uint32 x;
{
	p[i] = x;
}

static uint32
load_word32_indexed(p, i)
uint32 *p;
int i;
{
	return p[i];
}

static void
store_word32_preinc(p, x)
uint32 *p;
uint32 x;
{
	*++p = x;
}

static uint32
load_word32_postinc(p)
uint32 *p;
{
	return *p++;
}

static void
store_word32_struct_array(i, x, t)
int i;
uint32 x;
unsigned int t;
{
	wpa[i].lo = x;
	wpa[i].hi = x + 1U;
	wpa[i].tag = (uchar6)t;
}

static uint32
load_word32_struct_array(i)
int i;
{
	return wpa[i].lo + wpa[i].hi + (uint32)wpa[i].tag;
}

static void
store_word32_mix_array(i, x, t)
int i;
uint32 x;
unsigned int t;
{
	wma[i].pre = (uchar6)t;
	wma[i].mid = x;
	wma[i].post = (uchar6)(t + 1U);
}

static uint32
load_word32_mix_array(i)
int i;
{
	return wma[i].mid + (uint32)wma[i].pre + (uint32)wma[i].post;
}

static void
store_word32_nested(x, t)
uint32 x;
unsigned int t;
{
	wn.tag0 = (uchar6)t;
	wn.inner.pre = (uchar6)(t + 1U);
	wn.inner.mid = x;
	wn.inner.post = (uchar6)(t + 2U);
	wn.tail = x + 1U;
	wn.tag1 = (uchar6)(t + 3U);
}

static uint32
load_word32_nested(void)
{
	return (uint32)wn.tag0 + (uint32)wn.inner.pre + wn.inner.mid
	    + (uint32)wn.inner.post + wn.tail + (uint32)wn.tag1;
}

static void
store_word32_volatile(x)
uint32 x;
{
	vu32 = x;
	vwp.lo = x + 1U;
	vwp.hi = x + 2U;
	vwp.tag = (uchar6)3U;
	vwm.pre = (uchar6)4U;
	vwm.mid = x + 5U;
	vwm.post = (uchar6)6U;
	vwb.mid = x + 7U;
}

static uint32
load_word32_volatile(void)
{
	return vu32 + vwp.lo + vwp.hi + (uint32)vwp.tag
	    + (uint32)vwm.pre + vwm.mid + (uint32)vwm.post
	    + (uint32)vwb.mid;
}

static void
store_sword32_volatile(x)
int32 x;
{
	vs32 = x;
}

static int32
load_sword32_volatile(void)
{
	return vs32;
}

static uint32
store_word32_global_ptrs(x)
uint32 x;
{
	*glo_p = x;
	*ghi_p = x + 1U;
	*garr_p = x + 2U;
	*gtag_p = (uchar6)7U;
	return *glo_p + *ghi_p + *garr_p + (uint32)*gtag_p;
}

static int32
store_sword32_global_ptrs(x)
int32 x;
{
	*gslo_p = x;
	return *gslo_p;
}

static uint32
store_word32_stack(x)
uint32 x;
{
	struct word32_mix m;
	uint32 a[3];

	m.pre = (uchar6)1U;
	m.mid = x;
	m.post = (uchar6)2U;
	a[0] = x + 1U;
	a[1] = x + 2U;
	a[2] = x + 3U;
	return m.mid + (uint32)m.pre + (uint32)m.post
	    + a[0] + a[1] + a[2];
}

static uint32
union_word32_roundtrip(x)
uint32 x;
{
	wu.u32 = x;
	wu.s32 = (int32)wu.u32;
	return (uint32)wu.s32;
}

static int
branch_word32_zero(x)
uint32 x;
{
	wp.lo = x;
	if (wp.lo == (uint32)0)
		return 0;
	if (wp.lo == (uint32)-1)
		return -1;
	return 1;
}

uint32
use_word_insert_32(x, i)
uint32 x;
int i;
{
	uint32 r;
	int j;

	j = i & 3;
	store_word32_low(x);
	store_word32_high(x + 1U);
	store_sword32_low((int32)x);
	store_sword32_high((int32)(x + 1U));
	store_word32_mixed(x + 2U, 3U);
	store_sword32_mixed((int32)(x + 3U), -4);
	store_bits_mid(x + 4U);
	store_sbits_mid((int32)(x + 5U));
	store_word32_array(j, x + 6U);
	store_sword32_array(j, (int32)(x + 7U));
	store_word32_pointer(&wp.lo, x + 8U);
	store_sword32_pointer(&swp.lo, (int32)(x + 9U));
	store_word32_indexed(wa, j, x + 10U);
	store_word32_preinc(&wa[0], x + 11U);
	store_word32_struct_array(j, x + 12U, 5U);
	store_word32_mix_array(j, x + 13U, 6U);
	store_word32_nested(x + 14U, 7U);
	store_word32_volatile(x + 15U);
	store_sword32_volatile((int32)(x + 16U));

	r = store_word32_low_ret(x + 17U)
	    + store_word32_high_ret(x + 18U)
	    + load_word32_low()
	    + load_word32_high()
	    + (uint32)load_sword32_low()
	    + (uint32)load_sword32_high()
	    + load_word32_mixed()
	    + (uint32)load_sword32_mixed()
	    + load_bits_mid()
	    + (uint32)preserve_bits_mid(x + 19U)
	    + (uint32)preserve_sbits_mid((int32)(x + 20U))
	    + load_word32_array(j)
	    + (uint32)load_sword32_array(j)
	    + sum_word32_array(4)
	    + (uint32)sum_sword32_array(4)
	    + load_word32_pointer(&wp.hi)
	    + store_word32_pointer_ret(&wp.lo, x + 21U)
	    + load_word32_indexed(wa, j)
	    + load_word32_postinc(&wa[0])
	    + load_word32_struct_array(j)
	    + load_word32_mix_array(j)
	    + load_word32_nested()
	    + load_word32_volatile()
	    + (uint32)load_sword32_volatile()
	    + store_word32_global_ptrs(x + 22U)
	    + (uint32)store_sword32_global_ptrs((int32)(x + 23U))
	    + store_word32_stack(x + 24U)
	    + union_word32_roundtrip(x + 25U)
	    + (uint32)branch_word32_zero(x);

	copy_word32_pair(&wpa[0], &wp);
	copy_sword32_pair(&swp, &swp2);
	update_word32_pointer(&wp.lo, r);
	return r + wp.lo + wpa[0].lo;
}
