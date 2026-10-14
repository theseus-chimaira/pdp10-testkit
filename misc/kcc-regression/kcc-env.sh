# Shared installed-tool environment for KCC regressions.

kcc_require_prefix() {
    if [ -z "${PDP10_PREFIX:-}" ]; then
        echo "error: PDP10_PREFIX must be set" >&2
        exit 2
    fi
}

kcc_setup_env() {
    kcc_require_prefix
    PATH="$PDP10_PREFIX/bin:$PATH"
    export PDP10_PREFIX PATH

    KCC="$PDP10_PREFIX/bin/kcc"
    P10RUN="$PDP10_PREFIX/bin/p10run"
    KCCLIBDIR="$PDP10_PREFIX/lib/kcc"
    KCC_RT="$KCCLIBDIR/pdp6rt.s"
    export KCC P10RUN KCCLIBDIR KCC_RT
}
