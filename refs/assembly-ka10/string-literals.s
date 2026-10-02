	.data
	.align	2
s_empty:
	.word	0
	.align	2
s_word:
	.word	104101111115
	.word	117116000000
	.align	2
s_adjacent:
	.word	120104120055
	.word	61060000000
	.align	2
s_embedded:
	.word	101000102000
	.word	103000000000
	.align	2
s_escapes:
	.word	12011015134
	.word	42000000000
	.align	2
s_octal9:
	.word	1177200
	.word	377400777000
	.align	2
s_long:
	.word	60061062063
	.word	64065066067
	.word	70071141142
	.word	143144145146
	.word	147150151152
	.word	153154155156
	.word	157160161162
	.word	163164165166
	.word	167170171172
	.word	101102103104
	.word	105106107110
	.word	111112113114
	.word	115116117120
	.word	121122123124
	.word	125126127130
	.word	131132000000
	.align	2
us_basic:
	.word	141142143000
	.word	144145146777
	.word	0
	.align	2
ss_basic:
	.word	141142143000
	.word	144145146377
	.word	0
	.align	2
qs_basic:
	.word	161151156164
	.word	154151164
	.word	145162141154
	.word	0
	.align	2
uqs_basic:
	.word	165161151156
	.word	164000154151
	.word	164145162141

	.word	154777000000
%LLC0:
	.data
	.word	0
	.align	2
p_empty:
	.long	%LLC0+29142024192

%LLC1:
	.word	167157162144
	.data
	.word	0
	.align	2
p_word:
	.long	%LLC1+29142024192

%LLC2:
	.word	154145146164
	.word	162151147
	.data
	.word	150164000000
	.align	2
p_embedded:
	.long	%LLC2+29142024192

%LLC3:
	.word	200377400
	.data
	.word	777000000000
	.align	2
p_octal9:
	.long	%LLC3+29142024192

%LLC4:
	.word	172145162157
	.word	0
%LLC5:
	.word	157156145000
	.word	164141151154
	.word	0
%LLC6:
	.word	164167157377
	.word	0
%LLC7:
	.word	164150162145
	.word	145400777000
	.data
	.align	2
p_table:
	.long	%LLC4+29142024192
	.long	%LLC5+29142024192
	.long	%LLC6+29142024192
	.long	%LLC7+29142024192

%LLC8:
	.word	163154157164
	.word	160157151
	.word	156164145162
	.data
	.word	0
	.align	2
slot:
	.long	%LLC8+29142024192
	.word	141162162141
	.space	2
	.word	171000165143
	.word	150141162777
	.space	1
	.word	161151156
	.word	164000170000
	.space	1
	.align	2
mutable_literal_buffer:
	.word	155165164141
	.word	142154145000
	.space	8

%LLC9:
	.word	166157154141
	.word	164151154145
	.word	160164162
	.data
	.word	0
	.align	2
volatile_literal_pointer:
	.long	%LLC9+29142024192

literal_sizeof_arrays:
	movei 1,63
	popj 17,

literal_sizeof_expr:
	movei 1,22
	popj 17,

literal_direct_index:
	movei 1,212
	popj 17,

literal_octal_index:
	movei 1,200
	popj 17,

literal_array_index:
	move 2,1
	move 6,1
	andi 6,3
	move 4,6
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,s_word,8]
	jumpe 6,%L17
%L16:
	ibp 3
	sojn 4,%L16	; decrement_and_branch_until_zero
%L17:
	ldb 3,3
	move 1,2
	andi 1,7
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,s_adjacent,8]
	skipn 4,6
	jrst %L19
%L18:
	ibp 1
	sojn 4,%L18	; decrement_and_branch_until_zero
%L19:
	ldb 1,1
	add 1,3
	move 3,2
	andi 3,5
	move 4,2
	andi 4,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,s_embedded,8]
	jumpe 4,%L21
%L20:
	ibp 3
	sojn 4,%L20	; decrement_and_branch_until_zero
%L21:
	ldb 3,3
	add 1,3
	andi 2,4
	ash 2,-2	; ashrsi3_pointer
	add 2,[POINT 9,s_escapes,8]
	ldb 2,2
	add 1,2
	popj 17,

literal_unsigned_arrays:
	move 2,1
	andi 1,7
	move 3,2
	andi 3,3
	move 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,us_basic,8]
	jumpe 3,%L26
%L25:
	ibp 1
	sojn 4,%L25	; decrement_and_branch_until_zero
%L26:
	ldb 6,1
	move 1,2
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,uqs_basic,8]
	skipn 4,3
	jrst %L28
%L27:
	ibp 1
	sojn 4,%L27	; decrement_and_branch_until_zero
%L28:
	ldb 1,1
	add 6,1
	move 1,6
	popj 17,

