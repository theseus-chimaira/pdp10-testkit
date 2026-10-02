#include "insns.h"

typedef struct wide_pair {
	int71_t a;
	int71_t b;
} wide_pair_t;

typedef struct mixed_wide {
	int a;
	int71_t b;
	int c;
} mixed_wide_t;

typedef struct raw_pair {
	raw72_t a;
	raw72_t b;
} raw_pair_t;

int layout_word(void) { return sizeof(int); }
int layout_int71(void) { return sizeof(int71_t); }
int layout_raw72(void) { return sizeof(raw72_t); }
int layout_wide_pair(void) { return sizeof(wide_pair_t); }
int layout_mixed_wide(void) { return sizeof(mixed_wide_t); }
int layout_raw_pair(void) { return sizeof(raw_pair_t); }
