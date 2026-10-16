#!/usr/bin/env python3
"""Bounded real AAP PTR media handoff, driven by stage-one memory state.

The stage_ptr word remains zero until the entire first counted payload is
copied. Never advance to tape 2 merely because a wall-clock delay elapsed.
This diagnostic reports incomplete transfers without claiming kernel boot.
"""
import os
import re
import select
import subprocess
import tempfile
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
MEDIA = Path(os.environ.get('AAP_ALT_BOOT_OUT',os.environ.get('TMPDIR',str(Path.home()/'tmp'))+'/aap-alt-stage1-media-v1'))
SOURCES = 'main_net.c emu.c apr.c mem.c tty.c pt.c dc.c dt.c pclk.c netmem.c netcons.c cmd.c util.c threading.c rtc.c ../tools/pdp6common.c'.split()
STAGE_PTR = 0o275  # DAS label stage_ptr=0215 relative to stage1 load base 060
WORD = re.compile(rb'000275: ([0-7]{12})')

def read_until(proc, match, seconds):
    end = time.monotonic()+seconds
    pending=b''
    while time.monotonic()<end:
        ready,_,_=select.select([proc.stdout],[],[],min(0.5,max(0,end-time.monotonic())))
        if ready:
            chunk=os.read(proc.stdout.fileno(),4096)
            if not chunk:raise RuntimeError('console closed')
            pending+=chunk
            if match.search(pending):return pending
            if len(pending)>65536:pending=pending[-16384:]
    raise TimeoutError('no stage-one memory readback')

