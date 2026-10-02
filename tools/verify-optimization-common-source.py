#!/usr/bin/env python3
from __future__ import print_function
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
SEMANTIC_MANIFEST = ROOT / 'OPTIMIZATION_SEMANTIC_ONLY.tsv'
RESULT_ONLY_MANIFEST = ROOT / 'OPTIMIZATION_RESULT_ONLY.tsv'
MATRIX = ROOT / 'TEST_MATRIX.tsv'
TOKENS = ('__GNUC__', '__COMPILER_KCC__')

# These constructs have intentionally different KCC/GCC compatibility
# definitions.  The observable result may be comparable, but generated size
# and performance are not directly comparable without a normalized source.
DIFFERENTIAL = (
    'OPAQUE_REG',
    'likely(',
    'unlikely(',
    '__builtin_abs',
    '__builtin_memcpy',
    '__builtin_memset',
    '__builtin_alloca',
    '__builtin_ffs',
    '__builtin_pdp10_jffo',
    '__builtin_va_start',
    '__builtin_va_arg',
    '__builtin_va_end',
)


def read_semantic_manifest(path):
    out = {}
    for raw in path.read_text(encoding='utf-8').splitlines():
        if not raw or raw.startswith('#'):
            continue
        parts = raw.split('\t', 1)
        if len(parts) != 2 or not parts[1].strip():
            print('bad semantic-only manifest line: %s' % raw)
            sys.exit(1)
        out[parts[0]] = parts[1]
    return out


def read_result_only_manifest(path):
    out = {}
    for raw in path.read_text(encoding='utf-8').splitlines():
        if not raw or raw.startswith('#'):
            continue
        parts = raw.split('\t', 2)
        if len(parts) != 3 or not parts[1].strip() or not parts[2].strip():
            print('bad result-only manifest line: %s' % raw)
            sys.exit(1)
        out[parts[0]] = (parts[1], parts[2])
    return out


def active(status):
    return status not in ('', 'no_test', 'unsupported', 'obsolete')


def shared_matrix_sources():
    lines = MATRIX.read_text(encoding='utf-8').splitlines()
    header = None
    out = set()
    for raw in lines:
        if raw.startswith('test\t'):
            header = raw.split('\t')
            break
    if header is None:
        print('TEST_MATRIX.tsv has no header')
        sys.exit(1)
    for raw in lines:
        if not raw or raw.startswith('#') or raw.startswith('test\t'):
            continue
        parts = raw.split('\t')
        row = dict(zip(header, parts))
        source = row.get('test', '')
        kcc = any(active(row.get(col, '')) for col in header[3:]
                  if 'gcc' not in col and 'scc' not in col)
        gcc = any(active(row.get(col, '')) for col in header[3:]
                  if 'gcc' in col)
        if kcc and gcc:
            out.add(source)
    return out


semantic_allowed = read_semantic_manifest(SEMANTIC_MANIFEST)
result_only = read_result_only_manifest(RESULT_ONLY_MANIFEST)
shared = shared_matrix_sources()

conditioned = set()
differential = {}
for p in (ROOT / 'tests').rglob('*.c'):
    rel = p.relative_to(ROOT).as_posix()
    text = p.read_text(encoding='utf-8', errors='replace')
    if any(tok in text for tok in TOKENS):
        conditioned.add(rel)
    if rel in shared:
        hits = tuple(tok.rstrip('(') for tok in DIFFERENTIAL if tok in text)
        if hits:
            differential[rel] = hits

unlisted_semantic = sorted(conditioned - set(semantic_allowed))
stale_semantic = sorted(set(semantic_allowed) - conditioned)
missing_semantic = sorted(x for x in semantic_allowed if not (ROOT / x).is_file())
unlisted_result = sorted(set(differential) - set(result_only))
stale_result = sorted(set(result_only) - set(differential))
missing_result = sorted(x for x in result_only if not (ROOT / x).is_file())

print('conditioned_test_sources=%d' % len(conditioned))
print('semantic_only_entries=%d' % len(semantic_allowed))
print('differential_shared_sources=%d' % len(differential))
print('result_only_entries=%d' % len(result_only))
for x in unlisted_semantic:
    print('unlisted compiler-conditioned source', x)
for x in stale_semantic:
    print('stale semantic-only entry', x)
for x in missing_semantic:
    print('missing semantic-only source', x)
for x in unlisted_result:
    print('unlisted differential-helper source', x,
          ','.join(differential[x]))
for x in stale_result:
    print('stale result-only entry', x)
for x in missing_result:
    print('missing result-only source', x)

if (unlisted_semantic or stale_semantic or missing_semantic or
        unlisted_result or stale_result or missing_result):
    sys.exit(1)
