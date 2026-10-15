#!/usr/bin/env python3
"""Test hash bindings and source integrity on an actual PDP-6 guest trace."""
import importlib.util
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[2]
AAP = Path(os.environ.get('PDP6_AAP_ROOT', str(ROOT.parent / 'pdp6')))
sys.path.insert(0, str(ROOT / 'tools'))
from aap_guest_console_v1 import run_guest


def load():
    spec = importlib.util.spec_from_file_location('provenance', ROOT / 'tools/aap-profile-provenance-v1.py')
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main():
    module = load()
    with tempfile.TemporaryDirectory(prefix='aap-provenance-v1.',
             dir=os.environ.get('TMPDIR', str(Path.home() / 'tmp'))) as name:
        work = Path(name)
        emulator = work / 'pdp6_n'
        sources = ['main_net.c', 'emu.c', 'apr.c', 'mem.c', 'tty.c', 'pt.c', 'dc.c',
                   'dt.c', 'pclk.c', 'netmem.c', 'netcons.c', 'cmd.c', 'util.c',
                   'threading.c', 'rtc.c', '../tools/pdp6common.c']
        subprocess.run([os.environ.get('CC', 'cc'), '-O2', '-o', str(emulator)] +
                       sources + ['-lpthread', '-lm'], cwd=AAP / 'emu', check=True)
        config = work / 'init.ini'
        config.write_text('mkdev apr apr166\nmkdev ptr ptr760\n'
                          'mkdev fmem fmem162 0\nmkdev mem0 moby mem_0\n'
                          'connectmem fmem 0 apr -1\nconnectmem mem0 0 apr 0\n')
        words = {0o1000: (0o201 << 27) | (1 << 23) | 7,
                 0o1001: (0o202 << 27) | (1 << 23) | 0o1020,
                 0o1002: 0o254200000000}
        out, trace, states = run_guest(emulator, work, words, [0o1020])
        assert states[-1] == 'HALTED' and '001020: 000000000007' in out
        tracefile = work / 'actual.trace'
        tracefile.write_text(trace)
        image = work / 'guest.json'
        image.write_text(json.dumps({f'{a:o}': f'{w:o}' for a, w in words.items()}))
        base = module.provenance(AAP, emulator, config, image, tracefile)
        assert len(base['source_commit']) == 40
        assert len({base[k] for k in ('emulator_sha256', 'configuration_sha256',
                   'guest_image_sha256', 'trace_sha256')}) == 4
        config.write_text(config.read_text() + '# changed config\n')
        assert module.provenance(AAP, emulator, config, image, tracefile)['configuration_sha256'] != base['configuration_sha256']
        config.write_text(config.read_text().replace('# changed config\n', ''))
        image.write_text(json.dumps({**json.loads(image.read_text()), '1021': '1'}))
        assert module.provenance(AAP, emulator, config, image, tracefile)['guest_image_sha256'] != base['guest_image_sha256']
        tracefile.write_text(trace + '# changed trace\n')
        assert module.provenance(AAP, emulator, config, image, tracefile)['trace_sha256'] != base['trace_sha256']
        print('AAP real-guest source/config/binary/image/trace provenance v1: PASS')


if __name__ == '__main__':
    main()