with tempfile.TemporaryDirectory(prefix='aap-ptr-handoff-v1.',dir=os.environ.get('TMPDIR',str(Path.home()/'tmp'))) as d:
    w=Path(d)
    emulator=w/'pdp6_n'
    # Diagnostic-only copy: do not alter the emulator repository.
    source=(ROOT.parent/'pdp6/emu/pt.c').read_text()
    source=source.replace('n = read(ptr->fd, &c, 1);', '''n = read(ptr->fd, &c, 1);
    if(n == 1){ static unsigned samples; if((samples++ < 16) || (ptr->fd >= 0 && lseek(ptr->fd,0,SEEK_CUR) <= 5))
        fprintf(stderr,"PTR_RAW_V1 sample=%u offset=%ld octet=%03o\\n",samples,(long)lseek(ptr->fd,0,SEEK_CUR),c); }''')
    source=source.replace('bus->c12 |= ptr->ptr;', '''{ static unsigned samples; if((samples++ < 16) || (ptr->fd >= 0 && lseek(ptr->fd,0,SEEK_CUR) <= 5))
                fprintf(stderr,"PTR_DATAI_V1 sample=%u offset=%ld data=%012lo flag=%d busy=%d\\n",samples,(long)(ptr->fd >= 0 ? lseek(ptr->fd,0,SEEK_CUR) : -1),ptr->ptr,ptr->flag,ptr->busy);
            bus->c12 |= ptr->ptr; }''')
    (w/'ptr-diag-v1.c').write_text(source)
    subprocess.run([os.environ.get('CC','cc'),'-O2','-I',str(ROOT.parent/'pdp6/emu'),'-o',str(emulator),*[(str(w/'ptr-diag-v1.c') if name=='pt.c' else name) for name in SOURCES],'-lpthread','-lm'],cwd=ROOT.parent/'pdp6/emu',check=True)
    (w/'init.ini').write_text('mkdev apr apr166\nmkdev ptr ptr760 1\nmkdev fmem fmem162 0\nmkdev mem0 moby mem_0\nconnectio ptr apr\nconnectmem fmem 0 apr -1\nconnectmem mem0 0 apr 0\nmount ptr %s\n'% Path(os.environ.get('AAP_PTR_STAGE1_TAPE',str(MEDIA/'stage1-ptr-no-trailer-v2.pt'))))
    commands=['power on','deposit 20 710600000060','deposit 21 710740000010','deposit 22 254000000021','deposit 23 710440000026','deposit 24 710740000010','deposit 25 254000000024','deposit 26 000000000000','deposit 27 254000000021','ptrmotor ptr on','start 20']
    trace_file = (w/'stage1-aap-v1.trace').open('w+b')
    env=dict(os.environ,PDP6_AAP_TIMING_TRACE_V1='1')
    with subprocess.Popen([str(emulator)],cwd=w,stdin=subprocess.PIPE,stdout=subprocess.PIPE,stderr=trace_file,env=env,bufsize=0) as proc:
        def send(line):
            proc.stdin.write((line+'\n').encode());proc.stdin.flush()
        for command in commands:send(command)
        # Advance only after a genuine AAP instruction-start at the
        # Stage-1 entry, not a wall-clock delay or an unverified marker.
        deadline=time.monotonic()+8
        ready=False
        while time.monotonic()<deadline:
            trace_file.flush()
            text=(w/'stage1-aap-v1.trace').read_text(errors='replace')
            if text.count('pc=000146 ') >= 10:
                ready=True
                break
            time.sleep(0.05)
        assert ready, 'AAP trace did not confirm Stage-1 entry; refuse tape swap'
        print('Stage-1 first-byte wait observed repeatedly at PC 000146')
        send('unmount ptr');send('mount ptr %s'%(MEDIA/'ptr-boot1-v1.pt'))
        # Linux/Termux exposes the real mounted reader's consumed byte
        # count in /proc/PID/fdinfo. This is read-only instrumentation.
        def reader_offset():
            fdroot=Path('/proc')/str(proc.pid)/'fd'
            try:
                for fd in fdroot.iterdir():
                    try:
                        target=os.readlink(fd)
                        if target.endswith('ptr-boot1-v1.pt'):
                            info=(fdroot.parent/'fdinfo'/fd.name).read_text()
                            match=re.search(r'^pos:\s*(\d+)', info, re.M)
                            return int(match.group(1)) if match else None
                    except (OSError, ValueError):
                        continue
            except (OSError, PermissionError):
                pass
            return None
        maximum_offset=0
        deadline=time.monotonic()+32
        first_complete=False
        checks=0
        while time.monotonic()<deadline:
            send('examine 275')
            try:
                output=read_until(proc,WORD,0.8)
                values=WORD.findall(output)
                if values and int(values[-1],8):
                    first_complete=True;break
            except TimeoutError:pass
            offset=reader_offset()
            if offset is not None:
                maximum_offset=max(maximum_offset,offset)
            checks+=1
            time.sleep(0.1)
        print('PTR payload1 consumed bytes (maximum observed): %d / %d' % (maximum_offset, (MEDIA/'ptr-boot1-v1.pt').stat().st_size))
        if first_complete:
            send('unmount ptr');send('mount ptr %s'%(MEDIA/'ptr-boot2-v1.pt'))
            print('PTR first counted payload completed; switched to tape 2 on stage_ptr state')
            second_deadline=time.monotonic()+24
            while time.monotonic()<second_deadline:
                trace=(w/'stage1-aap-v1.trace').read_text(errors='replace')
                # Stage1 handoff is relocated octal 0172 + 0060 = 0252.
                if 'pc=000252 ' in trace:
                    print('PTR second payload Stage-1 handoff reached PC 000252')
                    break
                time.sleep(0.1)
            else:
                print('PTR second payload handoff NOT OBSERVED in bounded interval')
        else:
            print('PTR first payload INCOMPLETE within bounded interval; tape 2 deliberately not mounted; polls=%d'%checks)
        from collections import Counter
        pcs=Counter(re.findall(r'AAP_TIMING_V1 IT0 tick=\d+ pc=([0-7]{6})', (w/'stage1-aap-v1.trace').read_text(errors='replace')))
        print('AAP top executed PCs:',pcs.most_common(15))
        print('Device trace:',re.findall(r'PTR_(?:RAW|DATAI)_V1[^\n]*',(w/'stage1-aap-v1.trace').read_text(errors='replace'))[-25:])
        events=re.findall(r'AAP_TIMING_V1 IT0 tick=\d+ pc=([0-7]{6}) inst=([0-7]{3})',(w/'stage1-aap-v1.trace').read_text(errors='replace'))
        print('Final PCs:',events[-22:])
        send('cpustatus')
        try:
            status=read_until(proc,re.compile(rb'APR_STATUS_V1 (?:HALTED|RUNNING|START_PENDING)'),1)
            print('CPU status:',re.findall(rb'APR_STATUS_V1 [A-Z_]+',status)[-1:])
        except TimeoutError: print('CPU status: unresponsive')
        for address in ('2','3','5','100','274','275','276'):
            send('examine '+address)
        send('quit')
        try:
            output,_=proc.communicate(timeout=2)
            print('Post-halt readbacks:',re.findall(rb'[0-7]{6}: [0-7]{12}', output)[-10:])
        except subprocess.TimeoutExpired:proc.kill();proc.communicate()
trace_file.close()
print('KINIT/KCORE/MRES execution NOT VERIFIED')
