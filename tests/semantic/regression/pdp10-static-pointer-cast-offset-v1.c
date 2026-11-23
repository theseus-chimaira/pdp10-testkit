/* Static PDP-10 byte pointer offsets must retain their P/S selector.
   The initialized objects are volatile so the guest must read linked
   pointer words from data memory, not fold the comparisons at compile
   time.  All offset calculations stay within the words array.  */

struct static_ptr_record_v1 {
    int words[3];
};

struct static_ptr_pair_v1 {
    char *bytes;
    int *word;
};

static struct static_ptr_record_v1 record_v1 = {
    { 012345, 023456, 034567 }
};

static int *volatile word_v1 = &record_v1.words[2];
static char *volatile byte_v1 = (char *)&record_v1.words[2];
static char *volatile back4_v1 = (char *)&record_v1.words[2] - 4;
static char *volatile back8_v1 = (char *)&record_v1.words[2] - 8;
static char *volatile back5_v1 = (char *)&record_v1.words[2] - 5;
static char *volatile plusneg4_v1 = (char *)&record_v1.words[2] + (-4);
static int *volatile roundtrip4_v1 =
    (int *)((char *)&record_v1.words[2] - 4);
static int *volatile roundtrip8_v1 =
    (int *)((char *)&record_v1.words[2] - 8);

static volatile struct static_ptr_pair_v1 pair_v1 = {
    (char *)&record_v1.words[2] - 4,
    (int *)((char *)&record_v1.words[2] - 8)
};

int
main(void)
{
    if (word_v1 != &record_v1.words[2]) return 1;
    if (byte_v1 != (char *)&record_v1.words[2]) return 2;
    if (back4_v1 != (char *)&record_v1.words[1]) return 3;
    if (back8_v1 != (char *)&record_v1.words[0]) return 4;
    if (back5_v1 != (char *)&record_v1.words[0] + 3) return 5;
    if (plusneg4_v1 != (char *)&record_v1.words[1]) return 6;
    if (roundtrip4_v1 != &record_v1.words[1]) return 7;
    if (roundtrip8_v1 != &record_v1.words[0]) return 8;
    if (pair_v1.bytes != (char *)&record_v1.words[1]) return 9;
    if (pair_v1.word != &record_v1.words[0]) return 10;
    if (*roundtrip4_v1 != 023456) return 11;
    if (*roundtrip8_v1 != 012345) return 12;
    return 0;
}