literal_signed_arrays:
	move 2,1
	andi 1,7
	move 3,2
	andi 3,3
	move 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,ss_basic,8]
	jumpe 3,%L31
%L30:
	ibp 1
	sojn 4,%L30	; decrement_and_branch_until_zero
%L31:
	ldb 6,1
	trne 6,400
	orcmi 6,777
	move 1,2
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,qs_basic,8]
	skipn 4,3
	jrst %L33
%L32:
	ibp 1
	sojn 4,%L32	; decrement_and_branch_until_zero
%L33:
	ldb 4,1
	trne 4,400
	orcmi 4,777
	add 6,4
	move 1,6
	popj 17,

literal_pointer_index:
	move 3,1
	move 4,1
	andi 4,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,p_word
	jumpe 4,%L37
%L36:
	ibp 1
	sojn 4,%L36	; decrement_and_branch_until_zero
%L37:
	ldb 2,1
	move 4,3
	andi 4,2
	move 1,3
	andi 1,12
	ash 1,-2	; ashrsi3_pointer
	add 1,p_embedded
	jumpe 4,%L40
%L39:
	ibp 1
	sojn 4,%L39	; decrement_and_branch_until_zero
%L40:
	ldb 1,1
	add 2,1
	ldb 6,p_empty
	add 2,6
	move 1,2
	popj 17,

literal_pointer_octal:
	move 2,p_octal9
	move 3,1
	andi 3,4
	ash 3,-2	; ashrsi3_pointer
	add 3,2
	aos 4,1
	andi 4,4
	ash 4,-2	; ashrsi3_pointer
	add 4,2
	ldb 4,4
	ldb 3,3
	add 4,3
	addi 1,1
	andi 1,4
	ash 1,-2	; ashrsi3_pointer
	add 2,1
	ldb 2,2
	add 4,2
	move 1,4
	popj 17,

literal_return_pointer:
	andi 1,3
	move 1,p_table(1)
	popj 17,

literal_table_index:
	push 17,10
	move 10,2
	pushj 17,literal_return_pointer
	move 4,10
	andi 4,3
	andi 10,7
	ash 10,-2	; ashrsi3_pointer
	add 1,10
	jumpe 4,%L55
%L54:
	ibp 1
	sojn 4,%L54	; decrement_and_branch_until_zero
%L55:
	ldb 1,1
	pop 17,10
	popj 17,

%LLC11:
	.word	156145147141
	.word	164151166145
	.word	0
%LLC10:
	.word	160157163151
	.word	164151166145
	.word	0
literal_cond_pointer:
	move 3,[POINT 9,%LLC11,8]
	jumpl 1,%L58
	move 3,[POINT 9,%LLC4,8]
	jumpe 1,%L58
	move 3,[POINT 9,%LLC10,8]
%L58:
	move 4,1
	andi 4,3
	andi 1,7
	ash 1,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L72
%L71:
	ibp 1
	sojn 4,%L71	; decrement_and_branch_until_zero
%L72:
	ldb 1,1
	popj 17,

literal_scan:
	move 2,1
	movei 1,0
%L74:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,2
	jumpe 4,%L79
%L78:
	ibp 3
	sojn 4,%L78	; decrement_and_branch_until_zero
%L79:
	ldb 3,3
	jumpe 3,%L81
	aoja 1,%L74
%L81:
	popj 17,

%LLC12:
	.word	154157143141
	.word	154000164141
	.word	151154000000
literal_scan_globals:
	push 17,10
	move 1,[POINT 9,s_empty,8]
	pushj 17,literal_scan
	move 10,1
	move 1,[POINT 9,s_word,8]
	pushj 17,literal_scan
	add 10,1
	move 1,[POINT 9,s_embedded,8]
	pushj 17,literal_scan
	add 10,1
	move 1,p_embedded
	pushj 17,literal_scan
	add 10,1
	move 1,[POINT 9,%LLC12,8]
	pushj 17,literal_scan
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

literal_sum:
	move 7,1
	setzb 1,6
	caml 1,2
	popj 17,
	subi 2,1
%L104:
	move 4,6
	andi 4,3
	move 3,6
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L100
%L99:
	ibp 3
	sojn 4,%L99	; decrement_and_branch_until_zero
%L100:
	ldb 3,3
	add 1,3
	addi 6,1
	sojge 2,%L104	; doloop_end
	popj 17,

literal_usum:
	move 7,1
	setzb 1,6
	caml 1,2
	popj 17,
	subi 2,1
%L116:
	move 4,6
	andi 4,3
	move 3,6
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L112
%L111:
	ibp 3
	sojn 4,%L111	; decrement_and_branch_until_zero
%L112:
	ldb 3,3
	add 1,3
	addi 6,1
	sojge 2,%L116	; doloop_end
	popj 17,

