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
    subprocess.run([os.environ.get('CC','cc'),'-O2','-o',str(emulator),*SOURCES,'-lpthread','-lm'],cwd=ROOT.parent/'pdp6/emu',check=True)
    (w/'init.ini').write_text('mkdev apr apr166\nmkdev ptr ptr760 1\nmkdev fmem fmem162 0\nmkdev mem0 moby mem_0\nconnectio ptr apr\nconnectmem fmem 0 apr -1\nconnectmem mem0 0 apr 0\nmount ptr %s\n'% (MEDIA/'stage1-ptr-v1.pt'))
    commands=['power on','deposit 20 710600000060','deposit 21 710740000010','deposit 22 254000000021','deposit 23 710440000026','deposit 24 710740000010','deposit 25 254000000024','deposit 26 000000000000','deposit 27 254000000021','ptrmotor ptr on','start 20']
    with subprocess.Popen([str(emulator)],cwd=w,stdin=subprocess.PIPE,stdout=subprocess.PIPE,stderr=subprocess.DEVNULL,bufsize=0) as proc:
        def send(line):
            proc.stdin.write((line+'\n').encode());proc.stdin.flush()
        for command in commands:send(command)
        # Reader Stage-1 loads its code via the authentic RIM bootstrap.
        # Give it time to reach the waiting loop before replacing media.
        deadline=time.monotonic()+3
        while time.monotonic()<deadline:
            send('examine 275')
            try:
                read_until(proc,WORD,0.4)
            except TimeoutError: pass
            time.sleep(0.08)
        send('unmount ptr');send('mount ptr %s'%(MEDIA/'ptr-boot1-v1.pt'))
        deadline=time.monotonic()+15
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
            checks+=1
            time.sleep(0.1)
        if first_complete:
            send('unmount ptr');send('mount ptr %s'%(MEDIA/'ptr-boot2-v1.pt'))
            print('PTR first counted payload completed; switched to tape 2 on stage_ptr state')
        else:
            print('PTR first payload INCOMPLETE within bounded interval; tape 2 deliberately not mounted; polls=%d'%checks)
        send('quit')
        try:proc.communicate(timeout=2)
        except subprocess.TimeoutExpired:proc.kill();proc.communicate()
print('KINIT/KCORE/MRES execution NOT VERIFIED')
