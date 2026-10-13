/* Original KCC regression checks. */
typedef signed _KCCtype_int32 s32;
struct s { int a; s32 b[1]; };
static s32 *addr(p) struct s *p; { return &p->b[0]; }
int diff(p) struct s *p; { return addr(p) - &p->b[0]; }
