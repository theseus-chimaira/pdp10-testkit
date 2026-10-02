
pressure_skip_mem:
	push 17,10
	move 10,2
	move 7,3
	move 6,-2(17)
	move 2,-3(17)
	move 5,-4(17)
	move 3,-5(17)
	add 7,4
	add 6,2
	add 5,3
	move 3,7
	add 3,6
	add 3,5
	skipn 1,(1)
	jrst %L2
	add 1,7
	add 3,1
%L3:
	add 3,7
	add 3,6
	add 3,5
	move 1,3
	pop 17,10
	popj 17,
%L2:
	move 4,(10)
	add 4,6
	add 3,4
	jrst %L3

pressure_skip_compare:
	move 5,2
	move 6,4
	move 2,-1(17)
	move 7,-2(17)
	move 4,-3(17)
	sub 5,3
	sub 6,2
	sub 7,4
	skipge 1,(1)
	jrst %L7
	jumple 1,%L6
	move 2,5
	sub 2,6
	add 2,7
	add 2,1
%L4:
	move 1,2
	popj 17,
%L6:
	move 2,5
	add 2,6
	sub 2,7
	jrst %L4
%L7:
	move 2,5
	add 2,6
	add 2,7
	sub 2,1
	jrst %L4

pressure_skip_store:
	move 7,2
	move 6,3
	move 3,-1(17)
	move 2,-2(17)
	add 6,4
	add 6,3
	add 6,2
	skipe 4,(1)
	jrst %L9
	movem 6,(1)
%L10:
	move 1,(1)
	add 1,(7)
	add 1,6
	popj 17,
%L9:
	add 4,6
	movem 4,(7)
	jrst %L10

pressure_skip_eq:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,2
	move 5,-3(17)
	move 6,-4(17)
	move 7,-5(17)
	move 2,-6(17)
	move 10,3
	add 10,4
	add 5,6
	add 7,2
	sub 3,6
	xor 4,2
	skipe (1)
	jrst %L12
	move 1,10
	add 1,7
%L13:
	add 1,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L12:
	move 1,(11)
	add 1,5
	add 1,3
	jrst %L13

pressure_skip_ne:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,2
	move 5,-3(17)
	move 6,-4(17)
	move 7,-5(17)
	move 2,-6(17)
	move 10,3
	add 10,4
	add 5,6
	add 7,2
	sub 3,6
	xor 4,2
	skipn 1,(1)
	jrst %L15
	add 1,10
	add 1,7
%L16:
	add 1,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L15:
	move 1,(11)
	add 1,5
	add 1,3
	jrst %L16

pressure_skip_ge:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,2
	move 5,-3(17)
	move 6,-4(17)
	move 7,-5(17)
	move 2,-6(17)
	move 10,3
	add 10,4
	add 5,6
	add 7,2
	sub 3,6
	xor 4,2
	skipge 1,(1)
	jrst %L18
	add 1,10
	add 1,7
%L19:
	add 1,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L18:
	move 1,(11)
	add 1,5
	add 1,3
	jrst %L19

pressure_skip_le:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,2
	move 7,-3(17)
	move 6,-4(17)
	move 5,-5(17)
	move 2,-6(17)
	move 10,3
	add 10,4
	add 7,6
	add 5,2
	sub 3,6
	xor 4,2
	skipg 1,(1)
	jrst %L23
	move 1,(11)
	add 1,7
	add 1,3
%L22:
	add 1,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L23:
	add 1,10
	add 1,5
	jrst %L22

pressure_skip_gt:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,2
	move 5,-3(17)
	move 6,-4(17)
	move 7,-5(17)
	move 2,-6(17)
	move 10,3
	add 10,4
	add 5,6
	add 7,2
	sub 3,6
	xor 4,2
	skipg 1,(1)
	jrst %L25
	add 1,10
	add 1,7
%L26:
	add 1,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L25:
	move 1,(11)
	add 1,5
	add 1,3
	jrst %L26

