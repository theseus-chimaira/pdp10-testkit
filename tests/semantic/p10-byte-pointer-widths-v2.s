; PDP-6 native byte-pointer-width regression for freestanding p10bytes-v2.s.
; Exercises full-word 6/9/18/36-bit copying and filling, as well as 7/8-bit
; unaligned byte-pointer fallback and unsigned comparisons. All results are
; examined through main's return value by crt0-upstream-v1.s.
.text
.globl main
main:
 move 1,ptr6dst
 move 2,ptr6src
 movei 3,6
 pushj 17,p10bcopy_v2
 move 4,source6
 camn 4,dest6
 jrst width9
 movei 1,1
 popj 17,
width9:
 move 1,ptr9dst
 move 2,ptr9src
 movei 3,4
 pushj 17,p10bcopy_v2
 move 4,source9
 camn 4,dest9
 jrst width18
 movei 1,2
 popj 17,
width18:
 move 1,ptr18dst
 move 2,ptr18src
 movei 3,2
 pushj 17,p10bcopy_v2
 move 4,source18
 camn 4,dest18
 jrst width36
 movei 1,3
 popj 17,
width36:
 move 1,ptr36dst
 move 2,ptr36src
 movei 3,1
 pushj 17,p10bcopy_v2
 move 4,source36
 camn 4,dest36
 jrst width7
 movei 1,4
 popj 17,
width7:
 move 1,ptr7dst
 move 2,ptr7src
 movei 3,5
 pushj 17,p10bcopy_v2
 move 1,ptr7dst
 move 2,ptr7src
 movei 3,5
 pushj 17,p10bcmp_v2
 jumpe 1,width8
 movei 1,5
 popj 17,
width8:
 move 1,ptr8dst
 move 2,ptr8src
 movei 3,4
 pushj 17,p10bcopy_v2
 move 1,ptr8dst
 move 2,ptr8src
 movei 3,4
 pushj 17,p10bcmp_v2
 jumpe 1,fill6
 movei 1,6
 popj 17,
fill6:
 move 1,ptr6dst
 movei 2,17
 movei 3,6
 pushj 17,p10bfill_v2
 move 4,dest6
 camn 4,fill6expected
 jrst fill9
 movei 1,7
 popj 17,
fill9:
 move 1,ptr9dst
 movei 2,123
 movei 3,4
 pushj 17,p10bfill_v2
 move 4,dest9
 camn 4,fill9expected
 jrst fill18
 movei 1,10
 popj 17,
fill18:
 move 1,ptr18dst
 movei 2,123456
 movei 3,2
 pushj 17,p10bfill_v2
 move 4,dest18
 camn 4,fill18expected
 jrst fill36
 movei 1,11
 popj 17,
fill36:
 move 1,ptr36dst
 move 2,fill36expected
 movei 3,1
 pushj 17,p10bfill_v2
 move 4,dest36
 camn 4,fill36expected
 jrst fill7
 movei 1,12
 popj 17,
fill7:
 move 1,ptr7dst
 movei 2,17
 movei 3,5
 pushj 17,p10bfill_v2
 move 4,ptr7dst
 movei 5,5
fill7check:
 ldb 6,4
 caie 6,17
 jrst fail7
 ibp 4
 sojn 5,fill7check
; Unsigned 36-bit comparison is different from signed CAML.
 move 1,ptr36high
 move 2,ptr36zero
 movei 3,1
 pushj 17,p10bcmp_v2
 jumpg 1,compare_reverse
 movei 1,14
 popj 17,
compare_reverse:
 move 1,ptr36zero
 move 2,ptr36high
 movei 3,1
 pushj 17,p10bcmp_v2
 jumpl 1,compare_equal
 movei 1,15
 popj 17,
compare_equal:
 move 1,ptr36high
 move 2,ptr36high
 movei 3,1
 pushj 17,p10bcmp_v2
 jumpe 1,zero_count
 movei 1,16
 popj 17,
zero_count:
 move 1,ptr7dst
 move 2,ptr7src
 setz 3,
 pushj 17,p10bcmp_v2
 jumpe 1,success
 movei 1,17
 popj 17,
success:
 setz 1,
 popj 17,
fail7:
 movei 1,13
 popj 17,
.data
ptr6src: .word 0360600,,source6
ptr6dst: .word 0360600,,dest6
ptr9src: .word 0331100,,source9
ptr9dst: .word 0331100,,dest9
ptr18src: .word 0222200,,source18
ptr18dst: .word 0222200,,dest18
ptr36src: .word 0004400,,source36
ptr36dst: .word 0004400,,dest36
ptr7src: .word 0350700,,source7
ptr7dst: .word 0350700,,dest7
ptr8src: .word 0341000,,source8
ptr8dst: .word 0341000,,dest8
ptr36high: .word 0004400,,value36high
ptr36zero: .word 0004400,,value36zero
fill6expected: .word 0171717171717
fill9expected: .word 0123123123123
fill18expected: .word 0123456123456
fill36expected: .word 0123456701234
source6: .word 012345670123
source9: .word 012345670123
source18: .word 012345670123
source36: .word 012345670123
source7: .word 012345670123
source8: .word 012345670123
value36high: .word 0400000000000
value36zero: .word 0
dest6: .word 0
dest9: .word 0
dest18: .word 0
dest36: .word 0
dest7: .word 0
dest8: .word 0
