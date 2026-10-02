        .entry start
start:  IBP ptr
        LDB 1,ptr
        DPB 1,ptr
        HALT
ptr:    POINT 7,data,35
data:   0
