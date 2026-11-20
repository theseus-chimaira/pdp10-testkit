#!/usr/bin/env python3
"""Verify historical source identities after source reclassification.

The v1 crosswalk pins the original Git source identities. The v2
crosswalk additionally fingerprints current sources, including the one
explicitly reviewed PDP-10 stdarg adaptation. This fast check never
runs a compiler or fetches Git history.
"""

import csv
import hashlib
from pathlib import Path
import re
import sys

from p1_source_replacement_v1 import (
    HISTORICAL_PATH, HISTORICAL_SHA, source_matches_historical,
)

ROOT = Path(__file__).resolve().parents[1]
LEGACY_REGISTRY = ROOT / 'docs/HISTORICAL-SEMANTIC-SOURCE-RELINK-20261117-v1.tsv'
REGISTRY = ROOT / 'docs/HISTORICAL-SEMANTIC-SOURCE-RELINK-20261119-v2.tsv'
ADDITIONAL_REGISTRY = ROOT / 'docs/HISTORICAL-ADDITIONAL-SOURCE-RELINK-20261119-v1.tsv'
EXPECTED = {
    'docs/KCC-HEADER-SEMANTIC-RETEST-20261014-v3.md': 46,
    'docs/SEMANTIC-IMPORT-BATCHES-20261014-v11.md': 31,
    'docs/SEMANTIC-IMPORT-BATCHES-20261014-v12.md': 36,
    'docs/SEMANTIC-IMPORT-FINAL-20261014-v13.md': 12,
}
# Exact retired/absent paths allowed in dated documentation.  Adding a
# different dead link to any documentation file must not silently pass.
KNOWN_RETIRED = {
    ('TODO.md', 'tests/todo/codegen'),
    ('TODO.md', 'tests/todo/negative'),
    ('docs/CODEGEN-IMPORT-AUDIT-20261014.md', 'tests/todo/codegen'),
    ('docs/SPECIAL-SCRIPT-OWNERSHIP-AUDIT-20261116-v2.md',
     'misc/das/check-das-native-image.py'),
    ('docs/PDP10-DEFERRED-INTEGRATION-BATCH11-20261118-v18.md',
     'tests/semantic/upstream/pdp10/pdp10/990106-2.c'),
    ('docs/PDP10-DEFERRED-INTEGRATION-BATCH19-20261118-v27.md',
     'tests/todo/generic/pdp10/strct-varg-1.c'),
    ('docs/UPSTREAM-DUPLICATE-CONSOLIDATION-20261118-v21.md',
     'tests/semantic/upstream/wide-int/conversion.c'),
    ('docs/PDP10-P1-BATCH6-PROBE-20261119-v1.md',
     HISTORICAL_PATH),
    ('docs/PDP10-P1-NATIVE-BYTEPTR-REPLACEMENT-20261120-v1.md',
     HISTORICAL_PATH),
    ('docs/PDP10-P1-SOURCE-BATCHES-20261119-v1.md',
     HISTORICAL_PATH),
    ('docs/PDP10-P1-SOURCE-BATCHES-20261119-v2.md',
     HISTORICAL_PATH),
    ('docs/PDP10-P1-SOURCE-BATCHES-20261119-v3.md',
     HISTORICAL_PATH),
    ('docs/PDP10-P1-SOURCE-BATCHES-20261119-v4.md',
     HISTORICAL_PATH),
    ('docs/PDP10-P1-SOURCE-BATCHES-20261119-v5.md',
     HISTORICAL_PATH),
    ('docs/PDP10-P1-SOURCE-BATCHES-20261119-v6.md',
     HISTORICAL_PATH),
}
REPO_PATH = re.compile(
    r'`((?:\.{1,2}/)?(?:tests|tools|docs|misc|refs|support|workdir)/'
    r'[^`\s$*{}<>|]+)`')
FIELDS = ('document', 'historical_path', 'current_path', 'sha256',
          'historical_git_blob', 'basis', 'current_sha256')
LEGACY_FIELDS = FIELDS[:-1]
ADDITIONAL_FIELDS = ('document', 'historical_path', 'current_path',
                     'original_sha256', 'current_sha256',
                     'historical_git_blob', 'basis')
