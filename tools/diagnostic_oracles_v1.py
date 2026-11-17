"""Explicit source-located diagnostic assertions for PDP-10 compilers.

The source snapshots remain byte-identical to historical GCC originals.
Different KCC diagnostic wording is stored separately from the original
GCC regexp; no compiler is allowed to pass by merely exiting nonzero.
"""

import csv
import hashlib
from pathlib import Path
import re
import shlex

from compiler_negative_policy_v1 import (check_gcc_rejection,
                                         check_kcc_rejection, ICE_RE)


ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / 'DIAGNOSTIC_ORACLES_V1.tsv'
FIELDS = ('source', 'original', 'sha256', 'compiler', 'outcome',
          'options', 'severity', 'line', 'regex', 'count')
SEVERITIES = frozenset(('warning', 'error', 'bogus'))


def read_oracles(path=REGISTRY):
    with path.open(encoding='ascii', newline='') as stream:
        rows = list(csv.DictReader(stream, delimiter='\t'))
    if not rows or tuple(rows[0]) != FIELDS:
        raise ValueError('invalid diagnostic oracle columns')
    return rows


def group_oracles(rows, source, compiler):
    matches = [r for r in rows if r['source'] == source and
               r['compiler'] == compiler]
    if not matches:
        raise ValueError('no diagnostic oracles for ' + compiler + ' ' + source)
    outcomes = set((r['outcome'], r['options']) for r in matches)
    if len(outcomes) != 1:
        raise ValueError('conflicting compiler actions/options for ' + source)
    return matches


def validate_registry(rows, matrix=None):
    """Reject unowned/malformed declarations before running a compiler."""
    problems = []
    seen = set()
    owned = {}
    for r in rows:
        path = r['source']
        key = (path, r['compiler'], r['severity'], r['line'], r['regex'])
        if key in seen:
            problems.append('duplicated oracle: ' + repr(key))
        seen.add(key)
        if r['compiler'] not in ('gcc', 'kcc') or r['outcome'] not in ('accept', 'reject'):
            problems.append('invalid compiler/action for ' + path)
        if r['severity'] not in SEVERITIES:
            problems.append('invalid severity for ' + path)
        if not r['line'].isdigit() or int(r['line']) < 1:
            problems.append('invalid source line for ' + path)
        if not r['count'].isdigit() or int(r['count']) < 1:
            problems.append('invalid assertion count for ' + path)
        try:
            re.compile(r['regex'])
            flags = shlex.split(r['options'])
            if any(not s.startswith('-') or s.startswith('-o') or
                   s.startswith('-R') or s.startswith('-x') or
                   s.startswith('-march') for s in flags):
                problems.append('unsafe/invalid compiler flag for ' + path)
        except (re.error, ValueError) as error:
            problems.append('invalid regex/options for %s: %s' % (path, error))
        for column in ('source', 'original'):
            full = (ROOT / r[column]).resolve()
            if not full.is_relative_to(ROOT) or not full.is_file():
                problems.append('missing or unsafe ' + column + ': ' + r[column])
        if (ROOT / path).is_file() and (ROOT / r['original']).is_file():
            original = (ROOT / r['original']).read_bytes()
            digest = hashlib.sha256(original).hexdigest()
            if r['sha256'] != digest or (ROOT / path).read_bytes() != original:
                problems.append('historical fixture identity changed: ' + path)
        owned.setdefault(path, set()).add(r['compiler'])
    for source in owned:
        for compiler in owned[source]:
            try:
                group_oracles(rows, source, compiler)
            except ValueError as error:
                problems.append(str(error))
    if matrix is not None:
        registered = {r['test']: r for r in matrix}
        for source, compilers in owned.items():
            row = registered.get(source)
            if row is None or not row['group'].startswith('diagnostic'):
                problems.append('unregistered diagnostic source: ' + source)
                continue
            for col, value in row.items():
                if col in ('test', 'name', 'group') or value not in (
                        'diagnostic', 'pending', 'fail', 'ok', 'error', 'timeout'):
                    continue
                compiler = 'gcc' if '_gcc_' in col else 'kcc'
                if compiler not in compilers:
                    problems.append('registered without compiler oracle: ' +
                                    source + ' ' + col)
        for source, row in registered.items():
            if row['group'].startswith('diagnostic') and source not in owned:
                problems.append('diagnostic matrix row missing oracle: ' + source)
    return problems


def diagnostic_lines(output, compiler, line, source):
    """Return source-located messages from one line, never driver text.

    GCC 3.2 prints `file.c:N: ...`, while KCC uses
    `"file.c", line N: ...`.  Both formats may emit unrelated context,
    summary, and option/launcher text that must not satisfy a predicate.
    """
    # Never let an unrelated header/source diagnostic satisfy the oracle
    # just because it happens to use the same source-line number.
    basename = re.escape(Path(source).name)
    if compiler == 'gcc':
        pattern = re.compile(r'^(?:[^\n:]*[/\\])?' + basename + ':' + str(line) +
                             r'(?::[0-9]+)?:\s*(.+)$')
    else:
        pattern = re.compile(r'^"(?:[^"\n]*[/\\])?' + basename + '", line ' + str(line) +
                             r':\s*(.+)$')
    return [m.group(1) for raw in output.splitlines()
            if (m := pattern.match(raw)) is not None]


def diagnostic_severity(message, compiler):
    if compiler == 'gcc':
        if re.match(r'(?i)^warning\s*:', message):
            return 'warning'
        if re.match(r'(?i)^(?:note|remark)\s*:', message):
            return 'note'
        return 'error'
    if re.match(r'(?i)^\[(?:advisory|warning)\]', message):
        return 'warning'
    if re.match(r'(?i)^\[note\]', message):
        return 'note'
    return 'error'


def check_diagnostics(compiler, outcome, rows, result, output):
    """Return (status, reasons), preserving distinct ICE/setup failures."""
    if result == 'timeout':
        return 'timeout', ['compiler timed out']
    if result == 'setup_fail':
        return 'setup_fail', ['compiler launcher/setup failed']
    if result == 'signal' or ICE_RE.search(output):
        return 'compiler_ice', ['compiler signal/ICE']
    issues = []
    if outcome == 'reject':
        rejection = (check_gcc_rejection if compiler == 'gcc'
                     else check_kcc_rejection)
        if result == 'pass' or result == 'no_output':
            issues.append('compiler unexpectedly accepted source')
        elif result != 'fail':
            issues.append('compiler result not a diagnosed rejection: ' + result)
        else:
            invalid = rejection(1, output)
            if invalid:
                issues.append(invalid)
    elif result != 'pass':
        issues.append('expected successful compilation; got ' + result)

    for row in rows:
        line = int(row['line'])
        pattern = re.compile(row['regex'])
        msgs = diagnostic_lines(output, compiler, line, row['source'])
        matches = sum(bool(pattern.search(msg)) and
                      (row['severity'] == 'bogus' or
                       diagnostic_severity(msg, compiler) == row['severity'])
                      for msg in msgs)
        count = int(row['count'])
        if row['severity'] == 'bogus':
            if matches:
                issues.append('forbidden diagnostic at line %d: %s (%d)' %
                              (line, row['regex'], matches))
        elif matches < count:
            issues.append('missing %s at line %d: %s (%d < %d)' %
                          (row['severity'], line, row['regex'], matches, count))
    return ('policy_fail' if issues else 'pass'), issues
