/* An executable oracle for the packed pointer/short record from 960117-1.c.
 * The upstream test stores an ID byte and position without reading either
 * and its get_id() has no specified return despite a non-void type.
 * This companion checks the byte, the pointer and the packed short field.
 */

static char ids_v1[2][33];

typedef union {
    char *id __attribute__((aligned(2), packed));
} identifier_v1;

typedef struct {
    short position __attribute__((aligned(2), packed));
    identifier_v1 value __attribute__((aligned(2), packed));
} record_v1;

static record_v1 current_v1;
static volatile int chosen_v1;
volatile unsigned int fail_id;
extern void abort(void);

static void
put_identifier_v1(int slot, char byte, short position)
{
    current_v1.value.id = ids_v1[slot];
    current_v1.position = position;
    current_v1.value.id[0] = byte;
    current_v1.value.id[1] = '\0';
}

int
main(void)
{
    chosen_v1 = 0;
    put_identifier_v1(chosen_v1, 'c', 01234);
    if (current_v1.value.id != ids_v1[0] ||
        current_v1.value.id[0] != 'c' ||
        current_v1.value.id[1] != '\0' ||
        current_v1.position != 01234) {
        fail_id = 1;
        abort();
    }
    chosen_v1 = 1;
    put_identifier_v1(chosen_v1, 'z', 0567);
    if (current_v1.value.id != ids_v1[1] ||
        current_v1.value.id[0] != 'z' ||
        current_v1.value.id[1] != '\0' ||
        current_v1.position != 0567 ||
        ids_v1[0][0] != 'c') {
        fail_id = 2;
        abort();
    }
    return 0;
}
