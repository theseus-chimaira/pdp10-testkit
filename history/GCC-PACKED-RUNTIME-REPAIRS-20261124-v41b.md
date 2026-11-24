# GCC packed runtime repairs v41b

Review commit d4867fe, branch repair/packed-runtime-v41b, based on 71d4100.
Staged cc1 SHA256:
60fed2b3a4ff38f83418333207f666c3e88b82b5c43d8e27031013bdff3b7c2a.

Physical word references and target extraction/insertion patterns prevent
temporary aggregate data from being reinterpreted as halfword objects.
Constant packed integer field access uses the declared bit positions.
Integer-only packed static constructors stream target bytes from the
same layout, including across nested aggregate and array boundaries;
no full aggregate buffer. Noninteger constructors retain existing paths.

Exact staged acceptance: 324/324 PASS (176 historical recoveries and
148 earlier PASS guards). All 165 former ICE cells now pass. The four
recovered sources are union, chained-assignment, nested-byvalue, and
nested-wholecopy (44 cells each). New packed-slice regression: 44/44 PASS.
Existing packed-record pointer guard: 32/32 PASS. No full sweep or
installation. 528 of the v40a runtime failures remain; original 2614
GCC runtime failures are a separate untested cohort.

Diagnostic v41c (61b50b5, repair/packed-array-v41c) moves constant
packed stores ahead of an old exact16 logical-pointer path. Six focused
probes still fail; array-members advances from assertion 2 to 7 on
PDP-6 O0 and O2. The direct array stores are improved but indirect
packed pointer access remains broken. v41c is not the accepted build.
No new matrix exclusions. KCC v38 changes remain separate.
