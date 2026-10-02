#include "mixed-reloc-v35.h"
volatile int __test_exit;
int
main(void)
{
    if (reloc_data_v35[0] != 011 || reloc_data_v35[2] != 033)
        return 1;
    if (reloc_ptr_v35 != &reloc_data_v35[1])
        return 2;
    if (*reloc_ptr_v35 != 022)
        return 3;
    if (reloc_add_v35(1) != 034)
        return 4;
    if ((*reloc_fnptr_v35)(2) != 035)
        return 5;
    return 0;
}
