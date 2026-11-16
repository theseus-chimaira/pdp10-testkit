"""Shared diagnostic policy for compiler rejection tests.

An unexpected compiler signal, timeout, or internal error is never a
successful negative test, even if the output also contains syntax errors.
"""

import re


ICE_RE = re.compile(
    r'(?i)(internal compiler error|internal error|\bICE\b|segmentation fault|'
    r'compiler (?:crash|abort)|please submit a (?:full )?bug report|'
    r'assertion .* failed|fatal error: .*compiler)')

KCC_ERRORS_RE = re.compile(r'(?m)^\? KCC - [1-9][0-9]* errors? detected\s*$')
KCC_ERROR_LIMIT_RE = re.compile(
    r'(?m)^\? KCC - Fatal error: Too many errors\s*$')
KCC_SOURCE_MESSAGE_RE = re.compile(r'(?m)^"[^"\n]+", line [1-9][0-9]*: ')


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
