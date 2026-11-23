/* Optimized GCC must compare logical 9-bit STRING_CST characters,
   not their two-byte host representation.  The unresolved link_error
   is deliberate: every condition is fully constant and must fold.  */

typedef __SIZE_TYPE__ size_t;
extern int memcmp(const void *, const void *, size_t);
extern void link_error(void);

int
main(void)
{
    if (memcmp("\400", "\377", 1) <= 0) link_error();
    if (memcmp("\377", "\400", 1) >= 0) link_error();
    if (memcmp("\777", "\400", 1) <= 0) link_error();
    if (memcmp("\377", "\377", 1) != 0) link_error();
    if (memcmp("\0\777", "\0\400", 2) <= 0) link_error();
    if (__builtin_memcmp("\0\377", "\0\400", 2) >= 0)
        link_error();
    if (memcmp("\377\400", "\377\401", 2) >= 0) link_error();
    return 0;
}
