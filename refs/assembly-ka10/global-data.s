	.globl	gpds
	.data
	.align	2
gpds:
	.long	42798
	.globl	gpdu
	.align	2
gpdu:
	.long	256794
	.globl	gpdc
	.align	2
gpdc:
	.word	107
	.globl	gpst
	.align	2
gpst:
	.word	147154157142
	.word	141154055144
	.word	141164141000
	.align	2
gd_data_sint:
	.long	1402433619
	.align	2
gd_data_usint:
	.long	131478599
	.align	2
gd_data_qint:
	.word	773
	.align	2
gd_data_uqint:
	.word	377
	.align	2
gd_data_hint:
	.word	776544
	.align	2
gd_data_uhint:
	.word	76543
	.align	2
gd_data_char:
	.word	104
	.align	2
gd_data_schar:
	.word	775
	.align	2
gd_data_uchar:
	.word	377
	.align	2
gd_data_i32:
	.long	21913025
	.align	2
gd_data_ui32:
	.long	131478599
	.align	2
gd_data_dint:
	.long	0
	.long	342391
	.align	2
gd_data_udint:
	.long	0
	.long	2054353
	.align	2
gd_v_sint:
	.long	668
	.align	2
gd_v_usint:
	.long	3000
	.align	2
gd_v_char:
	.word	126
	.align	2
gd_v_uchar:
	.word	200
	.align	2
gd_init_sarr:
	.long	1
	.long	2
	.long	3
	.long	4
	.long	5
	.long	6
	.long	7
	.long	8
	.align	2
gd_part_sarr:
	.long	9
	.long	18
	.long	27
	.space	20
	.align	2
gd_init_darr:
	.long	0
	.long	1
	.long	68719476735
	.long	68719476734
	.long	0
	.long	3
	.align	2
gd_msg:
	.word	104101111115
	.word	117116000107
	.word	103103000000
	.align	2
gd_msg2:
	.word	120104120055
	.space	5
	.word	61060000000
	.align	2
gd_raw_chars:
	.word	1177200
	.word	376377101000
	.align	2
gd_c6:
	.word	770001021737
	.word	600000000000
	.align	2
gd_u6:
	.word	102374076
	.word	770000000000
	.align	2
gd_c7:
	.word	774000101076
	.word	377000000000
	.align	2
gd_u7:
	.word	20237600
	.word	773760000000
	.align	2
gd_c8:
	.word	776000010040
	.word	176777000000
	.align	2
gd_u8:
	.word	4023760
	.word	401773770000
	.align	2
gd_c9:
	.word	777000001002
	.word	177377600000
	.align	2
gd_u9:
	.word	1002377
	.word	400776777000
	.align	2
gd_s16:
	.word	777774000000
	.word	5777760
	.word	400000000000
	.align	2
gd_u16:
	.word	20
	.word	377776000000
	.word	777774000000
	.align	2
gd_s18:
	.word	777777000000
	.word	1377777
	.word	400000000000
	.align	2
gd_u18:
	.word	1
	.word	377777400000
	.word	777777000000
	.align	2
gd_data_struct:
	.word	141201771777
	.word	777655007654
	.long	42798
	.long	256794
	.long	342391
	.long	2054353
	.align	2
gd_data_bytes:
	.word	777077776177
	.space	1
	.word	775377774777
	.word	777700177777
	.space	1
	.word	600000777777
	.align	2
gd_data_packed:
	.word	102030405
	.word	60000202014
	.word	20120000100
	.word	4014040000
	.word	1002003004
	.word	1
	.word	2000000
	.align	2
gd_data_union_s:
	.long	342391
	.space	20

gd_const_sint:
	.long	2423
gd_const_msg:
	.word	143157156163
	.word	164055144141
	.data
	.word	164141000000
	.align	2
gd_ptr_sint:
	.long	gd_data_sint
	.align	2
gd_ptr_usint:
	.long	gd_data_usint
	.align	2
gd_ptr_msg0:
	.long	gd_msg+29142024192
	.align	2
gd_ptr_msg4:
	.long	gd_msg+29142024193
	.align	2
gd_ptr_raw3:
	.long	gd_raw_chars+150994944
	.align	2
gd_ptr_u6:
	.long	gd_u6+100663296
	.align	2
gd_ptr_u7:
	.long	gd_u7+31255953409
	.align	2
gd_ptr_u8:
	.long	gd_u8+21609054209
	.align	2
