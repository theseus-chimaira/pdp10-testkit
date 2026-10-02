#include "raw72.h"

#define WORD_BITS 36
#define SIGN36 ((unsigned long)1 << 35)

raw72_t
raw72_make(unsigned long hi, unsigned long lo)
{
	raw72_t r;
	r.hi = hi;
	r.lo = lo;
	return r;
}

raw72_t
raw72_add(raw72_t a, raw72_t b)
{
	raw72_t r;
	unsigned long lo;
	lo = a.lo + b.lo;
	r.lo = lo;
	r.hi = a.hi + b.hi + (lo < a.lo);
	return r;
}

raw72_t
raw72_not(raw72_t a)
{
	return raw72_make(~a.hi, ~a.lo);
}

raw72_t
raw72_neg(raw72_t a)
{
	return raw72_add(raw72_not(a), raw72_make(0, 1));
}

raw72_t
raw72_sub(raw72_t a, raw72_t b)
{
	return raw72_add(a, raw72_neg(b));
}

raw72_t
raw72_and(raw72_t a, raw72_t b)
{
	return raw72_make(a.hi & b.hi, a.lo & b.lo);
}

raw72_t
raw72_or(raw72_t a, raw72_t b)
{
	return raw72_make(a.hi | b.hi, a.lo | b.lo);
}

raw72_t
raw72_xor(raw72_t a, raw72_t b)
{
	return raw72_make(a.hi ^ b.hi, a.lo ^ b.lo);
}

raw72_t
raw72_shl(raw72_t a, unsigned int n)
{
	if (n >= 72)
		return raw72_make(0, 0);
	if (n == 0)
		return a;
	if (n >= WORD_BITS)
		return raw72_make(a.lo << (n - WORD_BITS), 0);
	return raw72_make((a.hi << n) | (a.lo >> (WORD_BITS - n)),
	    a.lo << n);
}

raw72_t
raw72_shr(raw72_t a, unsigned int n)
{
	if (n >= 72)
		return raw72_make(0, 0);
	if (n == 0)
		return a;
	if (n >= WORD_BITS)
		return raw72_make(0, a.hi >> (n - WORD_BITS));
	return raw72_make(a.hi >> n,
	    (a.lo >> n) | (a.hi << (WORD_BITS - n)));
}

int
raw72_ucmp(raw72_t a, raw72_t b)
{
	if (a.hi != b.hi)
		return a.hi < b.hi ? -1 : 1;
	if (a.lo != b.lo)
		return a.lo < b.lo ? -1 : 1;
	return 0;
}

int
raw72_scmp(raw72_t a, raw72_t b)
{
	int aneg;
	int bneg;
	aneg = (a.hi & SIGN36) != 0;
	bneg = (b.hi & SIGN36) != 0;
	if (aneg != bneg)
		return aneg ? -1 : 1;
	return raw72_ucmp(a, b);
}

#define LOW35 (SIGN36 - 1)

static int
raw72_is_zero(raw72_t a)
{
	return a.hi == 0 && a.lo == 0;
}

static int
raw72_is_negative(raw72_t a)
{
	return (a.hi & SIGN36) != 0;
}

static unsigned int
raw72_bit(raw72_t a, unsigned int n)
{
	if (n < WORD_BITS)
		return (unsigned int)((a.lo >> n) & 1);
	return (unsigned int)((a.hi >> (n - WORD_BITS)) & 1);
}

static raw72_t
raw72_set_bit(raw72_t a, unsigned int n)
{
	if (n < WORD_BITS)
		a.lo |= (unsigned long)1 << n;
	else
		a.hi |= (unsigned long)1 << (n - WORD_BITS);
	return a;
}

raw72_t
raw72_mul(raw72_t a, raw72_t b)
{
	raw72_t r;
	unsigned int n;
	r = raw72_make(0, 0);
	for (n = 0; n < 72; ++n) {
		if (raw72_bit(b, n))
			r = raw72_add(r, a);
		a = raw72_shl(a, 1);
	}
	return r;
}

int
raw72_udivmod(raw72_t dividend, raw72_t divisor, raw72_t *quotient,
    raw72_t *remainder)
{
	raw72_t q;
	raw72_t r;
	int n;
	if (raw72_is_zero(divisor))
		return -1;
	q = raw72_make(0, 0);
	r = raw72_make(0, 0);
	for (n = 71; n >= 0; --n) {
		r = raw72_shl(r, 1);
		if (raw72_bit(dividend, (unsigned int)n))
			r.lo |= 1;
		if (raw72_ucmp(r, divisor) >= 0) {
			r = raw72_sub(r, divisor);
			q = raw72_set_bit(q, (unsigned int)n);
		}
	}
	if (quotient != 0)
		*quotient = q;
	if (remainder != 0)
		*remainder = r;
	return 0;
}

int
raw72_sdivmod(raw72_t dividend, raw72_t divisor, raw72_t *quotient,
    raw72_t *remainder)
{
	raw72_t a;
	raw72_t b;
	raw72_t q;
	raw72_t r;
	int aneg;
	int bneg;
	int status;
	if (raw72_is_zero(divisor))
		return -1;
	aneg = raw72_is_negative(dividend);
	bneg = raw72_is_negative(divisor);
	a = aneg ? raw72_neg(dividend) : dividend;
	b = bneg ? raw72_neg(divisor) : divisor;
	status = raw72_udivmod(a, b, &q, &r);
	if (status != 0)
		return status;
	if (aneg != bneg)
		q = raw72_neg(q);
	if (aneg)
		r = raw72_neg(r);
	if (quotient != 0)
		*quotient = q;
	if (remainder != 0)
		*remainder = r;
	return 0;
}

raw72_t
raw72_from_int71_words(int71_words_t a)
{
	unsigned long hi;
	unsigned long lo;
	hi = (a.hi >> 1) | (a.hi & SIGN36);
	lo = ((a.hi & 1) << 35) | (a.lo & LOW35);
	return raw72_make(hi, lo);
}

int
raw72_to_int71_words(raw72_t a, int71_words_t *result)
{
	int71_words_t r;
	unsigned long sign;
	if (((a.hi >> 34) & 3) != 0 && ((a.hi >> 34) & 3) != 3)
		return -1;
	sign = a.hi & SIGN36;
	r.hi = (a.hi << 1) | (a.lo >> 35);
	r.lo = sign | (a.lo & LOW35);
	if (result != 0)
		*result = r;
	return 0;
}
