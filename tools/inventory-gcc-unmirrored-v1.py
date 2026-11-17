#!/usr/bin/env python3
"""Own historical GCC C sources without conflating source and test coverage.

--import archives source blobs from the pinned GCC Git revision and writes
the reviewed-source ledger. Default mode verifies local archive fingerprints,
ledger classifications and matrix owners. Neither mode executes any tests.
"""

import argparse
import collections
import csv
from functools import lru_cache
import hashlib
from pathlib import Path
import re
import subprocess
import sys


ROOT = Path(__file__).resolve().parents[1]
PREFLIGHT = ROOT / 'docs/GCC-C-FEASIBILITY-PREFLIGHT-20261116-v1.tsv'
LEDGER = ROOT / 'docs/GCC-C-UNMIRRORED-OWNERSHIP-20261116-v1.tsv'
STRUCTURAL = ROOT / 'docs/GCC-C-STRUCTURAL-OVERLAPS-20261116-v1.tsv'
COMPANIONS = ROOT / 'docs/GCC-C-SOURCE-COMPANIONS-20261116-v1.tsv'
BATCH01 = ROOT / 'docs/GCC-C-BATCH01-20261116-v1.tsv'
BATCH02 = ROOT / 'docs/GCC-C-BATCH02-20261117-v1.tsv'
BATCH03 = ROOT / 'docs/GCC-C-BATCH03-20261117-v1.tsv'
BATCH04 = ROOT / 'docs/GCC-C-BATCH04-20261117-v1.tsv'
KCC_SHARING = ROOT / 'docs/GCC-C-KCC-CROSS-COMPILER-20261117-v1.tsv'
REFS = ROOT / 'refs/gcc-c-unmirrored-v1'
REVISION = 'b0f5374f6d4462bb8759160ece635e306d90998f'
FIELDS = ('group', 'original_source', 'source_sha256', 'snapshot_path',
          'oracle_type', 'dg_action', 'dg_assertions', 'target_restrictions',
          'risk_flags', 'central_candidates', 'review_status', 'matrix_owner',
          'review_reason')

# These source-level adaptations were compared with the original assertions.
# This list is intentionally small and is NOT evidence of test execution.
REVIEWED = {
    'gcc.c-torture/execute/20000403-1.c': (
        'adapted-active', 'tests/semantic/upstream/generic/20000403-1.c',
        'Replaced sizeof(long)*8 with sizeof(long)*CHAR_BIT; original sign-boundary assertion retained'),
    'gcc.c-torture/execute/20011126-1.c': (
        'adapted-active', 'tests/semantic/upstream/wide-int/20011126-1.c',
        'Original negative-result abort becomes nonzero return'),
    'gcc.c-torture/execute/20020216-1.c': (
        'adapted-active', 'tests/semantic/upstream/generic/20020216-1.c',
        '9/18/36-bit sign-extension expectation replaces vacuous 8/16/32-bit guard'),
    'gcc.c-torture/execute/960311-3.c': (
        'adapted-active', 'tests/semantic/upstream/generic/960311-3.c',
        'DEBUG guard now encloses stdio include; main assertion unchanged'),
    'gcc.c-torture/execute/920711-1.c': (
        'adapted-active', 'tests/semantic/upstream/generic/920711-1.c',
        'Original decrement/branch condition retained and return converted to status; PDP-10 constant is positive'),
    'gcc.c-torture/compile/20020304-1.c': (
        'adapted-active', 'tests/codegen/upstream-gcc/compile/20020304-1.c',
        'Giant compile-only original retains function body; overly long GCC symbols shortened'),
    'gcc.c-torture/execute/20020402-3.c': (
        'adapted-deferred', 'tests/todo/generic/20020402-3.c',
        'Return checks blockvector pointer rather than unconditional success; not registered'),
    'gcc.c-torture/execute/920728-1.c': (
        'adapted-deferred', 'tests/todo/generic/920728-1.c',
        'Long diagnostic label shortened for target assembler; not registered'),
    'gcc.c-torture/execute/921202-1.c': (
        'partial-compile-overlap', 'tests/codegen/upstream-gcc/compile/921202-1.c',
        'Reworked large-array optimizer shape is compiled, but original runtime exit and checks are not retained'),
    'gcc.dg/builtin-prefetch-1.c': (
        'non-equivalent-overlap', '',
        'Current semantic version tests valid builtin arguments, not original invalid-argument warnings'),
    'gcc.dg/format/attr-2.c': (
        'non-equivalent-overlap', '',
        'Shared attribute syntax is not a matching format-warning oracle or format.h dependency'),
}

