"""Shared diagnostic policy for compiler rejection tests.

An unexpected compiler signal, timeout, or internal error is never a
successful negative test, even if the output also contains syntax errors.
"""

import re


# A bare \bICE\b anywhere in a compiler log is *not* reliable: the
# logged command may contain --out-dir .../p10tk-ice-only-... or a test
# source named ice.c, while the actual diagnostic is a normal missing
# header or syntax error.  Recognize ICE as a diagnostic, not a filename.
# Keep the full historic GCC/KCC internal-error and crash signatures.
ICE_RE = re.compile(
    r'(?im)(internal compiler error|internal error|'
    r'^\s*(?:fatal(?: error)?:\s*)?ICE\b|:\s*ICE:|'
    r'segmentation fault|compiler (?:crash|abort)|'
    r'please submit a (?:full )?bug report|'
    r'assertion .* failed|fatal error: .*compiler)')

KCC_ERRORS_RE = re.compile(r'(?m)^\? KCC - [1-9][0-9]* errors? detected\s*$')
KCC_ERROR_LIMIT_RE = re.compile(
    r'(?m)^\? KCC - Fatal error: Too many errors\s*$')
KCC_SOURCE_MESSAGE_RE = re.compile(r'(?m)^"[^"\n]+", line [1-9][0-9]*: ')

# GCC 3.2 often says `source.c:7: storage size isn't known`, without an
# `error:` prefix. Requiring modern `error:` text would reject valid old-GCC
# negative tests. A warning or locationless driver error is insufficient.
GCC_SOURCE_ERROR_RE = re.compile(
    r'(?m)^[^\n:]+\.(?:c|h):[1-9][0-9]*(?::[0-9]+)?: '
    r'(?!(?:warning|note|remark):)[^\n]+$', re.IGNORECASE)
GCC_SETUP_ERROR_RE = re.compile(
    r'(?i)(no such file or directory|cannot open input file|'
    r'unrecognized command.line option|unknown target cpu|'
    r'cannot (?:find|execute) (?:cc1|as|collect2)|'
    r'error trying to exec|permission denied)')


def check_kcc_rejection(returncode, diagnostics):
    """Return an error string or None for a normal diagnosed KCC rejection."""
    if returncode == 0:
        return 'compiler unexpectedly accepted invalid source'
    # Conventional shell statuses 124..127 denote timeout, launch or signal
    # failures. None can qualify as a successful compiler diagnostic.
    if returncode < 0 or returncode >= 124:
        return 'compiler terminated abnormally (%d)' % returncode
    if ICE_RE.search(diagnostics):
        return 'internal compiler error or crash diagnostic'
    if not (KCC_ERRORS_RE.search(diagnostics) or
            (KCC_ERROR_LIMIT_RE.search(diagnostics) and
             KCC_SOURCE_MESSAGE_RE.search(diagnostics))):
        return 'missing KCC error-count diagnostic'
    return None


def check_gcc_rejection(returncode, diagnostics):
    """Return an error string or None for a diagnosed historical GCC error."""
    if returncode == 0:
        return 'compiler unexpectedly accepted invalid source'
    if returncode < 0 or returncode >= 124:
        return 'compiler terminated abnormally (%d)' % returncode
    if ICE_RE.search(diagnostics):
        return 'internal compiler error or crash diagnostic'
    if GCC_SETUP_ERROR_RE.search(diagnostics):
        return 'missing input or invalid compiler configuration'
    if not GCC_SOURCE_ERROR_RE.search(diagnostics):
        return 'missing source-located GCC error diagnostic'
    return None
