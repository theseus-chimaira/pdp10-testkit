union U { int i; };
extern int x;
static union U u = (union U)x;
