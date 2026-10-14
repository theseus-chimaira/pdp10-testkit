#!/usr/bin/env python3

import tempfile
from pathlib import Path

from stubselect import needed_stub_symbols, selected_test_stubs


def main():
    asm = "\t.text\n\tpushj 17,__main\n\tpopj 17,\n"
    needed = needed_stub_symbols(asm)
    if needed != ["__main"]:
        raise SystemExit("unexpected startup stubs: %r" % (needed,))

    with tempfile.TemporaryDirectory() as directory:
        paths = selected_test_stubs(asm, directory)
        if len(paths) != 1:
            raise SystemExit("startup stub was not emitted")
        text = Path(paths[0]).read_text(encoding="ascii")
        if ".global __main\n" not in text:
            raise SystemExit("startup stub is not exported")
        if "__main:\n\tpopj 17,\n" not in text:
            raise SystemExit("startup stub has unexpected contents")

        paths = selected_test_stubs(asm, directory, exclude={"__main"})
        if paths:
            raise SystemExit("excluded startup stub was emitted")

    print("stubselect startup test: PASS")


if __name__ == "__main__":
    main()
