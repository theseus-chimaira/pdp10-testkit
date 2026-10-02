#include "mixed-reloc-v35.h"
int reloc_data_v35[3] = { 011, 022, 033 };
int *reloc_ptr_v35 = &reloc_data_v35[1];
int
reloc_add_v35(int x)
{
    return x + reloc_data_v35[2];
}
int (*reloc_fnptr_v35)(int) = reloc_add_v35;