gd_ptr_u9:
	.long	gd_u9+19478347777
	.align	2
gd_ptr_s18:
	.long	gd_s18+301989889
	.align	2
gd_ptr_sarr:
	.long	gd_init_sarr+2
	.align	2
gd_ptr_darr:
	.long	gd_init_darr+2
	.align	2
gd_ptr_public_string:
	.long	gpst+9814671360
	.align	2
gd_ptr_const_sint:
	.long	gd_const_sint
	.align	2
gd_ptr_const_msg:
	.long	gd_const_msg+150994944
	.align	2
gd_ptr_table:
	.long	gd_data_sint
	.long	gd_bss_sint
	.long	gd_init_sarr
	.long	gd_part_sarr+2
	.align	2
gd_char_ptr_table:
	.long	gd_msg+29142024192
	.long	gd_msg+150994944
	.long	gd_msg2+19478347776
	.long	gpst+29142024193
	.align	2
gd_void_ptrs:
	.long	gd_data_sint
	.long	gd_msg+29142024192
	.long	gd_raw_chars+29142024192
	.long	gd_data_struct

idx8:
	andi 1,7
	popj 17,

idx5:
	move 4,[314631463147]
	mul 4,1
	ashc 4,-44
	move 3,5
	ash 3,-1
	move 4,1
	ash 4,-43
	sub 3,4
	move 4,3
	lsh 4,2
	add 4,3
	sub 1,4
	popj 17,

global_data_read_scalars:
	pushj 17,idx8
	move 2,1
	move 1,gpbs
	add 1,gpds
	move 4,gd_bss_sint
	add 4,gd_data_sint
	add 1,4
	move 4,gd_bss_usint
	add 4,gd_data_usint
	add 1,4
	hrre 4,gd_bss_qint
	hrre 3,gd_data_qint
	add 4,3
	add 1,4
	ldb 4,[POINT 18,gd_data_uqint,35]
	ldb 6,[POINT 18,gd_bss_uqint,35]
	add 4,6
	add 1,4
	hrre 4,gd_bss_hint
	hrre 3,gd_data_hint
	add 4,3
	add 1,4
	hlrz 4,gd_data_uhint
	hlrz 6,gd_bss_uhint
	add 4,6
	add 1,4
	move 4,gd_data_i32
	add 4,gd_data_ui32
	add 1,4
	move 4,gd_init_sarr(2)
	add 4,gd_part_sarr(2)
	add 1,4
	move 4,gd_v_sint
	move 3,gd_v_usint
	add 4,3
	add 1,4
	popj 17,

global_data_read_bytes:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	pushj 17,idx8
	hrre 10,gd_data_schar
	ldb 6,[POINT 18,gd_data_char,35]
	add 10,6
	ldb 4,[POINT 18,gpdc,35]
	ldb 6,[POINT 18,gd_data_uchar,35]
	add 4,6
	add 10,4
	move 7,1
	move 6,1
	andi 6,3
	move 4,6
	ash 7,-2	; ashrsi3_pointer
	move 3,7
	add 3,[POINT 9,gd_msg,8]
	jumpe 6,%L33
%L32:
	ibp 3
	sojn 4,%L32	; decrement_and_branch_until_zero
%L33:
	ldb 2,3
	move 4,6
	move 3,7
	add 3,[POINT 9,gd_msg2,8]
	jumpe 6,%L35
%L34:
	ibp 3
	sojn 4,%L34	; decrement_and_branch_until_zero
%L35:
	ldb 3,3
	add 2,3
	add 10,2
	move 4,6
	move 3,7
	add 3,[POINT 9,gd_raw_chars,8]
	jumpe 6,%L37
%L36:
	ibp 3
	sojn 4,%L36	; decrement_and_branch_until_zero
%L37:
	ldb 3,3
	add 10,3
	move 3,[POINT 6,gd_c6,5]
	move 4,1
	jumple 1,%L39
%L38:
	ibp 3
	sojg 4,%L38	; decrement_and_branch_until_zero
%L39:
	jumpe 4,%L41
%L40:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L40
%L41:
	ldb 2,3
	trne 2,40
	orcmi 2,77
	move 3,[POINT 6,gd_u6,5]
	move 4,1
	jumple 1,%L43
%L42:
	ibp 3
	sojg 4,%L42	; decrement_and_branch_until_zero
%L43:
	jumpe 4,%L45
