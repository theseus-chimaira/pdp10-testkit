#!/usr/bin/env python3
"""Check that the original KL10 assembly fixture's DAS syntax port assembles.

This is an assembly-only harness check, not a linked/runtime semantic pass.
"""
import hashlib
import os
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
ORIGINAL = ROOT / 'tests/semantic/upstream/support/920428-1.s'
PORT = ROOT / 'tests/isa/das-port/920428-1-das-v1.s'
SHA256 = '747162b74215e1176b7031671da7d24012ffbaa508bbc3a6caf1f3fcc8f86ead'


def main():
    if hashlib.sha256(ORIGINAL.read_bytes()).hexdigest() != SHA256:
        raise ValueError('original source changed')
    tmpdir = Path(os.environ.get('TMPDIR') or (Path.home() / 'tmp'))
    tmpdir.mkdir(parents=True, exist_ok=True)
    target = tmpdir / 'p10tk-920428-1-das-port-v1.dobj'
    if target.exists():
        target.unlink()
    cmd = ['das', '-C', '-O', str(target), str(PORT)]
    result = subprocess.run(cmd, cwd=ROOT, check=False)
    if result.returncode or not target.is_file() or target.stat().st_size == 0:
        print('FAIL: DAS syntax port did not produce DOBJ', file=sys.stderr)
        return 1
    print('PASS: DAS syntax port assembled into DOBJ (%d bytes)' %
          target.stat().st_size)
    print('NOT TESTED: linkage, KL10 execution, or semantic behavior')
    return 0


if __name__ == '__main__':
    sys.exit(main())
