.text
.macro LOADHALF ac,src
MOVE \ac,\src
HRRZ \ac,\ac
.endm
start: JRST after
target: LOADHALF 1,source
after: XCT target
source: .word 1
.entry start
