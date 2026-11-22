.text
.globl main
main:
        move 13,[0123456]
        move 14,[0654321]
        move 15,[0712345]
        move 1,[POINT 9,area,8]
        movei 16,5
        pushj 17,$ADJBP
        came 1,[POINT 9,area+1,17]
         jrst bad_a
        move 16,[-5]
        pushj 17,$ADJBP
        came 1,[POINT 9,area,8]
         jrst bad_b
        move 16,[01753]
        pushj 17,$ADJBP
        came 1,[POINT 9,area+0372,35]
         jrst bad_c
        move 16,[-01753]
        pushj 17,$ADJBP
        came 1,[POINT 9,area,8]
         jrst bad_d
        move 1,[POINT 18,area,17]
        move 16,[0767]
        pushj 17,$ADJBP
        came 1,[POINT 18,area+0373,35]
         jrst bad_e
        move 16,[-0767]
        pushj 17,$ADJBP
        came 1,[POINT 18,area,17]
         jrst bad_f
        move 1,[POINT 7,area,6]
        move 16,[015]
        pushj 17,$ADJBP
        came 1,[POINT 7,area+2,27]
         jrst bad_g
        move 16,[-015]
        pushj 17,$ADJBP
        came 1,[POINT 7,area,6]
         jrst bad_h
        came 13,[0123456]
         jrst bad_i
        came 14,[0654321]
         jrst bad_j
        came 15,[0712345]
         jrst bad_k
        ; Reproduce the HIcmp constant-count call shape with a pointer
        ; held in AC3.  The 11111111-element displacement wraps the
        ; 18-bit word address and must not corrupt the caller's AC1.
        move 3,[POINT 18,area,17]
        move 1,[01234567]
        add 17,[1,,1]
        movem 1,0(17)
        add 17,[1,,1]
        movem 3,0(17)
        move 1,0(17)
        sub 17,[1,,1]
        move 16,[052305307]
        pushj 17,$ADJBP
        add 17,[1,,1]
        movem 1,0(17)
        move 3,0(17)
        sub 17,[1,,1]
        move 1,0(17)
        sub 17,[1,,1]
        came 3,[POINT 18,area+0142543,35]
         jrst bad_l
        came 1,[01234567]
         jrst bad_m
        movei 1,0
        jrst exit
bad_a:
        movei 1,1
        jrst exit
bad_b:
        movei 1,2
        jrst exit
bad_c:
        movei 1,3
        jrst exit
bad_d:
        movei 1,4
        jrst exit
bad_e:
        movei 1,5
        jrst exit
bad_f:
        movei 1,6
        jrst exit
bad_g:
        movei 1,7
        jrst exit
bad_h:
        movei 1,010
        jrst exit
bad_i:
        movei 1,011
        jrst exit
bad_j:
        movei 1,012
        jrst exit
bad_k:
        movei 1,013
        jrst exit
bad_l:
        movei 1,014
        jrst exit
bad_m:
        movei 1,015
        jrst exit
area:
        .word 0
