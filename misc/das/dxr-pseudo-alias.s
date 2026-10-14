title ignored title
.psect text
.entry start
start:  MOVEI 1,msg
        JRST done
.psect data
msg:    SIXBIT /OK/
.psect bss
buf:    BLOCK 3
.psect text
done:   HALT
end