%L44:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L44
%L45:
	ldb 4,3
	add 2,4
	add 10,2
	move 3,[POINT 7,gd_c7,6]
	move 4,1
	jumple 1,%L47
%L46:
	ibp 3
	sojg 4,%L46	; decrement_and_branch_until_zero
%L47:
	jumpe 4,%L49
%L48:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L48
%L49:
	ldb 2,3
	trne 2,100
	orcmi 2,177
	move 3,[POINT 7,gd_u7,6]
	move 4,1
	jumple 1,%L51
%L50:
	ibp 3
	sojg 4,%L50	; decrement_and_branch_until_zero
%L51:
	jumpe 4,%L53
%L52:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L52
%L53:
	ldb 4,3
	add 2,4
	add 10,2
	move 4,6
	move 3,7
	add 3,[POINT 8,gd_c8,7]
	jumpe 6,%L55
%L54:
	ibp 3
	sojn 4,%L54	; decrement_and_branch_until_zero
%L55:
	ldb 2,3
	trne 2,200
	orcmi 2,377
	move 4,6
	move 3,7
	add 3,[POINT 8,gd_u8,7]
	jumpe 6,%L57
%L56:
	ibp 3
	sojn 4,%L56	; decrement_and_branch_until_zero
%L57:
	ldb 4,3
	add 2,4
	add 10,2
	move 3,7
	add 3,[POINT 9,gd_c9,8]
	skipn 4,6
	jrst %L59
%L58:
	ibp 3
	sojn 4,%L58	; decrement_and_branch_until_zero
%L59:
	ldb 3,3
	trne 3,400
	orcmi 3,777
	andi 1,3
	move 4,7
	add 4,[POINT 9,gd_u9,8]
	jumpe 1,%L61
%L60:
	ibp 4
	sojn 1,%L60	; decrement_and_branch_until_zero
%L61:
	ldb 4,4
	add 3,4
	add 10,3
	move 1,12
	pushj 17,idx5
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,gd_s16,17]
	jumpe 4,%L63
%L62:
	ibp 1
	sojn 4,%L62	; decrement_and_branch_until_zero
%L63:
	move 4,(1)
	ash 4,-24
	move 11,4
	move 1,12
	pushj 17,idx5
	move 3,1
	andi 3,1
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,gd_u16,17]
	jumpe 3,%L65
%L64:
	ibp 1
	sojn 3,%L64	; decrement_and_branch_until_zero
%L65:
	move 4,(1)
	lsh 4,-24
	add 11,4
	add 10,11
	move 1,12
	pushj 17,idx5
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,gd_s18,17]
	jumpe 4,%L67
%L66:
	ibp 1
	sojn 4,%L66	; decrement_and_branch_until_zero
%L67:
	ldb 11,1
	hrre 11,11
	move 1,12
	pushj 17,idx5
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,gd_u18,17]
	jumpe 4,%L69
%L68:
	ibp 1
	sojn 4,%L68	; decrement_and_branch_until_zero
%L69:
	ldb 1,1
	add 11,1
	add 10,11
	move 4,gd_v_char
	move 3,gd_v_uchar
	add 4,3
	add 10,4
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

global_data_read_structs:
	pushj 17,idx5
	move 6,gd_data_struct
	lsh 6,-33
	ldb 4,[POINT 9,gd_data_struct,17]
	add 6,4
	move 4,gd_data_struct
	lsh 4,22
	ash 4,-33
	move 3,gd_data_struct
	andi 3,777
	add 4,3
	add 6,4
	hlre 4,gd_data_struct+1
	hrrz 3,gd_data_struct+1
	add 4,3
	add 6,4
	move 4,gd_data_struct+2
	add 4,gd_data_struct+3
	add 6,4
	move 3,gd_data_bytes
	ash 3,-36
	ldb 4,[POINT 6,gd_data_bytes,11]
	add 3,4
	add 6,3
	move 3,gd_data_bytes
	lsh 3,16
	ash 3,-35
	ldb 4,[POINT 7,gd_data_bytes,27]
	add 3,4
	add 6,3
	move 4,gd_data_bytes
	andi 4,17
	lsh 4,4
	move 3,gd_data_bytes+1
	lsh 3,-40
	ior 3,4
	lsh 3,34
	ash 3,-34
	ldb 4,[POINT 8,gd_data_bytes+1,15]
	add 3,4
	add 6,3
	move 4,gd_data_bytes+1
	lsh 4,20
	ash 4,-33
	move 3,gd_data_bytes+1
	andi 3,777
	add 4,3
	add 6,4
	move 3,gd_data_bytes+2
	ash 3,-24
	move 4,gd_data_bytes+2
	lsh 4,-4
	andi 4,177777
	add 3,4
	add 6,3
	hlre 4,gd_data_bytes+3
	hrrz 3,gd_data_bytes+3
	add 4,3
	add 6,4
	move 3,[POINT 18,gd_data_packed,17]
	move 4,1
	jumple 1,%L72
