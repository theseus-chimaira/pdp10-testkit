#include "insns.h"


/*
 * Scalar memory form coverage.
 *
 * This is the small-scalar companion to scalar-memory-forms.c.  Keep it
 * centered on ordinary scalar objects: static storage, stack storage,
 * address taking, volatile scalar memory, simple arrays, and promotion on
 * load/store.  Byte-pointer arithmetic is tested elsewhere.
 */

typedef signed char schar;
typedef unsigned char uchar;

extern void scalar_memory_forms();
extern void use_int();
extern void use_uint();

#define DECL_COMMON(T) \
static T scalar_##T; \
static volatile T vscalar_##T; \
static T array_##T[8]; \
static volatile T varray_##T[4]; \
static struct box_##T { T a; T b; } box_##T; \
static volatile struct vbox_##T { T a; T b; } vbox_##T; \
static T *ptr_scalar_##T = &scalar_##T; \
static T *ptr_array_##T = &array_##T[3]

#define TEST_COMMON(T) \
DECL_COMMON(T); \
static T ld_static_##T(void) \
{ \
	return scalar_##T; \
} \
static void st_static_##T(x) \
T x; \
{ \
	scalar_##T = x; \
} \
static T st_ret_static_##T(x) \
T x; \
{ \
	scalar_##T = x; \
	return scalar_##T; \
} \
static T ld_volatile_##T(void) \
{ \
	return vscalar_##T; \
} \
static void st_volatile_##T(x) \
T x; \
{ \
	vscalar_##T = x; \
} \
static T ld_struct_##T(void) \
{ \
	return box_##T.a; \
} \
static void st_struct_##T(x) \
T x; \
{ \
	box_##T.a = x; \
	box_##T.b = (T)(x + (T)1); \
} \
static T ld_vstruct_##T(void) \
{ \
	return vbox_##T.a; \
} \
static void st_vstruct_##T(x) \
T x; \
{ \
	vbox_##T.a = x; \
	vbox_##T.b = (T)(x + (T)1); \
} \
static T ld_array_##T(i) \
int i; \
{ \
	return array_##T[i]; \
} \
static void st_array_##T(i, x) \
int i; \
T x; \
{ \
	array_##T[i] = x; \
} \
static T st_ret_array_##T(i, x) \
int i; \
T x; \
{ \
	array_##T[i] = x; \
	return array_##T[i]; \
} \
static T ld_varray_##T(i) \
int i; \
{ \
	return varray_##T[i]; \
} \
static void st_varray_##T(i, x) \
int i; \
T x; \
{ \
	varray_##T[i] = x; \
} \
static T ld_pointer_##T(p) \
T *p; \
{ \
	return *p; \
} \
static void st_pointer_##T(p, x) \
T *p; \
T x; \
{ \
	*p = x; \
} \
static T st_ret_pointer_##T(p, x) \
T *p; \
T x; \
{ \
	*p = x; \
	return *p; \
} \
static T ld_global_pointer_##T(void) \
{ \
	return *ptr_scalar_##T + *ptr_array_##T; \
} \
static void ptr_static_##T(void) \
{ \
	scalar_memory_forms(&scalar_##T); \
	scalar_memory_forms(&array_##T[3]); \
	scalar_memory_forms(&box_##T.a); \
} \
static T ld_stack_##T(x) \
T x; \
{ \
	volatile T y; \
	y = x; \
	return y; \
} \
static T st_stack_##T(x) \
T x; \
{ \
	volatile T y; \
	y = x; \
	return y; \
} \
static void ptr_stack_##T(x) \
T x; \
{ \
	T y; \
	T a[3]; \
	y = x; \
	a[0] = x; \
	a[1] = (T)(x + (T)1); \
	a[2] = (T)(x + (T)2); \
	scalar_memory_forms(&y); \
	scalar_memory_forms(&a[1]); \
} \
static T update_static_##T(x) \
T x; \
{ \
	scalar_##T = (T)(scalar_##T + x); \
	return scalar_##T; \
} \
static T update_pointer_##T(p, x) \
T *p; \
T x; \
{ \
	*p = (T)(*p + x); \
	return *p; \
} \
static int sum_array_##T(n) \
int n; \
{ \
	int i; \
	int sum; \
	sum = 0; \
	for (i = 0; i < n; i++) \
		sum += (int)array_##T[i]; \
	return sum; \
} \
static int call_with_scalar_##T(x) \
T x; \
{ \
	T y; \
	y = x; \
	use_int((int)y); \
	return (int)y; \
} \
static int use_scalar_##T(x, i) \
T x; \
int i; \
{ \
	T local; \
	T *p; \
	local = x; \
	p = &array_##T[i & 7]; \
	st_static_##T(local); \
	st_volatile_##T((T)(local + (T)1)); \
	st_struct_##T((T)(local + (T)2)); \
	st_vstruct_##T((T)(local + (T)3)); \
	st_array_##T(i & 7, (T)(local + (T)4)); \
	st_varray_##T(i & 3, (T)(local + (T)5)); \
	st_pointer_##T(p, (T)(local + (T)6)); \
	ptr_static_##T(); \
	ptr_stack_##T(local); \
	return (int)ld_static_##T() \
	    + (int)st_ret_static_##T(local) \
	    + (int)ld_volatile_##T() \
	    + (int)ld_struct_##T() \
	    + (int)ld_vstruct_##T() \
	    + (int)ld_array_##T(i & 7) \
	    + (int)st_ret_array_##T((i + 1) & 7, local) \
	    + (int)ld_varray_##T(i & 3) \
	    + (int)ld_pointer_##T(p) \
	    + (int)st_ret_pointer_##T(p, local) \
	    + (int)ld_global_pointer_##T() \
	    + (int)ld_stack_##T(local) \
	    + (int)st_stack_##T(local) \
	    + (int)update_static_##T(local) \
	    + (int)update_pointer_##T(p, local) \
	    + sum_array_##T(4) \
	    + call_with_scalar_##T(local); \
}

#define TEST_SIGNED(T) \
TEST_COMMON(T) \
static int sign_branch_##T(x) \
T x; \
{ \
	if (x < (T)0) \
		return -1; \
	if (x == (T)0) \
		return 0; \
	return 1; \
} \
static int sign_load_static_##T(void) \
{ \
	return scalar_##T < (T)0; \
}

#define TEST_UNSIGNED(T) \
TEST_COMMON(T) \
static unsigned int zero_load_##T(p) \
T *p; \
{ \
	return (unsigned int)*p; \
} \
static int unsigned_branch_##T(x) \
T x; \
{ \
	if (x == (T)0) \
		return 0; \
	if ((unsigned int)x > (unsigned int)0177) \
		return 2; \
	return 1; \
}

TEST_SIGNED(schar)
TEST_UNSIGNED(uchar)
TEST_SIGNED(sQint)
TEST_UNSIGNED(uQint)
TEST_SIGNED(Hint)
TEST_UNSIGNED(uHint)
TEST_SIGNED(char6)
TEST_UNSIGNED(uchar6)
TEST_SIGNED(char7)
TEST_UNSIGNED(uchar7)
TEST_SIGNED(char8)
TEST_UNSIGNED(uchar8)
TEST_SIGNED(char9)
TEST_UNSIGNED(uchar9)
TEST_SIGNED(short16)
TEST_UNSIGNED(ushort16)
TEST_SIGNED(short18)
TEST_UNSIGNED(ushort18)
TEST_SIGNED(int32)
TEST_UNSIGNED(uint32)

int
use_scalars(seed, i)
int seed;
int i;
{
	return use_scalar_schar((schar)seed, i)
	    + use_scalar_uchar((uchar)seed, i)
	    + use_scalar_sQint((sQint)seed, i)
	    + use_scalar_uQint((uQint)seed, i)
	    + use_scalar_Hint((Hint)seed, i)
	    + use_scalar_uHint((uHint)seed, i)
	    + use_scalar_char6((char6)seed, i)
	    + use_scalar_uchar6((uchar6)seed, i)
	    + use_scalar_char7((char7)seed, i)
	    + use_scalar_uchar7((uchar7)seed, i)
	    + use_scalar_char8((char8)seed, i)
	    + use_scalar_uchar8((uchar8)seed, i)
	    + use_scalar_char9((char9)seed, i)
	    + use_scalar_uchar9((uchar9)seed, i)
	    + use_scalar_short16((short16)seed, i)
	    + use_scalar_ushort16((ushort16)seed, i)
	    + use_scalar_short18((short18)seed, i)
	    + use_scalar_ushort18((ushort18)seed, i)
	    + use_scalar_int32((int32)seed, i)
	    + use_scalar_uint32((uint32)seed, i);
}

int
uscbra(seed)
int seed;
{
	return sign_branch_schar((schar)seed)
	    + unsigned_branch_uchar((uchar)seed)
	    + sign_branch_sQint((sQint)seed)
	    + unsigned_branch_uQint((uQint)seed)
	    + sign_branch_Hint((Hint)seed)
	    + unsigned_branch_uHint((uHint)seed)
	    + sign_branch_char6((char6)seed)
	    + unsigned_branch_uchar6((uchar6)seed)
	    + sign_branch_char7((char7)seed)
	    + unsigned_branch_uchar7((uchar7)seed)
	    + sign_branch_char8((char8)seed)
	    + unsigned_branch_uchar8((uchar8)seed)
	    + sign_branch_char9((char9)seed)
	    + unsigned_branch_uchar9((uchar9)seed)
	    + sign_branch_short16((short16)seed)
	    + unsigned_branch_ushort16((ushort16)seed)
	    + sign_branch_short18((short18)seed)
	    + unsigned_branch_ushort18((ushort18)seed)
	    + sign_branch_int32((int32)seed)
	    + unsigned_branch_uint32((uint32)seed)
	    + sign_load_static_schar()
	    + sign_load_static_sQint()
	    + sign_load_static_Hint()
	    + sign_load_static_char6()
	    + sign_load_static_char7()
	    + sign_load_static_char8()
	    + sign_load_static_char9()
	    + sign_load_static_short16()
	    + sign_load_static_short18()
	    + sign_load_static_int32()
	    + (int)zero_load_uchar(&scalar_uchar)
	    + (int)zero_load_uQint(&scalar_uQint)
	    + (int)zero_load_uHint(&scalar_uHint)
	    + (int)zero_load_uchar6(&scalar_uchar6)
	    + (int)zero_load_uchar7(&scalar_uchar7)
	    + (int)zero_load_uchar8(&scalar_uchar8)
	    + (int)zero_load_uchar9(&scalar_uchar9)
	    + (int)zero_load_ushort16(&scalar_ushort16)
	    + (int)zero_load_ushort18(&scalar_ushort18)
	    + (int)zero_load_uint32(&scalar_uint32);
}
