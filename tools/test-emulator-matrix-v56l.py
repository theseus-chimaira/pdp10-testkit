#!/usr/bin/env python3
"""Verify matrix admission, deposit parsing and real KLH10 exit oracles."""
import importlib.util
import os
from pathlib import Path
import tempfile

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('replay',ROOT/'tools/run-emulator-matrix-v56l.py')
m = importlib.util.module_from_spec(spec)
spec.loader.exec_module(m)


def main():
    caps=m.capabilities()
    support={}
    for c in caps:
        support.setdefault(c['emulator'],set()).add(c['cpu'])
    assert support=={'simh':{'pdp6','ka10','ki10','ks10','kl10a','kl10b'},
                     'klh10':{'ks10','kl10b'},'kx10':{'kl10b'},
                     'ts10':{'ks10','kl10a','kl10b'}}
    assert {c['emulator'] for c in caps if c['cpu']=='kl10b' and c['address_model']=='extended'}==set(support)
    admitted=m.canonical_cells()
    assert set(k[2] for k in admitted)=={'gcc','kcc'}
    assert any(k[1]=='ks10' and k[2]=='kcc' for k in admitted)
    tmp=Path(os.environ.get('TMPDIR') or Path.home()/'tmp');tmp.mkdir(parents=True,exist_ok=True)
    root=Path(tempfile.mkdtemp(prefix='pdp10-emulator-matrix-v56l-',dir=tmp))
    run=root/'run';run.mkdir()
    # MOVEI/MOVEM/HALT with a poisoned result word and nonzero oracle.
    image=run/'smoke.simh';image.write_text('deposit 000100 201040000123\ndeposit 000101 202040000200\ndeposit 000102 254200000000\ndeposit 000200 000000000777\n')
    script=run/'smoke-run.ini';valid='do smoke.simh\ndeposit PC 100\necho __P10RUN_EXPECT__ __test_exit 200 000000000123\nexamine 200\n';script.write_text(valid)
    mem,entry,want,ih,oh=m.image_contract({},root)
    assert entry==0o100 and want=={0o200:0o123} and ih==m.sha(image.read_bytes())
    for bad in (valid.replace('do smoke.simh','do other.simh'),valid.replace('examine 200','examine 201'),valid.replace('__test_exit','other')):
        script.write_text(bad)
        try:m.image_contract({},root)
        except ValueError:pass
        else:raise AssertionError('malformed contract accepted')
    script.write_text(valid)
    for cpu in ('ks10','kl10b'):
        cap=next(c for c in caps if c['cpu']==cpu and c['emulator']=='klh10' and c['address_model']=='local')
        exe=m.executable(cap)
        for name,expected,outcome in [('positive',want,'pass'),('negative',{0o200:0o124},'run_fail')]:
            work=root/(cpu+'-'+name);work.mkdir()
            status,detail,log=m.klh10_local(exe,work,mem,entry,expected,20)
            assert status==outcome,(cpu,status,detail,log)
            print(f'PASS {cpu} {name}: {status}; {log}',flush=True)
    print('PASS emulator matrix admission and independent positive/negative controls',flush=True)


if __name__=='__main__':main()
