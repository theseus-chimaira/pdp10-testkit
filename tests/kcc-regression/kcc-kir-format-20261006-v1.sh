#!/bin/sh
set -eu

: "${TMPDIR:?TMPDIR must be set}"
: "${KCC_SOURCE:?KCC_SOURCE must point to the KCC tree}"
HOSTCC=${HOSTCC:-cc}
work="$TMPDIR/kcc-kir-format-20261006-v1-$$"
trap 'rm -rf "$work"' EXIT HUP INT TERM
mkdir -p "$work"

cat > "$work/test.c" <<'EOF'
#include "cckir.h"
#include "ccvla.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

SYMBOL *symbol;
void int_error(char *fmt, ...) { (void)fmt; }
SYMBOL *curfn;
SYMBOL *Reg_Id[R_MAXREG - R_MAX_NOPRESERVE];
int _reg_count;
INT maxauto;
int stackrefs, stkgoto;
char fn_main, fnabidirect, fnargkeepmask, fnargdropmask, fnargpredropmask;
static int test_labmax;
int labmax(void) { return test_labmax; }
void labset(int n) { test_labmax = n; }
void labrename(SYMBOL *s, unsigned int n)
{
    char tmp[IDENTSIZE]; int p = IDENTSIZE - 1;
    tmp[p] = '\0';
    do { tmp[--p] = (char)('0' + n % 10U); n /= 10U; } while (n && p > 1);
    tmp[--p] = '$'; strcpy(s->Sname, tmp + p);
}

static int graph_roundtrip(void)
{
    FILE *fp = tmpfile();
    TYPE base, shared, vla1, vla2, stag;
    SYMBOL sa, sb, tag, member;
    NODE root, a, b, a2, c, d, wi, str, flt;
    NODE *out = NULL;
    int kind = 0;

    if (!fp) return 101;
    memset(&base, 0, sizeof(base)); memset(&shared, 0, sizeof(shared));
    memset(&vla1, 0, sizeof(vla1)); memset(&vla2, 0, sizeof(vla2));
    memset(&stag, 0, sizeof(stag)); memset(&sa, 0, sizeof(sa));
    memset(&sb, 0, sizeof(sb)); memset(&tag, 0, sizeof(tag));
    memset(&member, 0, sizeof(member)); memset(&root, 0, sizeof(root));
    memset(&a, 0, sizeof(a)); memset(&b, 0, sizeof(b));
    memset(&a2, 0, sizeof(a2)); memset(&c, 0, sizeof(c)); memset(&d, 0, sizeof(d));
    memset(&wi, 0, sizeof(wi)); memset(&str, 0, sizeof(str));
    memset(&flt, 0, sizeof(flt));

    base.Tspec = TS_INT; base.Tsize = 1; base.Tflag = 36;
    shared.Tspec = TS_PTR; shared.Tsize = 1; shared.Tsubt = &base;
    vla1.Tspec = TS_ARRAY; vla1.Tflag = TF_VLA; vla1.Tsubt = &base;
    vla2 = vla1;
    stag.Tspec = TS_STRUCT; stag.Tsize = 1; stag.Tsmtag = &tag;

    strcpy(sa.Sname, "same"); strcpy(sb.Sname, "same");
    sa.Sclass = sb.Sclass = SC_AUTO; sa.Sflags = sb.Sflags = SF_LOCAL;
    sa.Stype = sb.Stype = &shared;
    tag.Sclass = SC_TAG; strcpy(tag.Sname, "^T"); tag.Stype = &stag;
    member.Sclass = SC_MEMBER; strcpy(member.Sname, "+m");
    member.Stype = &base; member.Ssmtag = &tag; tag.Ssmnext = &member;

    root.Nop = N_EXPRLIST; root.Ntype = &base; root.Nleft = &a; root.Nright = &b;
    a.Nop = Q_IDENT; a.Ntype = &vla1; a.Nid = &sa;
    b.Nop = N_EXPRLIST; b.Ntype = &base; b.Nleft = &a2; b.Nright = &c;
    a2.Nop = Q_IDENT; a2.Ntype = &vla2; a2.Nid = &sb;
    c.Nop = N_EXPRLIST; c.Ntype = &base; c.Nleft = &wi; c.Nright = &d;
    d.Nop = N_EXPRLIST; d.Ntype = &base; d.Nleft = &str; d.Nright = &flt;
    wi.Nop = N_ICONST; wi.Ntype = &base; wi.Nflag = NF_WIDE;
    wi.Niconst = 0123456701234L; wi.n_var1.n_int = 0765432107654L;
    str.Nop = N_SCONST; str.Ntype = &shared; str.Nsconst = "A\0B"; str.Nsclen = 4;
    flt.Nop = N_FCONST; flt.Ntype = &base; flt.Nfconst = 3.25;
    if (kir_write_header(fp) != 0 || kir_write_extdef(fp, &root) != 0) return 102;
    rewind(fp);
    if (kir_read_header(fp) != 0) return 103;
    if (kir_read_next(fp, &kind, &out) != 0) return 104;
    if (kind != KIR_REC_EXTDEF || out == NULL) return 105;
    if (out->Nleft->Nid == out->Nright->Nleft->Nid) return 106;
    if (out->Nleft->Ntype == out->Nright->Nleft->Ntype) return 107;
    if (out->Nleft->Ntype->Tsubt != out->Nright->Nleft->Ntype->Tsubt) return 108;
    if (!(out->Nright->Nright->Nleft->Nflag & NF_WIDE)) return 109;
    if (out->Nright->Nright->Nleft->n_var1.n_int != 0765432107654L) {
        fprintf(stderr, "wide high got %lo expected %lo\n",
            (unsigned long)out->Nright->Nright->Nleft->n_var1.n_int,
            (unsigned long)0765432107654L);
        return 110;
    }
    if (out->Nright->Nright->Nright->Nleft->Nsclen != 4) return 111;
    if (memcmp(out->Nright->Nright->Nright->Nleft->Nsconst, "A\0B", 4) != 0) return 112;
    if (out->Nright->Nright->Nright->Nright->Nfconst != 3.25) return 113;
    fclose(fp);
    kir_free_graph(out);
    return 0;
}

