#!/usr/bin/env python3
"""Host-only positive/negative controls for freestanding member selection."""

from freestanding_selection_v1 import select_freestanding


def expect(source, machine, members, symbols, compiler=None):
    got_members, got_symbols = select_freestanding(
        source, machine, compiler)
    assert got_members == members, (got_members, members)
    assert got_symbols == set(symbols), (got_symbols, symbols)


def main():
    expect("pushj 17,memmove\n", "pdp6",
           ["kcc-libc-memmove-v1.s", "kcc-libc-memcpy-v1.s"],
           ("memmove", "memcpy"))
    expect("jrst memcpy\n", "pdp6", ["kcc-libc-memcpy-v1.s"],
           ("memcpy",))
    expect(".extern strstr\n", "pdp6", ["kcc-libc-strstr-v1.s"],
           ("strstr",))
    expect("pushj 17,strspn\npushj 17,strpbrk\n", "pdp6",
           ["kcc-libc-strpbrk-v1.s", "kcc-libc-strspn-v1.s"],
           ("strpbrk", "strspn"))
    expect("pushj 17,strcpy\npushj 17,strchr\n", "pdp6",
           ["kcc-libc-string-v1.s"], ("strcpy", "strchr"))
    expect("memcpy:\n popj 17,\n pushj 17,memcpy\n", "pdp6", [], ())
    expect("pushj 17,memset\n", "pdp6", ["kcc-libc-memset-v1.s"],
           ("memset",))
    expect("pushj 17,p10bcmp_v2\n", "pdp6", ["p10bytes-v2.s"],
           ("p10bcmp_v2",))
    expect("pushj 17,__kcc_floatdidf\n", "pdp6",
           ["kcc-libc-dimode-float-pdp6-v1.s"], ("__kcc_floatdidf",))
    expect("pushj 17,__kcc_floatdidf\n", "ka10", [], ())
    expect("pushj 17,malloc\n", "pdp6", [], ())
    expect("pushj 17,sprintf\n", "pdp6",
           ["p10stdio-format-v2.s"], ("sprintf",), "gcc")
    expect("pushj 17,vsnprintf\npushj 17,vsprintf\n", "ka10",
           ["p10stdio-format-v2.s"], ("vsnprintf", "vsprintf"), "gcc")
    expect("pushj 17,isprint\n", "pdp6",
           ["kcc-libc-ctype-c-locale-v1.s"], ("isprint",), "kcc")
    expect(".long isprint\n.long isspace\n", "pdp6",
           ["kcc-libc-ctype-c-locale-v1.s"],
           ("isprint", "isspace"), "gcc")
    expect(".word isprint\n", "pdp6",
           ["kcc-libc-ctype-c-locale-v1.s"], ("isprint",), "gcc")
    expect("isprint:\n popj 17,\n.long isprint\n", "pdp6", [], (), "gcc")
    expect("pushj 17,sprintf\n", "pdp6", [], (), "kcc")
    expect("sprintf:\n popj 17,\n pushj 17,sprintf\n",
           "pdp6", [], (), "gcc")
    # Console functions require a real DAIMOS WRITECHAR veneer; never
    # load an OS-specific sink into the bare-metal compiler matrix.
    expect("pushj 17,printf\n", "pdp6", [], (), "gcc")
    print("PASS: freestanding member selection (20 host-only controls)")


if __name__ == "__main__":
    main()
