.TEXT
START:
        CAIE 3,0
        SETZ 1,
        SETZ 2,
        SKIPA 4,FOO
        SETZ 5,
        SETZ 6,
        AOSN 7,FOO
        SETZ 10,
        SETZ 11,
        TRNE 12,1
        SETZ 13,
        SETZ 14,
        XCT 15
        SETZ 1,
        SETZ 2,
        HALT
.DATA
FOO:    .WORD 0