static int module_identity_roundtrip(void)
{
    FILE *fp = tmpfile();
    TYPE base, ptr;
    SYMBOL head, glob;
    NODE r1, r2, i1, i2;
    NODE *out1 = NULL, *out2 = NULL;
    SYMBOL *saved_sym;
    TYPE *saved_type;
    int kind;

    if (!fp) return 201;
    memset(&base, 0, sizeof(base)); memset(&ptr, 0, sizeof(ptr));
    memset(&head, 0, sizeof(head)); memset(&glob, 0, sizeof(glob));
    memset(&r1, 0, sizeof(r1)); memset(&r2, 0, sizeof(r2));
    memset(&i1, 0, sizeof(i1)); memset(&i2, 0, sizeof(i2));
    base.Tspec = TS_INT; base.Tsize = 1;
    ptr.Tspec = TS_PTR; ptr.Tsize = 1; ptr.Tsubt = &base;
    strcpy(glob.Sname, "global"); glob.Sclass = SC_EXTREF;
    glob.Stype = &ptr; glob.Srefs = 1; head.Snext = &glob; glob.Sprev = &head;
    i1.Nop = Q_IDENT; i1.Ntype = &ptr; i1.Nid = &glob;
    r1.Nop = N_EXPRLIST; r1.Ntype = &base; r1.Nleft = &i1;
    i2 = i1; r2 = r1; r2.Nleft = &i2;

    curfn = &glob;
    maxauto = 7;
    fnabidirect = 1;
    fnargkeepmask = 012;
    fnargdropmask = 004;
    fnargpredropmask = 002;
    fn_main = 1;
    _reg_count = 1;
    Reg_Id[0] = &glob;
    stackrefs = 3;
    stkgoto = 1;
    if (kir_write_header(fp) != 0 || kir_write_extdef(fp, &r1) != 0) return 202;
    glob.Srefs = 3;                 /* Parser saw two further references. */
    if (kir_write_extdef(fp, &r2) != 0) return 203;
    if (kir_write_globals(fp, &head) != 0 || kir_write_module_end(fp, 0) != 0) return 204;
    rewind(fp);
    if (kir_read_header(fp) != 0 || kir_read_next(fp, &kind, &out1) != 0) return 205;
    if (kind != KIR_REC_EXTDEF || out1 == NULL) return 206;
    if (curfn != out1->Nleft->Nid) return 214;
    if (maxauto != 7 || !fnabidirect || fnargkeepmask != 012
      || fnargdropmask != 004 || fnargpredropmask != 002 || !fn_main
      || _reg_count != 1 || Reg_Id[0] != curfn
      || stackrefs != 3 || stkgoto != 1) return 215;
    saved_sym = out1->Nleft->Nid;
    saved_type = out1->Nleft->Ntype;
    if (saved_sym == NULL || saved_sym->Srefs != 1) return 207;
    --saved_sym->Srefs;             /* Simulate a backend reference fold. */
    kir_free_graph(out1);
    if (kir_read_next(fp, &kind, &out2) != 0 || kind != KIR_REC_EXTDEF) return 208;
    if (out2->Nleft->Nid != saved_sym) return 209;
    if (out2->Nleft->Nid->Srefs != 2) return 210; /* 0 + parser delta 2 */
    if (out2->Nleft->Ntype == saved_type) return 211; /* Types are graph-local. */
    kir_free_graph(out2);
    if (kir_read_next(fp, &kind, &out2) != 0 || kind != KIR_REC_MODULE_END) return 212;
    if (symbol == NULL || symbol->Snext != saved_sym || saved_sym->Snext != NULL) return 213;
    fclose(fp);
    kir_free_module();
    return 0;
}