%L71:
	ibp 3
	sojg 4,%L71	; decrement_and_branch_until_zero
%L72:
	jumpe 4,%L74
%L73:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L73
%L74:
	ldb 4,3
	trne 4,40
	orcmi 4,77
	add 6,4
	move 3,[POINT 18,gd_data_packed,17]
	move 4,1
	jumple 1,%L76
%L75:
	ibp 3
	sojg 4,%L75	; decrement_and_branch_until_zero
%L76:
	jumpe 4,%L78
%L77:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L77
%L78:
	addi 3,1
	ldb 4,3
	trne 4,100
	orcmi 4,177
	add 6,4
	move 2,1
	andi 2,3
	move 4,2
	move 7,1
	ash 7,-2	; ashrsi3_pointer
	move 3,7
	add 3,[POINT 18,gd_data_packed,17]
	jumpe 2,%L80
%L79:
	ibp 3
	sojn 4,%L79	; decrement_and_branch_until_zero
%L80:
	addi 3,2
	ldb 4,3
	trne 4,200
	orcmi 4,377
	add 6,4
	move 3,7
	add 3,[POINT 18,gd_data_packed,17]
	skipn 4,2
	jrst %L82
%L81:
	ibp 3
	sojn 4,%L81	; decrement_and_branch_until_zero
%L82:
	addi 3,3
	ldb 4,3
	trne 4,400
	orcmi 4,777
	add 6,4
	move 4,[252525252526]
	mul 4,1
	ashc 4,-44
	move 3,1
	ash 3,-43
	move 7,5
	sub 7,3
	move 2,7
	lsh 2,1
	add 2,7
	move 4,1
	sub 4,2
	move 2,4
	andi 2,1
	move 1,4
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,gd_data_packed,17]
	jumpe 2,%L84
%L83:
	ibp 1
	sojn 2,%L83	; decrement_and_branch_until_zero
%L84:
	hlre 4,5(1)
	add 6,4
	add 6,gd_data_union_s
	move 1,6
	popj 17,

global_data_use_pointers:
	move 2,1
	andi 2,3
	move 3,gd_ptr_usint
	move 4,gd_ptr_sint
	move 1,(4)
	add 1,(3)
	move 4,2
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,gd_ptr_msg0
	jumpe 2,%L88
%L87:
	ibp 3
	sojn 4,%L87	; decrement_and_branch_until_zero
%L88:
	move 4,gd_ptr_msg4
	subi 4,1
	ibp 4
	ibp 4
	ildb 4,4
	ldb 3,3
	add 4,3
	add 1,4
	ldb 6,gd_ptr_raw3
	add 1,6
	ldb 4,gd_ptr_u6
	ldb 3,gd_ptr_u7
	add 4,3
	add 1,4
	ldb 4,gd_ptr_u8
	ldb 6,gd_ptr_u9
	add 4,6
	add 1,4
	ldb 4,gd_ptr_s18
	hrre 4,4
	add 1,4
	move 3,gd_ptr_darr
	move 4,gd_ptr_sarr
	move 4,(4)
	add 4,1(3)
	add 1,4
	ldb 6,gd_ptr_public_string
	add 1,6
	move 4,gd_ptr_const_sint
	ldb 6,gd_ptr_const_msg
	add 6,(4)
	add 1,6
	add 1,@gd_ptr_table(2)
	ldb 2,gd_char_ptr_table(2)
	add 1,2
	hrrz 4,gd_void_ptrs
	add 1,(4)
	popj 17,

