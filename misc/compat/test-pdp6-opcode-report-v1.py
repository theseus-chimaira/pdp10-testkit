#!/usr/bin/env python3
"""Check decimal SIMH counters, aggregate totals and partial timing coverage."""
import pathlib
import subprocess
import sys
import tempfile


def main(reporter):
    with tempfile.TemporaryDirectory() as d:
        sample = pathlib.Path(d) / 'sample.out'
        sample.write_text('''__P10RUN_OPCODE_PROFILE__
OPCOUNT[0]-OPCOUNT[127]: same as above
OPCOUNT[128]: 00000000000000000010
OPCOUNT[129]-OPCOUNT[170]: same as above
OPCOUNT[171]: 00000000000000000020
OPCOUNT[172]: 00000000000000000030
OPCOUNT[173]-OPCOUNT[511]: same as above
''')
        result = subprocess.run([sys.executable, reporter, str(sample)],
                                capture_output=True, text=True, check=True)
        assert 'Executed opcode dispatches: 60' in result.stdout
        assert 'CPU timing: unavailable' in result.stdout
    print('pdp6 opcode report v1: PASS')


if __name__ == '__main__':
    if len(sys.argv) != 2:
        raise SystemExit('usage: test-pdp6-opcode-report-v1.py REPORTER')
    main(sys.argv[1])