pressure_skip_lt:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,2
	move 7,-3(17)
	move 6,-4(17)
	move 5,-5(17)
	move 2,-6(17)
	move 10,3
	add 10,4
	add 7,6
	add 5,2
	sub 3,6
	xor 4,2
	skipge 1,(1)
	jrst %L30
	move 1,(11)
	add 1,7
	add 1,3
%L29:
	add 1,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L30:
	add 1,10
	add 1,5
	jrst %L29

pressure_direct_eq:
	push 17,10
	move 10,2
	move 5,-2(17)
	move 6,-3(17)
	move 7,-4(17)
	move 2,-5(17)
	add 3,4
	add 5,6
	add 7,2
	move 4,3
	add 4,5
	add 4,7
	add 3,4
	skipn (1)
	jrst %L31
	move 3,(10)
	add 3,4
	add 3,5
%L31:
	move 1,3
	pop 17,10
	popj 17,

pressure_direct_ne:
	push 17,10
	move 10,2
	move 5,3
	move 7,-2(17)
	move 2,-3(17)
	move 6,-4(17)
	move 3,-5(17)
	add 5,4
	add 7,2
	add 6,3
	move 4,5
	add 4,7
	add 4,6
	skipn 1,(1)
	jrst %L34
	add 1,4
	add 1,5
%L33:
	pop 17,10
	popj 17,
%L34:
	move 1,(10)
	add 1,4
	add 1,7
	jrst %L33

pressure_direct_ge:
	push 17,10
	move 10,2
	move 7,3
	move 5,-2(17)
	move 2,-3(17)
	move 6,-4(17)
	move 3,-5(17)
	add 7,4
	add 5,2
	add 6,3
	move 4,7
	add 4,5
	add 4,6
	skipge 1,(1)
	jrst %L36
	add 1,4
	add 1,7
%L35:
	pop 17,10
	popj 17,
%L36:
	move 1,(10)
	add 1,4
	add 1,5
	jrst %L35

pressure_direct_le:
	push 17,10
	move 10,2
	move 5,3
	move 7,-2(17)
	move 2,-3(17)
	move 6,-4(17)
	move 3,-5(17)
	add 5,4
	add 7,2
	add 6,3
	move 4,5
	add 4,7
	add 4,6
	skipg 1,(1)
	jrst %L39
	move 1,(10)
	add 1,4
	add 1,7
%L37:
	pop 17,10
	popj 17,
%L39:
	add 1,4
	add 1,5
	jrst %L37

pressure_direct_gt:
	push 17,10
	move 10,2
	move 7,3
	move 5,-2(17)
	move 2,-3(17)
	move 6,-4(17)
	move 3,-5(17)
	add 7,4
	add 5,2
	add 6,3
	move 4,7
	add 4,5
	add 4,6
	skipg 1,(1)
	jrst %L41
	add 1,4
	add 1,7
%L40:
	pop 17,10
	popj 17,
%L41:
	move 1,(10)
	add 1,4
	add 1,5
	jrst %L40

pressure_direct_lt:
	push 17,10
	move 10,2
	move 5,3
	move 7,-2(17)
	move 2,-3(17)
	move 6,-4(17)
	move 3,-5(17)
	add 5,4
	add 7,2
	add 6,3
	move 4,5
	add 4,7
	add 4,6
	skipge 1,(1)
	jrst %L44
	move 1,(10)
	add 1,4
	add 1,7
%L42:
	pop 17,10
	popj 17,
%L44:
	add 1,4
	add 1,5
	jrst %L42

pressure_likely_eq:
	push 17,10
	move 10,2
	move 5,-2(17)
	move 6,-3(17)
	move 7,-4(17)
	move 2,-5(17)
	add 3,4
	sub 5,6
	xor 7,2
	move 4,3
	add 4,5
	add 4,7
	add 3,4
	skipe (1)
	jrst %L47
