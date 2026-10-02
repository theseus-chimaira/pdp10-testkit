        .entry start
start:  MOVEI 1,msg
        JRST done
msg:    SIXBIT /OK/
done:   HALT
