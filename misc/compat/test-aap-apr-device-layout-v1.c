/* The device registry casts Device * to Apr *: Device must be first. */
#include <stddef.h>
#include "pdp6.h"

typedef char apr_device_must_be_at_offset_zero[
    offsetof(Apr, dev) == 0 ? 1 : -1];

int main(void)
{
    Apr apr = {0};
    return (void *)&apr != (void *)&apr.dev;
}
