# GCC literal memcpy optimization v50d

Review e0309bd3094901e2543f52b0367ad753306d05e0, based on c50e5d5 and v48g.
Hosted cc1 SHA256:
ef87e463c314879d585d1e90bf0555ab8e4a2aa4e5bddc7794a9e1b0e6c8315d.

Short constant literal memcpy to a proven local first-byte address
stores full 36-bit words and inserts only the trailing selected bytes.
The literal callback reads all counted characters, including those
after embedded NUL. Preserve the original destination pointer.
The initial v50c candidate passed 88/88 targeted cells but regressed
four aligned memcpy-bi cells; all four pass on v48g. v50d retains
the typed word-address conversion and shares a saved destination
evaluation. All 106 final acceptance cells pass. All 88 measured
v50c images, assembly and normalized run scripts equal v50d.

20011024-1.c: all 11 size pairs improve, Os 38 words against 49 or
53 unoptimized, formerly 57 on PDP6 and KS10. PDP6 ticks:
O0 519, O1 182, O2 182, Os 182. KS10: 460,173,174,174.
Across both sources, 22/22 O1 and Os faster than O0,
22/22 Os smaller, 11 O2/O1 improvements, 8 ties, 3 regressions
(all three KS10 profiles of 20011024-1.c, one tick).

Archive audit v3: 848 measured cells (512 additional), O1/O0
206 improved, O2/O1 145 improved, 39 equal, 34 regressed,
Os/O0 204 improved. Historical revision provenance is incomplete.
Current-build results remain separate from archive statistics.
No full sweep, installation, native RAM or calibrated hardware timing.
Extended-addressing and cumulative acceptance remain pending.
