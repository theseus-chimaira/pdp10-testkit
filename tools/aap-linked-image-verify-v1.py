#!/usr/bin/env python3
"""Validate deposited PDP-6 linked image identity and trace entry evidence.

A verified DXR conversion is not a boot trace. Reject traces without a
real instruction fetch from the linked image outside low-core bootstrap.
"""
import argparse
import hashlib
from pathlib import Path
import re

DEPOSIT = re.compile(r'deposit ([0-7]{6}) ([0-7]{12})')
IT0 = re.compile(r'AAP_TIMING_V1 IT0 tick=(\d+) pc=([0-7]{6}) inst=([0-7]{3})')


def deposits(path):
    words = {}
    for line in Path(path).read_text().splitlines():
        match = DEPOSIT.fullmatch(line)
        if not match:
            if line.strip():
                raise ValueError('non-deposit record')
            continue
        address, value = (int(x, 8) for x in match.groups())
        if address in words:
            raise ValueError('duplicate image address')
        words[address] = value
    if not words:
        raise ValueError('empty linked image')
    return words


def verify(image, trace, minimum_text_pc=0o1000):
    image_words = deposits(image)
    total = 0
    fetched = set()
    for line in Path(trace).read_text().splitlines():
        if not line.startswith('AAP_TIMING_V1 IT0 '):
            continue
        match = IT0.fullmatch(line)
        if not match:
            raise ValueError('malformed instruction record')
        total += 1
        pc = int(match.group(2), 8)
        if pc >= minimum_text_pc and pc in image_words:
            fetched.add(pc)
    if not total:
        raise ValueError('no instruction-start trace')
    if not fetched:
        raise ValueError('no instruction starts in deposited linked image above low core')
    return total, fetched, hashlib.sha256(Path(image).read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('linked_image_deposits')
    parser.add_argument('aap_trace')
    args = parser.parse_args()
    total, fetched, digest = verify(args.linked_image_deposits, args.aap_trace)
    print('Candidate image-PC overlap: %d/%d distinct PCs/events' % (len(fetched), total))
    print('Deposit image SHA256:', digest)
    print('IMPORTANT: overlap alone does not prove image was actually loaded or PC belonged to code')


if __name__ == '__main__':
    main()
