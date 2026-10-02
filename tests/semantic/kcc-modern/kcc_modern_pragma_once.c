/* kcc_modern_pragma_once.c - common #pragma once accepted. */

#pragma once

volatile int __test_exit;

int
main()
{
    __test_exit = 0;
    return 0;
}
