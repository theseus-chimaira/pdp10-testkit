/* PDP-10 native nine-bit-char, eight-bit-enum policy probe.
 * The historical AMBIG_CONV enumerator has integral value 222.
 * Signed 8-bit 222 narrows to -34; unsigned 8-bit retains 222.
 * The enum bitfield's signedness is implementation defined.
 * Do not require either representation for a conforming compiler.
 * Both representations must obey the target's integer promotions.
 */

enum code_v1 { AMBIG_CONV_V1 = 222 };
struct fields_v1 {
    signed int signed_code : 8;
    unsigned int unsigned_code : 8;
    enum code_v1 enum_code : 8;
};

static volatile struct fields_v1 fields_v1;
volatile unsigned int fail_id;
volatile int observed_enum_v1;
extern void abort(void);

int
main(void)
{
    fields_v1.signed_code = -34;
    fields_v1.unsigned_code = 222U;
    fields_v1.enum_code = AMBIG_CONV_V1;

    if (fields_v1.signed_code != -34) {
        fail_id = 1;
        abort();
    }
    if (fields_v1.unsigned_code != 222U) {
        fail_id = 2;
        abort();
    }
    observed_enum_v1 = (int)fields_v1.enum_code;
    if (observed_enum_v1 != 222 && observed_enum_v1 != -34) {
        fail_id = 3;
        abort();
    }
    if (observed_enum_v1 == 222) {
        switch (fields_v1.enum_code) {
        case AMBIG_CONV_V1:
            break;
        default:
            fail_id = 4;
            abort();
        }
    } else {
        switch ((int)fields_v1.enum_code) {
        case -34:
            break;
        default:
            fail_id = 5;
            abort();
        }
    }
    return 0;
}
