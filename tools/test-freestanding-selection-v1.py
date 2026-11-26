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
    expect("pushj 17,__kcc_floatunssisf\n", "pdp6",
           ["kcc-libc-fp36-pdp6-v1.s"],
           ("__kcc_floatunssisf",))
    expect("pushj 17,__kcc_floatunsidf\n", "pdp6",
           ["kcc-libc-fp36-pdp6-v1.s"],
           ("__kcc_floatunsidf",))
    expect("pushj 17,__kcc_floatunsidf\n", "ka10",
           ["kcc-libc-fp36-pdp6-v1.s"], ("__kcc_floatunsidf",))
    expect("pushj 17,__kcc_fixunssfsi\n", "pdp6",
           ["kcc-libc-fp36-pdp6-v1.s"],
           ("__kcc_fixunssfsi",))
    expect("pushj 17,__kcc_fixunsdfsi\n", "pdp6",
           ["kcc-libc-fp36-pdp6-v1.s"],
           ("__kcc_fixunsdfsi",))
    expect("pushj 17,__kcc_floatsisf\n", "pdp6",
           ["kcc-libc-fp36-pdp6-v1.s"],
           ("__kcc_floatsisf",))
    expect("pushj 17,__kcc_fixsfsi\n", "pdp6",
           ["kcc-libc-fp36-pdp6-v1.s"],
           ("__kcc_fixsfsi",))
    expect("pushj 17,__kcc_fixdfsi\n", "pdp6",
           ["kcc-libc-fp36-signed-df-pdp6-v1.s",
            "kcc-libc-fp36-pdp6-v1.s"],
           ("__kcc_fixdfsi", "__kcc_fixunsdfsi", "__kcc_floatunsidf"))
    expect("pushj 17,__kcc_floatsidf\n", "pdp6",
           ["kcc-libc-fp36-signed-df-pdp6-v1.s",
            "kcc-libc-fp36-pdp6-v1.s"],
           ("__kcc_floatsidf", "__kcc_fixunsdfsi", "__kcc_floatunsidf"))
    expect("pushj 17,__kcc_fixdfsi\n", "ka10",
           ["kcc-libc-fp36-signed-df-pdp6-v1.s",
            "kcc-libc-fp36-pdp6-v1.s"],
           ("__kcc_fixdfsi", "__kcc_fixunsdfsi", "__kcc_floatunsidf"))
    expect("pushj 17,__kcc_floatsidf\n", "ki10",
           ["kcc-libc-fp36-signed-df-pdp6-v1.s",
            "kcc-libc-fp36-pdp6-v1.s"],
           ("__kcc_floatsidf", "__kcc_fixunsdfsi", "__kcc_floatunsidf"))
    expect("pushj 17,__kcc_floatdidf\n", "ks10",
           ["kcc-libc-dimode-float-pdp6-v1.s"], ("__kcc_floatdidf",))
    expect("pushj 17,malloc\n", "pdp6", [], ())
    expect("pushj 17,sprintf\n", "pdp6",
           ["p10stdio-format-v3.s"], ("sprintf",), "gcc")
    expect("pushj 17,vsnprintf\npushj 17,vsprintf\n", "ka10",
           ["p10stdio-format-v3.s"], ("vsnprintf", "vsprintf"), "gcc")
    expect("pushj 17,isprint\n", "pdp6",
           ["kcc-libc-ctype-c-locale-v1.s"], ("isprint",), "kcc")
    expect(".long isprint\n.long isspace\n", "pdp6",
           ["kcc-libc-ctype-c-locale-v1.s"],
           ("isprint", "isspace"), "gcc")
    expect(".word isprint\n", "pdp6",
           ["kcc-libc-ctype-c-locale-v1.s"], ("isprint",), "gcc")
    expect(".word 0,,isprint\n.word 0 ,, isspace\n", "pdp6",
           ["kcc-libc-ctype-c-locale-v1.s"],
           ("isprint", "isspace"), "gcc")
    expect("isprint:\n popj 17,\n.word 0,,isprint\n", "pdp6", [], (), "gcc")
    expect("isprint:\n popj 17,\n.long isprint\n", "pdp6", [], (), "gcc")
    expect("pushj 17,sprintf\n", "pdp6",
           ["p10stdio-format-v3.s"], ("sprintf",), "kcc")
    expect("movei 1,sprintf\n", "pdp6",
           ["p10stdio-format-v3.s"], ("sprintf",), "gcc")
    expect("movei 2,sprintf\n", "pdp6",
           ["p10stdio-format-v3.s"], ("sprintf",), "kcc")
    expect("sprintf:\n movei 1,sprintf\n", "pdp6", [], (), "kcc")
    expect("sprintf:\n popj 17,\n pushj 17,sprintf\n",
           "pdp6", [], (), "gcc")
    # Console functions require a real DAIMOS WRITECHAR veneer; never
    # load an OS-specific sink into the bare-metal compiler matrix.
    expect("pushj 17,printf\n", "pdp6", [], (), "gcc")
    print("PASS: freestanding member selection (34 host-only controls)")


if __name__ == "__main__":
    main()
