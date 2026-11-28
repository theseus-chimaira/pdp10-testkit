/* Native PDP-10 scalar widths selected by the GNU size attribute.
 * Check signedness, physical array packing, and element coordinates.
 * All unsigned maxima are exact native payload widths. */
#define CHECK_TYPE(N, UMAX, SMIN, SMAX, WORDS, SIZE) \
    typedef unsigned int u##N __attribute__((size(N))); \
    typedef signed int s##N __attribute__((__size__(N))); \
    static volatile union { u##N a[13]; unsigned long w[WORDS]; } un##N; \
    static volatile s##N sa##N[13]; \
    static int check##N(void) { \
        int i,j; \
        un##N.a[0] = (u##N)(UMAX); \
        sa##N[0] = (s##N)(SMIN); \
        sa##N[1] = (s##N)(SMAX); \
        if (un##N.a[0] != (UMAX) || sa##N[0] != (SMIN) || \
            sa##N[1] != (SMAX)) return 1; \
        if (sizeof(un##N.a) != 13*(SIZE) || sizeof(un##N) != (WORDS)*4) return 2; \
        if (un##N.w[0] != ((unsigned long)(UMAX) << (((N)<32)?36-(N):0))) return 9; \
        for (i=0;i<13;++i) for(j=0;j<13;++j) \
            if (&un##N.a[i]-&un##N.a[j] != i-j || \
                &sa##N[i]-&sa##N[j] != i-j) return 3; \
        return 0; \
    }
CHECK_TYPE(6,63UL,-32L,31L,3,1)
CHECK_TYPE(7,127UL,-64L,63L,3,1)
CHECK_TYPE(8,255UL,-128L,127L,4,1)
CHECK_TYPE(9,511UL,-256L,255L,4,1)
CHECK_TYPE(16,65535UL,-32768L,32767L,7,2)
CHECK_TYPE(18,262143UL,-131072L,131071L,7,2)
CHECK_TYPE(32,4294967295UL,-2147483648L,2147483647L,13,4)
CHECK_TYPE(36,0777777777777UL,-34359738368L,34359738367L,13,4)

static unsigned __attribute__((size(7))) x, y;
static unsigned a __attribute__((size(6))), b;
static const unsigned __attribute__((size(8))) c = 0377;
static unsigned long pass(unsigned value __attribute__((size(7))))
{ return value; }
struct record { unsigned a __attribute__((size(7))); unsigned b; };
static struct record r = {0177,0777777777777UL};
static char6 native6 = 077;
volatile unsigned fail_id;
int main(void)
{
    int rc;
    fail_id=6; if ((rc=check6())) return rc;
    fail_id=7; if ((rc=check7())) return rc;
    fail_id=8; if ((rc=check8())) return rc;
    fail_id=9; if ((rc=check9())) return rc;
    fail_id=16; if ((rc=check16())) return rc;
    fail_id=18; if ((rc=check18())) return rc;
    fail_id=32; if ((rc=check32())) return rc;
    fail_id=36; if ((rc=check36())) return rc;
    fail_id=100;
    x=0177; y=0177; a=077; b=0777777777777UL;
    if (x != 0177 || y != 0177 || a != 077 || b != 0777777777777UL || c != 0377) return 4;
    if (pass(0377) != 0177 || r.a != 0177 || r.b != 0777777777777UL) return 5;
    if (native6 != 077 || (char6)-1 != 077) return 6;
    if (sizeof(char6) != 1 || sizeof(int) != 4) return 7;
    /* An explicit local typedef takes precedence over the fallback. */
    { typedef signed _KCCtype_char6 char6; volatile char6 s = -1;
      if (s != -1) return 8; }
    fail_id=0;
    return 0;
}
