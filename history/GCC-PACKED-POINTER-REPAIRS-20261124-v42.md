# GCC packed pointer subtraction v42

Review commit 3c547c4 (repair/packed-pointer-v42), based on 61b50b5.
Staged cc1 SHA256:
bbceffb8a867162b0165edd2658159aed37c53fef23cb09541a19824a20bc3f8.

Local exact16 pointer subtraction distinguishes native S=16 from
logical S=1 representations. The logical difference uses physical
word and P-field positions, expressed in C storage units for the
front-end exact division. Constant logical pointer adjustments use
physical bit counts. No persistent target storage is added.

412/412 selected historical cells pass, including 88 recoveries and
324 earlier PASS guards. Packed slice regression 44/44 PASS. Resume
checkpoint completed after connection interruption; no full sweep.
440 exact-type runtime failures remain, with 2614 earlier runtime
failures separate. No master merge or compiler installation.
Extended pointer semantics and native RAM cost not established.

Follow-on v42a (d30e21b) separates explicit element counts from
legacy storage-unit adjustments. Initial probes recover bit-offset,
indexed calls and indexed stores; broader acceptance is separate.
