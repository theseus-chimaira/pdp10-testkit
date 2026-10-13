/* codegen-require-regex: "(?im)^\\s*(?:ibp|ildb)\\s+" */
/* codegen-forbid-regex: "(?i)adjbph" */
typedef unsigned _KCCtype_char16 u16;
u16 rd(u16 *p) { return *p; }
void wr(u16 *p, u16 v) { *p = v; }
