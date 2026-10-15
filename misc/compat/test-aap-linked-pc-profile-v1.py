#!/usr/bin/env python3
"""Conservative linked-map attribution regression; never a gate pass."""
import importlib.util
from pathlib import Path
import tempfile
import os
spec = importlib.util.spec_from_file_location('pcprofile', Path(__file__).resolve().parents[2]/'tools/aap-linked-pc-profile-v1.py')
mod = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mod)
with tempfile.TemporaryDirectory(prefix='aap-linked-pc-profile-v1.', dir=os.environ.get('TMPDIR',str(Path.home()/'tmp'))) as folder:
    directory = Path(folder)
    symbols = directory/'kcore.map'
    trace = directory/'timing.log'
    symbols.write_text('first 001000\nsecond 001100\n')
    trace.write_text('AAP_TIMING_V1 IT0 tick=10 pc=001001 inst=201\nAAP_TIMING_V1 IT0 tick=20 pc=001101 inst=254\n')
    total, counts = mod.count(trace, mod.read_map(symbols))
    assert total == 2 and counts == {'first':1,'second':1}
    trace.write_text('AAP_TIMING_V1 IT0 tick=10 pc=001001 inst=XYZ\n')
    try: mod.count(trace, mod.read_map(symbols))
    except ValueError: pass
    else: raise AssertionError('malformed trace accepted')
    trace.write_text('only bootstrap summary, no guest PC events\n')
    try: mod.count(trace, mod.read_map(symbols))
    except ValueError: pass
    else: raise AssertionError('bootstrap summary accepted')
print('AAP linked map PC profiler v1: PASS (candidate-only attribution)')
