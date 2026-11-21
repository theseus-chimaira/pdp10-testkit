#!/usr/bin/env python3
"""Static ownership check for standalone and delegated test scripts.

This is a registration and reference audit, never an execution test.
Recorded delegate edges require review when authored; textual references
alone are not evidence that a script was executed successfully.
"""

import collections
import csv
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
LEDGER = ROOT / 'docs/TEST-SCRIPT-OWNERSHIP-20261121-v7.tsv'
REGISTRY = ROOT / 'SPECIAL_TESTS.tsv'
FIELDS = ('path', 'disposition', 'owner', 'reason')
DISPATCHED_GROUPS = frozenset((
    'verify', 'compat', 'validation', 'gcc-bare-libgcc', 'das',
    'tools', 'kcc-regression', 'kcc-host'))


def read_tsv(path):
    with path.open(encoding='ascii', newline='') as inp:
        return list(csv.DictReader(inp, delimiter='\t'))


def script_paths():
    paths = subprocess.check_output(
        ['git', 'ls-files', '--cached', '--others', '--exclude-standard',
         '--', 'misc', 'tests', 'tools', 'refs'],
        cwd=ROOT, text=True).splitlines()
    return set(path for path in paths
               if path.startswith(('misc/', 'tests/', 'tools/', 'refs/'))
               and path.endswith(('.sh', '.py'))
               and (ROOT / path).is_file())


