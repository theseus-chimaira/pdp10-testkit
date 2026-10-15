#!/usr/bin/env python3
"""Linked-image candidate evidence rejects bootstrap-only traces."""
from pathlib import Path
import importlib.util
import tempfile
import os
spec = importlib.util.spec_from_file_location('v', Path(__file__).resolve().parents[2]/'tools/aap-linked-image-verify-v1.py')
v = importlib.util.module_from_spec(spec)
spec.loader.exec_module(v)
with tempfile.TemporaryDirectory(prefix='aap-linked-image-verify-v1.', dir=os.environ.get('TMPDIR',str(Path.home()/'tmp'))) as d:
    img, trace = Path(d)/'image',Path(d)/'trace'
    img.write_text('deposit 001000 201040000001\ndeposit 001001 254200000000\n')
    trace.write_text('AAP_TIMING_V1 IT0 tick=10 pc=000100 inst=201\n')
    try: v.verify(img,trace)
    except ValueError: pass
    else: raise AssertionError('bootstrap-only trace accepted')
    trace.write_text('AAP_TIMING_V1 IT0 tick=10 pc=001000 inst=201\n')
    count,pcs,digest=v.verify(img,trace)
    assert count==1 and pcs=={0o1000} and len(digest)==64
    img.write_text('deposit 001000 201040000001\ndeposit 001000 254200000000\n')
    try: v.deposits(img)
    except ValueError: pass
    else: raise AssertionError('duplicate image address accepted')
print('AAP linked image candidate verification: PASS')
