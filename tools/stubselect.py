# Selectively emit semantic-test support stubs.
#
# The old runners appended support/test-stubs.s to every linked test.  That file
# intentionally contains generic symbols such as f and use_ptr, which can
# collide with test-local functions.  Emit only stubs that the generated
# assembly actually references and does not define.

from __future__ import print_function
import re
from pathlib import Path

STUB_BODIES = {
    '__main': """__main:\n\tpopj 17,\n""",
    'f': """f:\n\tmovei 1,1\n\tpopj 17,\n""",
    'uf': """uf:\n\tmovei 1,1\n\tpopj 17,\n""",
    'clobber': """clobber:\n\tpopj 17,\n""",
    'use_int': """use_int:\n\tpopj 17,\n""",
    'use_uint': """use_uint:\n\tpopj 17,\n""",
    'use_sint': """use_sint:\n\tpopj 17,\n""",
    'use_usint': """use_usint:\n\tpopj 17,\n""",
    'use_dint': """use_dint:\n\tpopj 17,\n""",
    'use_udint': """use_udint:\n\tpopj 17,\n""",
    'use_ptr': """use_ptr:\n\tpopj 17,\n""",
    'use_intp': """use_intp:\n\tpopj 17,\n""",
    'use_sintp': """use_sintp:\n\tpopj 17,\n""",
    'use_char6p': """use_char6p:\n\tpopj 17,\n""",
    'use_short18p': """use_short18p:\n\tpopj 17,\n""",
    'use_char_pointer': """use_char_pointer:\n\tpopj 17,\n""",
    'use_uchar_pointer': """use_uchar_pointer:\n\tpopj 17,\n""",
    'memcpy': """memcpy:\n\tmove\t4,1\n\tmove\t5,2\n\tmove\t6,3\n\tjumpe\t6,__stub_memcpy_done\n__stub_memcpy_loop:\n\tldb\t7,5\n\tdpb\t7,4\n\tibp\t5\n\tibp\t4\n\tsojg\t6,__stub_memcpy_loop\n__stub_memcpy_done:\n\tpopj\t17,\n""",
    'memset': """memset:\n\tmove\t1,-1(17)\n\tmove\t2,-1(17)\n\tmove\t5,-2(17)\n\tmove\t4,-3(17)\n\tjumpe\t4,__stub_memset_done\n__stub_memset_loop:\n\tdpb\t5,2\n\tibp\t2\n\tsojg\t4,__stub_memset_loop\n__stub_memset_done:\n\tpopj\t17,\n""",
}

STUB_SYMBOLS = tuple(STUB_BODIES.keys())


def asm_defines_label(asm_text, name):
    return re.search(r'(?m)^\s*' + re.escape(name) + r':', asm_text) is not None


def asm_references_external(asm_text, name):
    if asm_defines_label(asm_text, name):
        return False
    if re.search(r'(?m)^\s*\.extern\s+' + re.escape(name) + r'\b', asm_text):
        return True
    if re.search(r'(?i)(?m)\bpushj\s+17,\s*' + re.escape(name) + r'\b', asm_text):
        return True
    return False


def needed_stub_symbols(asm_text):
    return [name for name in STUB_SYMBOLS if asm_references_external(asm_text, name)]


def selected_test_stubs(asm_text, outdir, stem='selected-test-stubs', exclude=None):
    exclude = set(exclude or [])
    needed = [name for name in needed_stub_symbols(asm_text) if name not in exclude]
    if not needed:
        return []
    outdir = Path(outdir)
    outdir.mkdir(parents=True, exist_ok=True)
    path = outdir / (stem + '.s')
    data = ['.text\n']
    for name in needed:
        # p10run assembles each source into a separate DOBJ.  A plain label is
        # local to that object, so dlink cannot use it to satisfy an external
        # reference from the compiler output.  Export each selected support
        # routine explicitly.
        data.append('.global ' + name + '\n')
        data.append(STUB_BODIES[name])
        data.append('\n')
    path.write_text(''.join(data))
    return [str(path)]
