/* Wide bit-field constraint. */
struct wide { unsigned long long x:71; };
int f(struct wide *p) { return sizeof(p->x); }
