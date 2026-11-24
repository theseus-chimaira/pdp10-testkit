#!/usr/bin/env python3
"""Small host-side tests for archived optimization audit."""
import importlib.util
from pathlib import Path
import struct
import tempfile

spec = importlib.util.spec_from_file_location(
    'audit', Path(__file__).with_name('audit-optimization-quality-v1.py'))
audit = importlib.util.module_from_spec(spec)
spec.loader.exec_module(audit)


def main():
    with tempfile.TemporaryDirectory() as d:
        p = Path(d) / 'test.dobj'
        p.write_bytes(struct.pack('<5Q', audit.MAGIC, (7 << 18) | 2,
                                  3 << 18, 0, 0) + b'\0' * 72)
        assert audit.read_object(p) == (7, 2, 3)
        p.write_bytes(b'\0' * 40)
        try:
            audit.read_object(p)
        except ValueError:
            pass
        else:
            raise AssertionError('bad magic accepted')
    base = dict(run='r', test='t.c', compiler='gcc', machine='pdp6',
                family='gcc-pdp6', kind='semantic', status='pass',
                library='same', words='20', text='18', ticks='40', opt='o0')
    rows = [base, dict(base, opt='o1', ticks='30'),
            dict(base, opt='o2', ticks='35'),
            dict(base, opt='os', words='18', text='15', ticks='40')]
    c = {(r['candidate'], r['metric']): r['verdict']
         for r in audit.comparisons(rows)}
    assert c == {('o1', 'ticks'): 'improved', ('o2', 'ticks'): 'regressed',
                 ('os', 'ticks'): 'equal', ('os', 'words'): 'improved',
                 ('os', 'text'): 'improved'}
    rows[1]['library'] = 'other'
    assert next(audit.comparisons(rows))['verdict'] == 'library_unverified'
    assert audit.result('', '3') == 'missing'
    print('optimization audit self-test PASS')


if __name__ == '__main__':
    main()
