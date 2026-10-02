#!/usr/bin/env python3
"""Prepare preprocessed PDP-10 libgcc1.s runtime/table units.

This writes small normalized .s files under --out-dir.  The files are meant to
be passed as extra sources to p10run.py after generated C assembly.  They are
not a linker replacement; they give the bare runtime harness the selected
PDP-10 libgcc1.s helper block plus the %BADL*/%BADX* tables that GCC-generated
byte-pointer pointer-difference code can reference.
"""
from __future__ import print_function
import argparse, hashlib, os, re, shutil, subprocess, sys
from pathlib import Path

DEFAULT_MACROS = [
    'Lpdp10_bare_runtime',
    'LBADL6', 'LBADL7', 'LBADL8', 'LBADL9', 'LBADLH',
    'LBADX6', 'LBADX7', 'LBADX8', 'LBADX9', 'LBADXH',
]

def run(cmd):
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = p.communicate()
    return p.returncode, out, err

def strip_c_comments(text):
    return re.sub(r'/\*.*?\*/', '', text, flags=re.S)

def simplify_indexed_disp(line):
    pat = re.compile(r'(?<![A-Za-z0-9_])(-?[0-9]+)\s*\+\s*(-?[0-9]+)(?=\([0-7]{1,2}\))')
    def repl(m):
        val = int(m.group(1), 10) + int(m.group(2), 10)
        return ('-' + format(-val, 'o')) if val < 0 else format(val, 'o')
    return pat.sub(repl, line)

def normalize(raw_text):
    text = strip_c_comments(raw_text)
    out = []
    for raw in text.splitlines():
        line = raw.rstrip().replace('\r', '')
        stripped = line.strip()
        upper = stripped.upper()
        if not stripped:
            continue
        if re.match(r'^TITLE(?:\s|$)', upper):
            continue
        if re.match(r'^ENTRY(?:\s|$)', upper):
            out.append(stripped)
            continue
        if upper == 'END' or re.match(r'^END\s+', upper):
            continue
        if re.match(r'^\.ENDPS(?:\s|$)', upper):
            continue
        if re.match(r'^\.PSECT(?:\s|$)', upper):
            low = stripped.lower()
            if '.text' in low:
                out.append('.text')
            elif '.rodata' in low or '.rdata' in low or '.data' in low:
                out.append('.data')
            elif '.bss' in low:
                out.append('.bss')
            else:
                out.append('.text')
            continue
        out.append(simplify_indexed_disp(line))
    return '\n'.join(out) + '\n'

def main(argv):
    ap = argparse.ArgumentParser()
    prefix = os.environ.get('PDP10_PREFIX')
    if not prefix:
        print('error: PDP10_PREFIX must be set', file=sys.stderr)
        return 2
    ap.add_argument('--libgcc1', default=str(Path(prefix)/'share/gcc-pdp10/config/pdp10/libgcc1.s'))
    ap.add_argument('--out-dir', default='workdir/libgcc1-badptr-units')
    ap.add_argument('--cpp', default='cpp')
    ap.add_argument('--regparm', default='4')
    ap.add_argument('--underscore', default='_')
    ap.add_argument('--macros', default=' '.join(DEFAULT_MACROS))
    args = ap.parse_args(argv)

    libgcc1 = Path(args.libgcc1)
    outdir = Path(args.out_dir)
    rawdir = outdir / 'raw'
    unitdir = outdir / 'units'
    rawdir.mkdir(parents=True, exist_ok=True)
    unitdir.mkdir(parents=True, exist_ok=True)

    if not libgcc1.is_file():
        print('error: libgcc1.s not found: %s' % libgcc1, file=sys.stderr)
        return 1
    if shutil.which(args.cpp) is None:
        print('error: cpp not found: %s' % args.cpp, file=sys.stderr)
        return 1

    units = []
    seen = {}
    nr = 0
    for macro in args.macros.split():
        nr += 1
        safe = re.sub(r'[^A-Za-z0-9_.-]', '_', macro)
        cmd = [args.cpp, '-P', '-x', 'assembler-with-cpp', '-D'+macro,
               '-D__REGPARM__='+str(args.regparm), '-DUNDERSCORE='+args.underscore,
               str(libgcc1)]
        rc, out, err = run(cmd)
        raw = rawdir / ('%03d-%s.raw.s' % (nr, safe))
        raw.write_bytes(out)
        if rc != 0:
            sys.stderr.write(err.decode('utf-8', 'replace'))
            print('error: cpp failed for %s' % macro, file=sys.stderr)
            return 1
        norm = normalize(out.decode('utf-8', 'replace'))
        fingerprint = '\n'.join(l.rstrip() for l in norm.splitlines() if l.strip())
        digest = hashlib.sha256(fingerprint.encode('utf-8')).hexdigest()
        if digest in seen:
            continue
        seen[digest] = macro
        unit = unitdir / ('%03d-%s.s' % (nr, safe))
        unit.write_text(norm)
        units.append(unit)

    if not any(re.search(r'(?m)^__main:', p.read_text(errors='ignore')) for p in units):
        unit = unitdir / '000-bare-__main-fallback.s'
        unit.write_text('.text\n\t.globl\t__main\n__main:\n\tpopj 17,\n')
        units.insert(0, unit)

    listfile = outdir / 'units.list'
    listfile.write_text('\n'.join(str(p) for p in units) + ('\n' if units else ''))
    for p in units:
        print(p)
    return 0

if __name__ == '__main__':
    raise SystemExit(main(sys.argv[1:]))
