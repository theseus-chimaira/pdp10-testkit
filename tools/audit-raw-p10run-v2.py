#!/usr/bin/env python3
"""Fail-closed census of registered and historical raw p10run callers.

This is source ownership evidence, not proof of guest execution or safe
standalone invocation. The ledger is intentionally an exact snapshot.
"""
import csv
import hashlib
from pathlib import Path
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
LEDGER = ROOT / 'docs/RAW-P10RUN-CALLERS-20261121-v2.tsv'
TOKENS = re.compile(r'\$\{?P10RUN\b|\$\{?p10run\b|\bP10RUN_BIN\b|(?:["\']|/)bin/p10run\b|["\']bin/p10run["\']')
# Literal executable invocation, not declarations, comments or documentation.
DIRECT = re.compile(r'\$\{?P10RUN\b|\$\{?p10run\b|["\']bin/p10run["\']|/bin/p10run\b|\bP10RUN_BIN\b')
FIELDS = ('path', 'owner', 'runtime', 'direct_policy', 'sha256', 'evidence')


def candidates():
    names = subprocess.check_output(['git', 'ls-files', '--cached', '--others',
                                     '--exclude-standard', '--', 'misc'],
                                    cwd=ROOT, text=True).splitlines()
    found = {}
    for name in sorted(set(names)):
        path = ROOT / name
        if not path.is_file() or not name.endswith(('.sh', '.py')):
            continue
        body = path.read_text(encoding='utf8', errors='replace')
        # Include direct calls and explicit runner variable assignments.
        if any(TOKENS.search(line) for line in body.splitlines()
               if line.strip() and not line.lstrip().startswith('#')):
            found[name] = body
    return found


def audit():
    problems = []
    with LEDGER.open(encoding='utf8', newline='') as f:
        rows = list(csv.DictReader(f, delimiter='\t'))
    with (ROOT / 'SPECIAL_TESTS.tsv').open(encoding='utf8', newline='') as f:
        registry = {r['path']: r for r in csv.DictReader(f, delimiter='\t')}
    with (ROOT / 'docs/TEST-SCRIPT-OWNERSHIP-20261121-v7.tsv').open(
            encoding='utf8', newline='') as f:
        historical = {r['path']: r for r in csv.DictReader(f, delimiter='\t')}
    found = candidates()
    ledger = {}
    for row in rows:
        if set(row) != set(FIELDS):
            problems.append('invalid ledger columns')
            break
        name = row['path']
        if name in ledger:
            problems.append('duplicate raw caller: ' + name)
        ledger[name] = row
        if row['owner'] not in ('registered', 'superseded', 'helper', 'tools'):
            problems.append('unknown owner class: ' + name)
        if row['runtime'] not in ('gcc', 'kcc', 'mixed', 'tool', 'historical'):
            problems.append('unknown runtime class: ' + name)
        if row['direct_policy'] not in ('isolated', 'dispatcher-only',
                                        'not-a-guest', 'historical'):
            problems.append('unknown direct policy: ' + name)
        source = ROOT / name
        if source.is_file():
            digest = hashlib.sha256(source.read_bytes()).hexdigest()
            if row['sha256'] != digest:
                problems.append('reviewed source changed: ' + name)
        if row['direct_policy'] == 'dispatcher-only':
            expected = {'kcc': 'kcc-source', 'gcc': 'gcc-source',
                        'mixed': 'kcc+gcc-source'}.get(row['runtime'])
            if row['evidence'] != expected:
                problems.append('unreviewed compiler evidence: ' + name)
        elif row['evidence'] not in ('previously-isolated', 'historical',
                                     'helper'):
            problems.append('invalid non-dispatch evidence: ' + name)
        if row['owner'] == 'registered' and name not in registry:
            problems.append('missing registered owner: ' + name)
        if row['owner'] == 'superseded' and (name not in historical or
                historical[name]['disposition'] != 'superseded'):
            problems.append('missing superseded owner: ' + name)
        if row['owner'] == 'helper' and name not in historical:
            problems.append('missing helper owner: ' + name)
        if row['direct_policy'] == 'isolated' and (
                'prepare_script_prefix' not in found.get(name, '') and
                'compiler_prefix' not in found.get(name, '')):
            problems.append('isolation marker absent: ' + name)
        if row['direct_policy'] == 'dispatcher-only' and (
                row['owner'] != 'registered' or
                row['runtime'] not in ('gcc', 'kcc', 'mixed')):
            problems.append('dispatcher-only unregistered caller: ' + name)
    for name in sorted(set(found) - set(ledger)):
        problems.append('new unclassified raw caller: ' + name)
    for name in sorted(set(ledger) - set(found)):
        problems.append('stale raw caller: ' + name)
    print('raw_p10run_v2 candidates=%d classified=%d isolated=%d dispatcher_only=%d' %
          (len(found), len(ledger),
           sum(r['direct_policy'] == 'isolated' for r in rows),
           sum(r['direct_policy'] == 'dispatcher-only' for r in rows)))
    for issue in sorted(set(problems)):
        print('ERROR: ' + issue)
    print('raw p10run ownership: %s (%d issues)' %
          ('FAIL' if problems else 'STATIC COMPLETE', len(problems)))
    return 1 if problems else 0


if __name__ == '__main__':
    sys.exit(audit())
