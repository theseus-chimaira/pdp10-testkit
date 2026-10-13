/* codegen-kcc-expect-compile-fail: yes */
struct pair { int x; int y; };
int runtime_value;
static struct pair *bad = &(struct pair){ .x = runtime_value, .y = 1 };
