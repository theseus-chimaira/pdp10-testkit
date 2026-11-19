#!/usr/bin/env python3
"""Fail-closed compiler/assembler versus DAIMOS OS test ownership audit.

Standalone compiler, assembler, linker, optimizer and ISA assertions belong
to pdp10-testkit; boot-backed native KCC/DAS/DLINK integration suites and OS
assertions belong to daimos-testkit. The historical split and 71-file return
are tracked separately so no source is owned by both repositories.
The source-hash-pinned transfer manifest records every moved/deduplicated
original; this audit never executes a guest or modifies either repository.
"""

import argparse
from collections import Counter
import csv
import hashlib
import os
from pathlib import Path
import re
import sys


PDP10 = Path(__file__).resolve().parents[1]
MANIFEST = PDP10 / 'docs/TESTKIT-SCOPE-MIGRATION-20261117-v3.tsv'
RETURN = PDP10 / 'docs/NATIVE-TOOLCHAIN-RETURN-20261119-v4.tsv'
KINIT_RETURN = PDP10 / 'docs/DAIMOS-KINIT-CODEGEN-RETURN-20261119-v1.tsv'
RETURN_FIELDS = ('old_path', 'new_path', 'source_sha256', 'original_sha256')
FIELDS = ('before', 'after', 'old_path', 'new_path',
          'original_sha256', 'resolution')


def safe_path(root, name):
    target = (root / name).resolve()
    if not target.is_relative_to(root.resolve()):
        raise ValueError('unsafe test ownership path: ' + name)
    return target


