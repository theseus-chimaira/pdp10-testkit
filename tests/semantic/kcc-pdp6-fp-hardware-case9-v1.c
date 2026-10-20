/* DEC Type 166 FADR hardware-fidelity case 9, version 1.
 * The FDAS/EMNF circuits predict 0544000000003 for this addition.
 * The separate 24-case mathematical regression is intentionally retained.
 */
extern void abort(void);

union pdp6_fp_hardware_word_v1 {
    float value;
    unsigned int word;
};

volatile float pdp6_fp_hardware_left_v1 = -134217728.0F;
volatile float pdp6_fp_hardware_right_v1 = 1.0F;
volatile float pdp6_fp_hardware_result_v1;
volatile unsigned int pdp6_fp_hardware_actual_v1;
volatile unsigned int pdp6_fp_hardware_case_v1;

int
main(void)
{
    union pdp6_fp_hardware_word_v1 result;
    pdp6_fp_hardware_case_v1 = 1;
    pdp6_fp_hardware_result_v1 =
        pdp6_fp_hardware_left_v1 + pdp6_fp_hardware_right_v1;
    result.value = pdp6_fp_hardware_result_v1;
    pdp6_fp_hardware_actual_v1 = result.word;
    if (result.word != 0544000000003UL)
        abort();
    return 0;
}
