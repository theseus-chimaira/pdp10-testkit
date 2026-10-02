# Shared PDP-10 installed-tool environment.
#
# PDP10_PREFIX is the only installation-path input.  Installed compilers,
# assembler, runner, and KCC runtime files are always taken from that prefix.

pdp10_require_prefix() {
    if [ -z "${PDP10_PREFIX:-}" ]; then
        echo "error: PDP10_PREFIX must be set" >&2
        exit 2
    fi
}

pdp10_first_tool() {
    for name in "$@"; do
        if [ -x "$PDP10_PREFIX/bin/$name" ]; then
            printf '%s\n' "$PDP10_PREFIX/bin/$name"
            return 0
        fi
    done
    printf '%s\n' "$PDP10_PREFIX/bin/$1"
}

pdp10_setup_env() {
    pdp10_require_prefix

    PATH="$PDP10_PREFIX/bin:$PATH"
    export PDP10_PREFIX PATH

    # Do not honor ambient path overrides.  A sweep must use one coherent
    # installed toolchain, rooted solely at PDP10_PREFIX.
    KCC=$(pdp10_first_tool kcc kcc10 pdp10-kcc)
    PDP10_GCC=$(pdp10_first_tool pdp10-dec-none-gcc pdp10-gcc)
    PDP10_AS="$PDP10_PREFIX/bin/pdp10-dec-none-as"
    PDP10_ASM="$PDP10_AS"
    P10RUN="$PDP10_PREFIX/bin/p10run"
    KCC_LIBDIR="$PDP10_PREFIX/lib/kcc"
    KCC_RT="$KCC_LIBDIR/ks10rt.s"

    export KCC PDP10_GCC PDP10_AS PDP10_ASM P10RUN KCC_LIBDIR KCC_RT
}
