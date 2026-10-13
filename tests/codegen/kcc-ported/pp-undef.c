/* codegen-kcc-preprocess: "source" */
/* codegen-require-regex: "pp_undef_ok" "pp_second_undef_ok" */
#define DAIMON_MRES_DRIVER_RUNTIME_ONLY 1
#undef DAIMON_MRES_DRIVER_RUNTIME_ONLY
#ifndef DAIMON_MRES_DRIVER_RUNTIME_ONLY
int pp_undef_ok(void)
{
    return 1;
}
#else
#error undef failed
#endif

#define CONFIGFS_MUTATION_ONLY 1
#undef CONFIGFS_MUTATION_ONLY
#ifndef CONFIGFS_MUTATION_ONLY
int pp_second_undef_ok(void)
{
    return 1;
}
#endif
