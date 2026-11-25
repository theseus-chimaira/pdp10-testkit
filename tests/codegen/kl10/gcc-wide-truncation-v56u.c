/* The normalized 71-bit pair has a duplicated sign bit in word two.
 * Expected low words are mathematical residues, not physical AC halves.
 * Exercise register, volatile/nonvolatile memory, arguments and returns.
 * Also valid in the flat 72-bit model. */
typedef unsigned long word;
typedef unsigned long long wide;
typedef signed long long swide;
volatile word fail_id, result;
static volatile wide uv;
static volatile swide sv;
static wide plain;
static word low(wide x) __attribute__((noinline));
static word low(wide x) { return (word)x; }
static word low_signed(swide x) __attribute__((noinline));
static word low_signed(swide x) { return (word)x; }
static word low_plain(void) __attribute__((noinline));
static word low_plain(void) { return (word)plain; }
static word low_volatile(void) __attribute__((noinline));
static word low_volatile(void) { return (word)uv; }
static word low_signed_volatile(void) __attribute__((noinline));
static word low_signed_volatile(void) { return (word)sv; }
static word a, b;
static word multiply(void) __attribute__((noinline));
static word multiply(void) { return (word)((wide)a*(wide)b); }
static int check(wide x,word want) {
    uv=x; plain=x;
    return low(x)==want && low_plain()==want && low_volatile()==want;
}
static int checks(swide x,word want) {
    sv=x; return low_signed(x)==want && low_signed_volatile()==want;
}
int main(void) {
    fail_id=1; if(!check(0ULL,0UL)) return 1;
    fail_id=2; if(!check(0400000000000ULL,0400000000000UL)) return 2;
    fail_id=3; if(!check(0777777777777ULL,0777777777777UL)) return 3;
    fail_id=4; if(!check(01000000000000ULL,0UL)) return 4;
    fail_id=5; if(!check(01400000000000ULL,0400000000000UL)) return 5;
    fail_id=6; if(!checks(-1LL,0777777777777UL)) return 6;
    fail_id=7; if(!checks(-0400000000000LL,0400000000000UL)) return 7;
    fail_id=8; if(!checks(-01000000000000LL,0UL)) return 8;
    fail_id=9; if(!checks(-01000000000001LL,0777777777777UL)) return 9;
    fail_id=10; a=012345670123UL; b=023456701234UL;
    if(multiply()!=0356774714224UL) return 10;
    fail_id=0; result=765; return 0;
}