%L45:
	move 1,3
	pop 17,10
	popj 17,
%L47:
	move 3,4
	add 3,(10)
	add 3,5
	jrst %L45

pressure_likely_ne:
	push 17,10
	move 10,2
	move 7,3
	move 5,-2(17)
	move 2,-3(17)
	move 6,-4(17)
	move 3,-5(17)
	add 7,4
	sub 5,2
	xor 6,3
	move 4,7
	add 4,5
	add 4,6
	skipn 1,(1)
	jrst %L49
	add 1,4
	add 1,7
%L48:
	pop 17,10
	popj 17,
%L49:
	move 1,4
	add 1,(10)
	add 1,5
	jrst %L48

pressure_likely_lt:
	push 17,10
	move 10,2
	move 7,3
	move 5,-2(17)
	move 2,-3(17)
	move 6,-4(17)
	move 3,-5(17)
	add 7,4
	sub 5,2
	xor 6,3
	move 4,7
	add 4,5
	add 4,6
	skipl 1,(1)
	jrst %L51
	add 1,4
	add 1,7
%L50:
	pop 17,10
	popj 17,
%L51:
	move 1,4
	add 1,(10)
	add 1,5
	jrst %L50

pressure_likely_gt:
	push 17,10
	move 10,2
	move 7,3
	move 5,-2(17)
	move 2,-3(17)
	move 6,-4(17)
	move 3,-5(17)
	add 7,4
	sub 5,2
	xor 6,3
	move 4,7
	add 4,5
	add 4,6
	skipg 1,(1)
	jrst %L53
	add 1,4
	add 1,7
%L52:
	pop 17,10
	popj 17,
%L53:
	move 1,4
	add 1,(10)
	add 1,5
	jrst %L52

pressure_unlikely_eq:
	push 17,10
	move 10,2
	move 5,-2(17)
	move 6,-3(17)
	move 7,-4(17)
	move 2,-5(17)
	add 3,4
	sub 5,6
	xor 7,2
	move 4,3
	add 4,5
	add 4,7
	add 3,4
	skipn (1)
	jrst %L54
	move 3,4
	add 3,(10)
	add 3,5
%L54:
	move 1,3
	pop 17,10
	popj 17,

pressure_unlikely_ne:
	push 17,10
	move 10,2
	move 5,3
	move 7,-2(17)
	move 2,-3(17)
	move 6,-4(17)
	move 3,-5(17)
	add 5,4
	sub 7,2
	xor 6,3
	move 4,5
	add 4,7
	add 4,6
	skipe 1,(1)
	jrst %L58
	move 1,4
	add 1,(10)
	add 1,7
%L56:
	pop 17,10
	popj 17,
%L58:
	add 1,4
	add 1,5
	jrst %L56

pressure_unlikely_lt:
	push 17,10
	move 10,2
	move 5,3
	move 7,-2(17)
	move 2,-3(17)
	move 6,-4(17)
	move 3,-5(17)
	add 5,4
	sub 7,2
	xor 6,3
	move 4,5
	add 4,7
	add 4,6
	skipge 1,(1)
	jrst %L61
	move 1,4
	add 1,(10)
	add 1,7
%L59:
	pop 17,10
	popj 17,
%L61:
	add 1,4
	add 1,5
	jrst %L59

pressure_unlikely_gt:
	push 17,10
	move 10,2
	move 5,3
	move 7,-2(17)
	move 2,-3(17)
	move 6,-4(17)
	move 3,-5(17)
	add 5,4
	sub 7,2
	xor 6,3
	move 4,5
	add 4,7
	add 4,6
	skiple 1,(1)
	jrst %L64
	move 1,4
	add 1,(10)
	add 1,7
%L62:
	pop 17,10
	popj 17,
%L64:
	add 1,4
	add 1,5
	jrst %L62