global_data_write_bss:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	move 10,2
	pushj 17,idx8
	move 11,1
	movem 10,gpbs
	move 2,10
	addi 2,1
	movem 2,gd_bss_sint
	move 1,10
	addi 1,2
	movem 1,gd_bss_usint
	move 6,10
	addi 6,3
	movem 6,gd_bss_qint
	move 7,10
	addi 7,4
	movem 7,gd_bss_uqint
	move 5,10
	addi 5,5
	movem 5,gd_bss_hint
	move 13,10
	addi 13,6
	movem 13,gd_bss_uhint
	move 14,10
	addi 14,7
	movem 14,gd_bss_char
	move 15,10
	addi 15,10
	movem 15,gd_bss_uchar
	move 3,[POINT 6,gd_bss_c6,5]
	move 4,11
	jumple 11,%L92
%L91:
	ibp 3
	sojg 4,%L91	; decrement_and_branch_until_zero
%L92:
	jumpe 4,%L94
%L93:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L93
%L94:
	dpb 10,3
	move 3,[POINT 6,gd_bss_u6,5]
	move 4,11
	jumple 11,%L96
%L95:
	ibp 3
	sojg 4,%L95	; decrement_and_branch_until_zero
%L96:
	jumpe 4,%L98
%L97:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L97
%L98:
	dpb 2,3
	move 3,[POINT 7,gd_bss_c7,6]
	move 4,11
	jumple 11,%L100
%L99:
	ibp 3
	sojg 4,%L99	; decrement_and_branch_until_zero
%L100:
	jumpe 4,%L102
%L101:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L101
%L102:
	dpb 1,3
	move 3,[POINT 7,gd_bss_u7,6]
	move 4,11
	jumple 11,%L104
%L103:
	ibp 3
	sojg 4,%L103	; decrement_and_branch_until_zero
%L104:
	jumpe 4,%L106
%L105:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L105
%L106:
	dpb 6,3
	move 2,11
	andi 2,3
	move 4,2
	move 1,11
	ash 1,-2	; ashrsi3_pointer
	move 3,1
	add 3,[POINT 8,gd_bss_c8,7]
	jumpe 2,%L108
%L107:
	ibp 3
	sojn 4,%L107	; decrement_and_branch_until_zero
%L108:
	dpb 7,3
	move 4,2
	move 3,1
	add 3,[POINT 8,gd_bss_u8,7]
	jumpe 2,%L110
%L109:
	ibp 3
	sojn 4,%L109	; decrement_and_branch_until_zero
%L110:
	dpb 5,3
	move 4,2
	move 3,1
	add 3,[POINT 9,gd_bss_c9,8]
	jumpe 2,%L112
%L111:
	ibp 3
	sojn 4,%L111	; decrement_and_branch_until_zero
%L112:
	dpb 13,3
	move 3,1
	add 3,[POINT 9,gd_bss_u9,8]
	skipn 4,2
	jrst %L114
%L113:
	ibp 3
	sojn 4,%L113	; decrement_and_branch_until_zero
%L114:
	dpb 14,3
	move 1,12
	pushj 17,idx5
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,gd_bss_s16,17]
	jumpe 4,%L116
%L115:
	ibp 1
	sojn 4,%L115	; decrement_and_branch_until_zero
%L116:
	dpb 15,1	; movhi
	move 1,12
	pushj 17,idx5
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,gd_bss_u16,17]
	jumpe 4,%L118
%L117:
	ibp 1
	sojn 4,%L117	; decrement_and_branch_until_zero
%L118:
	addi 10,11
	dpb 10,1	; movhi
	subi 10,11
	move 1,12
	pushj 17,idx5
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,gd_bss_s18,17]
	jumpe 4,%L120
%L119:
	ibp 1
	sojn 4,%L119	; decrement_and_branch_until_zero
%L120:
	addi 10,12
	dpb 10,1	; movhi
	subi 10,12
	move 1,12
	pushj 17,idx5
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,gd_bss_u18,17]
	jumpe 4,%L122
%L121:
	ibp 1
	sojn 4,%L121	; decrement_and_branch_until_zero
