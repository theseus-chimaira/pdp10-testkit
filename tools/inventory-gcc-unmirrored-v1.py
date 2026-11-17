#!/usr/bin/env python3
"""Own retained historical GCC C sources and rejected-source tombstones.

--import restores eligible source blobs from the pinned GCC Git revision,
deletes inapplicable snapshots, and writes the full decision ledger.
Default mode verifies retained hashes, removed-source absence, review
decisions, and compiler matrix owners. Neither mode executes any tests.
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
BATCH05 = ROOT / 'docs/GCC-C-BATCH05-20261117-v1.tsv'
BATCH06 = ROOT / 'docs/GCC-C-BATCH06-20261117-v1.tsv'
BATCH07 = ROOT / 'docs/GCC-C-BATCH07-20261117-v1.tsv'
BATCH07_COMPANIONS = ROOT / 'docs/GCC-C-BATCH07-COMPANIONS-20261117-v1.tsv'
BATCH08 = ROOT / 'docs/GCC-C-BATCH08-20261117-v1.tsv'
BATCH08_COMPANIONS = ROOT / 'docs/GCC-C-BATCH08-COMPANIONS-20261117-v1.tsv'
BATCH09 = ROOT / 'docs/GCC-C-BATCH09-20261117-v1.tsv'
BATCH09_COMPANIONS = ROOT / 'docs/GCC-C-BATCH09-COMPANIONS-20261117-v1.tsv'
BATCH10 = ROOT / 'docs/GCC-C-BATCH10-20261117-v1.tsv'
BATCH11 = ROOT / 'docs/GCC-C-BATCH11-20261117-v1.tsv'
BATCH12 = ROOT / 'docs/GCC-C-BATCH12-20261117-v1.tsv'
BATCH13 = ROOT / 'docs/GCC-C-BATCH13-20261117-v1.tsv'
BATCH14 = ROOT / 'docs/GCC-C-BATCH14-20261117-v1.tsv'
REMOVALS_V1 = ROOT / 'docs/GCC-C-INAPPLICABLE-REMOVALS-20261117-v1.tsv'
REMOVALS_V2 = ROOT / 'docs/GCC-C-INAPPLICABLE-REMOVALS-20261117-v2.tsv'
REMOVALS = ROOT / 'docs/GCC-C-INAPPLICABLE-REMOVALS-20261117-v3.tsv'
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


@lru_cache(maxsize=1)
def batch05_decisions():
    """Fifth 50-source C90/C99 and GNU attribute applicability review."""
    return {r['original_source']: r for r in read_tsv(BATCH05)}


@lru_cache(maxsize=1)
def batch06_decisions():
    """Sixth 50-source C99 and preprocessor applicability review."""
    return {r['original_source']: r for r in read_tsv(BATCH06)}


@lru_cache(maxsize=1)
def batch07_decisions():
    """Seventh 50-source GNU CPP contract and cross-compiler review."""
    return {r['original_source']: r for r in read_tsv(BATCH07)}


@lru_cache(maxsize=1)
def batch08_decisions():
    """Eighth 50-source diagnostic and CPP semantic compatibility review."""
    return {r['original_source']: r for r in read_tsv(BATCH08)}


@lru_cache(maxsize=1)
def batch09_decisions():
    """Ninth 50-source CPP macro, include and stringify compatibility review."""
    return {r['original_source']: r for r in read_tsv(BATCH09)}


@lru_cache(maxsize=1)
def batch10_decisions():
    """Tenth 50-source CPP, debugging and target-ABI compatibility review."""
    return {r['original_source']: r for r in read_tsv(BATCH10)}


@lru_cache(maxsize=1)
def batch11_decisions():
    """Eleventh 50-source GCC format-diagnostic applicability review."""
    return {r['original_source']: r for r in read_tsv(BATCH11)}


@lru_cache(maxsize=1)
def final105_decisions():
    """Final three exact-source groups (50/50/5), with native scopes."""
    return {r['original_source']: (index, r)
            for index, review in ((12, BATCH12), (13, BATCH13), (14, BATCH14))
            for r in read_tsv(review)}


@lru_cache(maxsize=1)
def removed_originals():
    """Versioned tombstones for 119 reviewed/deleted inapplicable originals.

    Keep their identities and fingerprints in the 679-source provenance
    ledger, but never restore or schedule their source snapshots.
    """
    rows = read_tsv(REMOVALS)
    previous_v1 = read_tsv(REMOVALS_V1)
    previous_v2 = read_tsv(REMOVALS_V2)
    if (len(previous_v1) != 89 or len(previous_v2) != 94 or
            previous_v2[:89] != previous_v1 or rows[:94] != previous_v2 or
            len(rows) != 119 or len({r['original_source'] for r in rows}) != 119):
        raise ValueError('expected 119 distinct tombstones preserving all earlier v1/v2 decisions')
    return {r['original_source']: r for r in rows}


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
    """Compare retained original bodies with all central C test bodies.

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
    deleted = removed_originals()
    for original in original_rows():
        path = original['original_source']
        if path in deleted:
            continue
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
                continue  # Already present as a retained original C snapshot.
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
    batch5 = batch05_decisions().get(original)
    batch6 = batch06_decisions().get(original)
    batch7 = batch07_decisions().get(original)
    batch8 = batch08_decisions().get(original)
    batch9 = batch09_decisions().get(original)
    batch10 = batch10_decisions().get(original)
    batch11 = batch11_decisions().get(original)
    final105 = final105_decisions().get(original)
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
    elif batch5:
        status = 'batch05-' + ('pending' if batch5['disposition'] == 'integrate'
                               else batch5['disposition'])
        matrix_owner = batch5['integrated_path']
        reason = batch5['pdp10_reason']
    elif batch6:
        status = 'batch06-' + ('pending' if batch6['disposition'] == 'integrate'
                               else batch6['disposition'])
        matrix_owner = batch6['integrated_path']
        reason = batch6['pdp10_reason']
    elif batch7:
        status = 'batch07-' + ('pending' if batch7['disposition'] == 'integrate'
                               else batch7['disposition'])
        matrix_owner = batch7['integrated_path']
        reason = batch7['pdp10_reason']
    elif batch8:
        status = 'batch08-' + ('pending' if batch8['disposition'] == 'integrate'
                               else batch8['disposition'])
        matrix_owner = batch8['integrated_path']
        reason = batch8['pdp10_reason']
    elif batch9:
        status = 'batch09-' + ('pending' if batch9['disposition'] == 'integrate'
                               else batch9['disposition'])
        matrix_owner = batch9['integrated_path']
        reason = batch9['pdp10_reason']
    elif batch10:
        status = 'batch10-' + ('pending' if batch10['disposition'] == 'integrate'
                               else batch10['disposition'])
        matrix_owner = batch10['integrated_path']
        reason = batch10['pdp10_reason']
    elif batch11:
        status = 'batch11-' + ('pending' if batch11['disposition'] == 'integrate'
                               else batch11['disposition'])
        matrix_owner = batch11['integrated_path']
        reason = batch11['pdp10_reason']
    elif final105:
        index, decision = final105
        status = 'batch%02d-' % index + ('pending' if decision['disposition'] == 'integrate'
                                        else decision['disposition'])
        matrix_owner = decision['integrated_path']
        reason = decision['pdp10_reason']
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
    deleted = removed_originals()
    result = []
    retained = []
    for row, data in archived(repo, records):
        original = row['original_source']
        path = snapshot_path(original)
        if path.is_file() and path.read_bytes() != data:
            raise ValueError('existing snapshot differs: ' + str(path))
        if original in deleted:
            # A regular inventory rebuild must not resurrect rejected tests.
            if path.exists():
                path.unlink()
        else:
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(data)
            retained.append(row)
        suffix = original[len('gcc/testsuite/'):]
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
    import_companions(repo, retained)
    print('Retained %d historical GCC source snapshots; deleted %d inapplicable originals; '
          'indexed %d historical decisions; no tests executed' %
          (len(retained), len(deleted), len(result)))
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
    batch5 = read_tsv(BATCH05)
    selected5 = [r['original_source'] for r in originals
                 if (r['original_source'][len('gcc/testsuite/'):] not in REVIEWED
                     and r['original_source'] not in batch_paths
                     and r['original_source'] not in batch2_paths
                     and r['original_source'] not in batch3_paths
                     and r['original_source'] not in batch4_paths)][:50]
    batch5_paths = [r['original_source'] for r in batch5]
    if (len(batch5) != 50 or batch5_paths != selected5 or
            len(set(batch5_paths)) != 50):
        errors.append('batch05 must contain exactly the next 50 unresolved original GCC sources in order')
    batch5_owners = {}
    for row in batch5:
        path = row['original_source']
        decision = row['disposition']
        scope = row['compiler_scope']
        owner = row['integrated_path']
        if row['source_sha256'] != source_hashes.get(path):
            errors.append('batch05 original source hash mismatch: ' + path)
        if (not row['original_oracle'] or not row['pdp10_reason'] or
                not row['kcc_reason'] or not row['constraints_not_exercised'] or
                decision not in ('integrate', 'defer', 'inapplicable')):
            errors.append('batch05 incomplete source decision: ' + path)
        if decision == 'integrate':
            prefix = ('tests/semantic/gcc-historical-b05-v1/'
                      if row['test_kind'] == 'run' else
                      'tests/codegen/gcc-historical-b05-v1/')
            if (scope not in ('both', 'gcc-only', 'kcc-only') or
                    row['test_kind'] not in ('compile', 'run') or
                    not owner or not owner.startswith(prefix) or
                    owner in batch5_owners or owner in batch4_owners or
                    owner in batch3_owners or owner in batch2_owners):
                errors.append('batch05 invalid active source owner: ' + path)
            batch5_owners[owner] = row
            src = ROOT / owner
            if (not src.is_file() or
                    digest(src.read_bytes()) != row['integrated_sha256']):
                errors.append('batch05 adapted source hash mismatch: ' + path)
        elif (scope != 'none' or row['test_kind'] or owner or
              row['integrated_sha256'] or row['gcc_profiles'] or
              row['kcc_profiles']):
            errors.append('batch05 excluded source has active test owner: ' + path)
    if len(batch5_owners) != 4:
        errors.append('batch05 source review has incorrect active owner count')
    batch6 = read_tsv(BATCH06)
    selected6 = [r['original_source'] for r in originals
                 if (r['original_source'][len('gcc/testsuite/'):] not in REVIEWED
                     and r['original_source'] not in batch_paths
                     and r['original_source'] not in batch2_paths
                     and r['original_source'] not in batch3_paths
                     and r['original_source'] not in batch4_paths
                     and r['original_source'] not in batch5_paths)][:50]
    batch6_paths = [r['original_source'] for r in batch6]
    if (len(batch6) != 50 or batch6_paths != selected6 or
            len(set(batch6_paths)) != 50):
        errors.append('batch06 must contain exactly the next 50 unresolved original GCC sources in order')
    batch6_owners = {}
    for row in batch6:
        path = row['original_source']
        decision = row['disposition']
        scope = row['compiler_scope']
        owner = row['integrated_path']
        if row['source_sha256'] != source_hashes.get(path):
            errors.append('batch06 original source hash mismatch: ' + path)
        if (not row['original_oracle'] or not row['pdp10_reason'] or
                not row['kcc_reason'] or not row['constraints_not_exercised'] or
                decision not in ('integrate', 'defer', 'inapplicable')):
            errors.append('batch06 incomplete source decision: ' + path)
        if decision == 'integrate':
            prefix = ('tests/semantic/gcc-historical-b06-v1/'
                      if row['test_kind'] == 'run' else
                      'tests/codegen/gcc-historical-b06-v1/')
            if (scope not in ('both', 'gcc-only', 'kcc-only') or
                    row['test_kind'] not in ('compile', 'run') or
                    not owner or not owner.startswith(prefix) or
                    owner in batch6_owners or owner in batch5_owners or
                    owner in batch4_owners or owner in batch3_owners or
                    owner in batch2_owners):
                errors.append('batch06 invalid active source owner: ' + path)
            batch6_owners[owner] = row
            src = ROOT / owner
            if (not src.is_file() or
                    digest(src.read_bytes()) != row['integrated_sha256']):
                errors.append('batch06 adapted source hash mismatch: ' + path)
        elif (scope != 'none' or row['test_kind'] or owner or
              row['integrated_sha256'] or row['gcc_profiles'] or
              row['kcc_profiles']):
            errors.append('batch06 excluded source has active test owner: ' + path)
    if len(batch6_owners) != 12:
        errors.append('batch06 source review has incorrect active owner count')
    batch7 = read_tsv(BATCH07)
    selected7 = [r['original_source'] for r in originals
                 if (r['original_source'][len('gcc/testsuite/'):] not in REVIEWED
                     and r['original_source'] not in batch_paths
                     and r['original_source'] not in batch2_paths
                     and r['original_source'] not in batch3_paths
                     and r['original_source'] not in batch4_paths
                     and r['original_source'] not in batch5_paths
                     and r['original_source'] not in batch6_paths)][:50]
    batch7_paths = [r['original_source'] for r in batch7]
    if (len(batch7) != 50 or batch7_paths != selected7 or
            len(set(batch7_paths)) != 50):
        errors.append('batch07 must contain exactly the next 50 unresolved original GCC sources in order')
    batch7_owners = {}
    for row in batch7:
        path = row['original_source']
        decision = row['disposition']
        scope = row['compiler_scope']
        owner = row['integrated_path']
        if row['source_sha256'] != source_hashes.get(path):
            errors.append('batch07 original source hash mismatch: ' + path)
        if (not row['original_oracle'] or not row['pdp10_reason'] or
                not row['kcc_reason'] or not row['constraints_not_exercised'] or
                decision not in ('integrate', 'defer', 'inapplicable')):
            errors.append('batch07 incomplete source decision: ' + path)
        if decision == 'integrate':
            prefix = ('tests/semantic/gcc-historical-b07-v1/'
                      if row['test_kind'] == 'run' else
                      'tests/codegen/gcc-historical-b07-v1/')
            if (scope not in ('both', 'gcc-only', 'kcc-only') or
                    row['test_kind'] not in ('compile', 'run') or
                    not owner or not owner.startswith(prefix) or
                    owner in batch7_owners or owner in batch6_owners or
                    owner in batch5_owners or owner in batch4_owners or
                    owner in batch3_owners or owner in batch2_owners):
                errors.append('batch07 invalid active source owner: ' + path)
            batch7_owners[owner] = row
            original_data = snapshot_path(path).read_bytes()
            expected = (b'/* codegen-kcc-preprocess: source */\n' + original_data
                        if owner.endswith(('20000207-1.c', '20000207-2.c'))
                        else original_data)
            src = ROOT / owner
            if (not src.is_file() or src.read_bytes() != expected or
                    digest(src.read_bytes()) != row['integrated_sha256']):
                errors.append('batch07 adapted source mismatch: ' + path)
        elif (scope != 'none' or row['test_kind'] or owner or
              row['integrated_sha256'] or row['gcc_profiles'] or
              row['kcc_profiles']):
            errors.append('batch07 excluded source has active test owner: ' + path)
    if len(batch7_owners) != 11:
        errors.append('batch07 source review has incorrect active owner count')
    expected_headers = {'gcc/testsuite/gcc.dg/cpp/20000628-1.h',
                        'gcc/testsuite/gcc.dg/cpp/20000628-1a.h'}
    header_rows = read_tsv(BATCH07_COMPANIONS)
    if (len(header_rows) != 2 or
            {r['original_source'] for r in header_rows} != expected_headers):
        errors.append('batch07 must pin exactly two recursive include companions')
    for row in header_rows:
        original = row['original_source']
        owner = 'tests/codegen/gcc-historical-b07-v1/20000628-1.c'
        target = ROOT / row['integrated_path']
        if (row['integrated_owner'] != owner or
                row['integrated_path'] !=
                'tests/codegen/gcc-historical-b07-v1/' + original.rsplit('/', 1)[-1] or
                not target.is_file() or
                not snapshot_path(original).is_file() or
                target.read_bytes() != snapshot_path(original).read_bytes() or
                row['source_sha256'] != digest(snapshot_path(original).read_bytes()) or
                row['integrated_sha256'] != digest(target.read_bytes())):
            errors.append('batch07 recursive header hash/ownership mismatch: ' + original)
    batch8 = read_tsv(BATCH08)
    selected8 = [r['original_source'] for r in originals
                 if (r['original_source'][len('gcc/testsuite/'):] not in REVIEWED
                     and r['original_source'] not in batch_paths
                     and r['original_source'] not in batch2_paths
                     and r['original_source'] not in batch3_paths
                     and r['original_source'] not in batch4_paths
                     and r['original_source'] not in batch5_paths
                     and r['original_source'] not in batch6_paths
                     and r['original_source'] not in batch7_paths)][:50]
    batch8_paths = [r['original_source'] for r in batch8]
    if (len(batch8) != 50 or batch8_paths != selected8 or
            len(set(batch8_paths)) != 50):
        errors.append('batch08 must contain exactly the next 50 unresolved original GCC sources in order')
    batch8_owners = {}
    for row in batch8:
        path = row['original_source']
        decision = row['disposition']
        scope = row['compiler_scope']
        owner = row['integrated_path']
        if row['source_sha256'] != source_hashes.get(path):
            errors.append('batch08 original source hash mismatch: ' + path)
        if (not row['original_oracle'] or not row['pdp10_reason'] or
                not row['kcc_reason'] or not row['constraints_not_exercised'] or
                decision not in ('integrate', 'defer', 'inapplicable')):
            errors.append('batch08 incomplete source decision: ' + path)
        if decision == 'integrate':
            prefix = ('tests/semantic/gcc-historical-b08-v1/'
                      if row['test_kind'] == 'run' else
                      'tests/codegen/gcc-historical-b08-v1/')
            if (scope not in ('both', 'gcc-only', 'kcc-only') or
                    row['test_kind'] not in ('compile', 'run') or
                    not owner or not owner.startswith(prefix) or
                    owner in batch8_owners or owner in batch7_owners or
                    owner in batch6_owners or owner in batch5_owners or
                    owner in batch4_owners or owner in batch3_owners or
                    owner in batch2_owners):
                errors.append('batch08 invalid active source owner: ' + path)
            batch8_owners[owner] = row
            original_data = snapshot_path(path).read_bytes()
            expected = (b'/* codegen-kcc-preprocess: source */\n' + original_data
                        if owner.endswith(('if-sc.c', 'if-unary.c', 'include1.c'))
                        else original_data)
            src = ROOT / owner
            if (not src.is_file() or src.read_bytes() != expected or
                    digest(src.read_bytes()) != row['integrated_sha256']):
                errors.append('batch08 adapted source mismatch: ' + path)
        elif (scope != 'none' or row['test_kind'] or owner or
              row['integrated_sha256'] or row['gcc_profiles'] or
              row['kcc_profiles']):
            errors.append('batch08 excluded source has active test owner: ' + path)
    if len(batch8_owners) != 7:
        errors.append('batch08 source review has incorrect active owner count')
    header8 = read_tsv(BATCH08_COMPANIONS)
    if (len(header8) != 1 or
            header8[0]['original_source'] != 'gcc/testsuite/gcc.dg/cpp/mi1c.h'):
        errors.append('batch08 requires the original CPP mi1c.h header')
    for row in header8:
        original = row['original_source']
        target = ROOT / row['integrated_path']
        if (row['integrated_owner'] != 'tests/codegen/gcc-historical-b08-v1/include1.c' or
                row['integrated_path'] != 'tests/codegen/gcc-historical-b08-v1/mi1c.h' or
                not target.is_file() or not snapshot_path(original).is_file() or
                target.read_bytes() != snapshot_path(original).read_bytes() or
                row['source_sha256'] != digest(snapshot_path(original).read_bytes()) or
                row['integrated_sha256'] != digest(target.read_bytes())):
            errors.append('batch08 CPP header hash/ownership mismatch: ' + original)
    batch9 = read_tsv(BATCH09)
    selected9 = [r['original_source'] for r in originals
                 if (r['original_source'][len('gcc/testsuite/'):] not in REVIEWED
                     and r['original_source'] not in batch_paths
                     and r['original_source'] not in batch2_paths
                     and r['original_source'] not in batch3_paths
                     and r['original_source'] not in batch4_paths
                     and r['original_source'] not in batch5_paths
                     and r['original_source'] not in batch6_paths
                     and r['original_source'] not in batch7_paths
                     and r['original_source'] not in batch8_paths)][:50]
    batch9_paths = [r['original_source'] for r in batch9]
    if (len(batch9) != 50 or batch9_paths != selected9 or
            len(set(batch9_paths)) != 50):
        errors.append('batch09 must contain exactly the next 50 unresolved original GCC sources in order')
    batch9_owners = {}
    preprocess9 = {'macro11.c', 'macro4.c', 'macro5.c', 'mi4.c'}
    for row in batch9:
        path = row['original_source']
        decision = row['disposition']
        scope = row['compiler_scope']
        owner = row['integrated_path']
        if row['source_sha256'] != source_hashes.get(path):
            errors.append('batch09 original source hash mismatch: ' + path)
        if (not row['original_oracle'] or not row['pdp10_reason'] or
                not row['kcc_reason'] or not row['constraints_not_exercised'] or
                decision not in ('integrate', 'defer', 'inapplicable')):
            errors.append('batch09 incomplete source decision: ' + path)
        if decision == 'integrate':
            prefix = ('tests/semantic/gcc-historical-b09-v1/'
                      if row['test_kind'] == 'run' else
                      'tests/codegen/gcc-historical-b09-v1/')
            if (scope not in ('both', 'gcc-only', 'kcc-only') or
                    row['test_kind'] not in ('compile', 'run') or
                    not owner or not owner.startswith(prefix) or
                    owner in batch9_owners or owner in batch8_owners or
                    owner in batch7_owners or owner in batch6_owners or
                    owner in batch5_owners or owner in batch4_owners or
                    owner in batch3_owners or owner in batch2_owners):
                errors.append('batch09 invalid active source owner: ' + path)
            batch9_owners[owner] = row
            original_data = snapshot_path(path).read_bytes()
            expected = (b'/* codegen-kcc-preprocess: source */\n'
                        if owner.rsplit('/', 1)[-1] in preprocess9 else b'') + original_data
            src = ROOT / owner
            if (not src.is_file() or src.read_bytes() != expected or
                    digest(src.read_bytes()) != row['integrated_sha256']):
                errors.append('batch09 adapted source mismatch: ' + path)
        elif (scope != 'none' or row['test_kind'] or owner or
              row['integrated_sha256'] or row['gcc_profiles'] or
              row['kcc_profiles']):
            errors.append('batch09 excluded source has active test owner: ' + path)
    if len(batch9_owners) != 19:
        errors.append('batch09 source review has incorrect active owner count')
    expected_companion9 = {
        'mi2.c': {'mi2a.h', 'mi2b.h', 'mi2c.h'},
        'mi3.c': {'mi3.def', 'mi3.h'},
        'mi4.c': {'mi1c.h'},
        'mi6.c': {'mi6a.h', 'mi6b.h', 'mi6c.h', 'mi6d.h', 'mi6e.h'},
    }
    expected_header9 = {
        ('gcc/testsuite/gcc.dg/cpp/' + name,
         'tests/' + ('semantic' if owner == 'mi6.c' else 'codegen') +
         '/gcc-historical-b09-v1/' + name,
         'tests/' + ('semantic' if owner == 'mi6.c' else 'codegen') +
         '/gcc-historical-b09-v1/' + owner)
        for owner, names in expected_companion9.items()
        for name in names
    }
    header9 = read_tsv(BATCH09_COMPANIONS)
    if (len(header9) != 11 or
            {(r['original_source'], r['integrated_path'], r['integrated_owner'])
             for r in header9} != expected_header9):
        errors.append('batch09 companion manifest must pin 11 exact include dependencies')
    for row in header9:
        original = row['original_source']
        src = snapshot_path(original)
        target = ROOT / row['integrated_path']
        if (not src.is_file() or not target.is_file() or
                src.read_bytes() != target.read_bytes() or
                row['source_sha256'] != digest(src.read_bytes()) or
                row['integrated_sha256'] != digest(target.read_bytes())):
            errors.append('batch09 companion header hash/ownership mismatch: ' + original)
    batch10 = read_tsv(BATCH10)
    selected10 = [r['original_source'] for r in originals
                  if (r['original_source'][len('gcc/testsuite/'):] not in REVIEWED
                      and r['original_source'] not in batch_paths
                      and r['original_source'] not in batch2_paths
                      and r['original_source'] not in batch3_paths
                      and r['original_source'] not in batch4_paths
                      and r['original_source'] not in batch5_paths
                      and r['original_source'] not in batch6_paths
                      and r['original_source'] not in batch7_paths
                      and r['original_source'] not in batch8_paths
                      and r['original_source'] not in batch9_paths)][:50]
    batch10_paths = [r['original_source'] for r in batch10]
    if (len(batch10) != 50 or batch10_paths != selected10 or
            len(set(batch10_paths)) != 50):
        errors.append('batch10 must contain exactly the next 50 unresolved originals in order')
    batch10_owners = {}
    for row in batch10:
        path = row['original_source']
        decision = row['disposition']
        scope = row['compiler_scope']
        owner = row['integrated_path']
        if row['source_sha256'] != source_hashes.get(path):
            errors.append('batch10 original source hash mismatch: ' + path)
        if (not row['original_oracle'] or not row['pdp10_reason'] or
                not row['kcc_reason'] or not row['constraints_not_exercised'] or
                decision not in ('integrate', 'defer', 'inapplicable')):
            errors.append('batch10 incomplete source decision: ' + path)
        if decision == 'integrate':
            prefix = ('tests/semantic/gcc-historical-b10-v1/'
                      if row['test_kind'] == 'run' else
                      'tests/codegen/gcc-historical-b10-v1/')
            if (scope != 'gcc-only' or row['test_kind'] not in ('compile', 'run') or
                    not owner or not owner.startswith(prefix) or
                    owner in batch10_owners or owner in batch9_owners or
                    owner in batch8_owners or owner in batch7_owners or
                    owner in batch6_owners or owner in batch5_owners or
                    owner in batch4_owners or owner in batch3_owners or
                    owner in batch2_owners):
                errors.append('batch10 invalid active source owner: ' + path)
            batch10_owners[owner] = row
            src = ROOT / owner
            expected = snapshot_path(path).read_bytes()
            if (not src.is_file() or src.read_bytes() != expected or
                    digest(src.read_bytes()) != row['integrated_sha256']):
                errors.append('batch10 original/active source mismatch: ' + path)
        elif (scope != 'none' or row['test_kind'] or owner or
              row['integrated_sha256'] or row['gcc_profiles'] or
              row['kcc_profiles']):
            errors.append('batch10 deferred/inapplicable original has active owner: ' + path)
    if len(batch10_owners) != 3:
        errors.append('batch10 source review has incorrect active owner count')
    if sum(r['disposition'] == 'inapplicable' for r in batch10) != 5:
        errors.append('batch10 must record exactly five newly inapplicable originals')
    batch11 = read_tsv(BATCH11)
    prior_reviewed = (set(batch_paths) | set(batch2_paths) |
                      set(batch3_paths) | set(batch4_paths) |
                      set(batch5_paths) | set(batch6_paths) |
                      set(batch7_paths) | set(batch8_paths) |
                      set(batch9_paths) | set(batch10_paths))
    selected11 = [r['original_source'] for r in originals
                  if (r['original_source'][len('gcc/testsuite/'):] not in REVIEWED
                      and r['original_source'] not in prior_reviewed)][:50]
    batch11_paths = [r['original_source'] for r in batch11]
    if (len(batch11) != 50 or batch11_paths != selected11 or
            len(set(batch11_paths)) != 50):
        errors.append('batch11 must contain exactly the next 50 unresolved sources in order')
    format_header = 'gcc/testsuite/gcc.dg/format/format.h'
    format_companions = [r for r in read_tsv(COMPANIONS)
                         if r['original_source'] == format_header]
    hdr = snapshot_path(format_header)
    if (len(format_companions) != 1 or
            format_companions[0]['status'] != 'preserved' or
            not hdr.is_file() or
            digest(hdr.read_bytes()) != format_companions[0]['source_sha256']):
        errors.append('batch11 original format.h companion is missing or modified')
    for row in batch11:
        path = row['original_source']
        source = snapshot_path(path)
        if row['source_sha256'] != source_hashes.get(path) or not source.is_file():
            errors.append('batch11 original hash or source missing: ' + path)
            continue
        data = source.read_bytes()
        source_text = data.decode('latin-1')
        if digest(data) != row['source_sha256']:
            errors.append('batch11 original source changed: ' + path)
        if (row['disposition'] != 'defer' or row['compiler_scope'] != 'none' or
                row['test_kind'] or row['integrated_path'] or
                row['integrated_sha256'] or row['gcc_profiles'] or
                row['kcc_profiles']):
            errors.append('batch11 diagnostic-only source incorrectly activated: ' + path)
        if (not row['original_oracle'] or not row['pdp10_reason'] or
                not row['kcc_reason'] or not row['constraints_not_exercised']):
            errors.append('batch11 incomplete individual oracle review: ' + path)
        options = re.findall(r'\bdg-options\s+"([^"]+)"', source_text)
        actions = re.findall(r'\bdg-do\s+([a-z]+)', source_text)
        if (len(options) != 1 or row['dg_options'] != options[0] or
                actions != ['compile'] or row['dg_target'] != 'compile'):
            errors.append('batch11 original DejaGNU action/options mismatch: ' + path)
        diagnostics = collections.Counter(re.findall(
            r'\{\s*dg-(warning|error|bogus)\b', source_text))
        for kind in ('warning', 'error', 'bogus'):
            if row[kind + '_assertions'] != str(diagnostics[kind]):
                errors.append('batch11 diagnostic count mismatch: ' + path + ' ' + kind)
        included = bool(re.search(
            r'^\s*#\s*include\s+"format\.h"', source_text, re.M))
        if (row['quoted_format_header'] != ('yes' if included else 'no') or
                (not included and path.rsplit('/', 1)[-1] not in
                 ('attr-5.c', 'attr-6.c'))):
            errors.append('batch11 format header ownership mismatch: ' + path)
    if sum(int(row['warning_assertions']) for row in batch11) != 940:
        errors.append('batch11 historical format-warning oracle census changed')
    if (sum(int(row['error_assertions']) for row in batch11) != 33 or
            sum(int(row['bogus_assertions']) for row in batch11) != 11):
        errors.append('batch11 historical diagnostic error/absence census changed')
    final_batches = [(12, read_tsv(BATCH12), 50, 3, 22),
                     (13, read_tsv(BATCH13), 50, 7, 3),
                     (14, read_tsv(BATCH14), 5, 0, 0)]
    final_originals = [r['original_source'] for r in originals
                       if (r['original_source'][len('gcc/testsuite/'):] not in REVIEWED
                           and r['original_source'] not in prior_reviewed
                           and r['original_source'] not in batch11_paths)]
    if len(final_originals) != 105:
        errors.append('final historical GCC original queue must have 105 identities')
    final_paths = []
    final_owners = {}
    final_rejected = 0
    final_deferred = 0
    for index, review, count, integrated, rejected_count in final_batches:
        paths = [r['original_source'] for r in review]
        if (len(review) != count or len(set(paths)) != count or
                paths != final_originals[len(final_paths):len(final_paths) + count]):
            errors.append('batch%02d must review exactly the next %d originals in order' %
                          (index, count))
        final_paths.extend(paths)
        if (sum(r['disposition'] == 'integrate' for r in review) != integrated or
                sum(r['disposition'] == 'inapplicable' for r in review) != rejected_count):
            errors.append('batch%02d integrated/rejected counts diverged' % index)
        for row in review:
            original = row['original_source']
            decision = row['disposition']
            owner = row['integrated_path']
            if row['source_sha256'] != source_hashes.get(original):
                errors.append('final GCC original SHA256 mismatch: ' + original)
            if (not row['original_oracle'] or not row['pdp10_reason'] or
                    not row['kcc_reason'] or not row['constraints_not_exercised'] or
                    decision not in ('integrate', 'inapplicable', 'defer')):
                errors.append('final GCC review has incomplete source decision: ' + original)
            for key in ('warning', 'error', 'bogus', 'final'):
                if not row[key + '_assertions'].isdigit():
                    errors.append('final GCC invalid diagnostic count: ' + original)
            if decision == 'integrate':
                prefix = ('tests/semantic/gcc-historical-b%02d-v1/' % index
                          if row['test_kind'] == 'run' else
                          'tests/codegen/gcc-historical-b%02d-v1/' % index)
                source = snapshot_path(original)
                compiled = ROOT / owner
                if (row['test_kind'] not in ('run', 'compile') or not owner or
                        not owner.startswith(prefix) or owner in final_owners or
                        not source.is_file() or not compiled.is_file() or
                        source.read_bytes() != compiled.read_bytes() or
                        row['integrated_sha256'] != digest(compiled.read_bytes())):
                    errors.append('final GCC original source adaptation mismatch: ' + original)
                final_owners[owner] = row
                allowed_kcc = (row['compiler_scope'] == 'both')
                gcc_cells = row['gcc_profiles'].split(';') if row['gcc_profiles'] else []
                kcc_cells = row['kcc_profiles'].split(';') if row['kcc_profiles'] else []
                expected_gcc = (['pdp6_gcc_o2']
                                if owner.rsplit('/', 1)[-1] in
                                ('struct-alias-1.c', 'struct-by-value-1.c', 'ultrasp4.c')
                                else ['pdp6_gcc_o0', 'pdp6_gcc_o1',
                                      'pdp6_gcc_o2', 'pdp6_gcc_os'])
                expected_kcc = ['pdp6', 'pdp6_base'] if allowed_kcc else []
                if (row['compiler_scope'] not in ('both', 'gcc-only') or
                        gcc_cells != expected_gcc or kcc_cells != expected_kcc):
                    errors.append('final GCC invalid compiler profile selection: ' + original)
            elif (row['compiler_scope'] != 'none' or row['test_kind'] or owner or
                  row['integrated_sha256'] or row['gcc_profiles'] or row['kcc_profiles']):
                errors.append('excluded final GCC source has active matrix owner: ' + original)
            if decision == 'inapplicable':
                final_rejected += 1
            elif decision == 'defer':
                final_deferred += 1
    if (len(final_paths) != 105 or final_paths != final_originals or
            len(final_owners) != 10 or final_rejected != 25 or final_deferred != 70):
        errors.append('final GCC census must classify exactly 105 originals')
    deleted = removed_originals()
    rejected = {}
    for index, review in enumerate((batch, batch2, batch3,
                                    batch4, batch5, batch6, batch7, batch8,
                                    batch9, batch10, batch11,
                                    final_batches[0][1], final_batches[1][1],
                                    final_batches[2][1]), 1):
        for row in review:
            decision = row['decision'] if index == 1 else row['disposition']
            if decision != 'inapplicable':
                continue
            original = row['original_source']
            rejected[original] = (index, row)
    if set(deleted) != set(rejected):
        errors.append('inapplicable deletion manifest differs from reviewed decisions')
    for original, removed in deleted.items():
        original_row = next((r for r in originals
                             if r['original_source'] == original), None)
        reviewed_row = rejected.get(original)
        recorded = by_path.get(original)
        if not original_row or not reviewed_row or not recorded:
            errors.append('unknown or unreviewed deleted source: ' + original)
            continue
        index, review = reviewed_row
        reason = (review['review_reason'] if index == 1
                  else review['pdp10_reason'])
        expected_status = 'batch%02d-inapplicable' % index
        if (removed['source_sha256'] != original_row['source_sha256'] or
                removed['snapshot_path'] != snapshot_path(original).relative_to(ROOT).as_posix() or
                removed['review_status'] != expected_status or
                removed['inapplicable_reason'] != reason or
                removed['removal_action'] != 'delete-original-snapshot' or
                recorded['review_status'] != expected_status or
                recorded['source_sha256'] != removed['source_sha256'] or
                recorded['review_reason'] != reason or recorded['matrix_owner']):
            errors.append('inapplicable deletion record diverged: ' + original)
    matrix_rows = {}
    with (ROOT / 'COMPILER_MATRIX.tsv').open(encoding='utf-8') as stream:
        matrix_rows = {r['test']: r for r in csv.DictReader(
            (line for line in stream if line.strip() and not line.startswith('#')),
            delimiter='\t')}
    matrix = set(matrix_rows)
    if any('/gcc-historical-b11-v1/' in owner for owner in matrix):
        errors.append('batch11 deferred format sources must not have compiler matrix registrations')
    for folder in ('tests/semantic/gcc-historical-b11-v1',
                   'tests/codegen/gcc-historical-b11-v1'):
        if (ROOT / folder).exists() and list((ROOT / folder).glob('*')):
            errors.append('batch11 has unexpected active test source: ' + folder)
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
    for owner, row in batch5_owners.items():
        entry = matrix_rows.get(owner)
        if entry is None:
            errors.append('batch05 test not registered: ' + owner)
            continue
        expected_group = ('semantic-gcc-historical-b05' if row['test_kind'] == 'run'
                          else 'codegen-gcc-historical-b05')
        if entry['group'] != expected_group:
            errors.append('batch05 incorrect matrix group: ' + owner)
        gcc_cells = row['gcc_profiles'].split(';') if row['gcc_profiles'] else []
        kcc_cells = row['kcc_profiles'].split(';') if row['kcc_profiles'] else []
        valid_gcc = {'pdp6_gcc_o0', 'pdp6_gcc_o1',
                     'pdp6_gcc_o2', 'pdp6_gcc_os'}
        valid_kcc = {'pdp6', 'pdp6_base'}
        if (not set(gcc_cells) <= valid_gcc or
                not set(kcc_cells) <= valid_kcc or
                len(set(gcc_cells)) != len(gcc_cells) or
                len(set(kcc_cells)) != len(kcc_cells) or
                bool(gcc_cells) != (row['compiler_scope'] in ('both', 'gcc-only')) or
                bool(kcc_cells) != (row['compiler_scope'] in ('both', 'kcc-only'))):
            errors.append('batch05 inconsistent compiler profile review: ' + owner)
        allowed = set(gcc_cells + kcc_cells)
        for col, value in entry.items():
            if col in ('test', 'group', 'name'):
                continue
            if col in allowed:
                if value != 'pending':
                    errors.append('batch05 expected pending compiler cell: %s %s' %
                                  (owner, col))
            elif value != 'no_test':
                errors.append('batch05 unreviewed compiler cell: %s %s' %
                              (owner, col))
    for folder in ('tests/semantic/gcc-historical-b05-v1',
                   'tests/codegen/gcc-historical-b05-v1'):
        for src in (ROOT / folder).glob('*.c'):
            name = src.relative_to(ROOT).as_posix()
            if name not in batch5_owners:
                errors.append('unowned batch05 C source: ' + name)
    for owner, row in batch6_owners.items():
        entry = matrix_rows.get(owner)
        if entry is None:
            errors.append('batch06 test not registered: ' + owner)
            continue
        expected_group = ('semantic-gcc-historical-b06' if row['test_kind'] == 'run'
                          else 'codegen-gcc-historical-b06')
        if entry['group'] != expected_group:
            errors.append('batch06 incorrect matrix group: ' + owner)
        gcc_cells = row['gcc_profiles'].split(';') if row['gcc_profiles'] else []
        kcc_cells = row['kcc_profiles'].split(';') if row['kcc_profiles'] else []
        valid_gcc = {'pdp6_gcc_o0', 'pdp6_gcc_o1',
                     'pdp6_gcc_o2', 'pdp6_gcc_os'}
        valid_kcc = {'pdp6', 'pdp6_base'}
        if (not set(gcc_cells) <= valid_gcc or
                not set(kcc_cells) <= valid_kcc or
                len(set(gcc_cells)) != len(gcc_cells) or
                len(set(kcc_cells)) != len(kcc_cells) or
                bool(gcc_cells) != (row['compiler_scope'] in ('both', 'gcc-only')) or
                bool(kcc_cells) != (row['compiler_scope'] in ('both', 'kcc-only'))):
            errors.append('batch06 inconsistent compiler profile review: ' + owner)
        allowed = set(gcc_cells + kcc_cells)
        for col, value in entry.items():
            if col in ('test', 'group', 'name'):
                continue
            if col in allowed:
                if value != 'pending':
                    errors.append('batch06 expected pending compiler cell: %s %s' %
                                  (owner, col))
            elif value != 'no_test':
                errors.append('batch06 unreviewed compiler cell: %s %s' %
                              (owner, col))
    for folder in ('tests/semantic/gcc-historical-b06-v1',
                   'tests/codegen/gcc-historical-b06-v1'):
        for src in (ROOT / folder).glob('*.c'):
            name = src.relative_to(ROOT).as_posix()
            if name not in batch6_owners:
                errors.append('unowned batch06 C source: ' + name)
    for owner, row in batch7_owners.items():
        entry = matrix_rows.get(owner)
        if entry is None:
            errors.append('batch07 test not registered: ' + owner)
            continue
        expected_group = ('semantic-gcc-historical-b07' if row['test_kind'] == 'run'
                          else 'codegen-gcc-historical-b07')
        if entry['group'] != expected_group:
            errors.append('batch07 incorrect matrix group: ' + owner)
        gcc_cells = row['gcc_profiles'].split(';') if row['gcc_profiles'] else []
        kcc_cells = row['kcc_profiles'].split(';') if row['kcc_profiles'] else []
        valid_gcc = {'pdp6_gcc_o0', 'pdp6_gcc_o1',
                     'pdp6_gcc_o2', 'pdp6_gcc_os'}
        valid_kcc = {'pdp6', 'pdp6_base'}
        if (not set(gcc_cells) <= valid_gcc or
                not set(kcc_cells) <= valid_kcc or
                len(set(gcc_cells)) != len(gcc_cells) or
                len(set(kcc_cells)) != len(kcc_cells) or
                bool(gcc_cells) != (row['compiler_scope'] in ('both', 'gcc-only')) or
                bool(kcc_cells) != (row['compiler_scope'] in ('both', 'kcc-only'))):
            errors.append('batch07 inconsistent compiler profile review: ' + owner)
        allowed = set(gcc_cells + kcc_cells)
        for col, value in entry.items():
            if col in ('test', 'group', 'name'):
                continue
            if col in allowed:
                if value != 'pending':
                    errors.append('batch07 expected pending compiler cell: %s %s' %
                                  (owner, col))
            elif value != 'no_test':
                errors.append('batch07 unreviewed compiler cell: %s %s' %
                              (owner, col))
    for folder in ('tests/semantic/gcc-historical-b07-v1',
                   'tests/codegen/gcc-historical-b07-v1'):
        for src in (ROOT / folder).glob('*.c'):
            name = src.relative_to(ROOT).as_posix()
            if name not in batch7_owners:
                errors.append('unowned batch07 C source: ' + name)
    actual_headers = {p.relative_to(ROOT).as_posix()
                      for p in (ROOT / 'tests/codegen/gcc-historical-b07-v1').glob('*.h')}
    expected_header_paths = {r['integrated_path'] for r in header_rows}
    if actual_headers != expected_header_paths:
        errors.append('batch07 unexpected or missing recursive include headers')
    for owner, row in batch8_owners.items():
        entry = matrix_rows.get(owner)
        if entry is None:
            errors.append('batch08 test not registered: ' + owner)
            continue
        expected_group = ('semantic-gcc-historical-b08' if row['test_kind'] == 'run'
                          else 'codegen-gcc-historical-b08')
        if entry['group'] != expected_group:
            errors.append('batch08 incorrect matrix group: ' + owner)
        gcc_cells = row['gcc_profiles'].split(';') if row['gcc_profiles'] else []
        kcc_cells = row['kcc_profiles'].split(';') if row['kcc_profiles'] else []
        valid_gcc = {'pdp6_gcc_o0', 'pdp6_gcc_o1',
                     'pdp6_gcc_o2', 'pdp6_gcc_os'}
        valid_kcc = {'pdp6', 'pdp6_base'}
        if (not set(gcc_cells) <= valid_gcc or
                not set(kcc_cells) <= valid_kcc or
                len(set(gcc_cells)) != len(gcc_cells) or
                len(set(kcc_cells)) != len(kcc_cells) or
                bool(gcc_cells) != (row['compiler_scope'] in ('both', 'gcc-only')) or
                bool(kcc_cells) != (row['compiler_scope'] in ('both', 'kcc-only'))):
            errors.append('batch08 inconsistent compiler profile review: ' + owner)
        allowed = set(gcc_cells + kcc_cells)
        for col, value in entry.items():
            if col in ('test', 'group', 'name'):
                continue
            if col in allowed:
                if value != 'pending':
                    errors.append('batch08 expected pending compiler cell: %s %s' %
                                  (owner, col))
            elif value != 'no_test':
                errors.append('batch08 unreviewed compiler cell: %s %s' %
                              (owner, col))
    for folder in ('tests/semantic/gcc-historical-b08-v1',
                   'tests/codegen/gcc-historical-b08-v1'):
        for src in (ROOT / folder).glob('*.c'):
            name = src.relative_to(ROOT).as_posix()
            if name not in batch8_owners:
                errors.append('unowned batch08 C source: ' + name)
    headers8 = {p.relative_to(ROOT).as_posix()
                for p in (ROOT / 'tests/codegen/gcc-historical-b08-v1').glob('*.h')}
    if headers8 != {r['integrated_path'] for r in header8}:
        errors.append('batch08 unexpected or missing CPP include headers')
    for owner, row in batch9_owners.items():
        entry = matrix_rows.get(owner)
        if entry is None:
            errors.append('batch09 test not registered: ' + owner)
            continue
        expected_group = ('semantic-gcc-historical-b09' if row['test_kind'] == 'run'
                          else 'codegen-gcc-historical-b09')
        if entry['group'] != expected_group:
            errors.append('batch09 incorrect matrix group: ' + owner)
        gcc_cells = row['gcc_profiles'].split(';') if row['gcc_profiles'] else []
        kcc_cells = row['kcc_profiles'].split(';') if row['kcc_profiles'] else []
        valid_gcc = {'pdp6_gcc_o0', 'pdp6_gcc_o1',
                     'pdp6_gcc_o2', 'pdp6_gcc_os'}
        valid_kcc = {'pdp6', 'pdp6_base'}
        if (not set(gcc_cells) <= valid_gcc or
                not set(kcc_cells) <= valid_kcc or
                len(set(gcc_cells)) != len(gcc_cells) or
                len(set(kcc_cells)) != len(kcc_cells) or
                bool(gcc_cells) != (row['compiler_scope'] in ('both', 'gcc-only')) or
                bool(kcc_cells) != (row['compiler_scope'] in ('both', 'kcc-only'))):
            errors.append('batch09 inconsistent compiler profile review: ' + owner)
        allowed = set(gcc_cells + kcc_cells)
        for col, value in entry.items():
            if col in ('test', 'group', 'name'):
                continue
            if col in allowed:
                if value != 'pending':
                    errors.append('batch09 expected pending compiler cell: %s %s' %
                                  (owner, col))
            elif value != 'no_test':
                errors.append('batch09 unreviewed compiler cell: %s %s' %
                              (owner, col))
    for folder in ('tests/semantic/gcc-historical-b09-v1',
                   'tests/codegen/gcc-historical-b09-v1'):
        for src in (ROOT / folder).glob('*.c'):
            name = src.relative_to(ROOT).as_posix()
            if name not in batch9_owners:
                errors.append('unowned batch09 C source: ' + name)
    actual_header9 = {p.relative_to(ROOT).as_posix()
                      for folder in ('tests/semantic/gcc-historical-b09-v1',
                                     'tests/codegen/gcc-historical-b09-v1')
                      for p in (ROOT / folder).glob('*')
                      if p.is_file() and p.suffix not in ('.c',)}
    if actual_header9 != {r['integrated_path'] for r in header9}:
        errors.append('batch09 unexpected or missing CPP include companions')
    for owner, row in batch10_owners.items():
        entry = matrix_rows.get(owner)
        if entry is None:
            errors.append('batch10 test not registered: ' + owner)
            continue
        expected_group = ('semantic-gcc-historical-b10' if row['test_kind'] == 'run'
                          else 'codegen-gcc-historical-b10')
        if entry['group'] != expected_group:
            errors.append('batch10 incorrect matrix group: ' + owner)
        valid_gcc = {'pdp6_gcc_o0', 'pdp6_gcc_o1',
                     'pdp6_gcc_o2', 'pdp6_gcc_os'}
        cells = row['gcc_profiles'].split(';') if row['gcc_profiles'] else []
        if (set(cells) != valid_gcc or len(cells) != 4 or
                row['kcc_profiles'] or row['compiler_scope'] != 'gcc-only'):
            errors.append('batch10 incorrect GCC/KCC profile scope: ' + owner)
        for col, value in entry.items():
            if col in ('test', 'group', 'name'):
                continue
            if (col in valid_gcc and value != 'pending') or (
                    col not in valid_gcc and value != 'no_test'):
                errors.append('batch10 unexpected compiler cell: %s %s' % (owner, col))
    for folder in ('tests/semantic/gcc-historical-b10-v1',
                   'tests/codegen/gcc-historical-b10-v1'):
        for src in (ROOT / folder).glob('*.c'):
            name = src.relative_to(ROOT).as_posix()
            if name not in batch10_owners:
                errors.append('unowned batch10 C source: ' + name)
    if (len(list((ROOT / 'tests/semantic/gcc-historical-b10-v1').glob('*'))) != 2 or
            len(list((ROOT / 'tests/codegen/gcc-historical-b10-v1').glob('*'))) != 1):
        errors.append('batch10 unexpected or missing test-local sources')
    for owner, row in final_owners.items():
        entry = matrix_rows.get(owner)
        if entry is None:
            errors.append('final GCC test missing from compiler matrix: ' + owner)
            continue
        index = (12 if '/gcc-historical-b12-v1/' in owner else
                 13 if '/gcc-historical-b13-v1/' in owner else 14)
        expected_group = ('semantic' if row['test_kind'] == 'run' else 'codegen') + \
                         '-gcc-historical-b%02d' % index
        if entry['group'] != expected_group:
            errors.append('final GCC matrix group mismatch: ' + owner)
        allowed = set(row['gcc_profiles'].split(';'))
        if row['kcc_profiles']:
            allowed.update(row['kcc_profiles'].split(';'))
        for col, value in entry.items():
            if col in ('test', 'group', 'name'):
                continue
            if (col in allowed and value != 'pending') or (
                    col not in allowed and value != 'no_test'):
                errors.append('final GCC unreviewed compiler cell: %s %s' %
                              (owner, col))
    for index in (12, 13, 14):
        for folder in ('tests/semantic/gcc-historical-b%02d-v1' % index,
                       'tests/codegen/gcc-historical-b%02d-v1' % index):
            for src in (ROOT / folder).glob('*'):
                if src.is_file() and src.relative_to(ROOT).as_posix() not in final_owners:
                    errors.append('unexpected final GCC unowned source: ' + str(src))
    if any('gcc-historical-b14-v1' in m for m in matrix):
        errors.append('final batch14 deferred sources must not be matrix active')
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
        if path in deleted:
            if stored.exists():
                errors.append('deleted inapplicable original was restored: ' + path)
            continue
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
                'batch02-pending', 'batch03-pending', 'batch04-pending',
                'batch05-pending', 'batch06-pending', 'batch07-pending',
                'batch08-pending', 'batch09-pending', 'batch10-pending',
                'batch12-pending', 'batch13-pending', 'batch14-pending')
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
    structural = read_tsv(STRUCTURAL)
    structural_paths = [r['original_source'] for r in structural]
    retained_paths = {r['original_source'] for r in originals
                      if r['original_source'] not in deleted}
    if (len(structural_paths) != len(retained_paths) or
            set(structural_paths) != retained_paths):
        errors.append('structural overlap index is not restricted to retained originals')
    snapshots = {p.relative_to(ROOT).as_posix()
                 for p in REFS.rglob('*.c')}
    expected = {snapshot_path(r['original_source']).relative_to(ROOT).as_posix()
                for r in originals if r['original_source'] not in deleted}
    expected.update(snapshot_path(p).relative_to(ROOT).as_posix()
                    for p, row in companion_paths.items()
                    if row['status'] == 'preserved' and p.endswith('.c'))
    for extra in sorted(snapshots - expected):
        errors.append('unowned GCC archival source: ' + extra)
    counts = collections.Counter(r['review_status'] for r in ledger)
    print('GCC historical C decisions: %d; retained snapshots: %d; '
          'deleted inapplicable originals: %d; statuses: %s' %
          (len(ledger), len(originals) - len(deleted), len(deleted),
           ', '.join('%s=%d' % p for p in sorted(counts.items()))))
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
