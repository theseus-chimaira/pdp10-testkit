#!/usr/bin/env python3
"""Static syntax and local-fixture prerequisites for registered testkit.

This check never runs a compiler or guest program.  It validates tracked
shell/Python scripts and literal quoted C includes in matrix sources.
Compiler-provided angle includes and conditional target APIs are separate.
"""

import ast
import csv
from pathlib import Path
import re
import subprocess


ROOT = Path(__file__).resolve().parents[1]
INCLUDE = re.compile(r'^\s*#\s*include\s*"([^"\n]+)"', re.M)


def tracked_scripts():
    output = subprocess.check_output(
        ['git', 'ls-files', '--cached', '--others', '--exclude-standard',
         '--', 'misc', 'tests', 'tools', 'refs'],
        cwd=ROOT, text=True)
    return sorted(set(path for path in output.splitlines()
                      if path.endswith(('.sh', '.py')) and
                      (ROOT / path).is_file()))


def matrix_sources():
    with (ROOT / 'COMPILER_MATRIX.tsv').open(encoding='utf8', newline='') as f:
        lines = (line for line in f if line.strip() and
                 not line.startswith('#'))
        return list(csv.DictReader(lines, delimiter='\t'))


def audit():
    problems = []
    scripts = tracked_scripts()
    shell = python = sources = includes = 0
    for name in scripts:
        path = ROOT / name
        if name.endswith('.py'):
            python += 1
            try:
                ast.parse(path.read_text(encoding='utf8', errors='replace'),
                          filename=name)
            except (SyntaxError, ValueError) as exc:
                problems.append('%s: Python syntax: %s' % (name, exc))
        else:
            shell += 1
            result = subprocess.run(['bash', '-n', str(path)],
                                    capture_output=True, text=True)
            if result.returncode != 0:
                problems.append('%s: shell syntax: %s' %
                                (name, result.stderr.strip()[:250]))

    # These are the source-side include directories actually offered by
    # the configured C runner.  Source-specific -I paths are checked by the
    # separate declared-oracle audit; angle-bracket headers are not owned
    # by this testkit and intentionally not claimed to exist here.
    supports = tuple(ROOT / name for name in (
        'support/kcc', 'support/gcc', 'support/common', 'support/include'))
    for row in matrix_sources():
        name = row['test']
        path = ROOT / name
        if path.suffix != '.c':
            continue
        sources += 1
        # A negative C testcase may intentionally reference a missing
        # header to assert rejection.  Such an absence is not an install
        # prerequisite and must not block the registered negative runner.
        if (row['group'].startswith('negative') or
                row['group'] == 'validation-gcc-edge-negative'):
            continue
        for target in INCLUDE.findall(path.read_text(
                encoding='utf8', errors='replace')):
            includes += 1
            if not any((directory / target).is_file() for directory in
                       (path.parent,) + supports):
                problems.append('%s: unowned local quoted include: %s' %
                                (name, target))

    if not scripts or not sources:
        problems.append('empty script or compiler-source census')
    for issue in problems:
        print('ERROR: ' + issue)
    print('Registered fixture integrity: scripts=%d shell=%d python=%d '
          'C_sources=%d quoted_includes=%d problems=%d' %
          (len(scripts), shell, python, sources, includes, len(problems)))
    return 1 if problems else 0


if __name__ == '__main__':
    raise SystemExit(audit())