def audit(daimos):
    errors = []
    with MANIFEST.open(encoding='ascii', newline='') as file:
        rows = list(csv.DictReader(file, delimiter='\t'))
    if len(rows) != 150 or not rows or tuple(rows[0]) != FIELDS:
        errors.append('unexpected migration manifest structure/census')

    with RETURN.open(encoding='ascii', newline='') as file:
        ret = list(csv.DictReader(file, delimiter='\t'))
    if len(ret) != 71 or not ret or tuple(ret[0]) != RETURN_FIELDS:
        errors.append('unexpected native return manifest structure/census')
    reversed_paths = {row['old_path']: row for row in ret}
    if len(reversed_paths) != len(ret):
        errors.append('duplicate returned source paths')
    historical = {row['new_path']: row for row in rows}
    # A later source-owner correction moves one DAIMOS KINIT integration
    # check back into the OS testkit.  Retain all original v3/v4 ledgers;
    # this is a separate exact, checksum-pinned re-home, not a wildcard.
    with KINIT_RETURN.open(encoding='ascii', newline='') as file:
        rereleased = list(csv.DictReader(file, delimiter='\t'))
    if (len(rereleased) != 1 or not rereleased or
            tuple(rereleased[0]) != ('old_path', 'new_path',
            'original_sha256', 'current_sha256', 'basis')):
        errors.append('wrong KINIT ownership return manifest')
    kinit_old = 'misc/validation/daimos-kcc-pdp6-codegen-v1.sh'
    kinit_new = 'tests/validation/daimos-kinit-pdp6-stack-codegen-v1.sh'
    if rereleased:
        kinit = rereleased[0]
        old_edge = historical.get(kinit_old)
        if (kinit['old_path'] != kinit_old or
                kinit['new_path'] != kinit_new or
                kinit['basis'] != 'tag-only-rename' or
                old_edge is None or old_edge['before'] != 'daimos-testkit' or
                old_edge['after'] != 'pdp10-testkit' or
                kinit['original_sha256'] != old_edge['original_sha256']):
            errors.append('invalid KINIT ownership return edge')
        if (PDP10 / kinit_old).exists():
            errors.append('KINIT test still owned by compiler testkit')
        if daimos is not None:
            source = safe_path(daimos, kinit_new)
            if not source.is_file():
                errors.append('missing DAIMOS-owned KINIT test')
            else:
                content = source.read_bytes()
                if (hashlib.sha256(content).hexdigest() !=
                        kinit['current_sha256'] or
                        hashlib.sha256(content.replace(
                        b'tag=daimos-kinit-pdp6-stack-codegen-v1',
                        b'tag=daimos-kcc-pdp6-codegen-v1')).hexdigest() !=
                        kinit['original_sha256']):
                    errors.append('KINIT migrated test changed assertions')
    for row in ret:
        original = historical.get(row['old_path'])
        if (original is None or original['before'] != 'daimos-testkit' or
                original['after'] != 'pdp10-testkit' or
                original['old_path'] != row['new_path'] or
                original['original_sha256'] != row['original_sha256']):
            errors.append('invalid native return edge: ' + row['old_path'])
        if not re.fullmatch('[0-9a-f]{64}', row['source_sha256']):
            errors.append('invalid returned source SHA256: ' + row['old_path'])
    if daimos is not None:
        remote = daimos / 'tests/validation/NATIVE-TOOLCHAIN-RETURN-20261119-v4.tsv'
        if not remote.is_file() or remote.read_bytes() != RETURN.read_bytes():
            errors.append('native return manifests differ between testkits')

    direction = Counter()
    seen = set()
    for row in rows:
        before = row['before']
        after = row['after']
        direction[(before, after, row['resolution'])] += 1
        if (before, after) not in ((
                'daimos-testkit', 'pdp10-testkit'),
                ('pdp10-testkit', 'daimos-testkit')):
            errors.append('invalid ownership transfer: ' + before + ' -> ' + after)
            continue
        old = row['old_path']
        new = row['new_path']
        if (before, old) in seen:
            errors.append('duplicate source owner: ' + before + '/' + old)
        seen.add((before, old))
        digest = row['original_sha256']
        if not re.fullmatch('[0-9a-f]{64}', digest):
            errors.append('invalid original source SHA256: ' + old)
        returned = reversed_paths.get(new)
        if returned is not None:
            # v3 was a valid historical transfer, later reversed by v4.
            # Its old DAIMOS file is now authoritative again.
            if (PDP10 / new).exists():
                errors.append('returned file still in compiler testkit: ' + new)
            if daimos is not None:
                target = safe_path(daimos, old)
                if not target.is_file():
                    errors.append('missing returned native file: ' + old)
                elif (target.suffix.lower() in ('.c', '.s') and
                      hashlib.sha256(target.read_bytes()).hexdigest() != digest):
                    errors.append('returned C/ASM fixture changed: ' + old)
            continue
        if new == kinit_old:
            # The exact v5 return above separately checks its new owner,
            # original content, renamed diagnostic tag and absence here.
            continue
        source_root = daimos if before == 'daimos-testkit' else PDP10
        target_root = daimos if after == 'daimos-testkit' else PDP10
        if source_root is not None:
            try:
                if safe_path(source_root, old).exists():
                    errors.append('migrated source still in old owner: ' + old)
            except ValueError as error:
                errors.append(str(error))
        if target_root is not None:
            try:
                target = safe_path(target_root, new)
                if not target.is_file():
                    errors.append('missing relocated test: ' + new)
                elif (target.suffix.lower() in ('.c', '.s') and
                      hashlib.sha256(target.read_bytes()).hexdigest() != digest):
                    # C/ASM source fixtures remain byte-identical.  Shell
                    # wrappers may change only to repair relocated paths.
                    errors.append('C/ASM fixture changed: ' + new)
            except ValueError as error:
                errors.append(str(error))
    expected = {
        ('daimos-testkit','pdp10-testkit','moved'):99,
        ('daimos-testkit','pdp10-testkit','deduplicated'):28,
        ('pdp10-testkit','daimos-testkit','moved'):23,
    }
    if direction != Counter(expected):
        errors.append('transfer category/count changed: ' + str(direction))

    # Reject new compiler-only sources placed in DAIMOS.  Keep intentional
    # mixed DAIMOS guest tests: the primary assertion, not a KCC filename or
    # a DAS invocation, determines ownership.
    if daimos is not None:
        for prefix in ('kcc-', 'daimos-kcc-', 'dlink-xip-'):
            for path in (daimos / 'tests/host').glob(prefix + '*'):
                if path.is_file():
                    errors.append('compiler/linker host test in OS repo: ' + str(path))
        for prefix in ('daimos-kcc-', 'daimos-gcc-'):
            for path in (daimos / 'tests/target').glob(prefix + '*'):
                if path.exists():
                    errors.append('compiler-only guest test in OS repo: ' + str(path))
        for prefix in ('pdp10-gcc-', 'kcc-excluded-long-', 'dxr2-st2-'):
            for path in (daimos / 'tests/validation').glob(prefix + '*'):
                if path.exists():
                    errors.append('compiler/assembler oracle in OS repo: ' + str(path))
        # Native toolchain directories are now allowed here only when each
        # actual source is explicitly recorded in the v4 return ledger.
        approved = {r['new_path'] for r in ret}
        # New guest-native smoke tests are not historical v4 transfers.
        # Keep this list exact: a broad prefix exemption would hide
        # accidental compiler-only tests added to the DAIMOS checkout.
        followon_guest_smokes = {
            'tests/validation/daimos-native-kcc-hello-v1.sh',
            'tests/validation/daimos-native-kcc-hello-v1.md',
        }
        for name in sorted(followon_guest_smokes):
            if not safe_path(daimos, name).is_file():
                errors.append('missing approved guest smoke: ' + name)
        approved.update(followon_guest_smokes)
        for prefix in ('kcc-native-', 'kcc-kgen-', 'kcc-kir-',
                       'kcc-gccabi-', 'kcc-symbolic-', 'das-native-ascii7-',
                       'das-native-dobj-', 'das-native-global-spill-',
                       'das-native-object-gate-', 'native-dlink-',
                       'daimos-native-dlink-', 'daimos-native-kcc-',
                       'daimos-kcc-kparse-', 'daimos-kcc-kcpp-',
                       'daimos-kcc-make-all-', 'daimos-kcc-manual-',
                       'daimos-kcc-simh-progress-'):
            for item in (daimos / 'tests/validation').glob(prefix + '*'):
                candidates = item.rglob('*') if item.is_dir() else (item,)
                for file in candidates:
                    if file.is_file() and file.relative_to(daimos).as_posix() not in approved:
                        errors.append('unregistered native file in OS repo: ' + str(file))

    # Conversely, a boot-stage/DAIMOS service assertion cannot accidentally
    # reappear in the standalone compiler/assembler suite.
    for prefix in ('test-aap-daimos-stage1', 'test-aap-alt-stage1',
                   'test-aap-ptr-handoff', 'test-simh-ptr-tsfs-boot',
                   'test-pdp6-root-', 'test-pdp6-boot-failure',
                   'test-pdp6-kernel-boot-profile'):
        for path in (PDP10 / 'misc/compat').glob(prefix + '*'):
            if path.is_file():
                errors.append('DAIMOS OS assertion in compiler repo: ' + str(path))
    for path in ('misc/das/run-das-native-daimos.sh',
                 'misc/das/das-native-run.c'):
        if (PDP10 / path).exists():
            errors.append('native DAIMOS guest assertion in compiler repo: ' + path)

    # README/TODO/current STATUS are live directions, unlike dated
    # historical reports or the migration manifest itself. Reject
    # references to any source path that has changed owner.
    documents = [PDP10 / 'README.md', PDP10 / 'TODO.md',
                 PDP10 / 'docs/TESTKIT-SCOPE-MIGRATION-20261119-v4.md']
    if daimos is not None:
        documents += [daimos / 'README.MD', daimos / 'TODO.MD',
                      daimos / 'STATUS.MD',
                      daimos / 'tests/validation/TESTKIT-SCOPE-MIGRATION-20261117-v3.md']
    obsolete_docs = ('TESTKIT-SCOPE-MIGRATION-20261117-v1.tsv',
                     'TESTKIT-SCOPE-MIGRATION-20261117-v2.tsv',
                     'TESTKIT-SCOPE-MIGRATION-20261117-v2.md',
                     'PDP6-AAP-KERNEL-COVERAGE-MATRIX-20261015-v1.md')
    for document in documents:
        if not document.is_file():
            errors.append('missing active documentation: ' + str(document))
            continue
        body = document.read_text(encoding='utf-8', errors='replace')
        for row in rows:
            if row['new_path'] not in reversed_paths and row['old_path'] in body:
                errors.append('stale old-owner test path in ' + str(document) +
                              ': ' + row['old_path'])
        for old_name in obsolete_docs:
            if old_name in body:
                errors.append('superseded document cited by ' +
                              str(document) + ': ' + old_name)

    for error in sorted(set(errors)):
        print('ERROR:', error)
    print('testkit ownership boundary: %s (127 compiler/assembler transfers, '
          '23 OS transfers, 71 native returns, %d problems%s)' %
          ('PASS' if not errors else 'FAIL', len(errors),
           '' if daimos is not None else '; DAIMOS checkout not attached'))
    return int(bool(errors))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--require-cross', action='store_true',
                        help='fail if the DAIMOS OS testkit checkout is absent')
    args = parser.parse_args()
    daimos = Path(os.environ.get('DAIMOS_TESTKIT_REPO',
                                 str(PDP10.parent/'daimos-testkit'))).resolve()
    if not (daimos / 'Makefile').is_file():
        if args.require_cross:
            raise SystemExit('missing DAIMOS OS testkit: ' + str(daimos))
        daimos = None
    return audit(daimos)


if __name__ == '__main__':
    sys.exit(main())
