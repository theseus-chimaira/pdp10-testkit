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


# Generator-expression family lists are not literal AST tuples. Map their
# registered, executed test programs to the exact architectural instruction
# families they validate, rather than guessing from generated labels.
GENERATED_EVIDENCE = {
    'test-aap-batch100-v4.py': {'pushj', 'popj'},
    'test-aap-batch100-v5.py': {'blt'},
    'test-aap-batch100-v6.py': {'ldb', 'dpb'},
    'test-aap-batch100-v7.py': {'ildb', 'idpb'},
    'test-aap-batch100-v8.py': {'ibp'},
    'test-aap-batch100-v10.py': {'blt'},
    'test-aap-setzm-v1.py': {'setzm'},
    'test-aap-hrli-v1.py': {'hrli'},
    'test-aap-sojg-v1.py': {'sojg'},
    'test-aap-aoja-v1.py': {'aoja'},
    'test-aap-tlc-v1.py': {'tlc'},
    'test-aap-idivi-v1.py': {'idivi'},
}
FAMILY_ALIASES = {
    'jumpe_taken': 'jumpe', 'jumpe_nonzero': 'jumpe',
    'jumpn_taken': 'jumpn', 'jumpn_fall': 'jumpn',
    'aobjn_loop': 'aobjn', 'aobjn_long': 'aobjn',
    'skipe_taken': 'skipe', 'skipe_zero': 'skipe',
    'skipn_nonzero': 'skipn', 'skipl_negative': 'skipl',
    'skipge_zero': 'skipge', 'skipg_zero': 'skipg',
    'jumpl_negative': 'jumpl', 'jumpge_zero': 'jumpge',
    'jumpg_positive': 'jumpg', 'jumple_zero': 'jumple',
    'xct_move': 'xct', 'xct_nested': 'xct',
    'xct_memory': 'xct', 'xct_jrst': 'xct',
    'xct_movei': 'xct',
    'direct': 'move', 'indexed': 'move',
    'indirect': 'move', 'nested': 'move',
    'arithmetic': 'addi',
}


def verified_family_names():
    result = set()
    registered = set()
    for line in (ROOT / 'SPECIAL_TESTS.tsv').read_text().splitlines():
        fields = line.split('\t')
        if len(fields) >= 4:
            registered.add(fields[3])
    for path in sorted((ROOT / 'misc/compat').glob('test-aap-batch*.py')):
        if path.relative_to(ROOT).as_posix() not in registered:
            continue
        tree = ast.parse(path.read_text())
        for node in ast.walk(tree):
            if (isinstance(node, ast.For) and
                    isinstance(node.target, ast.Name) and
                    node.target.id == 'family' and
                    isinstance(node.iter, (ast.Tuple, ast.List))):
                result.update(x.value.lower() for x in node.iter.elts
                              if isinstance(x, ast.Constant) and isinstance(x.value, str))
        result.update(GENERATED_EVIDENCE.get(path.name, set()))
    result.update(FAMILY_ALIASES[name] for name in tuple(result)
                  if name in FAMILY_ALIASES)
    # These are executed as real top-level guest instructions in the
    # registered suites, but do not appear as a generated family label.
    if ('misc/compat/test-aap-control-flow-v1.sh' in registered and
            'misc/compat/test-aap-xct-v2.sh' in registered):
        result.add('jrst')
    if 'misc/compat/test-aap-batch100-v1.py' in registered:
        result.update(('movei', 'movem'))
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
    total = sum(counts.values())
    matched = sum(n for op, n in counts.items() if op in tested)
    print('source mnemonic references:', total)
    print('references with at least one mapped fixture:', matched, '/', total,
          '(%.1f%% static-only)' % (100.0 * matched / total if total else 0))
    print('MNEMONIC\tSOURCE_LINES\tBATCH_LABEL_MATCH')
    for mnemonic, count in counts.most_common():
        print('%s\t%d\t%s' % (mnemonic.upper(), count, 'yes' if mnemonic in tested else 'no'))
    print('\nGAPS BY CLASS (source lines with no exact batch family label):')
    for group, names in GROUPS.items():
        uncovered = [(m, counts[m]) for m in names if counts[m] and m not in tested]
        print('%s\t%d\t%s' % (group, sum(n for _, n in uncovered),
                               ', '.join('%s:%d' % x for x in sorted(uncovered, key=lambda x: -x[1])) or '-'))
    print('\nIMPORTANT: This is a static source-reference proxy only;')
    print('a matching fixture does not validate all instruction paths.')


if __name__ == '__main__':
    main()
