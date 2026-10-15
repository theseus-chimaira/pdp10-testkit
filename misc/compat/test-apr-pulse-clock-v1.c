/* Freestanding-sized C99 test of AAP APR logical pulse accounting. */
#include "apr_pulse_clock_v1.h"

int main(void)
{
    uint64_t t = 0;
    if (apr_pulse_clock_advance_v1(&t, 100) || t != 100) return 1;
    if (apr_pulse_clock_advance_v1(&t, 0) || t != 100) return 2;
    if (apr_pulse_clock_advance_v1(&t, 250) || t != 350) return 3;
    if (apr_pulse_clock_advance_v1(&t, -1) == 0 || t != 350) return 4;
    t = UINT64_MAX - 1;
    if (apr_pulse_clock_advance_v1(&t, 2) == 0 ||
        t != UINT64_MAX - 1) return 5;
    if (apr_pulse_clock_advance_v1(&t, 1) || t != UINT64_MAX) return 6;
    return 0;
}
