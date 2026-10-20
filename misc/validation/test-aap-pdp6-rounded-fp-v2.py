#!/usr/bin/env python3
"""Manual AAP PDP-6 floating normalization characterization.

Only the testkit is modified; the AAP emulator is never patched.
For the full 24-case suite AAP first differs on case 9:
  -134217728.0F + 1.0F -> 0544000000003
versus the mathematical-exact 0544000000001.
The PDP-6 is documented to lose low fraction bits in certain
normalization circumstances. This difference is NOT yet proven to
be a defect in AAP; consult the original gate-level documentation.

This script deliberately fails when its guest does not satisfy the
mathematical oracle. It is registered MANUAL, not an expected PASS.
"""

import os
from pathlib import Path
import runpy

os.environ["PDP6_AAP_FULL_ROUNDED_V2"] = "1"
runpy.run_path(str(Path(__file__).resolve().parent /
                   "test-kcc-aap-dimode-float-pdp6-v1.py"),
               run_name="__main__")
