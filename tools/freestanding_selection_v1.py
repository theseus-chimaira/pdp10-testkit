"""Select installed PDP-10 freestanding assembly members for p10run.

The semantic runner accepts source files, not DARC archives. Keep its
source selection minimal and model inter-member references explicitly.
This is a selection policy, not a substitute for production dlink tests.
"""

import re


STRING_SYMBOLS = ("strcpy", "strncpy", "strcat", "strncat", "strchr",
                  "strrchr", "strtok", "strcspn")
SEARCH_SYMBOLS = ("strstr", "strpbrk", "strspn")
BYTE_SYMBOLS = ("p10bcopy_v2", "p10bfill_v2", "p10bcmp_v2")
DFLOAT_SYMBOLS = ("__kcc_floatdidf", "__kcc_fixdfdi")
UFLOAT_SYMBOLS = ("__kcc_floatunssisf", "__kcc_floatunsidf",
                  "__kcc_fixunssfsi", "__kcc_fixunsdfsi",
                  "__kcc_floatsisf", "__kcc_fixsfsi")
BUFFER_STDIO_SYMBOLS = ("sprintf", "vsprintf", "snprintf", "vsnprintf")
HEAP_SYMBOLS = ("malloc", "free", "calloc", "realloc", "p10heap_init_v1")
HEAP_MEMBER = "p10heap-arena-v1.s"
CTYPE_C_LOCALE_SYMBOLS = ("isprint", "isspace")

# Symbol-to-member ownership is shared by the installed KCC and GCC
# freestanding libraries.  The C-locale entry points have an independent
# versioned archive, separate from the unchanged core libp10c-v2.a.
# A single source file may export several symbols.
MEMBERS = {
    **{symbol: "kcc-libc-ctype-c-locale-v1.s" for symbol in CTYPE_C_LOCALE_SYMBOLS},
    **{symbol: "kcc-libc-string-v1.s" for symbol in STRING_SYMBOLS},
    **{symbol: "kcc-libc-%s-v1.s" % symbol
       for symbol in ("strlen", "strcmp", "strncmp") + SEARCH_SYMBOLS},
    "memcmp": "kcc-libc-memcmp-v2.s",
    "memset": "kcc-libc-memset-v1.s",
    "memcpy": "kcc-libc-memcpy-v1.s",
    "memmove": "kcc-libc-memmove-v1.s",
    **{symbol: "p10bytes-v2.s" for symbol in BYTE_SYMBOLS},
    **{symbol: "kcc-libc-dimode-float-pdp6-v1.s"
       for symbol in DFLOAT_SYMBOLS},
    **{symbol: "kcc-libc-fp36-pdp6-v1.s"
       for symbol in UFLOAT_SYMBOLS},
    "__kcc_fixdfsi": "kcc-libc-fp36-signed-df-pdp6-v1.s",
    "__kcc_floatsidf": "kcc-libc-fp36-signed-df-pdp6-v1.s",
}

# Explicit cross-member dependencies, including tail calls.
DEPENDENCIES = {
    "kcc-libc-memmove-v1.s": ("memcpy",),
    "kcc-libc-fp36-signed-df-pdp6-v1.s": ("__kcc_fixunsdfsi",
                                                  "__kcc_floatunsidf"),
}

REFERENCES = re.compile(
    # GCC also materializes function addresses in .long/.word constants.
    # Function-pointer uses must select the same real library member as
    # direct PUSHJ calls; they cannot be treated as unresolved stubs.
    r"(?mi)^\s*(?:pushj\s+\d+\s*,\s*|jrst\s+|\.extern\s+"
    # A local-address relocation may use a numeric left half (0,,symbol).
    r"|movei\s+\d+\s*,\s*"
    r"|\.(?:long|word)\s+(?:[+-]?[0-9]+\s*,,\s*)?)"
    r"([A-Za-z_][A-Za-z_0-9]*)\b")


def select_freestanding(asm_text, machine, compiler=None):
    """Return (member filenames, owned symbols) in deterministic order.

    Do not override symbols implemented by the test itself. The conversion
    helpers are selected by actual emitted symbol references, not by the
    simulator CPU: KCC can emit these calls in base and other profiles too.
    """
    defined = set(re.findall(
        r"(?m)^\s*([A-Za-z_][A-Za-z_0-9]*):", asm_text))
    references = set(REFERENCES.findall(asm_text))
    pending = sorted(references - defined)
    members = dict(MEMBERS)
    if compiler in ("gcc", "kcc"):
        # Each compiler has its own build of the shared C source.
        # Never pass a private va_list across compiler boundaries.
        members.update({symbol: "p10stdio-format-v3.s"
                        for symbol in BUFFER_STDIO_SYMBOLS})
        # A partial test-defined allocator must not collide with this
        # single-member provider. Explicit initialization remains possible.
        if not defined.intersection(HEAP_SYMBOLS):
            members.update({symbol: HEAP_MEMBER for symbol in HEAP_SYMBOLS})
    selected = []
    owned = set()
    while pending:
        symbol = pending.pop(0)
        member = members.get(symbol)
        if member is None or symbol in defined:
            continue
        owned.add(symbol)
        if member not in selected:
            selected.append(member)
            pending.extend(DEPENDENCIES.get(member, ()))
    return selected, owned


def heap_startup_required(asm_text, fragments):
    """The harness initializes only its own heap, not a client's arena."""
    return (HEAP_MEMBER in fragments
            and "p10heap_init_v1" not in set(REFERENCES.findall(asm_text)))
