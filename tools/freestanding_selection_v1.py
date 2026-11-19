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

# Symbol-to-member ownership is shared by the installed KCC and GCC
# freestanding archives. A single source file may export several symbols.
MEMBERS = {
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
}

# Explicit cross-member dependencies, including tail calls.
DEPENDENCIES = {"kcc-libc-memmove-v1.s": ("memcpy",)}

REFERENCES = re.compile(
    r"(?mi)^\s*(?:pushj\s+\d+\s*,\s*|jrst\s+|\.extern\s+)"
    r"([A-Za-z_][A-Za-z_0-9]*)\b")


def select_freestanding(asm_text, machine):
    """Return (member filenames, owned symbols) in deterministic order.

    Do not override symbols implemented by the test itself. Only the PDP-6
    software D-format ABI is admitted for the dedicated conversion member.
    """
    defined = set(re.findall(
        r"(?m)^\s*([A-Za-z_][A-Za-z_0-9]*):", asm_text))
    references = set(REFERENCES.findall(asm_text))
    pending = sorted(references - defined)
    selected = []
    owned = set()
    while pending:
        symbol = pending.pop(0)
        member = MEMBERS.get(symbol)
        if member is None or symbol in defined:
            continue
        if symbol in DFLOAT_SYMBOLS and machine != "pdp6":
            continue
        owned.add(symbol)
        if member not in selected:
            selected.append(member)
            pending.extend(DEPENDENCIES.get(member, ()))
    return selected, owned
