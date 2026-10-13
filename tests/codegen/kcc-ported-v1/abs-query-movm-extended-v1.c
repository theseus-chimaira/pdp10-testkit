/* codegen-kcc-policy-only: yes */
/* Original KCC assembly requirements. */
/* codegen-require-regex: "(?ims)^lt:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movm\\s+)" "(?ims)^le:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movm\\s+)" "(?ims)^gt:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movm\\s+)" "(?ims)^ge:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movm\\s+)" "(?ims)^zgt:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movm\\s+)" "(?ims)^zge:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movm\\s+)" "(?ims)^zlt:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movm\\s+)" "(?ims)^zle:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movm\\s+)" "(?ims)^arr:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movm\\s+)" "(?ims)^member:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movm\\s+)" "(?ims)^arrms:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movms\\s+)" */
/* codegen-forbid-regex: "(?ims)^lt:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*(?:skip|jump|cam|jrst)[a-z]*\\s+)" "(?ims)^le:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*(?:skip|jump|cam|jrst)[a-z]*\\s+)" "(?ims)^gt:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*(?:skip|jump|cam|jrst)[a-z]*\\s+)" "(?ims)^ge:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*(?:skip|jump|cam|jrst)[a-z]*\\s+)" "(?ims)^zgt:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*(?:skip|jump|cam|jrst)[a-z]*\\s+)" "(?ims)^zge:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*(?:skip|jump|cam|jrst)[a-z]*\\s+)" "(?ims)^zlt:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*(?:skip|jump|cam|jrst)[a-z]*\\s+)" "(?ims)^zle:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*(?:skip|jump|cam|jrst)[a-z]*\\s+)" "(?ims)^arr:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*(?:skip|jump|cam|jrst)[a-z]*\\s+)" "(?ims)^member:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*(?:skip|jump|cam|jrst)[a-z]*\\s+)" "(?ims)^no_side:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movm[s|m]?\\s+)" "(?ims)^no_volatile:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:^\\s*movm[s|m]?\\s+)" */
struct pair { int a; int b; };
int ga[8];
volatile int vv;

int lt(x) int x; { return x < 0 ? -x : x; }
int le(x) int x; { return x <= 0 ? -x : x; }
int gt(x) int x; { return x > 0 ? x : -x; }
int ge(x) int x; { return x >= 0 ? x : -x; }
int zgt(x) int x; { return 0 > x ? -x : x; }
int zge(x) int x; { return 0 >= x ? -x : x; }
int zlt(x) int x; { return 0 < x ? x : -x; }
int zle(x) int x; { return 0 <= x ? x : -x; }

int arr(i) int i; { return ga[i] < 0 ? -ga[i] : ga[i]; }
int member(p) struct pair *p; { return p->b >= 0 ? p->b : -p->b; }
void arrms(i) int i; { ga[i] = ga[i] <= 0 ? -ga[i] : ga[i]; }

int no_side(i) int i; { return ga[i++] < 0 ? -ga[i++] : ga[i++]; }
int no_volatile() { return vv >= 0 ? vv : -vv; }
