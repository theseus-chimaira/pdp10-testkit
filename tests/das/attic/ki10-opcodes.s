; KI10/KA10 extended opcode table smoke test.
; This file is assembled by tests/run-assembler-tests.sh, which verifies the
; exact SIMH deposit words.  It catches opcode-table regressions such as the
; former DFAD..DDIV off-by-one encoding bug.
ADJSP 1,2
DFAD 1,2
DFSB 1,2
DFMP 1,2
DFDV 1,2
DADD 1,2
DSUB 1,2
DMUL 1,2
DDIV 1,2
DMOVE 1,2
DMOVN 1,2
FIX 1,2
DMOVEM 1,2
DMOVNM 1,2
FIXR 1,2
FLTR 1,2
UFA 1,2
DFN 1,2
FSC 1,2
ADJBP 1,2
IBP 1,2
ILDB 1,2
LDB 1,2
IDPB 1,2
DPB 1,2