static int vla_metadata_roundtrip(void)
{
    FILE *fp = tmpfile();
    TYPE base, vla;
    SYMBOL obj, bsym, baseptr, mark;
    NODE root, ident, bound;
    NODE *out = NULL, *obound;
    SYMBOL *oobj;
    int kind;

    if (!fp) return 301;
    memset(&base,0,sizeof(base)); memset(&vla,0,sizeof(vla));
    memset(&obj,0,sizeof(obj)); memset(&bsym,0,sizeof(bsym));
    memset(&baseptr,0,sizeof(baseptr)); memset(&mark,0,sizeof(mark));
    memset(&root,0,sizeof(root)); memset(&ident,0,sizeof(ident)); memset(&bound,0,sizeof(bound));
    base.Tspec=TS_INT; base.Tsize=1;
    vla.Tspec=TS_ARRAY; vla.Tflag=TF_VLA; vla.Tsubt=&base;
    strcpy(obj.Sname,"vlaobj"); obj.Sclass=SC_AUTO; obj.Sflags=SF_LOCAL; obj.Stype=&vla;
    strcpy(bsym.Sname,"vlab1"); bsym.Sclass=SC_AUTO; bsym.Sflags=SF_LOCAL; bsym.Stype=&base;
    strcpy(baseptr.Sname,"vlap1"); baseptr.Sclass=SC_AUTO; baseptr.Sflags=SF_LOCAL; baseptr.Stype=&base;
    strcpy(mark.Sname,"vlam1"); mark.Sclass=SC_AUTO; mark.Sflags=SF_LOCAL; mark.Stype=&base;
    bound.Nop=N_ICONST; bound.Ntype=&base; bound.Niconst=7;
    ident.Nop=Q_IDENT; ident.Ntype=&vla; ident.Nid=&obj;
    root.Nop=N_EXPRLIST; root.Ntype=&base; root.Nleft=&ident;
    if (vlainfoadd_v12(&vla,&bound,&bsym,1) != 0) return 302;
    if (vlaobjaddmeta_v12(&obj,&baseptr,&mark) != 0) return 303;
    if (kir_write_header(fp) != 0 || kir_write_extdef(fp,&root) != 0) return 304;
    rewind(fp); vlaclear_v12();
    if (kir_read_header(fp) != 0 || kir_read_next(fp,&kind,&out) != 0) return 305;
    if (kind != KIR_REC_EXTDEF || out == NULL) return 306;
    oobj=out->Nleft->Nid;
    obound=vlaboundexpr_v11(out->Nleft->Ntype);
    if (obound == NULL || obound->Nop != N_ICONST || obound->Niconst != 7) return 307;
    if (vlaboundsym_v11(out->Nleft->Ntype) == NULL) return 308;
    if (!vlaboundcaptured_v12(out->Nleft->Ntype)) return 309;
    if (vlabase_v11(oobj) == NULL || vlaobjmarkget_v12(oobj) == NULL) return 310;
    kir_free_graph(out); vlaclear_v12(); fclose(fp);
    return 0;
}

int main(void)
{
    FILE *fp = tmpfile();
    if (!fp) return 10;
    fputs("BAD1", fp); rewind(fp);
    if (kir_read_header(fp) == 0) return 11;
    fclose(fp);
    {
        int rc = graph_roundtrip();
        if (rc) { fprintf(stderr, "graph_roundtrip failed: %d\n", rc); return 12; }
    }
    {
        int rc = module_identity_roundtrip();
        if (rc) { fprintf(stderr, "module_identity_roundtrip failed: %d\n", rc); return 13; }
    }
    {
        int rc = vla_metadata_roundtrip();
        if (rc) { fprintf(stderr, "vla_metadata_roundtrip failed: %d\n", rc); return 14; }
    }
    puts("kcc-kir-format: PASS");
    return 0;
}
EOF

"$HOSTCC" -std=c99 -funsigned-char -I"$KCC_SOURCE" \
    "$work/test.c" "$KCC_SOURCE/cckirwrite.c" "$KCC_SOURCE/cckirread.c" \
    "$KCC_SOURCE/ccvla.c" \
    -o "$work/test"
"$work/test"
