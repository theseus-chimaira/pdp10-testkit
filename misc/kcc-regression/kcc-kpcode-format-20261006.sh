#!/bin/sh
set -eu

: "${TMPDIR:?TMPDIR must be set}"
: "${KCC_SOURCE:?KCC_SOURCE must point to the KCC tree}"

HOSTCC=${HOSTCC:-cc}
work="$TMPDIR/kcc-kpcode-format-20261006-$$"
trap 'rm -rf "$work"' EXIT HUP INT TERM
mkdir -p "$work"

cat > "$work/test.c" <<'EOF'
#include "cckpcode.h"
#include <stdio.h>
#include <string.h>

static int
roundtrip_header(void)
{
    FILE *fp = tmpfile();
    struct kpcode_header h = { 1, 2, 3, 4, 5 };
    struct kpcode_header got;
    int ok;

    if (!fp) return 0;
    ok = kpcode_write_header(fp, &h) == 0;
    rewind(fp);
    ok = ok && kpcode_read_header(fp, &got) == 0;
    ok = ok && memcmp(&h, &got, sizeof(h)) == 0;
    fclose(fp);
    return ok;
}

static int
bad_magic(void)
{
    FILE *fp = tmpfile();
    struct kpcode_header got;
    int rc;
    if (!fp) return 0;
    fputs("BADCODE1", fp);
    rewind(fp);
    rc = kpcode_read_header(fp, &got);
    fclose(fp);
    return rc < 0;
}

static int
bad_version(void)
{
    FILE *fp = tmpfile();
    struct kpcode_header h = { 1, 2, 3, 4, 5 };
    struct kpcode_header got;
    int rc;
    if (!fp) return 0;
    if (kpcode_write_header(fp, &h) != 0) return 0;
    if (fseek(fp, KPCODE_MAGIC_BYTES + 4, SEEK_SET) != 0) return 0;
    fputc(KPCODE_VERSION + 1, fp); /* reject future version, not the current v2 */
    rewind(fp);
    rc = kpcode_read_header(fp, &got);
    fclose(fp);
    return rc < 0;
}

static int
record_roundtrip(void)
{
    FILE *fp = tmpfile();
    INT in[2];
    INT out[2];
    unsigned int kind = 0, n = 0;
    int ok;
    if (!fp) return 0;
    in[0] = (INT)-1;
    in[1] = (INT)0123456701234ULL;
    ok = kpcode_write_record(fp, KPCODE_REC_TEXT, in, 2) == 0;
    rewind(fp);
    ok = ok && kpcode_read_record(fp, &kind, out, 2, &n) == 0;
    ok = ok && kind == KPCODE_REC_TEXT && n == 2;
    ok = ok && (((unsigned INT)out[0]) & KPCODE_WORD_MASK) == KPCODE_WORD_MASK;
    ok = ok && (((unsigned INT)out[1]) & KPCODE_WORD_MASK) ==
        (((unsigned INT)in[1]) & KPCODE_WORD_MASK);
    fclose(fp);
    return ok;
}

static int
truncated_record(void)
{
    FILE *fp = tmpfile();
    INT in[2] = { 1, 2 }, out[2];
    unsigned int kind, n;
    long len;
    int rc;
    if (!fp) return 0;
    if (kpcode_write_record(fp, KPCODE_REC_TEXT, in, 2) != 0) return 0;
    if (fseek(fp, 0, SEEK_END) != 0) return 0;
    len = ftell(fp);
    if (len <= 1) return 0;
    if (fseek(fp, 0, SEEK_SET) != 0) return 0;
    {
        FILE *shortfp = tmpfile();
        long i;
        if (!shortfp) return 0;
        for (i = 0; i < len - 1; ++i) fputc(fgetc(fp), shortfp);
        rewind(shortfp);
        rc = kpcode_read_record(shortfp, &kind, out, 2, &n);
        fclose(shortfp);
    }
    fclose(fp);
    return rc < 0;
}

