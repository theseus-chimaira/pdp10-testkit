#ifndef DAIMOS_RAW72_H
#define DAIMOS_RAW72_H

/* Flat raw 72-bit value.  Each member is one 36-bit PDP-10 word. */
typedef struct raw72 {
	unsigned long hi;
	unsigned long lo;
} raw72_t;

typedef raw72_t uraw72_t;

raw72_t raw72_make(unsigned long, unsigned long);
raw72_t raw72_add(raw72_t, raw72_t);
raw72_t raw72_sub(raw72_t, raw72_t);
raw72_t raw72_neg(raw72_t);
raw72_t raw72_and(raw72_t, raw72_t);
raw72_t raw72_or(raw72_t, raw72_t);
raw72_t raw72_xor(raw72_t, raw72_t);
raw72_t raw72_not(raw72_t);
raw72_t raw72_shl(raw72_t, unsigned int);
raw72_t raw72_shr(raw72_t, unsigned int);
int raw72_ucmp(raw72_t, raw72_t);
int raw72_scmp(raw72_t, raw72_t);


/* Complete modulo-2^72 arithmetic and checked division. */
raw72_t raw72_mul(raw72_t, raw72_t);
int raw72_udivmod(raw72_t, raw72_t, raw72_t *, raw72_t *);
int raw72_sdivmod(raw72_t, raw72_t, raw72_t *, raw72_t *);

/* Explicit representation adapters. */
typedef struct int71_words {
	unsigned long hi;
	unsigned long lo;
} int71_words_t;

raw72_t raw72_from_int71_words(int71_words_t);
int raw72_to_int71_words(raw72_t, int71_words_t *);

#endif
