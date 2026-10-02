/* Reload/register-pressure regression test.

   This is a compile-only test.  Do not exact-match the generated
   assembly: the point is that reload must not ICE, create an impossible
   constraint, or generate unrecognizable RTL while keeping several
   values live across calls.

   Historical bug shape: binary-search loop, array-indexed load, several
   live loop bounds, a value live across two calls, and unsigned range
   comparisons.  The old version used uninitialized locals, which made it
   a poor semantic test.  This version has defined inputs and declared
   callees while preserving the reload pressure.
*/

struct scalar_memory_forms
{
	void **array;
	unsigned *begin;
	unsigned *range;
	unsigned *tag;
	unsigned count;
};

struct reload_slot
{
	void *object;
	unsigned begin;
	unsigned range;
	unsigned tag;
};

extern int get(void *);
extern void quux(int);
extern void sink_ptr(void *);
extern void sink_uint(unsigned);

static void *global_objects[8];
static unsigned global_begin[8] = { 0, 10, 20, 30, 40, 50, 60, 70 };
static unsigned global_range[8] = { 9, 9, 9, 9, 9, 9, 9, 9 };
static unsigned global_tag[8] = { 1, 3, 5, 7, 11, 13, 17, 19 };
static struct scalar_memory_forms global_vec = {
	global_objects,
	global_begin,
	global_range,
	global_tag,
	8
};
static volatile unsigned reload_noise;

static unsigned
safe_count(vec)
struct scalar_memory_forms *vec;
{
	if (vec->count == 0)
		return 1;
	return vec->count;
}

static void *
search_object(vec, pc)
struct scalar_memory_forms *vec;
unsigned pc;
{
	unsigned lo, hi;

	lo = 0;
	hi = vec->count;
	while (lo < hi) {
		unsigned i;
		void *f;
		unsigned pc_begin;
		unsigned pc_range;
		unsigned pc_end;
		unsigned tag;
		int x;

		i = (lo + hi) / 2;
		f = vec->array[i];
		pc_begin = vec->begin[i];
		pc_range = vec->range[i];
		tag = vec->tag[i];
		pc_end = pc_begin + pc_range;

		/* Keep X, F, bounds, and TAG live across multiple calls. */
		x = get(f);
		quux(x);
		sink_uint(tag);
		quux(x + (int)(tag & 7));

		if (pc < pc_begin)
			hi = i;
		else if (pc >= pc_end)
			lo = i + 1;
		else
			return f;
	}

	return 0;
}

static int
search_index(vec, pc)
struct scalar_memory_forms *vec;
unsigned pc;
{
	unsigned lo;
	unsigned hi;
	int result;

	lo = 0;
	hi = vec->count;
	result = -1;
	while (lo < hi) {
		unsigned i;
		unsigned begin;
		unsigned range;
		unsigned tag;
		void *obj;
		int v;

		i = (lo + hi) / 2;
		begin = vec->begin[i];
		range = vec->range[i];
		tag = vec->tag[i];
		obj = vec->array[i];

		v = get(obj);
		quux(v);
		quux(v ^ (int)tag);

		if (pc - begin < range) {
			result = (int)i;
			break;
		}
		if (pc < begin)
			hi = i;
		else
			lo = i + 1;
	}
	return result;
}

static void *
search_object_with_bias(vec, pc, bias)
struct scalar_memory_forms *vec;
unsigned pc;
unsigned bias;
{
	unsigned lo;
	unsigned hi;
	unsigned saved_count;

	lo = 0;
	hi = vec->count;
	saved_count = safe_count(vec);
	while (lo < hi) {
		unsigned i;
		unsigned j;
		unsigned begin;
		unsigned range;
		unsigned end;
		unsigned tag;
		void *f;
		void *g;
		int x;
		int y;

		i = (lo + hi) / 2;
		j = i + 1;
		if (j >= saved_count)
			j = i;

		f = vec->array[i];
		g = vec->array[j];
		begin = vec->begin[i] + bias;
		range = vec->range[i];
		end = begin + range;
		tag = vec->tag[j];

		x = get(f);
		y = get(g);
		quux(x + y);
		sink_ptr(f);
		quux((x - y) + (int)(tag & 017));

		if (pc < begin)
			hi = i;
		else if (pc >= end)
			lo = i + 1;
		else
			return f;
	}
	return 0;
}

static unsigned
sum_ranges(vec, pc)
struct scalar_memory_forms *vec;
unsigned pc;
{
	unsigned i;
	unsigned sum;
	unsigned count;

	sum = 0;
	count = vec->count;
	for (i = 0; i < count; i++) {
		unsigned begin;
		unsigned range;
		unsigned tag;
		void *obj;
		int v;

		begin = vec->begin[i];
		range = vec->range[i];
		tag = vec->tag[i];
		obj = vec->array[i];
		v = get(obj);
		quux(v);

		if (pc >= begin && pc < begin + range)
			sum += tag + (unsigned)v;
		else
			sum += tag ^ range;
	}
	return sum;
}

static void *
search_slot(slots, count, pc)
struct reload_slot *slots;
unsigned count;
unsigned pc;
{
	unsigned lo;
	unsigned hi;

	lo = 0;
	hi = count;
	while (lo < hi) {
		unsigned i;
		unsigned begin;
		unsigned range;
		unsigned tag;
		void *obj;
		int v;

		i = (lo + hi) / 2;
		obj = slots[i].object;
		begin = slots[i].begin;
		range = slots[i].range;
		tag = slots[i].tag;

		v = get(obj);
		quux(v);
		sink_uint(tag + range);
		quux(v + (int)(pc - begin));

		if (pc < begin)
			hi = i;
		else if (pc >= begin + range)
			lo = i + 1;
		else
			return obj;
	}
	return 0;
}

void *
use_reload_bug(vec, slots, pc)
struct scalar_memory_forms *vec;
struct reload_slot *slots;
unsigned pc;
{
	void *a;
	void *b;
	void *c;
	int idx;
	unsigned s;

	a = search_object(vec, pc);
	b = search_object_with_bias(vec, pc + reload_noise, reload_noise & 3);
	idx = search_index(vec, pc);
	s = sum_ranges(vec, pc);
	c = search_slot(slots, vec->count, pc + (s & 1));

	sink_uint(s + (unsigned)idx);
	if (a != 0)
		return a;
	if (b != 0)
		return b;
	return c;
}


void *
urbg(pc)
unsigned pc;
{
	struct reload_slot slots[4];

	slots[0].object = global_vec.array[0];
	slots[0].begin = global_vec.begin[0];
	slots[0].range = global_vec.range[0];
	slots[0].tag = global_vec.tag[0];
	slots[1].object = global_vec.array[1];
	slots[1].begin = global_vec.begin[1];
	slots[1].range = global_vec.range[1];
	slots[1].tag = global_vec.tag[1];
	slots[2].object = global_vec.array[2];
	slots[2].begin = global_vec.begin[2];
	slots[2].range = global_vec.range[2];
	slots[2].tag = global_vec.tag[2];
	slots[3].object = global_vec.array[3];
	slots[3].begin = global_vec.begin[3];
	slots[3].range = global_vec.range[3];
	slots[3].tag = global_vec.tag[3];

	return use_reload_bug(&global_vec, slots, pc);
}
