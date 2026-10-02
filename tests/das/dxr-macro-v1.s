.text

.if 0
.macro HIDDEN p
.if 1
.word 777
.endif
.endm
.endif

.macro PAIR a,b
.word \a
.word \1
.word \b
.word \2
.endm

.macro INNER v
.rept 2
.word \v
.endr
.endm

.macro OUTER v
INNER \1
UNIQ\@:
.word \v\()7
.word UNIQ\@
.endm

.macro CHOOSE flag,value
.if \flag
.word \value
.else
.word 0
.endif
.endm

.macro WITHINC
.include "dxr-macro-include-v1.inc"
.endm

start:
PAIR 1,2
OUTER 3
OUTER 4
.rept 2
PAIR (4+1),6
.endr
CHOOSE 1,11
CHOOSE 0,12
WITHINC
.entry start
