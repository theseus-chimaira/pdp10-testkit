/* Wide bit-field constraint. */
struct wide { unsigned long long x:71; };
void *f(struct wide *p) { return &p->x; }
