#!/usr/bin/env python3
"""Produce auditable AAP execution provenance; no implied timing calibration.

Each profile is bound to a particular emulator executable, clean source
revision, simulator configuration, guest memory image and actual trace.
An uncommitted emulator source tree is rejected rather than silently
misidentified as its last committed revision.
"""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess


def digest(data):
    return hashlib.sha256(data).hexdigest()


def provenance(repo, emulator, config, words, trace):
    repo = Path(repo).resolve()
    def git(*args):
        return subprocess.run(['git', '-C', str(repo), *args], check=True,
                              capture_output=True, text=True).stdout.strip()
    if git('status', '--porcelain'):
        raise ValueError('dirty AAP source revision: cannot certify provenance')
    revision = git('rev-parse', 'HEAD')
    image = json.loads(Path(words).read_text())
    if not isinstance(image, dict) or not image:
        raise ValueError('guest words must be a nonempty address/word JSON object')
    image_words = {}
    for a, w in image.items():
        address, word = int(a, 8), int(w, 8)
        if address < 0 or address > 0o777777 or word < 0 or word >= (1 << 36):
            raise ValueError('invalid 18-bit guest address or 36-bit word')
        image_words[f'{address:06o}'] = f'{word:012o}'
    canonical = json.dumps(image_words, sort_keys=True, separators=(',', ':')).encode()
    return {'schema': 'pdp6-aap-provenance-v1',
            'source_commit': revision,
            'source_tree': digest(git('ls-tree', '-r', 'HEAD').encode()),
            'emulator_sha256': digest(Path(emulator).read_bytes()),
            'configuration_sha256': digest(Path(config).read_bytes()),
            'guest_image_sha256': digest(canonical),
            'trace_sha256': digest(Path(trace).read_bytes())}


def main():
    p = argparse.ArgumentParser(description=__doc__)
    for item in ('repo', 'emulator', 'config', 'words', 'trace', 'output'):
        p.add_argument(item)
    a = p.parse_args()
    record = provenance(a.repo, a.emulator, a.config, a.words, a.trace)
    Path(a.output).write_text(json.dumps(record, indent=2, sort_keys=True) + '\n')
    print('AAP provenance v1:', record['source_commit'], record['guest_image_sha256'])


if __name__ == '__main__':
    main()
