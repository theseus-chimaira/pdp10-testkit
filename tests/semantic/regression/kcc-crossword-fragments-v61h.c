/* Independent physical-word oracle for ordinary crossing bitfields.
** Inputs and expected words were calculated as a 72-bit physical stream:
** (raw0 << 36) | raw1, with field bits replaced at the declared offset.
** No target shifts or field operations are used to compute expectations.
*/
typedef unsigned long W;
volatile unsigned fail_id;
#define CHECK(ID, PHASE, WIDTH, RAW0, RAW1, UVAL, SVAL, NEW, OUT0, OUT1) \
static int check##ID(void) { \
    union { \
        W raw[2]; \
        struct { unsigned pad:PHASE; unsigned field:WIDTH; \
                 unsigned tail:(72-PHASE-WIDTH); } u; \
        struct { unsigned pad:PHASE; signed field:WIDTH; \
                 unsigned tail:(72-PHASE-WIDTH); } s; \
    } volatile x; \
    x.raw[0] = RAW0; x.raw[1] = RAW1; \
    if (x.u.field != UVAL || x.s.field != SVAL) return 1; \
    x.u.field = NEW; \
    if (x.raw[0] != OUT0 || x.raw[1] != OUT1) return 2; \
    x.s.field = SVAL; \
    if (x.raw[0] != RAW0 || x.raw[1] != RAW1) return 3; \
    return 0; \
}

CHECK(1, 1, 36, 0622150531704UL, 0763636363636UL, 0444321263611UL,
      -29473020023L, 0333456514166UL, 0555627246073UL, 0363636363636UL)
CHECK(2, 35, 36, 0525252525253UL, 0110642547422UL, 0444321263611UL,
      -29473020023L, 0333456514166UL, 0525252525252UL, 0667135230354UL)
CHECK(3, 18, 36, 0525252444321UL, 0263611363636UL, 0444321263611UL,
      -29473020023L, 0333456514166UL, 0525252333456UL, 0514166363636UL)
CHECK(4, 12, 32, 0525250642547UL, 0423636363636UL, 0024321263611UL,
      -1555732599L, 0013456514166UL, 0525227135230UL, 0355636363636UL)
CHECK(5, 30, 7, 0525252525244UL, 0763636363636UL, 0000000000111UL,
      -55L, 0000000000066UL, 0525252525233UL, 0363636363636UL)
CHECK(6, 33, 4, 0525252525254UL, 0763636363636UL, 0000000000011UL,
      -7L, 0000000000006UL, 0525252525253UL, 0363636363636UL)
CHECK(7, 20, 35, 0525252522150UL, 0531704763636UL, 0244321263611UL,
      -12293150839L, 0133456514166UL, 0525252455627UL, 0246073363636UL)
CHECK(8, 2, 35, 0522150531704UL, 0763636363636UL, 0244321263611UL,
      -12293150839L, 0133456514166UL, 0455627246073UL, 0363636363636UL)
CHECK(9, 34, 3, 0525252525252UL, 0763636363636UL, 0000000000005UL,
      -3L, 0000000000002UL, 0525252525251UL, 0363636363636UL)
CHECK(10, 17, 20, 0525253531704UL, 0763636363636UL, 0000003263611UL,
      -170103L, 0000000514166UL, 0525252246073UL, 0363636363636UL)

/* A side-effecting lvalue address must survive load/modify/store. */
struct crossing { unsigned pad:12; unsigned field:32; unsigned tail:28; };
static volatile struct crossing obj = {0123, 0x12345678UL, 0456};
static volatile unsigned calls;
static volatile struct crossing *get(void) { ++calls; return &obj; }
static int side(void)
{
    unsigned old;
    get()->field ^= 0x87654321UL;
    if (calls != 1 || obj.field != 0x95511559UL) return 1;
    old = get()->field++;
    if (calls != 2 || old != 0x95511559UL || obj.field != 0x9551155aUL)
        return 2;
    if (obj.pad != 0123 || obj.tail != 0456) return 3;
    return 0;
}

int main(void)
{
    int rc;
    fail_id = 1; if ((rc = check1()) != 0) return rc;
    fail_id = 2; if ((rc = check2()) != 0) return rc;
    fail_id = 3; if ((rc = check3()) != 0) return rc;
    fail_id = 4; if ((rc = check4()) != 0) return rc;
    fail_id = 5; if ((rc = check5()) != 0) return rc;
    fail_id = 6; if ((rc = check6()) != 0) return rc;
    fail_id = 7; if ((rc = check7()) != 0) return rc;
    fail_id = 8; if ((rc = check8()) != 0) return rc;
    fail_id = 9; if ((rc = check9()) != 0) return rc;
    fail_id = 10; if ((rc = check10()) != 0) return rc;
    fail_id = 11; if ((rc = side()) != 0) return rc;
    fail_id = 0;
    return 0;
}
