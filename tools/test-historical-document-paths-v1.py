#!/usr/bin/env python3
"""Check retained semantic source paths in four dated compiler reports.

The historical observations remain unchanged. A separate TSV maps their
original file identities onto byte-identical current sources, verified
against the original Git blobs when the mapping was prepared. This fast
check intentionally does not run any compiler or fetch Git history.
"""

import csv
import hashlib
from pathlib import Path
import re
import sys


ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / 'docs/HISTORICAL-SEMANTIC-SOURCE-RELINK-20261117-v1.tsv'
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
}
REPO_PATH = re.compile(
    r'`((?:\.{1,2}/)?(?:tests|tools|docs|misc|refs|support|workdir)/'
    r'[^`\s$*{}<>|]+)`')
FIELDS = ('document', 'historical_path', 'current_path', 'sha256',
          'historical_git_blob', 'basis')


def relative_file(name):
    path = (ROOT / name).resolve()
    if not path.is_relative_to(ROOT.resolve()):
        raise ValueError('path outside PDP10 testkit: ' + name)
    return path


def audit():
    failures = []
    with REGISTRY.open(encoding='ascii', newline='') as file:
        rows = list(csv.DictReader(file, delimiter='\t'))
    if not rows or tuple(rows[0]) != FIELDS or len(rows) != 125:
        failures.append('wrong historical source crosswalk schema/count')

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
                not re.fullmatch('[0-9a-f]{64}', row['sha256'])):
            failures.append('invalid original provenance: ' + before)
            continue
        old_path = relative_file(before)
        new_path = relative_file(after)
        if old_path.exists():
            failures.append('historical location unexpectedly restored: ' + before)
        if not new_path.is_file():
            failures.append('missing current source: ' + after)
        else:
            if after not in current_hashes:
                current_hashes[after] = hashlib.sha256(
                    new_path.read_bytes()).hexdigest()
            if current_hashes[after] != row['sha256']:
                failures.append('source content changed: ' + after)
        if doc in source_text:
            text = source_text[doc]
            if '`' + after + '`' not in text:
                failures.append('unlinked current source in ' + doc + ': ' + after)
            if '`' + before + '`' in text:
                failures.append('stale historical path in ' + doc + ': ' + before)

    if counts != EXPECTED:
        failures.append('unexpected per-report source census: ' + str(counts))
    for name, content in source_text.items():
        if ('HISTORICAL-SEMANTIC-SOURCE-RELINK-20261117-v1.tsv'
                not in content or 'not a new test run' not in content):
            failures.append('missing historical provenance note: ' + name)

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
    print('Historical document source paths v1: %s (%d original paths, '
          '%d byte-verified current files, %d problems)' %
          ('PASS' if not failures else 'FAIL', len(rows),
           len(current_hashes), len(failures)))
    return int(bool(failures))


if __name__ == '__main__':
    sys.exit(audit())
