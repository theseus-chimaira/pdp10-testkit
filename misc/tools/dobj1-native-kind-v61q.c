/* Exercise the real native object reader with a deterministic word file.
 * File operations are supplied here instead of requiring a running DAIMOS
 * kernel. The parser and all 36-bit operations execute on the target CPU. */
#include "dobj_native.h"

#define BASE 3U
#define RELOC (BASE + 12U)
#define FILE_WORDS (RELOC + 6U)
static kword_t file_words[FILE_WORDS];
static unsigned int file_size, cursor, partial;
volatile int __test_exit;

kword_t dsys_seek(int fd, kword_t offset, unsigned int whence)
{
    if (fd != 1 || whence != SYS_SEEK_SET || offset > file_size)
        return (kword_t)-1;
    cursor = (unsigned int)offset;
    return offset;
}

int dsys_read_words(int fd, kword_t *b, unsigned int n)
{
    unsigned int i;
    if (fd != 1 || cursor > file_size) return -1;
    if (n > file_size-cursor) n = file_size-cursor;
    if (partial && n > 1U) n = 1U;
    for (i=0U; i<n; ++i) b[i]=file_words[cursor++];
    return (int)n;
}

int u_write_words_all(int fd, const kword_t *w, unsigned int n)
{ (void)fd; (void)w; (void)n; return -1; }
int u_putc(int fd, int ch)
{ (void)fd; (void)ch; return -1; }
int u_put_uint(int fd, kword_t v)
{ (void)fd; (void)v; return -1; }
int u_put_octal(int fd, kword_t v, unsigned int digits)
{ (void)fd; (void)v; (void)digits; return -1; }

static void record(unsigned int pos, unsigned int section, unsigned int kind)
{
    unsigned int symbolic = kind == ND_RELOC_SYMBOL_RH18 ||
        kind == ND_RELOC_SYMBOL_LH18;
    file_words[pos] = nd_halves((section<<15)|(kind<<12)|
        ((symbolic ? ND_SEC_ABS : ND_SEC_TEXT)<<9),(pos-RELOC)/3U);
    file_words[pos+1U] = symbolic ? 1UL : 0UL;
    file_words[pos+2U] = 0UL;
}

int main(void)
{
    struct nd_obj o;
    struct nd_reloc r;
    unsigned int k, section, site, pos, ok;
    /* A member at nonzero file offset with two stored sections, a
     * defined symbol and two distinct relocation sites. */
    file_size=FILE_WORDS;
    file_words[BASE]=nd_magic("DOBJ1 ");
    file_words[BASE+1U]=nd_halves(2UL,2UL);
    file_words[BASE+2U]=nd_halves(0UL,1UL);
    file_words[BASE+3U]=nd_halves(2UL,0UL);
    file_words[BASE+4U]=0UL;
    file_words[BASE+9U]=nd_halves((ND_SYM_DEF<<15)|(ND_SEC_TEXT<<12)|1U,0UL);
    file_words[BASE+10U]=0UL;
    file_words[BASE+11U]=(kword_t)'a'<<27;
    for (partial=0U; partial<2U; ++partial) {
        for (section=ND_SEC_TEXT; section<=ND_SEC_DATA; ++section) {
            for (site=0U; site<2U; ++site) {
                pos=RELOC+3U*site;
                for (k=0U; k<8U; ++k) {
                    record(RELOC,ND_SEC_TEXT,ND_RELOC_LOCAL_RH18);
                    record(RELOC+3U,ND_SEC_DATA,ND_RELOC_LOCAL_LH18);
                    record(pos,section,k);
                    ok=(k>=ND_RELOC_LOCAL_RH18 && k<=ND_RELOC_SYMBOL_LH18);
                    if ((nd_obj_parse(1,BASE,&o)==0)!=ok) return 1;
                    if ((nd_obj_reloc(1,&o,site,&r)==0)!=ok) return 2;
                    if (ok && (r.type!=k || r.loc_sec!=section ||
                        o.object_words!=FILE_WORDS-BASE)) return 3;
                }
            }
        }
        record(RELOC,ND_SEC_TEXT,ND_RELOC_LOCAL_RH18);
        record(RELOC+3U,ND_SEC_DATA,ND_RELOC_LOCAL_LH18);
        file_size=FILE_WORDS-1U;
        if (nd_obj_parse(1,BASE,&o)==0) return 4;
        file_size=FILE_WORDS;
        if (nd_obj_parse(1,BASE,&o)!=0) return 5;
    }
    return 0;
}
