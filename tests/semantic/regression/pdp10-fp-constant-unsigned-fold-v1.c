/* PDP-10 36-bit unsigned constant -> SF/DF folding, C89, v1.
 * A host 64-bit unsigned type must never widen target ~0U beyond 36 bits.
 * Volatile inputs and independent numeric expected values prevent a
 * compiler from disguising a target-width constant fold as a pass.
 */
extern void abort(void);
volatile unsigned int fail_id;
volatile unsigned int input_v1 = ~0U;
volatile unsigned int half_v1 = (~0U) >> 1;
volatile float expected_sf_v1 = 68719476736.0F;
volatile double expected_df_v1 = 68719476735.0;
volatile float folded_sf_v1;
volatile float runtime_sf_v1;
volatile double folded_df_v1;
volatile double runtime_df_v1;

int
main(void)
{
    folded_sf_v1 = (float)~0U;
    runtime_sf_v1 = (float)input_v1;
    if (folded_sf_v1 != expected_sf_v1) {
        fail_id = 1;
        abort();
    }
    if (folded_sf_v1 != runtime_sf_v1) {
        fail_id = 2;
        abort();
    }
    folded_df_v1 = (double)~0U;
    runtime_df_v1 = (double)input_v1;
    if (folded_df_v1 != expected_df_v1) {
        fail_id = 3;
        abort();
    }
    if (folded_df_v1 != runtime_df_v1) {
        fail_id = 4;
        abort();
    }
    if ((float)((~0U) >> 1) != (float)half_v1) {
        fail_id = 5;
        abort();
    }
    if ((double)((~0U) >> 1) != (double)half_v1) {
        fail_id = 6;
        abort();
    }
    return 0;
}