%L122:
	addi 10,13
	dpb 10,1	; movhi
	subi 10,13
	move 6,10
	addi 6,14
	movem 6,gd_bss_sarr(11)
	move 4,[252525252526]
	mul 4,11
	ashc 4,-44
	move 12,11
	ash 12,-43
	move 4,5
	sub 4,12
	move 7,4
	lsh 7,1
	add 7,4
	move 6,11
	sub 6,7
	move 7,6
	lsh 7,1
	move 3,10
	ash 3,-43
	move 4,3
	move 3,10
	addi 3,15
	move 1,3
	tlc 1,400000
	move 6,10
	tlc 6,400000
	caml 1,6
	tdza 1,1
	movei 1,1
	add 1,4
	movem 1,gd_bss_darr(7)
	movem 3,gd_bss_darr+1(7)
	move 6,10
	addi 6,16
	movem 6,gd_bss_struct+2
	addi 10,17
	dpb 10,[POINT 9,gd_bss_bytes+1,35]
	subi 10,17
	move 4,[314631463147]
	mul 4,11
	ashc 4,-44
	move 3,5
	ash 3,-1
	sub 3,12
	move 4,3
	lsh 4,2
	add 4,3
	move 6,11
	sub 6,4
	move 4,6
	move 3,6
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 4,[POINT 18,gd_bss_packed+3,17]
	jumpe 3,%L124
%L123:
	ibp 4
	sojn 3,%L123	; decrement_and_branch_until_zero
%L124:
	addi 10,20
	dpb 10,4
	move 2,10
	addi 2,1
	movem 2,gd_bss_union
	move 1,gpbs
	add 1,gd_bss_sint
	add 1,gd_bss_sarr(11)
	move 4,[252525252526]
	mul 4,11
	ashc 4,-44
	move 4,5
	sub 4,12
	move 3,4
	lsh 3,1
	add 3,4
	move 4,11
	sub 4,3
	lsh 4,1
	add 1,gd_bss_darr+1(4)
	add 1,2
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

global_data_update_init:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	pushj 17,idx8
	addm 10,gd_data_sint
	addm 11,gd_data_usint
	addm 10,gd_init_sarr(1)
	move 4,gd_part_sarr(1)
	sub 4,10
	movem 4,gd_part_sarr(1)
	move 6,1
	andi 6,3
	move 4,6
	move 7,1
	ash 7,-2	; ashrsi3_pointer
	move 2,7
	add 2,[POINT 9,gd_msg,8]
	jumpe 6,%L127
%L126:
	ibp 2
	sojn 4,%L126	; decrement_and_branch_until_zero
%L127:
	move 4,6
	move 3,7
	add 3,[POINT 9,gd_msg,8]
	jumpe 6,%L129
%L128:
	ibp 3
	sojn 4,%L128	; decrement_and_branch_until_zero
%L129:
	ldb 4,3
	addi 4,1
	dpb 4,2
	move 4,6
	move 2,7
	add 2,[POINT 9,gd_raw_chars,8]
	jumpe 6,%L131
%L130:
	ibp 2
	sojn 4,%L130	; decrement_and_branch_until_zero
%L131:
	move 4,6
	move 3,7
	add 3,[POINT 9,gd_raw_chars,8]
	jumpe 6,%L133
%L132:
	ibp 3
	sojn 4,%L132	; decrement_and_branch_until_zero
%L133:
	ldb 4,3
	xori 4,177
	dpb 4,2
	move 4,6
	move 2,7
	add 2,[POINT 9,gd_u9,8]
	jumpe 6,%L135
%L134:
	ibp 2
	sojn 4,%L134	; decrement_and_branch_until_zero
%L135:
	move 3,7
	add 3,[POINT 9,gd_u9,8]
	skipn 4,6
	jrst %L137
%L136:
	ibp 3
	sojn 4,%L136	; decrement_and_branch_until_zero
%L137:
	ldb 4,3
	addi 4,1
	dpb 4,2
	addm 10,gd_data_struct+2
	hlrz 4,gd_data_struct+1
	add 4,11
	hrlm 4,gd_data_struct+1
	hrrz 4,gd_data_bytes+3
	add 4,11
	hrrm 4,gd_data_bytes+3
	move 4,[252525252526]
	mul 4,1
	ashc 4,-44
	move 6,1
	ash 6,-43
	move 3,5
	sub 3,6
	move 4,3
	lsh 4,1
	add 4,3
	move 7,1
	sub 7,4
	move 4,7
	move 3,7
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 4,[POINT 18,gd_data_packed,17]
	jumpe 3,%L139
%L138:
	ibp 4
	sojn 3,%L138	; decrement_and_branch_until_zero
%L139:
	addi 4,5
	dpb 10,4	; movhi
	movem 10,gd_data_union_sc+2
	move 4,gd_v_sint
	add 4,10
	movem 4,gd_v_sint
	move 2,gd_data_sint
	add 2,gd_data_struct+2
	add 2,10
	move 4,[252525252526]
	mul 4,1
	ashc 4,-44
	move 4,5
	sub 4,6
	move 3,4
	lsh 3,1
	add 3,4
	move 4,1
	sub 4,3
	move 3,4
	andi 3,1
	move 1,4
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,gd_data_packed,17]
	jumpe 3,%L141
