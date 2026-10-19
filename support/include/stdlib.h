#ifndef PDP10_TESTKIT_STDLIB_V1_H
#define PDP10_TESTKIT_STDLIB_V1_H

/* Freestanding test declarations, not a hosted libc implementation.
 * exit and abort are supplied by the testkit termination runtime.
 * Other routines require real target implementations to link; never
 * silently satisfy a semantic test with an empty or dummy function.
 * size_t is always taken from the selected compiler's target header.
 */
#include <stddef.h>

#define EXIT_SUCCESS 0
#define EXIT_FAILURE 1

void abort(void);
void exit(int status);

int abs(int value);
int atoi(const char *text);
void *malloc(size_t size);
void *calloc(size_t count, size_t size);
void *realloc(void *ptr, size_t size);
void free(void *ptr);
int remove(const char *path);
void qsort(void *base, size_t count, size_t width,
           int (*compare)(const void *, const void *));

#endif
