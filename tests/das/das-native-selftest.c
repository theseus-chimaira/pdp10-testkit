#define DAS_NATIVE 1
#define DAS_NATIVE_SELFTEST 1
#define DAS_NATIVE_CORE_ONLY 1
#include "das.c"
int main(void) { return das_native_selftest(); }