pressure_skip_inverted:
	push 17,10
	move 10,2
	move 5,3
	move 7,-2(17)
	move 2,-3(17)
	move 6,-4(17)
	move 3,-5(17)
	add 5,4
	add 7,2
	add 6,3
	move 4,5
	add 4,7
	add 4,6
	skipe 1,(1)
	jrst %L66
	move 1,(10)
	add 1,7
%L67:
	add 1,4
	pop 17,10
	popj 17,
%L66:
	add 1,5
	add 1,6
	jrst %L67

pressure_skip_goto:
	push 17,10
	move 10,2
	move 5,3
	move 7,-2(17)
	move 2,-3(17)
	move 6,-4(17)
	move 3,-5(17)
	add 5,4
	add 7,2
	add 6,3
	move 4,5
	add 4,7
	add 4,6
	skipe 1,(1)
	jrst %L70
	move 1,(10)
	add 1,7
%L71:
	add 1,4
	pop 17,10
	popj 17,
%L70:
	add 1,5
	add 1,6
	jrst %L71

pressure_skip_two_tests:
	push 17,10
	move 10,2
	move 5,3
	move 7,-2(17)
	move 2,-3(17)
	move 6,-4(17)
	move 3,-5(17)
	add 5,4
	sub 7,2
	add 6,3
	move 4,5
	add 4,7
	add 4,6
	skipge 1,(1)
	jrst %L75
	jumple 1,%L74
	add 1,4
	add 1,7
%L72:
	pop 17,10
	popj 17,
%L74:
	move 1,4
	add 1,(10)
	add 1,6
	jrst %L72
%L75:
	sub 4,1
	move 1,4
	add 1,5
	jrst %L72

pressure_skip_three_tests:
	push 17,10
	move 10,2
	move 5,4
	move 7,-2(17)
	move 2,-3(17)
	move 6,-4(17)
	move 4,-5(17)
	add 5,3
	add 7,2
	add 6,4
	sub 3,4
	move 2,5
	add 2,7
	add 2,6
	add 2,3
	skipe 1,(1)
	jrst %L77
	move 1,2
	add 1,(10)
%L76:
	pop 17,10
	popj 17,
%L77:
	jumpl 1,%L80
	jumple 1,%L79
	add 1,2
	add 1,7
	jrst %L76
%L79:
	move 1,2
	add 1,6
	jrst %L76
%L80:
	sub 2,1
	move 1,2
	add 1,5
	jrst %L76

pressure_skip_store_eq:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,2
	move 10,3
	move 7,4
	move 2,-3(17)
	move 5,-4(17)
	move 3,-5(17)
	move 6,-6(17)
	move 4,-7(17)
	add 7,2
	add 5,3
	add 6,4
	move 4,7
	add 4,6
	skipn 1,(1)
	jrst %L83
	move 4,1
	add 4,(11)
	add 4,5
%L83:
	movem 4,(10)
	add 4,7
	add 4,5
	add 4,6
	move 1,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

pressure_skip_store_ne:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,2
	move 10,3
	move 5,4
	move 2,-3(17)
	move 7,-4(17)
	move 3,-5(17)
	move 6,-6(17)
	move 4,-7(17)
	sub 5,2
	sub 7,3
	sub 6,4
	skipn 1,(1)
	jrst %L85
	add 1,5
	add 1,6
%L86:
	movem 1,(10)
	add 1,5
	add 1,7
	add 1,6
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L85:
	move 1,(11)
	add 1,7
	jrst %L86

pressure_skip_update_p:
	push 17,10
	move 5,1
	move 10,2
	move 1,3
	move 6,-2(17)
	move 2,-3(17)
	move 7,-4(17)
	move 3,-5(17)
	add 1,4
	add 6,2
	add 7,3
	skipn 4,(5)
	jrst %L88
	add 4,1
	movem 4,(5)
%L89:
	add 1,(5)
	add 1,6
	add 1,7
	pop 17,10
	popj 17,
%L88:
	move 10,(10)
	add 10,6
	movem 10,(5)
	jrst %L89