ADDITIONAL_SOURCE_COMMIT = 'def52e67f291119e0bb1180424f0239c818fc763'
STDARG_PATH = 'tests/todo/generic/varargs/strct-varg-1.c'
STDARG_PREFIX = (
    b'/* PDP-10 has stdarg.h, not the obsolete varargs.h interface. */\n'
    b'#if defined(__PDP10__) || defined(__pdp10__)\n'
    b'#define NO_VARARGS 1\n'
    b'#endif\n\n'
)
STDARG_BASIS = 'pdp10-stdarg-prefix-055c047'


def relative_file(name):
    path = (ROOT / name).resolve()
    if not path.is_relative_to(ROOT.resolve()):
        raise ValueError('path outside PDP10 testkit: ' + name)
    return path


def audit():
    failures = []
    if not source_matches_historical(HISTORICAL_PATH, HISTORICAL_SHA):
        failures.append('reviewed native byte-pointer replacement missing')
    with LEGACY_REGISTRY.open(encoding='ascii', newline='') as file:
        legacy_rows = list(csv.DictReader(file, delimiter='\t'))
    with REGISTRY.open(encoding='ascii', newline='') as file:
        rows = list(csv.DictReader(file, delimiter='\t'))
    with ADDITIONAL_REGISTRY.open(encoding='ascii', newline='') as file:
        supplemental = list(csv.DictReader(file, delimiter='\t'))
    if (len(legacy_rows) != 125 or not legacy_rows or
            tuple(legacy_rows[0]) != LEGACY_FIELDS):
        failures.append('wrong immutable v1 source crosswalk schema/count')
    if not rows or tuple(rows[0]) != FIELDS or len(rows) != 125:
        failures.append('wrong historical source crosswalk schema/count')
    if (len(supplemental) != 54 or not supplemental or
            tuple(supplemental[0]) != ADDITIONAL_FIELDS):
        failures.append('wrong supplemental source crosswalk schema/count')
    legacy = {(r['document'], r['historical_path']): r
              for r in legacy_rows}
    adapted = set()

    seen = set()
    counts = {key: 0 for key in EXPECTED}
    source_text = {}
    current_hashes = {}
    for name in EXPECTED:
        path = relative_file(name)
        if not path.is_file():
            failures.append('missing source report: ' + name)
            continue
        source_text[name] = path.read_text(encoding='utf-8')

    for row in rows:
        doc = row['document']
        before = row['historical_path']
        after = row['current_path']
        key = (doc, before)
        original = legacy.get(key)
        if (original is None or original['sha256'] != row['sha256'] or
                original['historical_git_blob'] != row['historical_git_blob']):
            failures.append('original source identity changed: ' + str(key))
        if key in seen:
            failures.append('duplicate original source entry: ' + str(key))
        seen.add(key)
        if doc not in EXPECTED:
            failures.append('unknown historical report: ' + doc)
            continue
        counts[doc] += 1
        if (not before.startswith('tests/') or
                not after.startswith('tests/') or
                not row['historical_git_blob'].endswith(':' + before) or
                not re.fullmatch('[0-9a-f]{64}', row['sha256']) or
                not re.fullmatch('[0-9a-f]{64}', row['current_sha256'])):
            failures.append('invalid original provenance: ' + before)
            continue
        old_path = relative_file(before)
        new_path = relative_file(after)
        if old_path.exists():
            failures.append('historical location unexpectedly restored: ' + before)
        if not new_path.is_file():
            failures.append('missing current source: ' + after)
        else:
            content = new_path.read_bytes()
            if after not in current_hashes:
                current_hashes[after] = hashlib.sha256(content).hexdigest()
            if current_hashes[after] != row['current_sha256']:
                failures.append('source content changed: ' + after)
            if row['current_sha256'] != row['sha256']:
                if (after != STDARG_PATH or row['basis'] != STDARG_BASIS or
                        not before.endswith('/strct-varg-1.c') or
                        not content.startswith(STDARG_PREFIX) or
                        hashlib.sha256(content[len(STDARG_PREFIX):]).hexdigest()
                        != row['sha256']):
                    failures.append('unapproved source adaptation: ' + after)
                adapted.add(key)
            elif original is not None and row['basis'] != original['basis']:
                failures.append('changed source resolution basis: ' + after)
        if doc in source_text:
            text = source_text[doc]
            if '`' + after + '`' not in text:
                failures.append('unlinked current source in ' + doc + ': ' + after)
            if '`' + before + '`' in text:
                failures.append('stale historical path in ' + doc + ': ' + before)

    if counts != EXPECTED:
        failures.append('unexpected per-report source census: ' + str(counts))
    for name, content in source_text.items():
        if ('HISTORICAL-SEMANTIC-SOURCE-RELINK-20261119-v2.tsv'
                not in content or 'not a new test run' not in content):
            failures.append('missing historical provenance note: ' + name)
    if len(adapted) != 2:
        failures.append('expected exactly two references to stdarg adaptation')

    # In addition to the original 125 paths, the 2026-11-18 duplicate
    # consolidation moved 54 previously valid links in live reports.
    # Their original Git blobs were checked at ledger creation. Pin both
    # their original identities and the current source bytes here.
    supplemental_seen = set()
    supplemental_adapted = set()
    for row in supplemental:
        doc = row['document']
        before = row['historical_path']
        after = row['current_path']
        key = (doc, before)
        if key in supplemental_seen:
            failures.append('duplicate supplemental source: ' + str(key))
        supplemental_seen.add(key)
        if (not doc.startswith('docs/') or not before.startswith('tests/') or
                not after.startswith('tests/') or
                row['historical_git_blob'] !=
                ADDITIONAL_SOURCE_COMMIT + ':' + before or
                not re.fullmatch('[0-9a-f]{64}', row['original_sha256']) or
                not re.fullmatch('[0-9a-f]{64}', row['current_sha256'])):
            failures.append('invalid supplemental provenance: ' + str(key))
            continue
        if relative_file(before).exists():
            failures.append('supplemental historical source restored: ' + before)
        current = relative_file(after)
        if not current.is_file():
            failures.append('missing supplemental current source: ' + after)
            continue
        content = current.read_bytes()
        if hashlib.sha256(content).hexdigest() != row['current_sha256']:
            failures.append('supplemental source changed: ' + after)
        if row['original_sha256'] == row['current_sha256']:
            if row['basis'] != 'byte-identical':
                failures.append('invalid supplemental resolution: ' + after)
        else:
            if (after != STDARG_PATH or row['basis'] != STDARG_BASIS or
                    not content.startswith(STDARG_PREFIX) or
                    hashlib.sha256(content[len(STDARG_PREFIX):]).hexdigest()
                    != row['original_sha256']):
                failures.append('unapproved supplemental adaptation: ' + after)
            supplemental_adapted.add(key)
        text = relative_file(doc).read_text(encoding='utf-8')
        if '`' + after + '`' not in text or '`' + before + '`' in text:
            failures.append('stale supplemental source link: ' + str(key))
    if len(supplemental_adapted) != 1:
        failures.append('expected exactly one additional stdarg adaptation')

    # Audit local literal links across the complete live documentation
    # tree, not just the four source-level reports. An explicitly retired
    # source is not a broken instruction so long as it stays in its
    # original reviewed historical context.
    markdown_files = ([ROOT / 'README.md', ROOT / 'TODO.md'] +
                      sorted((ROOT / 'docs').glob('*.md')))
    seen_retired = set()
    for path in markdown_files:
        name = str(path.relative_to(ROOT))
        for number, line in enumerate(path.read_text(
                encoding='utf-8').splitlines(), 1):
            for raw in REPO_PATH.findall(line):
                token = raw.rstrip(',.);:')
                if any(mark in token for mark in ('...', '*', '[', ']')):
                    continue
                target = ((path.parent / token) if token.startswith('../')
                          else ROOT / token)
                if target.exists():
                    continue
                if (name, token) in KNOWN_RETIRED:
                    seen_retired.add((name, token))
                    continue
                failures.append('broken local documentation path: %s:%d %s'
                                % (name, number, token))
    if seen_retired != KNOWN_RETIRED:
        failures.append('retired-path ledger differs from documentation: '
                        + repr(KNOWN_RETIRED - seen_retired))

    for failure in sorted(set(failures)):
        print('ERROR:', failure)
    print('Historical document source paths v2: %s (%d original paths, '
          '%d supplemental paths, %d pinned current files, '
          '%d reviewed adaptations, %d problems)' %
          ('PASS' if not failures else 'FAIL', len(rows),
           len(supplemental), len(current_hashes),
           len(adapted) + len(supplemental_adapted), len(failures)))
    return int(bool(failures))


if __name__ == '__main__':
    sys.exit(audit())
