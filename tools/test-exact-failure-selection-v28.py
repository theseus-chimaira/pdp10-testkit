#!/usr/bin/env python3
"""Self-check the exact-cell failure replay manifest used by run-tests.py.

No compiler is invoked.  All scratch files live below TMPDIR (or
$HOME/tmp when TMPDIR is unset).  The active COMPILER_MATRIX.tsv still
owns the selected cell identity and the semantic pass/fail oracle.
"""
import importlib.util
import os
import sys
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
os.environ.setdefault('PDP10_PREFIX', str(Path.home() / 'cross'))
sys.path.insert(0, str(ROOT / 'tools'))
spec = importlib.util.spec_from_file_location(
    'p10_runner_selection_v28', str(ROOT / 'tools' / 'run-tests.py'))
runner = importlib.util.module_from_spec(spec)
spec.loader.exec_module(runner)

HEADER = 'test\tmachine\tcompiler\tprofile\tkind\tstatus\n'
SRC = 'tests/semantic/runtime/runtime-byte-pointer-diff.c'
CELL = (SRC, 'pdp6', 'gcc', 'gcc-base-o0', 'semantic')


def check_invalid(path, text, expected):
    path.write_text(text, encoding='ascii')
    try:
        runner.read_failure_cell_list(path)
    except ValueError as exc:
        assert expected in str(exc), (expected, str(exc))
    else:
        raise AssertionError('invalid input accepted: ' + expected)


def main():
    temp_parent = Path(os.environ.get('TMPDIR') or Path.home() / 'tmp')
    temp_parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='p10-failure-selection-v28-',
                                     dir=str(temp_parent)) as scratch:
        path = Path(scratch) / 'selection-v28.tsv'
        row = '\t'.join(CELL)
        path.write_text(HEADER + row + '\trun_fail\n', encoding='ascii')
        selection = runner.read_failure_cell_list(path)
        assert selection == set([CELL]), selection

        rows = [r for r in runner.split_rows() if r['test'] == SRC]
        semantic, other, missing, ignored = runner.build_cells(
            rows, runner.all_profiles())
        assert not missing and not ignored and not other
        present = set(runner.cell_key(source, cell)
                      for source, cell in semantic)
        assert CELL in present
        assert len(present & selection) == 1

        check_invalid(path, HEADER + row + '\tpass\n', 'not a failing')
        check_invalid(path, HEADER + row + '\trun_fail\n' +
                      row + '\ttimeout\n', 'duplicate')
        check_invalid(path, 'bad\theader\n', 'requires TSV fields')
        check_invalid(path, HEADER + '../bad.c\tpdp6\tgcc\t'
                      'gcc-base-o0\tsemantic\trun_fail\n', 'invalid source')
        check_invalid(path, HEADER, 'empty cell selection')

    print('Exact failure selection v28: PASS (identity, active matrix, '
          'duplicate, pass, malformed input, empty selection)')


if __name__ == '__main__':
    main()
