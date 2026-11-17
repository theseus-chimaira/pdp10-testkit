#!/usr/bin/env python3
"""Verify byte-preserving special KCC diagnostic capture.

KCC may emit a raw 0xff source-excerpt sentinel.  The harness must not
turn it into a UnicodeDecodeError or lose the compiler's exit status.
"""

import os
from pathlib import Path
import sys
import tempfile


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
from kcc_special_checks import _compile


def main():
    tmpdir = Path(os.environ.get('TMPDIR') or (Path.home() / 'tmp'))
    tmpdir.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='kcc-special-decode-v1-',
                                     dir=tmpdir) as path:
        work = Path(path)
        compiler = work / 'fake-kcc-v1'
        compiler.write_text(
            '#!' + sys.executable + '\n'
            'import sys\n'
            'sys.stdout.buffer.write(b"test.c:7: [Warning] source byte '
            '\\xff\\n")\n'
            'sys.exit(1 if "-x=ka10" in sys.argv else 0)\n',
            encoding='ascii')
        compiler.chmod(0o700)
        expected = b'test.c:7: [Warning] source byte \xff\n'
        for target, returncode in (('pdp6', 0), ('ka10', 1)):
            actual_rc, message = _compile(compiler, work, 'test.c',
                                          target, 'out')
            if actual_rc != returncode or message.encode('latin-1') != expected:
                raise AssertionError('KCC diagnostic bytes/exit lost: ' +
                                     target)
    print('KCC special diagnostic capture: PASS (raw 0xff, exit 0/1)')


if __name__ == '__main__':
    main()