pressure_skip_update_q:
	push 17,10
	move 10,2
	move 6,3
	move 7,-2(17)
	move 2,-3(17)
	move 5,-4(17)
	move 3,-5(17)
	sub 6,4
	sub 7,2
	sub 5,3
	skipge 1,(1)
	jrst %L93
	add 1,7
	movem 1,(10)
%L92:
	add 6,(10)
	add 6,7
	add 6,5
	move 1,6
	pop 17,10
	popj 17,
%L93:
	move 4,6
	sub 4,1
	movem 4,(10)
	jrst %L92

pressure_skip_global:
	move 5,1
	move 7,3
	move 6,-1(17)
	move 3,-2(17)
	add 5,2
	add 7,4
	add 6,3
	skipn 1,mskip_pg0
	jrst %L95
	add 1,5
%L96:
	add 1,6
	popj 17,
%L95:
	move 1,mskip_pg1
	add 1,7
	jrst %L96

pressure_skip_global_store:
	move 7,3
	move 6,-1(17)
	move 3,-2(17)
	add 1,2
	add 7,4
	add 6,3
	skipe 4,mskip_pg0
	jrst %L98
	move 5,1
	add 5,6
	movem 5,mskip_pg2
%L99:
	add 1,mskip_pg2
	add 1,7
	add 1,6
	popj 17,
%L98:
	add 4,7
	movem 4,mskip_pg2
	jrst %L99

pressure_skip_sint_global:
	move 5,1
	move 7,3
	move 6,-1(17)
	move 3,-2(17)
	add 5,2
	add 7,4
	add 6,3
	skipge 1,mskip_psg0
	jrst %L103
	move 1,mskip_psg1
	add 1,7
%L102:
	add 1,6
	popj 17,
%L103:
	add 1,5
	jrst %L102

pressure_skip_array:
	move 7,2
	move 5,4
	move 2,-1(17)
	move 6,-2(17)
	move 4,-3(17)
	andi 1,17
	add 7,3
	add 5,2
	add 6,4
	skipn 4,mskip_pbuf(1)
	jrst %L105
	move 1,4
	add 1,7
%L106:
	add 1,6
	popj 17,
%L105:
	addi 1,1
	andi 1,17
	move 1,mskip_pbuf(1)
	add 1,5
	jrst %L106

pressure_skip_array_store:
	move 6,2
	move 7,4
	move 2,-1(17)
	move 5,-2(17)
	move 4,-3(17)
	andi 1,17
	sub 6,3
	sub 7,2
	sub 5,4
	skipge 3,mskip_pbuf(1)
	jrst %L110
	aos 4,1
	andi 4,17
	add 3,7
	movem 3,mskip_pbuf(4)
%L109:
	andi 1,17
	add 6,mskip_pbuf(1)
	add 6,7
	add 6,5
	move 1,6
	popj 17,
%L110:
	aos 4,1
	andi 4,17
	move 2,6
	sub 2,3
	movem 2,mskip_pbuf(4)
	jrst %L109

pressure_skip_sint_array:
	push 17,10
	move 6,1
	move 5,2
	move 10,4
	move 2,-2(17)
	move 7,-3(17)
	move 4,-4(17)
	andi 6,17
	add 5,3
	add 10,2
	add 7,4
	skipge 1,mskip_psbuf(6)
	jrst %L112
	add 1,5
%L113:
	add 1,7
	pop 17,10
	popj 17,
%L112:
	addi 6,1
	andi 6,17
	move 1,mskip_psbuf(6)
	add 1,10
	jrst %L113

pressure_skip_struct:
	push 17,10
	move 10,1
	move 5,2
	move 7,4
	move 2,-2(17)
	move 6,-3(17)
	move 4,-4(17)
	add 5,3
	add 7,2
	add 6,4
	skipn 1,(1)
	jrst %L115
	add 1,5
