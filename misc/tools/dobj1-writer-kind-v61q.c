/* The in-memory writer must reject unsupported kinds before emitting bytes. */
#include "dobj.h"
#include <stdio.h>
#include <string.h>

int main(void)
{
    struct dobj_object o;
    struct dobj_word data;
    struct dobj_reloc r;
    struct dobj_symbol sym;
    FILE *f;
    int kind, rc, good;
    memset(&o, 0, sizeof(o));
    memset(&r, 0, sizeof(r));
    memset(&sym, 0, sizeof(sym));
    data = dobj_word_halves(0UL, 0UL);
    o.data_words = o.symbol_count = o.reloc_count = 1UL;
    o.data = &data;
    o.symbols = &sym;
    o.relocs = &r;
    strcpy(sym.name, "anchor");
    sym.kind = DOBJ_SYM_DEF;
    sym.sec = DOBJ_SEC_DATA;
    r.loc_sec = DOBJ_SEC_DATA;
    for (kind = -1; kind <= 8; ++kind) {
        f = tmpfile();
        if (f == NULL) return 1;
        r.type = kind;
        r.symbol = (kind == 2 || kind == 4) ? 1UL : 0UL;
        r.target_sec = r.symbol ? DOBJ_SEC_ABS : DOBJ_SEC_DATA;
        good = kind >= 1 && kind <= 4;
        rc = dobj_write(f, &o);
        if ((rc == 0) != good || (!good && ftell(f) != 0L)) return 2;
        if (fclose(f) != 0) return 3;
    }
    puts("PASS: writer accepted 4 defined kinds and rejected 6 invalid kinds before output");
    return 0;
}