%LLC13:
	.word	141142143144
	.word	145146000000
%LLC14:
	.word	377400777000
literal_sum_cases:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 12,1
	andi 12,7
	move 1,[POINT 9,%LLC13,8]
	move 2,12
	pushj 17,literal_sum
	move 10,1
	move 2,11
	andi 2,77
	move 1,[POINT 9,s_long,8]
	pushj 17,literal_sum
	add 10,1
	move 1,[POINT 9,us_basic,8]
	move 2,12
	pushj 17,literal_usum
	add 10,1
	andi 11,3
	move 1,[POINT 9,%LLC14,8]
	move 2,11
	pushj 17,literal_usum
	add 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

%LLC15:
	.word	143157160171
	.word	164141151
	.word	154777000000
literal_copy_to_buffer:
	movei 5,0
	caml 5,2
	popj 17,
	subi 2,1
%L148:
	move 7,5
	andi 7,3
	move 3,7
	move 4,5
	ash 4,-2	; ashrsi3_pointer
	move 6,1
	add 6,4
	jumpe 7,%L141
%L140:
	ibp 6
	sojn 3,%L140	; decrement_and_branch_until_zero
%L141:
	add 4,[POINT 9,%LLC15,8]
	skipn 3,7
	jrst %L144
%L143:
	ibp 4
	sojn 3,%L143	; decrement_and_branch_until_zero
%L144:
	ldb 4,4
	dpb 4,6
	addi 5,1
	sojge 2,%L148	; doloop_end
	popj 17,

%LLC16:
	.word	130131132000
literal_mutable_store:
	dpb 1,[POINT 9,mutable_literal_buffer,8]
	move 4,1
	andi 4,3
	move 3,4
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,%LLC16,8]
	jumpe 4,%L151
%L150:
	ibp 3
	sojn 4,%L150	; decrement_and_branch_until_zero
%L151:
	ldb 3,3
	dpb 3,[POINT 9,mutable_literal_buffer,17]
	move 4,1
	andi 4,2
	andi 1,6
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,s_octal9,8]
	jumpe 4,%L153
%L152:
	ibp 1
	sojn 4,%L152	; decrement_and_branch_until_zero
%L153:
	ldb 1,1
	dpb 1,[POINT 9,mutable_literal_buffer,26]
	move 1,mutable_literal_buffer
	lsh 1,-33
	ldb 4,[POINT 9,mutable_literal_buffer,17]
	add 1,4
	ldb 4,[POINT 9,mutable_literal_buffer,26]
	add 1,4
	popj 17,

literal_struct_fields:
	move 6,1
	andi 6,7
	move 2,1
	andi 2,3
	move 4,2
	move 3,6
	ash 3,-2	; ashrsi3_pointer
	add 3,slot
	jumpe 2,%L157
%L156:
	ibp 3
	sojn 4,%L156	; decrement_and_branch_until_zero
%L157:
	ldb 1,3
	move 4,2
	move 3,6
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,slot,8]
	jumpe 2,%L160
%L159:
	ibp 3
	sojn 4,%L159	; decrement_and_branch_until_zero
%L160:
	addi 3,1
	ldb 3,3
	add 3,1
	move 4,2
	move 1,6
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,slot,8]
	jumpe 2,%L163
%L162:
	ibp 1
	sojn 4,%L162	; decrement_and_branch_until_zero
%L163:
	addi 1,3
	ldb 1,1
	add 3,1
	move 1,6
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,slot,8]
	skipn 4,2
	jrst %L166
%L165:
	ibp 1
	sojn 4,%L165	; decrement_and_branch_until_zero
%L166:
	addi 1,5
	ldb 4,1
	trne 4,400
	orcmi 4,777
	add 3,4
	move 1,3
	popj 17,

%LLC17:
	.word	177200377
	.word	400777000000
literal_store_volatile:
	move 3,volatile_literal_pointer
	move 4,1
	andi 4,14
	ash 4,-2	; ashrsi3_pointer
	add 3,4
	ldb 3,3
	hrrm 3,vchar_sink
	move 4,1
	andi 4,1
	andi 1,5
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,%LLC17,8]
	jumpe 4,%L172
%L171:
	ibp 1
	sojn 4,%L171	; decrement_and_branch_until_zero
%L172:
	ldb 1,1
	hrrm 1,vuchar_sink
	popj 17,

%LLC18:
	.word	141162147165
	.word	155145156164
	.word	164141151
	.word	154000000000
literal_pass_pointer:
	push 17,10
	move 10,1
	move 1,[POINT 9,%LLC18,8]
	pushj 17,use_char_pointer
	move 4,10
	andi 4,3
	move 3,4
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,s_word,8]
	jumpe 4,%L185
