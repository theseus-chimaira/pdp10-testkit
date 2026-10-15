#!/usr/bin/env python3
"""Unit tests for strict AAP instruction-start timing intervals."""
import importlib.util
import pathlib
import sys
import tempfile


def main(reporter):
    spec = importlib.util.spec_from_file_location('aap_tick_cost', reporter)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    with tempfile.TemporaryDirectory() as directory:
        trace = pathlib.Path(directory) / 'trace.txt'
        trace.write_text('''AAP_TIMING_V1 IT0 tick=601 pc=001000 inst=000
AAP_TIMING_V1 ET0A tick=1302 pc=001000 inst=201
AAP_TIMING_V1 IT0 tick=2002 pc=001001 inst=201
AAP_TIMING_V1 ET0A tick=3103 pc=001001 inst=271
AAP_TIMING_V1 IT0 tick=3953 pc=001002 inst=271
AAP_TIMING_V1 ET0A tick=4654 pc=001002 inst=254
''')
        measured = module.intervals(trace)
        assert [(x['opcode_octal'], x['ticks']) for x in measured] == [
            ('201', 1401), ('271', 1951)]
        assert len(measured) == 2  # halt has no next instruction boundary
        trace.write_text('''AAP_TIMING_V1 IT0 tick=100 pc=001000 inst=000
AAP_TIMING_V1 ET0A tick=200 pc=001000 inst=256
AAP_TIMING_V1 ET0A tick=300 pc=001000 inst=201
AAP_TIMING_V1 IT0 tick=500 pc=001001 inst=201
AAP_TIMING_V1 ET0A tick=650 pc=001001 inst=254
''')
        measured = module.intervals(trace)
        assert measured[0]['opcode_octal'] == '256'
        assert measured[0]['nested_opcodes_octal'] == ['201']
        assert measured[0]['ticks'] == 400
        trace.write_text('''AAP_TIMING_V1 IT0 tick=100 pc=001000 inst=000
AAP_TIMING_V1 ET0A tick=200 pc=001000 inst=256
AAP_TIMING_V1 IT0 tick=500 pc=001001 inst=256
AAP_TIMING_V1 ET0A tick=650 pc=001001 inst=254
''')
        try:
            module.intervals(trace)
        except ValueError:
            pass
        else:
            raise AssertionError('unfinished XCT accepted')
        # A nested XCT must be attributed to one outer instruction,
        # and an unfinished or mismatched nesting chain must be rejected.
        trace.write_text('AAP_TIMING_V1 IT0 tick=100 pc=001000 inst=000\nAAP_TIMING_V1 ET0A tick=200 pc=001000 inst=256\nAAP_TIMING_V1 ET0A tick=300 pc=001000 inst=256\nAAP_TIMING_V1 ET0A tick=400 pc=001000 inst=201\nAAP_TIMING_V1 IT0 tick=700 pc=001001 inst=201\nAAP_TIMING_V1 ET0A tick=800 pc=001001 inst=254\n')
        nested = module.intervals(trace)
        assert len(nested) == 1
        assert nested[0]['nested_opcodes_octal'] == ['256', '201']
        assert nested[0]['ticks'] == 600
        for invalid in (
            'AAP_TIMING_V1 IT0 tick=100 pc=001000 inst=000\nAAP_TIMING_V1 ET0A tick=200 pc=001000 inst=256\nAAP_TIMING_V1 ET0A tick=300 pc=001000 inst=256\n',
            'AAP_TIMING_V1 IT0 tick=100 pc=001000 inst=000\nAAP_TIMING_V1 ET0A tick=200 pc=001000 inst=256\nAAP_TIMING_V1 ET0A tick=300 pc=001002 inst=201\n',
        ):
            trace.write_text(invalid)
            try:
                module.intervals(trace)
            except ValueError:
                pass
            else:
                raise AssertionError('invalid nested XCT trace accepted')
        trace.write_text('AAP_TIMING_V1 IT0 tick=2 pc=001000 inst=000\n')
        try:
            module.intervals(trace)
        except ValueError:
            pass
        else:
            raise AssertionError('unpaired trace accepted')
    print('AAP tick interval calculation v1: PASS')


if __name__ == '__main__':
    reporter = (pathlib.Path(sys.argv[1]) if len(sys.argv) > 1 else
                pathlib.Path(__file__).resolve().parents[2] / 'tools/aap-tick-cost-v1.py')
    main(reporter.resolve())
