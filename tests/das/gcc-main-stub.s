; Test-only GCC runtime stub for flat DXR corpus assembly.
; GCC emits a call to __main before main body code.
; DXR V1 has no external symbol/link step, so corpus tests append this
; local no-op definition instead of adding imports to the executable format.
        .globl __main
__main:
        popj 17,
