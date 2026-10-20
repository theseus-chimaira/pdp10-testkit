/* Targeted PDP-6 rounded-FP negative-halfway diagnostic.
 * AAP PDP-6 reports 0543400000000 for both rounded additions below,
 * while the currently installed SIMH PDP-6 reports 0544000000001.
 * A failing SIMH result MUST NOT be accepted as a passing regression.
 */
extern void abort(void);

union pdp6_negative_float_v1 {
    float value;
    unsigned int word;
};

volatile float pdp6_negative_source_v1;
volatile float pdp6_negative_plus_v1;
volatile float pdp6_negative_minus_v1;

int
main(void)
{
    union pdp6_negative_float_v1 v;
    pdp6_negative_source_v1 = -134217728.0F;
    pdp6_negative_plus_v1 = pdp6_negative_source_v1 + -1.0F;
    pdp6_negative_minus_v1 = pdp6_negative_source_v1 - 1.0F;
    v.value = pdp6_negative_plus_v1;
    if (v.word != 0543400000000UL)
        abort();
    v.value = pdp6_negative_minus_v1;
    if (v.word != 0543400000000UL)
        abort();
    return 0;
}
