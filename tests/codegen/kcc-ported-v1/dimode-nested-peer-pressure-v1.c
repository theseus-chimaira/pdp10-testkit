/* Normalized KCC assembly assertions. */
/* codegen-require-regex:  */
/* codegen-forbid-regex:  */
struct pair71 { long long a; long long b; };
struct nested71 { struct pair71 p; long long tail; };

long long
nested_add(p, x)
struct nested71 *p;
long long x;
{
    return p->p.a + p->tail + x;
}
