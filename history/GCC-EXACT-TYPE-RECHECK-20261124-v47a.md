# GCC exact-type recheck and void-pointer repair v47a

Review eef83fe (repair/void-roundtrip-v47a), based on 5c89d46.
Hosted staged cc1 SHA256:
3bee8f496b13c3b7b5484ea78e6cdd9adb4558235a24267853198b7fc755518b.

All 176 remaining exact-type runtime cells reproduced on v45b.
The dynamic member-address helper had adjusted the incoming record
pointer without converting its native selector to the member selector.
Convert before applying the member-sized displacement, keeping the
one-word pointer representation. All 44 historical void-pointer
roundtrip cells passed; the 32 packed-record pointer guards and
mixed KCC/GCC ordinary and byte-pointer representation suite passed.

The other three packed-record sources still fail the six focused
PDP-6 probes. Their 132 cells remain in the exact-type backlog.
Staged total known backlog: 2652 (2520 historical runtime and 132
exact-type). The v46 memory/string investigation remains deferred.
No full sweep, installation or cumulative acceptance. The new
patch does not establish noncanonical packed pointer semantics.
