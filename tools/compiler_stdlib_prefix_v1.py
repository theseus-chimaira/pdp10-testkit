"""Select the installed compiler freestanding C library for guest tests.

The installed p10run tool unconditionally tries PDP10_PREFIX/lib/libc.a.
The default prefix may contain a distinct OS library.  A testkit-owned
runtime prefix redirects that one lookup to the installed compiler's
libp10c-v2.a without changing the toolchain or the user's installation.

No hosted malloc, ctype, FILE, or console functions are fabricated.
Unresolved references to such functions remain real link failures.
"""

import hashlib
import os
from pathlib import Path


POLICY = "compiler-stdlib-v1"
ARCHIVES = {
    "kcc": "lib/kcc/freestanding/libp10c-v2.a",
    "gcc": "lib/gcc-lib/pdp10-dec-none/3.2/freestanding/libp10c-v2.a",
}


def archive_path(prefix, compiler):
    """Return the genuine installed compiler archive; never OS libc.a."""
    if compiler not in ARCHIVES:
        raise ValueError("unknown PDP-10 compiler runtime: " + str(compiler))
    archive = Path(prefix) / ARCHIVES[compiler]
    if not archive.is_file():
        raise ValueError("missing compiler freestanding library: " + str(archive))
    if archive.is_symlink() and archive.resolve().parent != archive.parent.resolve():
        raise ValueError("compiler libc path redirects outside freestanding directory")
    return archive.resolve()


def archive_sha256(prefix, compiler):
    """Bind checkpoints to the bytes of the actually selected archive."""
    digest = hashlib.sha256()
    with archive_path(prefix, compiler).open("rb") as stream:
        while True:
            block = stream.read(65536)
            if not block:
                break
            digest.update(block)
    return digest.hexdigest()


def overlay_path(outroot, compiler):
    if compiler not in ARCHIVES:
        raise ValueError("unknown compiler overlay: " + str(compiler))
    return Path(outroot) / "compiler-stdlib-prefix-v1" / compiler


def require_link(link, target):
    """Fail closed on unexpected paths rather than overwriting user data."""
    if link.is_symlink():
        if link.resolve() != target.resolve():
            raise ValueError("stale or foreign compiler prefix link: " + str(link))
    elif link.exists():
        raise ValueError("non-symlink compiler prefix entry: " + str(link))
    else:
        link.symlink_to(target)
    if link.resolve() != target.resolve():
        raise ValueError("compiler runtime link did not resolve correctly")


def prepare(outroot, prefix, compilers):
    """Create one compiler-specific, non-DAIMOS prefix per compiler.

    The bin link supplies the installed assembler, linker, simulator and
    compiler executables. The only libc.a entry is the real installed
    *compiler* archive; no other libraries are copied or searched.
    """
    original = Path(prefix).resolve()
    installed_bin = original / "bin"
    if not installed_bin.is_dir():
        raise ValueError("missing installed PDP-10 compiler tools")
    result = {}
    for compiler in sorted(set(compilers)):
        source = archive_path(original, compiler)
        destination = overlay_path(outroot, compiler)
        lib = destination / "lib"
        if destination.is_symlink() or lib.is_symlink():
            raise ValueError("runtime prefix directory is an unexpected symlink")
        lib.mkdir(parents=True, exist_ok=True)
        require_link(destination / "bin", installed_bin)
        require_link(lib / "libc.a", source)
        if (destination / "lib" / "libc.a").resolve() != source:
            raise ValueError("runtime libc was not the compiler archive")
        stamp = destination / "compiler-stdlib-policy-v1.txt"
        if stamp.is_symlink():
            raise ValueError("compiler runtime policy marker is a symlink")
        expected = ("policy=" + POLICY + "\ncompiler=" + compiler +
                    "\narchive=" + str(source) + "\nsha256=" +
                    archive_sha256(original, compiler) + "\n")
        if stamp.is_file() and stamp.read_text(encoding="ascii") != expected:
            raise ValueError("compiler runtime changed in existing prefix")
        stamp.write_text(expected, encoding="ascii")
        result[compiler] = destination.resolve()
    return result


def env_for_cell(outroot, prefix, compiler, base_env=None):
    """Give p10run a strict compiler-library prefix for this one cell."""
    overlay = overlay_path(outroot, compiler)
    expected = archive_path(prefix, compiler)
    if ((overlay / "lib" / "libc.a").resolve() != expected or
            not (overlay / "lib" / "libc.a").is_symlink()):
        raise ValueError("compiler stdlib prefix not prepared")
    env = dict(os.environ if base_env is None else base_env)
    env["PDP10_PREFIX"] = str(overlay.resolve())
    return env