# Independent PDP-10 runtime assertions absent from the central matrix.
# Initially registered with GCC-only *pending* PDP-6 cells. The separate
# KCC sharing crosswalk explicitly enables compatible KCC pending cells.
# The KL10-only pointer-initializer case is excluded until a KL10 profile
# exists; the signed 71-bit division case needs -mlong-long-71bit first.
NEW_RUNTIME = {
    name: ('registered-pending', 'tests/semantic/gcc-historical-v1/' + name,
           'Original PDP-10 GCC runtime assertion retained unchanged; GCC PDP-6 profiles only, pending verification')
    for name in (
        'alignas-frame-byteptr-v1.c',
        'exact16-pointer-call-1.c',
        'exact16-word-roundtrip-1.c',
        'packed-bitptr-arith-1.c',
        'packed-bitptr-decay-1.c',
        'packed-bitptr-direct-1.c',
        'packed-char-store-1.c',
        'packed-exact16-crossword-1.c',
        'packed-exact16-global-arith-1.c',
        'packed-exact16-global-roundtrip-1.c',
        'packed-pointer-global-1.c',
        'packed-pointer-local-1.c',
        'sibcall-fallthrough-1.c',
    )
}
for _name, _review in NEW_RUNTIME.items():
    REVIEWED['gcc.c-torture/execute/pdp10/' + _name] = _review

ACTION = re.compile(r'\bdg-do\s+(run|compile|assemble|preprocess|link)\b')
ASSERTIONS = re.compile(r'\bdg-(error|warning|message|bogus|excess-errors|final)\b')
TARGETS = re.compile(r'\bdg-(require-effective-target|skip-if)\b|'
                     r'\bdg-do\s+\w+\s*\{\s*target\b')
QUOTED_INCLUDE = re.compile(rb'^\s*#\s*include\s*"([^"\n]+)"', re.M)
COMMENTS = re.compile(r'("(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'|'
                      r'/\*.*?\*/|//[^\n]*)', re.S)
TOKENS = re.compile(r'"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'|'
                    r'[A-Za-z_][A-Za-z_0-9]*|0[xX][0-9A-Fa-f]+|'
                    r'[0-9]+(?:\.[0-9]*)?(?:[eE][+-]?[0-9]+)?|'
                    r'\.\.\.|>>=|<<=|->|\+\+|--|==|!=|<=|>=|&&|'
                    r'\|\||<<|>>|\+=|-=|\*=|/=|%=|&=|\^=|\|=|\S', re.S)


def read_tsv(path):
    with path.open(encoding='utf-8', newline='') as stream:
        return list(csv.DictReader(stream, delimiter='\t'))


@lru_cache(maxsize=1)
def batch01_decisions():
    """Explicit per-source compatibility decisions, never inferred from names."""
    return {r['original_source']: r for r in read_tsv(BATCH01)}


@lru_cache(maxsize=1)
def batch02_decisions():
    """The next 50 original GCC tests, including KCC and GCC eligibility."""
    return {r['original_source']: r for r in read_tsv(BATCH02)}


@lru_cache(maxsize=1)
def batch03_decisions():
    """Third 50-source assertion/diagnostic/KCC compatibility review."""
    return {r['original_source']: r for r in read_tsv(BATCH03)}


@lru_cache(maxsize=1)
def batch04_decisions():
    """Fourth 50-source diagnostic and compiler applicability review."""
    return {r['original_source']: r for r in read_tsv(BATCH04)}


def original_rows():
    rows = [r for r in read_tsv(PREFLIGHT)
            if r['group'] != 'pdp10-target']
    if (len(rows) != 679 or
            len({r['original_source'] for r in rows}) != len(rows)):
        raise ValueError('expected 679 distinct non-target GCC C sources')
    return rows


def digest(data):
    return hashlib.sha256(data).hexdigest()


def token_grams(data):
    """Cheap similarity hints, NOT semantic or assertion equivalence."""
    source = data.decode('latin-1')
    bare = COMMENTS.sub(
        lambda match: ' ' if match.group().startswith(('/',))
        else match.group(), source)
    words = TOKENS.findall(bare)
    return set(hash(tuple(words[i:i + 6]))
               for i in range(max(0, len(words) - 5)))