%L116:
	add 1,6
	pop 17,10
	popj 17,
%L115:
	move 1,1(10)
	add 1,7
	jrst %L116

pressure_skip_struct_store:
	move 5,1
	move 1,2
	move 7,4
	move 2,-1(17)
	move 6,-2(17)
	move 4,-3(17)
	add 1,3
	add 7,2
	add 6,4
	skipe 4,(5)
	jrst %L118
	move 4,1
	add 4,6
%L120:
	movem 4,2(5)
	add 1,2(5)
	add 1,7
	add 1,6
	popj 17,
%L118:
	add 4,1(5)
	add 4,7
	jrst %L120

pressure_skip_global_struct:
	move 5,1
	move 7,3
	move 6,-1(17)
	move 3,-2(17)
	add 5,2
	add 7,4
	add 6,3
	skipn 1,mskip_gp
	jrst %L122
	add 1,5
%L123:
	add 1,6
	popj 17,
%L122:
	move 1,mskip_gp+1
	add 1,7
	jrst %L123

pressure_skip_sint_struct:
	move 5,1
	move 7,3
	move 6,-1(17)
	move 3,-2(17)
	add 5,2
	add 7,4
	add 6,3
	skipge 1,mskip_sgp
	jrst %L127
	move 1,mskip_sgp+1
	add 1,7
%L126:
	add 1,6
	popj 17,
%L127:
	add 1,5
	jrst %L126

pressure_skip_volatile:
	push 17,10
	move 10,2
	move 5,3
	move 7,-2(17)
	move 2,-3(17)
	move 6,-4(17)
	move 3,-5(17)
	add 5,4
	add 7,2
	add 6,3
	move 1,(1)
	jumpe 1,%L129
	add 1,5
%L130:
	add 1,6
	pop 17,10
	popj 17,
%L129:
	move 1,(10)
	add 1,7
	jrst %L130

pressure_skip_volatile_store:
	push 17,10
	move 10,2
	move 7,3
	move 6,-2(17)
	move 2,-3(17)
	move 5,-4(17)
	move 3,-5(17)
	sub 7,4
	sub 6,2
	sub 5,3
	move 1,(1)
	jumpl 1,%L134
	add 1,6
	movem 1,(10)
%L133:
	move 1,(10)
	add 1,7
	add 1,6
	add 1,5
	pop 17,10
	popj 17,
%L134:
	move 4,7
	sub 4,1
	movem 4,(10)
	jrst %L133

pressure_skip_call_after:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 6,2
	move 12,3
	move 11,-5(17)
	move 2,-6(17)
	move 13,-7(17)
	move 3,-10(17)
	add 12,4
	add 11,2
	add 13,3
	skipn 1,(1)
	jrst %L136
	move 10,1
	add 10,12
%L137:
	move 1,10
	pushj 17,sink_int
	add 10,12
	add 10,11
	add 10,13
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,
%L136:
	move 10,(6)
	add 10,11
	jrst %L137

pressure_skip_call_in_arms:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 6,2
	move 12,3
	move 11,-5(17)
	move 2,-6(17)
	move 13,-7(17)
	move 3,-10(17)
	add 12,4
	add 11,2
	add 13,3
	skipn 1,(1)
	jrst %L139
	move 10,1
	add 10,12
%L141:
	move 1,10
	pushj 17,sink_int
	add 10,12
	add 10,11
	add 10,13
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,
%L139:
	move 10,(6)
	add 10,11
	jrst %L141

pressure_skip_call_before:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 10,1
	move 14,2
	move 13,3
	move 12,-6(17)
	move 2,-7(17)
	move 11,-10(17)
	move 3,-11(17)
	add 13,4
	add 12,2
	add 11,3
	move 1,13
	add 1,12
	add 1,11
	pushj 17,sink_int
	skipn 1,(10)
	jrst %L143
	add 1,13
%L144:
	add 1,11
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,
%L143:
	move 1,(14)
	add 1,12
	jrst %L144