static int
structured_records(void)
{
    FILE *fp = tmpfile();
    SYMBOL s1, s2;
    PCODE p;
    PCODE q;
    INT words[32];
    unsigned int kind, n;
    int ok;

    if (!fp) return 0;
    memset(&s1, 0, sizeof(s1));
    memset(&s2, 0, sizeof(s2));
    memset(&p, 0, sizeof(p));
    memset(&q, 0, sizeof(q));
    strcpy(s1.Sname, "same");
    strcpy(s2.Sname, "same");
    s1.Sclass = s2.Sclass = SC_EXTREF;
    p.Ptype = PTA_MINDEXED;
    p.Pop = P_MOVE;
    p.Preg = 3;
    p.Pindex = 4;
    p.Poffset = (INT)-7;
    q.Ptype = PTA_RCONST;
    q.Pop = P_MOVE;
    q.Preg = 1;
    q.Pvalue = (INT)0400000000147LL;

    ok = kpcode_write_symbol(fp, 7, &s1) == 0;
    ok = ok && kpcode_write_symbol(fp, 8, &s2) == 0;
    ok = ok && kpcode_write_pcode(fp, &p, 7) == 0;
    ok = ok && kpcode_write_pcode(fp, &q, 0) == 0;
    rewind(fp);

    ok = ok && kpcode_read_record(fp, &kind, words, 32, &n) == 0;
    ok = ok && kind == KPCODE_REC_SYMBOL && n >= 2 && words[0] == 7;
    ok = ok && kpcode_read_record(fp, &kind, words, 32, &n) == 0;
    ok = ok && kind == KPCODE_REC_SYMBOL && n >= 2 && words[0] == 8;
    ok = ok && kpcode_read_record(fp, &kind, words, 32, &n) == 0;
    ok = ok && kind == KPCODE_REC_PCODE && n == KPCODE_PCODE_WORDS;
    ok = ok && words[KPCODE_PCODE_SYMID] == 7;
    ok = ok && words[KPCODE_PCODE_PREG] == 3;
    ok = ok && words[KPCODE_PCODE_REG2] == 4;
    ok = ok && kpcode_decode_pcode(words, n, &p, &s1) == 0;
    ok = ok && p.Poffset == (INT)-7;
    ok = ok && kpcode_read_record(fp, &kind, words, 32, &n) == 0;
    ok = ok && kpcode_decode_pcode(words, n, &p, NULL) == 0;
    ok = ok && p.Pvalue == (INT)0400000000147LL;
    fclose(fp);
    return ok;
}

/* KPCODE2 must transport the entire 36-bit target float word, not
 * the binary32 bits of the host's 24-bit-significand float type.
 * Verify that the low target bits survive through the stream.
 */
static int
exact_target_float_roundtrip(void)
{
    FILE *fp = tmpfile();
    PCODE in, out;
    INT words[32];
    unsigned int kind = 0, n = 0;
    int ok;
    if (!fp) return 0;
    memset(&in, 0, sizeof(in));
    memset(&out, 0, sizeof(out));
    in.Ptype = PTA_FCONST;
    in.Pop = P_MOVE;
    in.Preg = 1;
    in.Pfloatword = (INT)0234400000002ULL; /* exactly 2^27 + 4 */
    ok = kpcode_write_pcode(fp, &in, 0) == 0;
    rewind(fp);
    ok = ok && kpcode_read_record(fp, &kind, words, 32, &n) == 0;
    ok = ok && kind == KPCODE_REC_PCODE && n == KPCODE_PCODE_WORDS;
    ok = ok && kpcode_decode_pcode(words, n, &out, NULL) == 0;
    ok = ok && out.Ptype == PTA_FCONST;
    ok = ok && out.Pfloatword == in.Pfloatword;
    fclose(fp);
    return ok;
}

int
main(void)
{
    INT chunks[KPCODE_INT_CHUNKS];
    INT wide = (INT)~(unsigned INT)0;

    kpcode_pack_int(chunks, wide);
    if (kpcode_unpack_int(chunks) != wide) return 7;
    if (!roundtrip_header()) return 1;
    if (!bad_magic()) return 2;
    if (!bad_version()) return 3;
    if (!record_roundtrip()) return 4;
    if (!truncated_record()) return 5;
    if (!structured_records()) return 6;
    if (!exact_target_float_roundtrip()) return 8;
    puts("kcc-kpcode-format: PASS");
    return 0;
}
EOF

"$HOSTCC" -std=c99 -funsigned-char -I"$KCC_SOURCE" \
    "$work/test.c" "$KCC_SOURCE/cckpwrite.c" "$KCC_SOURCE/cckpread.c" \
    -o "$work/test"
"$work/test"