def report_structural_overlaps():
    """Compare all 679 original bodies with all central C test bodies.

    A shared six-token sequence is evidence to inspect, not the test's
    oracle; ignore common/short patterns to avoid misleading matches.
    """
    central = []
    index = collections.defaultdict(list)
    for path in sorted((ROOT / 'tests').rglob('*.c')):
        grams = token_grams(path.read_bytes())
        number = len(central)
        central.append((path.relative_to(ROOT).as_posix(), len(grams)))
        for gram in grams:
            index[gram].append(number)
    rows = []
    for original in original_rows():
        path = original['original_source']
        grams = token_grams(snapshot_path(path).read_bytes())
        counter = collections.Counter()
        if len(grams) >= 20:
            for gram in grams:
                owners = index.get(gram, ())
                if len(owners) < 35:
                    counter.update(owners)
        leads = []
        for number, shared in counter.items():
            central_path, size = central[number]
            if shared < 10 or size < 20:
                continue
            # A partial copy can legitimately be smaller than the original.
            fraction = shared / min(len(grams), size)
            if fraction >= 0.5:
                leads.append((fraction, shared, central_path))
        leads.sort(key=lambda item: (-item[0], -item[1], item[2]))
        best = leads[0] if leads else (0.0, 0, '')
        rows.append((path, len(grams), best[2], best[1],
                     '%.3f' % best[0],
                     'potential-source-shape-overlap' if leads else
                     'no-strong-source-shape-lead'))
    with STRUCTURAL.open('w', encoding='utf-8', newline='') as stream:
        writer = csv.writer(stream, delimiter='\t', lineterminator='\n')
        writer.writerow(('original_source', 'original_sixgrams',
                         'central_source_candidate', 'shared_sixgrams',
                         'fraction_of_smaller_source', 'evidence_level'))
        writer.writerows(rows)
    print('Structural search: %d sources, %d potential source-shape leads' %
          (len(rows), sum(bool(r[2]) for r in rows)))
    print('No assertion equivalence inferred from token similarity')


def snapshot_path(original):
    prefix = 'gcc/testsuite/'
    if not original.startswith(prefix):
        raise ValueError('source outside GCC test suite: ' + original)
    suffix = original[len(prefix):]
    path = (REFS / suffix).resolve()
    if not path.is_relative_to(REFS.resolve()):
        raise ValueError('unsafe source path: ' + original)
    return path


def quoted_companions(original, data):
    """Yield test-local include paths, not installed/system headers."""
    for name in QUOTED_INCLUDE.findall(data):
        inc = name.decode('latin-1')
        candidate = (Path(original).parent / inc).as_posix()
        if (not candidate.startswith('gcc/testsuite/') or
                '..' in Path(candidate).parts):
            raise ValueError('unsafe relative GCC include: ' + candidate)
        yield candidate


def import_companions(repo, originals):
    """Preserve archived local #include dependencies, not just C entries."""
    original_paths = {r['original_source'] for r in originals}
    pending = [(r['original_source'], snapshot_path(r['original_source']).read_bytes())
               for r in originals]
    dependencies = {}
    while pending:
        owner, data = pending.pop()
        for child in quoted_companions(owner, data):
            if child in original_paths:
                continue  # Already present as one of the 679 C snapshots.
            if child in dependencies:
                dependencies[child]['included_by'].add(owner)
                continue
            cmd = ['git', '-C', str(repo), 'show', REVISION + ':' + child]
            result = subprocess.run(cmd, stdout=subprocess.PIPE,
                                    stderr=subprocess.DEVNULL)
            if result.returncode:
                dependencies[child] = {'sha256': '',
                                       'included_by': {owner},
                                       'status': 'absent-in-original'}
                continue
            body = result.stdout
            out = snapshot_path(child)
            if out.is_file() and out.read_bytes() != body:
                raise ValueError('existing companion differs: ' + child)
            out.parent.mkdir(parents=True, exist_ok=True)
            out.write_bytes(body)
            dependencies[child] = {'sha256': digest(body),
                                   'included_by': {owner},
                                   'status': 'preserved'}
            pending.append((child, body))
    with COMPANIONS.open('w', encoding='utf-8', newline='') as stream:
        writer = csv.writer(stream, delimiter='\t', lineterminator='\n')
        writer.writerow(('original_source', 'source_sha256', 'status',
                         'included_by'))
        for path, info in sorted(dependencies.items()):
            writer.writerow((path, info['sha256'], info['status'],
                             ';'.join(sorted(info['included_by']))))
    print('Preserved %d quoted include companions; missing historical files: %d' %
          (sum(d['status'] == 'preserved' for d in dependencies.values()),
           sum(d['status'] == 'absent-in-original' for d in dependencies.values())))


def archived(repo, records):
    with subprocess.Popen(['git', '-C', str(repo), 'cat-file', '--batch'],
                          stdin=subprocess.PIPE, stdout=subprocess.PIPE) as proc:
        for row in records:
            original = row['original_source']
            proc.stdin.write((REVISION + ':' + original + '\n').encode('ascii'))
            proc.stdin.flush()
            header = proc.stdout.readline().split()
            if len(header) != 3 or header[1] != b'blob':
                raise ValueError('missing original blob: ' + original)
            size = int(header[2])
            data = proc.stdout.read(size)
            if len(data) != size or proc.stdout.read(1) != b'\n':
                raise ValueError('invalid original blob: ' + original)
            if digest(data) != row['source_sha256']:
                raise ValueError('GCC archival source hash mismatch: ' + original)
            yield row, data
        proc.stdin.close()
        if proc.wait():
            raise ValueError('GCC git cat-file failed')


