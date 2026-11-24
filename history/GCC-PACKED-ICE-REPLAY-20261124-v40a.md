# GCC exact-type runtime replay v40a

Compiler review commit 71d4100 on repair/packed-ice-v40a.
Staged hosted cc1 SHA256:
c1182aaf18f2dad471794e82f32c93ff249ea372e13e6af627cb02dcc604f07d.

Exact 852-cell historical selection completed after several interrupted
connections, resuming only incomplete cells. 148 PASS, 704 runtime
assertion failures; zero compile, assembly or link failures. All 165
former packed-aggregate ICE cells reach execution but fail assertions.
Of the other 687 cells, 148 PASS and 539 fail assertions.
No exclusions or changed oracles. 32 existing packed-record pointer
guards passed with this staged compiler.

The candidate fixes union field-position handling, physical word-based
packed aggregate bit copying and normalization of byte-pointer views
before word bit-field expansion. Semantic acceptance remains incomplete.
A separate packed-copy probe passes PDP-6 O2 but fails O0; the original
installed compiler ICEs on that probe at both optimization levels.
The review branch preserves the candidate without changing master
or the installed compiler. The GCC worktree retains the patch.
No full sweep or KCC changes. The original 2614 GCC runtime failures
were not replayed. Exact results and hashes are in the v40a manifests.