def audit():
    problems = []
    scripts = script_paths()
    special = read_tsv(REGISTRY)
    ledger = read_tsv(LEDGER)
    if not ledger or not special:
        raise RuntimeError('missing ownership ledger or special registry')

    direct = {}
    for row in special:
        path = row['path']
        if path in direct:
            problems.append('duplicate registered path: ' + path)
        direct[path] = row
        if row['group'] not in DISPATCHED_GROUPS:
            problems.append('unreachable special group: ' + row['group'])
        if row['enabled'] not in ('yes', 'manual'):
            problems.append('unknown special activation: ' + path)

    owners = {}
    for row in ledger:
        path = row['path']
        if path in owners:
            problems.append('duplicate delegated script: ' + path)
        owners[path] = row
        if path not in scripts:
            problems.append('stale ledger source: ' + path)
        if row['disposition'] not in (
                'delegated', 'module-helper', 'compat-entrypoint',
                'entrypoint', 'manual-tool', 'replaced-assertion',
                'superseded'):
            problems.append('unknown disposition: ' + path)
        if not row['reason'].strip():
            problems.append('missing ownership reason: ' + path)

    for path in sorted(scripts):
        row = direct.get(path)
        # Registered nested DAS checkers are intentionally skipped by the
        # dispatcher and must have a real registered upstream owner.
        nested = bool(row and row['group'] == 'das'
                      and row['profile'] == 'nested')
        if (row is None or nested) and path not in owners:
            problems.append('unconnected script: ' + path)
        if row and not nested and path in owners:
            problems.append('duplicate direct/delegated owner: ' + path)

    visited = set()
    stack = set()

    def resolve(path):
        if path in visited:
            return
        if path in stack:
            problems.append('ownership cycle: ' + path)
            return
        stack.add(path)
        row = owners.get(path)
        if row:
            parent = row['owner']
            if row['disposition'] in ('compat-entrypoint', 'entrypoint',
                                      'manual-tool'):
                allowed = {
                    'compat-entrypoint': {'misc/tools/run.sh'},
                    'entrypoint': {'tools/run-tests.py',
                                   'tools/run-misc-suites.py'},
                    'manual-tool': {'tools/audit-gcc-c-feasibility-v1.py',
                                    'tools/census-cross-repo-v1.py',
                                    'misc/kcc-host/daimos-kcc-make-auto-vars-20261010-v1.py',
                                    'misc/kcc-host/daimos-kcc-make-normalization-20261010-v1.py',
                                    'tools/admit-p1-deferred-matrix-v1.py',
                                    'tools/run-p1-batch4-deferred-v1.py',
                                    'tools/run-p1-deferred-batches-v1.py',
                                    'tools/summarize-p1-deferred-batches-v1.py'},
                }
                if path not in allowed[row['disposition']] or parent:
                    problems.append('invalid standalone disposition: ' + path)
            elif row['disposition'] == 'superseded':
                # Historical scripts stay in git; the registered newer
                # version is authoritative. Explicit edges prohibit silently
                # retiring arbitrary tests or changing their assertions.
                approved = {
                    'misc/validation/pdp10-gcc-char-word-boundary-v45.sh':
                        'misc/validation/pdp10-gcc-char-word-boundary-v46.sh',
                    'misc/validation/test-badl-tables.sh':
                        'misc/validation/test-badl-tables-v2.sh',
                    'misc/validation/test-upstream-crt-v1.sh':
                        'misc/validation/test-upstream-crt-v2.sh',
                    'tools/audit-script-ownership-v4.py':
                        'tools/audit-script-ownership-v5.py',
                    'tools/audit-raw-p10run-v1.py':
                        'tools/audit-raw-p10run-v2.py',
                    'tools/audit-script-ownership-v5.py':
                        'tools/audit-script-ownership-v6.py',
                    'tools/audit-test-inventory-v1.py':
                        'tools/audit-test-inventory-v2.py',
                }
                if (approved.get(path) != parent or
                        not (parent in direct and direct[parent]['enabled'] == 'yes'
                                 or parent in owners and
                                 owners[parent]['disposition'] == 'superseded')):
                    problems.append('unreviewed superseded script: ' + path)
                elif parent in scripts:
                    resolve(parent)
            elif row['disposition'] == 'replaced-assertion':
                allowed = {
                    'refs/gcc-pdp10-target-v2/bare-dlink-libgcc.sh':
                        'misc/validation/test-badl-tables-v2.sh',
                    'refs/assembler-inputs/run-smoke.sh':
                        'misc/das/check-reference-assembly-v5.sh',
                }
                if (allowed.get(path) != parent or parent not in direct or
                        direct[parent]['enabled'] != 'yes'):
                    problems.append('unreviewed assertion replacement: ' + path)
                elif parent in scripts:
                    resolve(parent)
            else:
                if not parent or parent == path:
                    problems.append('missing delegate parent: ' + path)
                elif parent not in scripts:
                    problems.append('nonexistent delegate parent: ' + parent)
                else:
                    body = (ROOT / parent).read_text(encoding='utf-8',
                                                     errors='replace')
                    name = (Path(path).stem if row['disposition'] ==
                            'module-helper' else Path(path).name)
                    if name not in body:
                        problems.append('parent does not name child: ' +
                                        parent + ' -> ' + path)
                    resolve(parent)
        elif path not in direct:
            problems.append('no registered root: ' + path)
        elif (direct[path]['group'] == 'das'
              and direct[path]['profile'] == 'nested'):
            problems.append('nested DAS checker lacks parent: ' + path)
        stack.remove(path)
        visited.add(path)

    for path in sorted(scripts):
        resolve(path)

    counts = collections.Counter(row['disposition'] for row in ledger)
    active = sum(p in direct and p not in owners and
                 direct[p]['enabled'] == 'yes' for p in scripts)
    manual = sum(p in direct and p not in owners and
                 direct[p]['enabled'] == 'manual' for p in scripts)
    print('script_ownership_v6 scripts=%d registered_enabled=%d '
          'registered_manual=%d delegated=%d modules=%d '
          'entrypoints=%d manual_tools=%d replaced=%d superseded=%d' %
          (len(scripts), active, manual, counts['delegated'], counts['module-helper'],
           counts['entrypoint'] + counts['compat-entrypoint'],
           counts['manual-tool'], counts['replaced-assertion'],
           counts['superseded']))
    for issue in sorted(set(problems)):
        print('ERROR: ' + issue)
    print('script ownership: %s (%d issue(s))' %
          ('FAIL' if problems else 'STATIC COMPLETE', len(problems)))
    return 1 if problems else 0


if __name__ == '__main__':
    raise SystemExit(audit())
