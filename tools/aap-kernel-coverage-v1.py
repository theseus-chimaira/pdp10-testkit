#!/usr/bin/env python3
"""Conservative static DAIMOS kernel vs AAP timing-fixture inventory.

Source token counts are NOT runtime opcode frequencies or executable coverage.
Count assembly mnemonics in PDP-6 kernel source; report unrepresented
families explicitly. No compiler-derived .c opcodes are inferred.
"""
import ast
from collections import Counter
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
DAIMOS = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT.parent / 'DAIMOS'
MNEMONIC = re.compile(r'^\s*([a-z][a-z0-9]*)\s+(?:(?:[0-7]+|[a-z_][a-z0-9_]*):\s*)?', re.I)
LABEL = re.compile(r'^(?:[a-z_.$%][\w.$%]*|[0-9]+):\s*', re.I)
INSTRUCTION = re.compile(r'^\s*([a-z][a-z0-9]*)\b', re.I)
BASE = {'move', 'movei', 'movem', 'movn', 'movni', 'movm', 'movsi', 'add', 'addi',
        'addm', 'sub', 'subi', 'subm', 'imul', 'imuli', 'and', 'andi', 'andm',
        'ior', 'iori', 'iorm', 'xor', 'xori', 'xorm', 'lsh', 'ash', 'rot',
        'jrst', 'jumpn', 'jumpe', 'jumpl', 'jumpg', 'jumpge', 'jumple',
        'skipe', 'skipn', 'skipl', 'skipge', 'skipg', 'aobjn', 'push', 'pop',
        'hll', 'hlr', 'hrl', 'hrr', 'hllz', 'hlrz', 'hrlz', 'hrrz', 'hllo',
        'hrro', 'xct', 'setz', 'seto'}
# These are architecturally relevant but not all encoded by the timing suites.
GROUPS = {
    'byte': 'ibp ildb idpb ldb dpb ldci ldc dpci dpc cao'.split(),
    'block': 'blt'.split(),
    'call-stack': 'pushj popj adjsp jsr jsp jsa jra'.split(),
    'doubleword': 'mul div idiv ashc lshc rotc'.split(),
    'halfword': 'hll hlr hrl hrr hllz hlrz hrlz hrrz hllo hrro hllm hlrm hrlm hrrm hlls hrrs hllzs hrrzs'.split(),
    'conditionals': 'cai caie cain cail caig caige caile cam came camn caml camg camge camle aoj soj aos sos aobjp'.split(),
    'logical-tests': 'tdne tdnn trne trnn tlne tlnn tro trz tlz tlo setz seto eqv andca andcm orca orcm'.split(),
    'interrupts-io': 'blki blko datai datao cono coni consz conso'.split(),
}


def verified_family_names():
    result = set()
    for path in sorted((ROOT / 'misc/compat').glob('test-aap-batch*.py')):
        tree = ast.parse(path.read_text())
        for node in ast.walk(tree):
            if isinstance(node, ast.For) and isinstance(node.target, ast.Name) and node.target.id == 'family':
                if isinstance(node.iter, (ast.Tuple, ast.List)):
                    result.update(x.value.lower() for x in node.iter.elts if isinstance(x, ast.Constant) and isinstance(x.value, str))
    # Explicit semantic mapping for generated call-depth families.
    if any(x.startswith('depth') for x in result):
        result.update(('pushj', 'popj'))
    if any(x.startswith('len') for x in result):
        result.add('blt')
    if any(x.startswith('ldc') for x in result):
        result.update(('ldc', 'ldb'))
    if any(x.startswith('dpc') for x in result):
        result.update(('dpc', 'dpb'))
    if any(x.startswith('ldci') for x in result):
        result.update(('ldci', 'ildb'))
    if any(x.startswith('dpci') for x in result):
        result.update(('dpci', 'idpb'))
    if any(x.startswith('ibp') for x in result):
        result.add('ibp')
    return result


def source_counts():
    counts = Counter()
    files = Counter()
    for path in sorted((DAIMOS / 'system/kernel').rglob('*.s')):
        for line in path.read_text(errors='replace').splitlines():
            line = line.split(';', 1)[0].split('/*', 1)[0].strip()
            if not line or line.startswith(('.', '#', '*', '//')):
                continue
            while LABEL.match(line):
                line = LABEL.sub('', line, count=1).strip()
            match = INSTRUCTION.match(line)
            if match:
                token = match.group(1).lower()
                # Data macros and assembler directives deliberately excluded.
                if token in BASE or any(token in names for names in GROUPS.values()):
                    counts[token] += 1
                    files[token] += 1
    return counts, files


def main():
    counts, _ = source_counts()
    tested = verified_family_names()
    print('Static PDP-6 kernel assembly source inventory (not runtime frequency)')
    print('assembly files:', len(list((DAIMOS / 'system/kernel').rglob('*.s'))))
    print('AAP batch family labels:', len(tested))
    print('source mnemonic references:', sum(counts.values()))
    print('MNEMONIC\tSOURCE_LINES\tBATCH_LABEL_MATCH')
    for mnemonic, count in counts.most_common():
        print('%s\t%d\t%s' % (mnemonic.upper(), count, 'yes' if mnemonic in tested else 'no'))
    print('\nGAPS BY CLASS (source lines with no exact batch family label):')
    for group, names in GROUPS.items():
        uncovered = [(m, counts[m]) for m in names if counts[m] and m not in tested]
        print('%s\t%d\t%s' % (group, sum(n for _, n in uncovered),
                               ', '.join('%s:%d' % x for x in sorted(uncovered, key=lambda x: -x[1])) or '-'))
    print('\nIMPORTANT: Exact family-label match is a LOWER BOUND; specialized')
    print('case labels such as xct_memory, aobjn_loop are not inferred.')


if __name__ == '__main__':
    main()