def ownership(row, data):
    original = row['original_source']
    suffix = original[len('gcc/testsuite/'):]
    dg_action = ACTION.findall(data.decode('latin-1'))
    dg_checks = ASSERTIONS.findall(data.decode('latin-1'))
    target = bool(TARGETS.search(data.decode('latin-1')))
    if 'error' in dg_checks:
        oracle = 'diagnostic-rejection'
    elif 'warning' in dg_checks or 'bogus' in dg_checks:
        oracle = 'warning-diagnostic'
    elif 'final' in dg_checks:
        oracle = 'dg-final-oracle'
    elif '/cpp/' in original or dg_action == ['preprocess']:
        oracle = 'preprocessor-contract'
    elif dg_action == ['run'] or row['group'] == 'torture-execute':
        oracle = 'runtime-oracle-review'
    else:
        oracle = 'compile-oracle-review'
    reviewed = REVIEWED.get(suffix)
    batch = batch01_decisions().get(original)
    batch2 = batch02_decisions().get(original)
    batch3 = batch03_decisions().get(original)
    batch4 = batch04_decisions().get(original)
    if reviewed:
        status, matrix_owner, reason = reviewed
    elif batch:
        status = 'batch01-' + ('pending' if batch['decision'] == 'integrate'
                               else batch['decision'])
        matrix_owner = batch['integrated_path']
        reason = batch['review_reason']
    elif batch2:
        status = 'batch02-' + ('pending' if batch2['disposition'] == 'integrate'
                               else batch2['disposition'])
        matrix_owner = batch2['integrated_path']
        reason = batch2['pdp10_reason']
    elif batch3:
        status = 'batch03-' + ('pending' if batch3['disposition'] == 'integrate'
                               else batch3['disposition'])
        matrix_owner = batch3['integrated_path']
        reason = batch3['pdp10_reason']
    elif batch4:
        status = 'batch04-' + ('pending' if batch4['disposition'] == 'integrate'
                               else batch4['disposition'])
        matrix_owner = batch4['integrated_path']
        reason = batch4['pdp10_reason']
    else:
        status = ('same-name-review' if row['name_match'] != 'no-same-name'
                  else 'unreviewed')
        matrix_owner = ''
        reason = ('Filename overlap is not proof of equivalent GCC assertions'
                  if status == 'same-name-review' else
                  'Source not byte-identical to existing tests; independent assertion review required')
    return dict(zip(FIELDS, (
        row['group'], original, row['source_sha256'],
        snapshot_path(original).relative_to(ROOT).as_posix(),
        oracle, ','.join(dg_action) or ('run' if row['group'] == 'torture-execute'
                                      else 'compile'),
        ','.join(sorted(set(dg_checks))), 'yes' if target else 'no',
        row['risk_flags'],
        '' if row['central_candidate_path'] == 'none'
        else row['central_candidate_path'],
        status, matrix_owner, reason)))


def import_sources(repo):
    records = original_rows()
    result = []
    for row, data in archived(repo, records):
        path = snapshot_path(row['original_source'])
        if path.is_file() and path.read_bytes() != data:
            raise ValueError('existing snapshot differs: ' + str(path))
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(data)
        suffix = row['original_source'][len('gcc/testsuite/'):]
        if suffix in REVIEWED and REVIEWED[suffix][0] == 'registered-pending':
            dest = ROOT / REVIEWED[suffix][1]
            if dest.is_file() and dest.read_bytes() != data:
                raise ValueError('registered GCC test differs: ' + str(dest))
            dest.parent.mkdir(parents=True, exist_ok=True)
            dest.write_bytes(data)
        result.append(ownership(row, data))
    with LEDGER.open('w', encoding='utf-8', newline='') as stream:
        writer = csv.DictWriter(stream, fieldnames=FIELDS,
                                delimiter='\t', lineterminator='\n')
        writer.writeheader()
        writer.writerows(result)
    import_companions(repo, records)
    print('Archived %d historical GCC source snapshots; no tests executed' %
          len(result))
    print('Ledger: ' + str(LEDGER))


