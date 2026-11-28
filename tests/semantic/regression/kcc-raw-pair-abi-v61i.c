/* Raw aggregate pairs must not be reduced to scalar register values.
 * Return a direct incoming pair and load a pair through an indexed address.
 */
struct pair { unsigned long hi, lo; };
static volatile struct pair input = { 0123456701234UL, 0765432107654UL };
static struct pair identity(struct pair x) { return x; }
static struct pair load(volatile struct pair *p) { return *p; }
int main(void)
{
    struct pair r = identity(input);
    if (r.hi != 0123456701234UL || r.lo != 0765432107654UL) return 1;
    r = load(&input);
    if (r.hi != 0123456701234UL || r.lo != 0765432107654UL) return 2;
    return 0;
}