%L184:
	ibp 1
	sojn 3,%L184	; decrement_and_branch_until_zero
%L185:
	pushj 17,use_char_pointer
	move 4,10
	andi 4,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,us_basic,8]
	jumpe 4,%L193
%L192:
	ibp 1
	sojn 4,%L192	; decrement_and_branch_until_zero
%L193:
	pushj 17,use_uchar_pointer
	move 1,10
	aos 2,10
	pop 17,10
	jrst literal_table_index

literal_pointer_difference:
	move 4,[110000000004]
	move 5,[0]
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

literal_compare_bytes:
	move 4,1
	andi 4,4
	ash 4,-2	; ashrsi3_pointer
	add 4,p_octal9
	ldb 6,4
	addi 1,1
	andi 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,%LLC3,8]
	ldb 2,1
	move 3,6
	tlc 3,400000
	move 4,2
	tlc 4,400000
	seto 1,
	camge 3,4
	popj 17,
	camn 6,2
	tdza 1,1
	movei 1,1
	popj 17,

%LLC19:
	.word	163164141143
	.word	153000000000
literal_stack_array:
	add 17,[4,,4]
	movei 4,0
	movem 4,-3(17)
	move 6,1
	andi 6,5
	move 2,1
	andi 2,1
	move 4,2
	move 3,6
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,%LLC19,8]
	jumpe 2,%L209
%L208:
	ibp 3
	sojn 4,%L208	; decrement_and_branch_until_zero
%L209:
	ldb 3,3
	dpb 3,[POINT 9,-3(17),17]
	move 1,6
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,s_embedded,8]
	skipn 4,2
	jrst %L211
%L210:
	ibp 1
	sojn 4,%L210	; decrement_and_branch_until_zero
%L211:
	ldb 1,1
	dpb 1,[POINT 9,-3(17),26]
	movei 4,0
	movem 4,-1(17)
	movsi 6,777
	iorm 6,-1(17)
	movei 4,1
	dpb 4,[POINT 9,-1(17),26]
	move 1,-3(17)
	lsh 1,-33
	ldb 4,[POINT 9,-3(17),17]
	add 1,4
	ldb 4,[POINT 9,-3(17),26]
	add 1,4
	move 4,-1(17)
	lsh 4,-33
	add 1,4
	ldb 4,[POINT 9,-1(17),17]
	add 1,4
	addi 1,1
	add 17,[-4,,-4]
	popj 17,

	.globl	use_string_literals
use_string_literals:
	add 17,[7,,7]
	movem 10,-6(17)
	movem 11,-5(17)
	movem 12,-4(17)
	move 11,1
	movei 1,-3(17)
	tlo 1,331100
	move 12,11
	andi 12,17
	move 2,12
	pushj 17,literal_copy_to_buffer
	move 1,11
	pushj 17,literal_store_volatile
	pushj 17,literal_sizeof_arrays
	move 10,1
	pushj 17,literal_sizeof_expr
	add 10,1
	pushj 17,literal_direct_index
	add 10,1
	pushj 17,literal_octal_index
	add 10,1
	move 1,11
	pushj 17,literal_array_index
	add 10,1
	move 1,11
	pushj 17,literal_unsigned_arrays
	add 10,1
	move 1,11
	pushj 17,literal_signed_arrays
	add 10,1
	move 1,11
	pushj 17,literal_pointer_index
	add 10,1
	move 1,11
	pushj 17,literal_pointer_octal
	add 10,1
	move 2,11
	addi 2,1
	move 1,11
	pushj 17,literal_table_index
	add 10,1
	move 1,11
	pushj 17,literal_cond_pointer
	add 10,1
	pushj 17,literal_scan_globals
	add 10,1
	move 1,11
	pushj 17,literal_sum_cases
	add 10,1
	move 1,11
	pushj 17,literal_mutable_store
	add 10,1
	move 1,11
	pushj 17,literal_struct_fields
	add 10,1
	move 1,11
	pushj 17,literal_pass_pointer
	add 10,1
	pushj 17,literal_pointer_difference
	add 10,1
	move 1,11
	pushj 17,literal_compare_bytes
	add 10,1
	move 1,11
	pushj 17,literal_stack_array
	add 1,10
	movei 4,-3(17)
	tlo 4,331100
	andi 11,3
	ash 12,-2	; ashrsi3_pointer
	add 4,12
	jumpe 11,%L217
%L216:
	ibp 4
	sojn 11,%L216	; decrement_and_branch_until_zero
%L217:
	ldb 4,4
	add 1,4
	move 10,-6(17)
	move 11,-5(17)
	move 12,-4(17)
	add 17,[-7,,-7]
	popj 17,

	.bss
vchar_sink:
	.space	4
vuchar_sink:
	.space	4