%L140:
	ibp 1
	sojn 3,%L140	; decrement_and_branch_until_zero
%L141:
	hlre 4,5(1)
	add 2,4
	move 1,2
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
ls_bss%0:
	.space	4
	.data
	.align	2
ls_data%1:
	.long	83
	.align	2
ls_msg%2:
	.word	154157143141
	.word	154000000000
	.align	2
ls_u9%3:
	.word	1776777

global_data_local_static:
	move 5,1
	andi 5,3
	move 4,1
	addb 4,ls_bss%0
	addm 4,ls_data%1
	move 7,5
	move 4,5
	ash 7,-2	; ashrsi3_pointer
	move 2,7
	add 2,[POINT 9,ls_msg%2,8]
	jumpe 5,%L144
%L143:
	ibp 2
	sojn 4,%L143	; decrement_and_branch_until_zero
%L144:
	move 6,5
	andi 6,3
	move 4,6
	move 3,7
	add 3,[POINT 9,ls_msg%2,8]
	jumpe 6,%L146
%L145:
	ibp 3
	sojn 4,%L145	; decrement_and_branch_until_zero
%L146:
	ldb 4,3
	addi 4,1
	dpb 4,2
	move 4,6
	move 2,7
	add 2,[POINT 9,ls_u9%3,8]
	jumpe 6,%L148
%L147:
	ibp 2
	sojn 4,%L147	; decrement_and_branch_until_zero
%L148:
	move 4,6
	move 3,7
	add 3,[POINT 9,ls_u9%3,8]
	jumpe 6,%L150
%L149:
	ibp 3
	sojn 4,%L149	; decrement_and_branch_until_zero
%L150:
	ldb 4,3
	addi 4,1
	dpb 4,2
	move 3,ls_bss%0
	add 3,ls_data%1
	move 1,7
	add 1,[POINT 9,ls_msg%2,8]
	skipn 4,6
	jrst %L152
%L151:
	ibp 1
	sojn 4,%L151	; decrement_and_branch_until_zero
%L152:
	ldb 1,1
	add 1,3
	move 3,7
	add 3,[POINT 9,ls_u9%3,8]
	skipn 4,5
	jrst %L154
%L153:
	ibp 3
	sojn 4,%L153	; decrement_and_branch_until_zero
%L154:
	ldb 3,3
	add 1,3
	popj 17,

global_data_mix:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 12,2
	pushj 17,global_data_read_scalars
	move 10,1
	move 1,11
	pushj 17,global_data_read_bytes
	add 10,1
	move 1,11
	pushj 17,global_data_read_structs
	add 10,1
	move 1,11
	pushj 17,global_data_use_pointers
	add 10,1
	move 1,11
	move 2,12
	pushj 17,global_data_write_bss
	add 10,1
	move 1,11
	move 2,12
	pushj 17,global_data_update_init
	add 10,1
	move 1,11
	pushj 17,global_data_local_static
	add 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

	.comm	gpbs, 4
	.comm	gpbu, 4
	.comm	gpbc, 4
	.bss
gd_bss_sint:
	.space	4
gd_bss_usint:
	.space	4
gd_bss_qint:
	.space	4
gd_bss_uqint:
	.space	4
gd_bss_hint:
	.space	4
gd_bss_uhint:
	.space	4
gd_bss_char:
	.space	4
gd_bss_uchar:
	.space	4
gd_bss_c6:
	.space	12
gd_bss_u6:
	.space	12
gd_bss_c7:
	.space	12
gd_bss_u7:
	.space	12
gd_bss_c8:
	.space	12
gd_bss_u8:
	.space	12
gd_bss_c9:
	.space	12
gd_bss_u9:
	.space	12
gd_bss_s16:
	.space	12
gd_bss_u16:
	.space	12
gd_bss_s18:
	.space	12
gd_bss_u18:
	.space	12
gd_bss_sarr:
	.space	32
gd_bss_darr:
	.space	24
gd_bss_struct:
	.space	24
gd_bss_bytes:
	.space	16
gd_bss_packed:
	.space	28
gd_bss_union:
	.space	24
gd_data_union_sc:
	.space	24