def verify_sources():
    originals = original_rows()
    ledger = read_tsv(LEDGER)
    errors = []
    if len(ledger) != len(originals):
        errors.append('ledger count differs from 679')
    by_path = {r['original_source']: r for r in ledger}
    if len(by_path) != len(ledger):
        errors.append('duplicate ledger source path')
    batch = read_tsv(BATCH01)
    selected = [r['original_source'] for r in originals
                if r['original_source'][len('gcc/testsuite/'):] not in REVIEWED][:50]
    batch_paths = [r['original_source'] for r in batch]
    if len(batch) != 50 or batch_paths != selected:
        errors.append('batch01 must contain the first 50 previously unresolved GCC C sources in order')
    source_hashes = {r['original_source']: r['source_sha256'] for r in originals}
    for row in batch:
        path = row['original_source']
        if row['source_sha256'] != source_hashes.get(path):
            errors.append('batch01 original source hash mismatch: ' + path)
        if (not row['review_reason'] or not row['original_oracle'] or
                row['decision'] not in ('integrate', 'defer', 'inapplicable')):
            errors.append('batch01 incomplete disposition: ' + path)
        if row['decision'] == 'integrate':
            expected = 'tests/semantic/gcc-historical-b01-v1/' + Path(path).name
            if (row['integrated_path'] != expected or
                    row['pdp10_compatibility'] != 'adapted-native'):
                errors.append('batch01 unexpected test owner: ' + path)
            target = ROOT / row['integrated_path']
            if not target.is_file() or digest(target.read_bytes()) != row['integrated_sha256']:
                errors.append('batch01 missing/changed adapted test: ' + path)
        elif row['integrated_path'] or row['integrated_sha256']:
            errors.append('batch01 deferred source incorrectly registered: ' + path)
    batch2 = read_tsv(BATCH02)
    selected2 = [r['original_source'] for r in originals
                 if (r['original_source'][len('gcc/testsuite/'):] not in REVIEWED
                     and r['original_source'] not in batch_paths)][:50]
    batch2_paths = [r['original_source'] for r in batch2]
    if (len(batch2) != 50 or batch2_paths != selected2 or
            len(set(batch2_paths)) != 50):
        errors.append('batch02 must contain exactly the next 50 unresolved original GCC sources in order')
    batch2_owners = {}
    for row in batch2:
        path = row['original_source']
        decision = row['disposition']
        scope = row['compiler_scope']
        owner = row['integrated_path']
        if row['source_sha256'] != source_hashes.get(path):
            errors.append('batch02 source hash mismatch: ' + path)
        if (not row['pdp10_reason'] or not row['kcc_reason'] or
                not row['oracle'] or decision not in ('integrate', 'defer', 'inapplicable')):
            errors.append('batch02 incomplete source decision: ' + path)
        if decision == 'integrate':
            if (scope not in ('both', 'gcc-only', 'kcc-only') or
                    row['test_kind'] not in ('run', 'compile') or not owner or
                    owner in batch2_owners or not owner.startswith(
                        'tests/semantic/gcc-historical-b02-v1/' if row['test_kind'] == 'run'
                        else 'tests/codegen/gcc-historical-b02-v1/')):
                errors.append('batch02 invalid active source owner: ' + path)
            batch2_owners[owner] = row
            src = ROOT / owner
            if (not src.is_file() or
                    digest(src.read_bytes()) != row['integrated_sha256']):
                errors.append('batch02 adapted source hash differs: ' + path)
        elif (scope != 'none' or row['test_kind'] or owner or
              row['integrated_sha256']):
            errors.append('batch02 deferred/inapplicable source has a test owner: ' + path)
    if len(batch2_owners) != 11:
        errors.append('batch02 source review has incorrect active owner count')
    batch3 = read_tsv(BATCH03)
    selected3 = [r['original_source'] for r in originals
                 if (r['original_source'][len('gcc/testsuite/'):] not in REVIEWED
                     and r['original_source'] not in batch_paths
                     and r['original_source'] not in batch2_paths)][:50]
    batch3_paths = [r['original_source'] for r in batch3]
    if (len(batch3) != 50 or batch3_paths != selected3 or
            len(set(batch3_paths)) != 50):
        errors.append('batch03 must contain exactly the next 50 unresolved original GCC sources in order')
    batch3_owners = {}
    for row in batch3:
        path = row['original_source']
        decision = row['disposition']
        scope = row['compiler_scope']
        owner = row['integrated_path']
        if row['source_sha256'] != source_hashes.get(path):
            errors.append('batch03 original source hash mismatch: ' + path)
        if (not row['original_oracle'] or not row['pdp10_reason'] or
                not row['kcc_reason'] or not row['constraints_not_exercised'] or
                decision not in ('integrate', 'defer', 'inapplicable')):
            errors.append('batch03 incomplete source decision: ' + path)
        if decision == 'integrate':
            prefix = ('tests/semantic/gcc-historical-b03-v1/'
                      if row['test_kind'] == 'run' else
                      'tests/codegen/gcc-historical-b03-v1/')
            if (scope not in ('both', 'gcc-only', 'kcc-only') or
                    row['test_kind'] not in ('run', 'compile') or not owner or
                    owner in batch3_owners or not owner.startswith(prefix) or
                    owner in batch2_owners):
                errors.append('batch03 invalid active test owner: ' + path)
            batch3_owners[owner] = row
            src = ROOT / owner
            if (not src.is_file() or
                    digest(src.read_bytes()) != row['integrated_sha256']):
                errors.append('batch03 adapted source hash differs: ' + path)
        elif (scope != 'none' or row['test_kind'] or owner or
              row['integrated_sha256']):
            errors.append('batch03 deferred/inapplicable source has an active owner: ' + path)
    if len(batch3_owners) != 7:
        errors.append('batch03 source review has incorrect active owner count')
    batch4 = read_tsv(BATCH04)
    selected4 = [r['original_source'] for r in originals
                 if (r['original_source'][len('gcc/testsuite/'):] not in REVIEWED
                     and r['original_source'] not in batch_paths
                     and r['original_source'] not in batch2_paths
                     and r['original_source'] not in batch3_paths)][:50]
    batch4_paths = [r['original_source'] for r in batch4]
    if (len(batch4) != 50 or batch4_paths != selected4 or
            len(set(batch4_paths)) != 50):
        errors.append('batch04 must contain exactly the next 50 unresolved original GCC sources in order')
    batch4_owners = {}
    for row in batch4:
        path = row['original_source']
        decision = row['disposition']
        scope = row['compiler_scope']
        owner = row['integrated_path']
        if row['source_sha256'] != source_hashes.get(path):
            errors.append('batch04 original source hash mismatch: ' + path)
        if (not row['original_oracle'] or not row['pdp10_reason'] or
                not row['kcc_reason'] or not row['constraints_not_exercised'] or
                decision not in ('integrate', 'defer', 'inapplicable')):
            errors.append('batch04 incomplete source decision: ' + path)
        if decision == 'integrate':
            if (scope not in ('both', 'gcc-only', 'kcc-only') or
                    row['test_kind'] != 'compile' or not owner or
                    not owner.startswith('tests/codegen/gcc-historical-b04-v1/') or
                    owner in batch4_owners or owner in batch3_owners or
                    owner in batch2_owners):
                errors.append('batch04 invalid active source owner: ' + path)
            batch4_owners[owner] = row
            src = ROOT / owner
            if (not src.is_file() or
                    digest(src.read_bytes()) != row['integrated_sha256']):
                errors.append('batch04 adapted source fingerprint differs: ' + path)
        elif (scope != 'none' or row['test_kind'] or owner or
              row['integrated_sha256']):
            errors.append('batch04 excluded source unexpectedly has test owner: ' + path)
    if len(batch4_owners) != 5:
        errors.append('batch04 source review has incorrect active owner count')
    matrix_rows = {}
    with (ROOT / 'COMPILER_MATRIX.tsv').open(encoding='utf-8') as stream:
        matrix_rows = {r['test']: r for r in csv.DictReader(
            (line for line in stream if line.strip() and not line.startswith('#')),
            delimiter='\t')}
    matrix = set(matrix_rows)
    for owner, row in batch2_owners.items():
        entry = matrix_rows.get(owner)
        if entry is None:
            errors.append('batch02 test not registered: ' + owner)
            continue
        group = ('semantic-gcc-historical-b02' if row['test_kind'] == 'run'
                 else 'codegen-gcc-historical-b02')
        if entry['group'] != group:
            errors.append('batch02 wrong test group: ' + owner)
        allowed = set()
        if row['compiler_scope'] in ('both', 'gcc-only'):
            allowed.update(('pdp6_gcc_o0', 'pdp6_gcc_o1',
                            'pdp6_gcc_o2', 'pdp6_gcc_os'))
        if row['compiler_scope'] in ('both', 'kcc-only'):
            allowed.update(('pdp6', 'pdp6_base'))
        for col, value in entry.items():
            if col in ('test', 'group', 'name'):
                continue
            if col in allowed:
                if value not in ('pending', 'semantic', 'ok', 'fail',
                                 'error', 'timeout', 'codegen'):
                    errors.append('batch02 unreviewed active compiler cell: %s %s' %
                                  (owner, col))
            elif value != 'no_test':
                errors.append('batch02 unreviewed other compiler cell: %s %s' %
                              (owner, col))
    for folder in ('tests/semantic/gcc-historical-b02-v1',
                   'tests/codegen/gcc-historical-b02-v1'):
        for src in (ROOT / folder).glob('*.c'):
            name = src.relative_to(ROOT).as_posix()
            if name not in batch2_owners:
                errors.append('unowned batch02 C source: ' + name)
    for owner, row in batch3_owners.items():
        entry = matrix_rows.get(owner)
        if entry is None:
            errors.append('batch03 test not registered: ' + owner)
            continue
        group = ('semantic-gcc-historical-b03' if row['test_kind'] == 'run'
                 else 'codegen-gcc-historical-b03')
        if entry['group'] != group:
            errors.append('batch03 incorrect matrix group: ' + owner)
        allowed = set()
        if row['compiler_scope'] in ('both', 'gcc-only'):
            allowed.update(('pdp6_gcc_o0', 'pdp6_gcc_o1',
                            'pdp6_gcc_o2', 'pdp6_gcc_os'))
        if row['compiler_scope'] in ('both', 'kcc-only'):
            allowed.update(('pdp6', 'pdp6_base'))
        for col, value in entry.items():
            if col in ('test', 'group', 'name'):
                continue
            if col in allowed:
                if value != 'pending':
                    errors.append('batch03 expected pending compiler cell: %s %s' %
                                  (owner, col))
            elif value != 'no_test':
                errors.append('batch03 unreviewed compiler cell: %s %s' %
                              (owner, col))
    for folder in ('tests/semantic/gcc-historical-b03-v1',
                   'tests/codegen/gcc-historical-b03-v1'):
        for src in (ROOT / folder).glob('*.c'):
            name = src.relative_to(ROOT).as_posix()
            if name not in batch3_owners:
                errors.append('unowned batch03 C source: ' + name)
    for owner, row in batch4_owners.items():
        entry = matrix_rows.get(owner)
        if entry is None:
            errors.append('batch04 test not registered: ' + owner)
            continue
        if entry['group'] != 'codegen-gcc-historical-b04':
            errors.append('batch04 incorrect matrix group: ' + owner)
        allowed = set()
        if row['compiler_scope'] in ('both', 'gcc-only'):
            allowed.update(('pdp6_gcc_o0', 'pdp6_gcc_o1',
                            'pdp6_gcc_o2', 'pdp6_gcc_os'))
        if row['compiler_scope'] in ('both', 'kcc-only'):
            allowed.update(('pdp6', 'pdp6_base'))
        for col, value in entry.items():
            if col in ('test', 'group', 'name'):
                continue
            if col in allowed:
                if value != 'pending':
                    errors.append('batch04 expected pending compiler cell: %s %s' %
                                  (owner, col))
            elif value != 'no_test':
                errors.append('batch04 unreviewed compiler cell: %s %s' %
                              (owner, col))
    for src in (ROOT / 'tests/codegen/gcc-historical-b04-v1').glob('*.c'):
        name = src.relative_to(ROOT).as_posix()
        if name not in batch4_owners:
            errors.append('unowned batch04 C source: ' + name)
    kcc_review = read_tsv(KCC_SHARING)
    kcc_by_owner = {r['integrated_path']: r for r in kcc_review}
    expected_kcc_owners = {
        r['integrated_path'] for r in batch if r['decision'] == 'integrate'
    }
    expected_kcc_owners.update(
        r['matrix_owner'] for r in ledger
        if r['review_status'] == 'registered-pending')
    if (len(kcc_review) != 30 or len(kcc_by_owner) != 30 or
            set(kcc_by_owner) != expected_kcc_owners):
        errors.append('KCC cross-compiler review must cover exactly 30 new historical runtime owners')
    for item in kcc_review:
        owner = item['integrated_path']
        decision = item['kcc_disposition']
        if (not item['kcc_reason'] or decision not in ('pending', 'gcc-only') or
                item['kcc_profiles'] != ('pdp6;pdp6_base' if decision == 'pending' else '')):
            errors.append('invalid KCC compatibility decision: ' + owner)
        if by_path.get(item['original_source'], {}).get('matrix_owner') != owner:
            errors.append('KCC compatibility decision has wrong original source: ' + owner)
        if owner not in matrix:
            errors.append('missing KCC cross-compiler matrix owner: ' + owner)
    for orig in originals:
        path = orig['original_source']
        stored = snapshot_path(path)
        if not stored.is_file():
            errors.append('missing archived source: ' + path)
            continue
        data = stored.read_bytes()
        if digest(data) != orig['source_sha256']:
            errors.append('wrong archived source hash: ' + path)
        actual = ownership(orig, data)
        recorded = by_path.get(path)
        if recorded != actual:
            errors.append('stale source classification/crosswalk: ' + path)
        if recorded and recorded['matrix_owner']:
            target = recorded['matrix_owner']
            if not (ROOT / target).is_file():
                errors.append('missing adapted source: ' + target)
            active = recorded['review_status'] in (
                'adapted-active', 'partial-compile-overlap',
                'registered-pending', 'batch01-pending',
                'batch02-pending', 'batch03-pending', 'batch04-pending')
            if (target in matrix) != active:
                errors.append('adapted registration status disagrees: ' + target)
            if recorded['review_status'] in ('registered-pending', 'batch01-pending'):
                if (recorded['review_status'] == 'registered-pending' and
                        (not (ROOT / target).is_file() or (ROOT / target).read_bytes() != data)):
                    errors.append('registered historical source changed: ' + target)
                cell_row = matrix_rows.get(target)
                if cell_row:
                    expected_group = ('semantic-gcc-historical-b01'
                                      if recorded['review_status'] == 'batch01-pending'
                                      else 'semantic-gcc-historical')
                    if cell_row['group'] != expected_group:
                        errors.append('wrong GCC historical matrix group: ' + target)
                    allowed = {'pdp6_gcc_o0', 'pdp6_gcc_o1',
                               'pdp6_gcc_o2', 'pdp6_gcc_os'}
                    kcc = kcc_by_owner.get(target)
                    if kcc and kcc['kcc_disposition'] == 'pending':
                        allowed.update(('pdp6', 'pdp6_base'))
                    permitted_statuses = {'pending', 'semantic', 'ok',
                                          'fail', 'error', 'timeout'}
                    for column, value in cell_row.items():
                        if column in ('test', 'group', 'name'):
                            continue
                        if column in allowed:
                            if value not in permitted_statuses:
                                errors.append('inactive historical compiler cell: %s %s' %
                                              (target, column))
                        elif value != 'no_test':
                            errors.append('unreviewed compiler/CPU cell: %s %s' %
                                          (target, column))
    expected_batch_sources = {r['integrated_path'] for r in batch
                              if r['decision'] == 'integrate'}
    actual_batch_sources = {
        path.relative_to(ROOT).as_posix()
        for path in (ROOT / 'tests/semantic/gcc-historical-b01-v1').glob('*.c')}
    for unowned in sorted(actual_batch_sources - expected_batch_sources):
        errors.append('unowned batch01 source: ' + unowned)
    included = read_tsv(COMPANIONS)
    companion_paths = {}
    for row in included:
        child = row['original_source']
        if child in companion_paths:
            errors.append('duplicate GCC companion path: ' + child)
        companion_paths[child] = row
        target = snapshot_path(child)
        if row['status'] == 'preserved':
            if not target.is_file() or digest(target.read_bytes()) != row['source_sha256']:
                errors.append('missing/changed GCC companion: ' + child)
        elif row['status'] != 'absent-in-original' or row['source_sha256'] or target.exists():
            errors.append('invalid absent GCC companion: ' + child)
    original_paths = {r['original_source'] for r in originals}
    visited = set()
    reached_companions = set()
    queue = [(r['original_source'], snapshot_path(r['original_source']).read_bytes())
             for r in originals if snapshot_path(r['original_source']).is_file()]
    while queue:
        owner, data = queue.pop()
        if owner in visited:
            continue
        visited.add(owner)
        for child in quoted_companions(owner, data):
            if child in original_paths:
                continue
            reached_companions.add(child)
            if child not in companion_paths:
                errors.append('unowned GCC quoted include: ' + child)
            elif companion_paths[child]['status'] == 'preserved':
                queue.append((child, snapshot_path(child).read_bytes()))
    for stale in sorted(companion_paths.keys() - reached_companions):
        errors.append('stale GCC companion record: ' + stale)
    snapshots = {p.relative_to(ROOT).as_posix()
                 for p in REFS.rglob('*.c')}
    expected = {snapshot_path(r['original_source']).relative_to(ROOT).as_posix()
                for r in originals}
    expected.update(snapshot_path(p).relative_to(ROOT).as_posix()
                    for p, row in companion_paths.items()
                    if row['status'] == 'preserved' and p.endswith('.c'))
    for extra in sorted(snapshots - expected):
        errors.append('unowned GCC archival source: ' + extra)
    counts = collections.Counter(r['review_status'] for r in ledger)
    print('GCC historical C sources: %d; statuses: %s' %
          (len(ledger), ', '.join('%s=%d' % p for p in sorted(counts.items()))))
    for err in errors:
        print('ERROR: ' + err, file=sys.stderr)
    return int(bool(errors))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--import-sources', action='store_true')
    parser.add_argument('--report-overlaps', action='store_true',
                        help='write six-token similarity hints, without execution')
    parser.add_argument('--gcc-repo', default=str(ROOT.parent / 'gcc-pdp10'))
    args = parser.parse_args()
    if args.import_sources:
        import_sources(Path(args.gcc_repo))
    if args.report_overlaps:
        report_structural_overlaps()
    return verify_sources()


if __name__ == '__main__':
    sys.exit(main())
