#!/usr/bin/env python3
"""Verify Stage-1's five byte LSH/IOR reconstruction independent of PTR."""
import os,re,subprocess,tempfile,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2];sys.path.insert(0,str(ROOT/'tools'))
from aap_guest_console_v1 import run_guest
with tempfile.TemporaryDirectory(prefix='aap-ptr-assemble-v1.',dir=os.environ.get('TMPDIR',str(Path.home()/'tmp'))) as d:
 w=Path(d); emulator=w/'pdp6_n'
 subprocess.run([os.environ.get('CC','cc'),'-O2','-w','-o',str(emulator),*'main_net.c emu.c apr.c mem.c tty.c pt.c dc.c dt.c pclk.c netmem.c netcons.c cmd.c util.c threading.c rtc.c ../tools/pdp6common.c'.split(),'-lpthread','-lm'],cwd=ROOT.parent/'pdp6/emu',check=True)
 (w/'init.ini').write_text('mkdev apr apr166\nmkdev ptr ptr760\nmkdev fmem fmem162 0\nmkdev mem0 moby mem_0\nconnectmem fmem 0 apr -1\nconnectmem mem0 0 apr 0\n')
 source=w/'assemble-v1.s';source.write_text(''' .text
 .entry start
start: setz 3,
 movei 5,0
 lsh 3,010
 ior 3,5
 movei 5,0
 lsh 3,010
 ior 3,5
 movei 5,0
 lsh 3,010
 ior 3,5
 movei 5,054
 lsh 3,010
 ior 3,5
 movei 5,0144
 lsh 3,010
 ior 3,5
 movem 3,result
 halt 0
result: .word 0
''')
 dxr=w/'assemble-v1.dxr'
 subprocess.run([str(ROOT.parent/'das/das'),'-F','-K','-O',str(dxr),str(source)],check=True)
 # Extract 36-bit words from DXR via the documented converter in SIMH deposit mode.
 deposits=w/'assemble-v1.deposit';subprocess.run([str(ROOT.parent/'das/dxrconvert'),'--simh','-b','1000',str(dxr),str(deposits)],check=True)
 words={int(a,8):int(v,8) for a,v in re.findall(r'deposit ([0-7]+) ([0-7]+)',deposits.read_text())}
 last=max(words)
 output,trace,states=run_guest(emulator,w,words,[last],start_address=0o1000,timeout=9)
 print('synthetic reconstruction result:',re.findall(r'%06o: [0-7]{12}'%last,output), 'expected 000000026144')
 assert re.search(r'%06o: 000000026144'%last,output),output[-500:]
 print('AAP PTR five-byte LSH/IOR v1: PASS')
