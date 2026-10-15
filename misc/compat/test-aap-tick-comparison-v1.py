#!/usr/bin/env python3
"""Reject non-equivalent AAP cost profiles and timing regressions."""
import json
from pathlib import Path
import subprocess
import sys
import tempfile


def main(comparator):
    with tempfile.TemporaryDirectory() as directory:
        base, candidate = (Path(directory) / name for name in ('base.json', 'candidate.json'))
        p = {'schema': 'pdp6-aap-tick-cost-v1',
             'unit': 'AAP logical pulse-delay ticks',
             'method': 'consecutive IT0 interval',
             'terminal_instruction_unmeasured': True,
             'workload_id': 'same-correctness-case-v1',
             'model_id': 'aap-revision-fmem-core-v1',
             'intervals': [{'ticks': 100}, {'ticks': 200}],
             'complete_intervals': 2, 'total_complete_ticks': 300}
        base.write_text(json.dumps(p))
        p['intervals'] = [{'ticks': 150}, {'ticks': 170}]
        p['total_complete_ticks'] = 320
        candidate.write_text(json.dumps(p))

        def run(*extra):
            return subprocess.run([sys.executable, str(comparator), str(base),
                                   str(candidate), *extra],
                                  capture_output=True, text=True).returncode

        assert run() == 1
        assert run('--max-regression-pct', '7') == 0
        p['model_id'] = 'different-machine'
        candidate.write_text(json.dumps(p))
        assert run('--max-regression-pct', '99') != 0
        p['model_id'] = 'aap-revision-fmem-core-v1'
        p['total_complete_ticks'] = 1
        candidate.write_text(json.dumps(p))
        assert run('--max-regression-pct', '99') != 0
    print('AAP tick cost comparison v1: PASS')


if __name__ == '__main__':
    main(Path(__file__).resolve().parents[2] / 'tools/compare-aap-tick-cost-v1.py')
