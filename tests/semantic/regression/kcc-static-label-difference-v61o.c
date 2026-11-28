/* The assembler must resolve text-section label differences in C-byte
 * units, including negative values and narrow packed fields. */
static volatile int visits;
volatile unsigned fail_id;
static int dispatch(int index)
{
    static const short offsets[] = { &&first - &&first,
                                     &&second - &&first,
                                     &&third - &&first };
    static volatile int words[] = { &&second - &&first, &&first - &&second };
    static volatile short reverse = &&first - &&second;
    static volatile unsigned short narrow = &&first - &&second;
    static volatile unsigned int raw = &&first - &&second;
    static volatile struct ordinary {
        char prefix;
        short diff;
        unsigned tail;
    } ordinary = { 7, &&first - &&second, 0123456 };
    static volatile struct packed {
        char prefix[3];
        int diff;
        unsigned tail:5;
        signed delta:18;
    } __attribute__((packed)) packed = {{1,2,3}, &&first - &&second,
                                       023, &&second - &&first};
    int delta = &&second - &&first;
    fail_id = 1;
    if (!delta || delta % 4 || offsets[0] || offsets[1] != delta ||
        offsets[2] != &&third - &&first) return 90;
    fail_id = 2;
    if (words[0] != delta || words[1] != -delta || reverse != -delta ||
        narrow != (unsigned short)-delta || raw != (unsigned)-delta) return 91;
    fail_id = 3;
    if (ordinary.prefix != 7 || ordinary.diff != -delta || ordinary.tail != 0123456)
        return 92;
    fail_id = 4;
    if (packed.prefix[0] != 1 || packed.prefix[1] != 2 || packed.prefix[2] != 3 ||
        packed.diff != -delta || packed.tail != 023 || packed.delta != delta)
        return 93;
    fail_id = 5;
    goto *(&&first + offsets[index]);
first:
    visits += 1;
    return 11;
second:
    visits += 2;
    return 22;
third:
    visits += 3;
    return 33;
}
int main(void)
{
    if (dispatch(0) != 11 || dispatch(1) != 22 || dispatch(2) != 33 || visits != 6)
        return 1;
    fail_id = 0;
    return 0;
}