pressure_skip_nested:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,2
	move 11,3
	move 5,4
	move 2,-3(17)
	move 6,-4(17)
	move 3,-5(17)
	move 7,-6(17)
	move 4,-7(17)
	add 5,2
	add 6,3
	add 7,4
	skipn 1,(1)
	jrst %L146
	skipge 4,(10)
	jrst %L149
	add 1,4
	add 1,6
%L148:
	add 1,7
%L145:
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L149:
	sub 1,4
	add 1,5
	jrst %L148
%L146:
	move 1,(11)
	add 1,5
	add 1,6
	jrst %L145

pressure_skip_loop:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 5,2
	move 7,3
	move 6,-3(17)
	move 2,-4(17)
	move 10,-5(17)
	move 3,-6(17)
	add 7,4
	add 6,2
	add 10,3
	setzb 1,3
	caml 1,5
	jrst %L160
	move 2,5
	subi 2,1
%L161:
	move 4,3
	andi 4,17
	add 4,11
	skipn 4,(4)
	jrst %L156
	add 4,7
	add 1,4
%L153:
	addi 3,1
	sojge 2,%L161	; doloop_end
%L160:
	add 1,7
	add 1,6
	add 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L156:
	add 1,6
	jrst %L153

pressure_skip_loop_store:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 7,2
	move 1,3
	move 5,-3(17)
	move 2,-4(17)
	move 11,-5(17)
	move 3,-6(17)
	add 1,4
	add 5,2
	add 11,3
	movei 6,0
	caml 6,7
	jrst %L175
	move 2,7
	subi 2,1
%L176:
	move 4,6
	andi 4,17
	add 4,10
	skipe 3,(4)
	jrst %L168
	movem 1,(4)
%L165:
	addi 6,1
	sojge 2,%L176	; doloop_end
%L175:
	subi 7,1
	andi 7,17
	add 10,7
	add 1,(10)
	add 1,5
	add 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L168:
	add 3,5
	movem 3,(4)
	jrst %L165

pressure_skip_qi:
	move 6,3
	move 7,-1(17)
	move 3,-2(17)
	add 6,4
	add 7,3
	ldb 4,1
	trne 4,400
	orcmi 4,777
	add 6,4
	jumpn 4,%L177
	ldb 6,2
	trne 6,400
	orcmi 6,777
	add 6,7
%L177:
	move 1,6
	popj 17,

pressure_skip_qi_signed:
	move 6,3
	move 7,-1(17)
	move 3,-2(17)
	sub 6,4
	sub 7,3
	ldb 4,1
	trne 4,400
	orcmi 4,777
	sub 6,4
	jumpl 4,%L179
	ldb 6,2
	trne 6,400
	orcmi 6,777
	add 6,7
%L179:
	move 1,6
	popj 17,

pressure_skip_hi:
	move 6,3
	move 7,-1(17)
	move 3,-2(17)
	add 6,4
	add 7,3
	ldb 4,1
	hrre 4,4
	add 6,4
	jumpn 4,%L181
	ldb 6,2
	hrre 6,6
	add 6,7
%L181:
	move 1,6
	popj 17,

pressure_skip_hi_signed:
	move 6,3
	move 7,-1(17)
	move 3,-2(17)
	sub 6,4
	sub 7,3
	ldb 4,1
	hrre 4,4
	sub 6,4
	jumpl 4,%L183
	ldb 6,2
	hrre 6,6
	add 6,7
%L183:
	move 1,6
	popj 17,

	.bss
mskip_pg0:
	.space	4
mskip_pg1:
	.space	4
mskip_pg2:
	.space	4
mskip_pbuf:
	.space	64
mskip_psg0:
	.space	4
mskip_psg1:
	.space	4
mskip_psbuf:
	.space	64
mskip_gp:
	.space	8
mskip_gt:
	.space	12
mskip_sgp:
	.space	8
