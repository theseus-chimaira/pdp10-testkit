/* codegen-kcc-policy-only: yes */
/* KCC compiler-specific instruction assertions. */
/* codegen-require-regex: "POINT 16" */
/* codegen-forbid-regex: "POINT 32" */
typedef signed _KCCtype_char16 s16;
typedef unsigned _KCCtype_char16 u16;
typedef signed _KCCtype_int32 s32;
typedef unsigned _KCCtype_int32 u32;

s16 a16[4];
u16 u16a[4];
s32 a32[4];
u32 u32a[4];

int load16(i) int i; { return a16[i]; }
int loadu16(i) int i; { return u16a[i]; }
int load32(i) int i; { return a32[i]; }
int loadu32(i) int i; { return u32a[i]; }
long diff16(p, q) s16 *p; s16 *q; { return p - q; }
int arg16(x) s16 x; { return x; }
int argu16(x) u16 x; { return x; }
int arg32(x) s32 x; { return x; }
int argu32(x) u32 x; { return x; }
