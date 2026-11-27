/* Bitfield extraction must retain native word displacements.
 * Populate the containing words independently of bitfield stores.
 */
typedef union {
    struct {
        unsigned long prefix[2];
        unsigned int high : 8;
        unsigned int low : 28;
        unsigned int next : 8;
        unsigned int rest : 28;
    } field;
    unsigned long words[4];
} object_t;
static volatile object_t objects[3];
volatile unsigned fail_id;

static unsigned int high_value(volatile object_t *p)
{
    return p->field.high;
}
static unsigned int next_value(volatile object_t *p)
{
    return p->field.next;
}
static unsigned int low_value(volatile object_t *p)
{
    return p->field.low;
}
int main(void)
{
    unsigned int i;
    for (i = 0; i < 3; ++i) {
        objects[i].words[0] = 0123456701234UL;
        objects[i].words[1] = 0765432107654UL;
        objects[i].words[2] = ((unsigned long)(222-i) << 28) | 01234567UL;
        objects[i].words[3] = ((unsigned long)(17+i) << 28) | 07654321UL;
    }
    for (i = 0; i < 3; ++i) {
        fail_id = 1;
        if (high_value(&objects[i]) != 222-i) return 1;
        fail_id = 2;
        if (next_value(&objects[i]) != 17+i) return 2;
        fail_id = 3;
        if (low_value(&objects[i]) != 01234567UL) return 3;
    }
    fail_id = 0;
    return 0;
}
