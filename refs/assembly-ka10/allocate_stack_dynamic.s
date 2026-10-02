
alloca_words:
	add 17,[3,,3]
	movem 16,-2(17)
	movem 10,-1(17)
	movem 11,(17)
	movei 16,-2(17)
	move 7,1
	movei 11,(17)
	move 4,7
	lsh 4,2
	addi 4,7
	ash 4,-2
	movei 3,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	hrrz 1,3
	move 10,2
	jumple 7,%L12
	move 6,1
	move 4,2
	move 2,7
	subi 2,1
%L13:
	movem 4,(6)
	addi 6,1
	add 10,4
	addi 4,1
	sojge 2,%L13	; doloop_end
%L12:
	move 2,7
	pushj 17,sink_words
	move 17,11
	move 1,10
	move 16,-2(17)
	move 10,-1(17)
	move 11,(17)
	add 17,[-3,,-3]
	popj 17,

alloca_words_bounded:
	add 17,[3,,3]
	movem 16,-2(17)
	movem 10,-1(17)
	movem 11,(17)
	movei 16,-2(17)
	move 7,1
	movei 11,(17)
	andi 7,17
	move 4,7
	lsh 4,2
	addi 4,13
	ash 4,-2
	movei 3,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	hrrz 1,3
	move 10,2
	jumpl 7,%L25
	move 6,1
	move 4,2
	move 2,7
%L26:
	movem 4,(6)
	addi 6,1
	add 10,4
	addi 4,1
	sojge 2,%L26	; doloop_end
%L25:
	aos 2,7
	pushj 17,sink_words
	move 17,11
	move 1,10
	move 16,-2(17)
	move 10,-1(17)
	move 11,(17)
	add 17,[-3,,-3]
	popj 17,

alloca_words_plus_one:
	add 17,[4,,4]
	movem 16,-3(17)
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	movei 16,-3(17)
	move 3,1
	movei 12,(17)
	move 4,3
	lsh 4,2
	addi 4,13
	ash 4,-2
	movei 10,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	movem 2,(10)
	move 11,10
	add 11,3
	add 2,3
	movem 2,(11)
	addi 3,1
	move 1,10
	move 2,3
	pushj 17,sink_words
	move 1,(10)
	add 1,(11)
	move 17,12
	move 16,-3(17)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-4,,-4]
	popj 17,

alloca_words_plus_three:
	add 17,[4,,4]
	movem 16,-3(17)
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	movei 16,-3(17)
	move 3,1
	movei 12,(17)
	move 4,3
	lsh 4,2
	addi 4,23
	ash 4,-2
	movei 10,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	movem 2,(10)
	move 11,10
	add 11,3
	add 2,3
	movem 2,2(11)
	addi 3,3
	move 1,10
	move 2,3
	pushj 17,sink_words
	move 1,(10)
	add 1,2(11)
	move 17,12
	move 16,-3(17)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-4,,-4]
	popj 17,

alloca_words_from_mem:
	add 17,[4,,4]
	movem 16,-3(17)
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	movei 16,-3(17)
	move 3,2
	movei 12,(17)
	move 2,(1)
	move 4,2
	lsh 4,2
	addi 4,7
	ash 4,-2
	movei 10,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	movem 3,(10)
	move 11,10
	add 11,2
	add 3,2
	movem 3,-1(11)
	move 1,10
	pushj 17,sink_words
	move 1,(10)
	add 1,-1(11)
	move 17,12
	move 16,-3(17)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-4,,-4]
	popj 17,

alloca_words_from_volatile:
	add 17,[4,,4]
	movem 16,-3(17)
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	movei 16,-3(17)
	move 3,2
	movei 12,(17)
	move 2,(1)
	move 4,2
	lsh 4,2
	addi 4,7
	ash 4,-2
	movei 10,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	movem 3,(10)
	move 11,10
	add 11,2
	add 3,2
	movem 3,-1(11)
	move 1,10
	pushj 17,sink_words
	move 1,(10)
	add 1,-1(11)
	move 17,12
	move 16,-3(17)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-4,,-4]
	popj 17,

alloca_chars:
	add 17,[5,,5]
	movem 16,-4(17)
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	movei 16,-4(17)
	move 12,1
	movei 13,(17)
	addi 12,6
	move 4,12
	iori 4,3
	subi 12,6
	ash 4,-2
	movei 1,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	tlo 1,331100
	move 11,2
	movei 10,0
	caml 10,12
	jrst %L62
	move 5,2
	move 7,12
	subi 7,1
%L63:
	move 2,10
	andi 2,3
	move 4,2
	move 6,10
	ash 6,-2	; ashrsi3_pointer
	move 3,1
	add 3,6
	jumpe 2,%L56
%L55:
	ibp 3
	sojn 4,%L55	; decrement_and_branch_until_zero
%L56:
	dpb 5,3
	move 3,1
	add 3,6
	skipn 4,2
	jrst %L59
%L58:
	ibp 3
	sojn 4,%L58	; decrement_and_branch_until_zero
%L59:
	ldb 3,3
	add 11,3
	addi 5,1
	addi 10,1
	sojge 7,%L63	; doloop_end
%L62:
	move 2,12
	pushj 17,sink_chars
	move 17,13
	move 1,11
	move 16,-4(17)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-5,,-5]
	popj 17,

alloca_chars_plus_one:
	add 17,[5,,5]
	movem 16,-4(17)
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	movei 16,-4(17)
	move 11,1
	movei 13,(17)
	addi 11,7
	move 4,11
	iori 4,3
	subi 11,7
	ash 4,-2
	movei 10,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	tlo 10,331100
	dpb 2,10
	move 12,11
	move 4,11
	andi 4,3
	ash 12,-2	; ashrsi3_pointer
	move 3,10
	add 3,12
	jumpe 4,%L69
%L68:
	ibp 3
	sojn 4,%L68	; decrement_and_branch_until_zero
%L69:
	add 2,11
	dpb 2,3
	move 2,11
	addi 2,1
	move 1,10
	pushj 17,sink_chars
	ldb 3,10
	move 1,11
	andi 1,3
	move 4,10
	add 4,12
	jumpe 1,%L72
%L71:
	ibp 4
	sojn 1,%L71	; decrement_and_branch_until_zero
%L72:
	ldb 4,4
	add 3,4
	move 17,13
	move 1,3
	move 16,-4(17)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-5,,-5]
	popj 17,

alloca_chars_plus_three:
	add 17,[6,,6]
	movem 16,-5(17)
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	movei 16,-5(17)
	move 10,1
	movei 14,(17)
	addi 10,11
	move 4,10
	iori 4,3
	subi 10,11
	ash 4,-2
	movei 11,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	tlo 11,331100
	dpb 2,11
	move 13,11
	ibp 13
	move 3,13
	ibp 3
	move 12,10
	move 4,10
	andi 4,3
	ash 12,-2	; ashrsi3_pointer
	add 3,12
	jumpe 4,%L78
%L77:
	ibp 3
	sojn 4,%L77	; decrement_and_branch_until_zero
%L78:
	add 2,10
	dpb 2,3
	move 2,10
	addi 2,3
	move 1,11
	pushj 17,sink_chars
	ldb 3,11
	move 4,13
	ibp 4
	move 1,10
	andi 1,3
	add 4,12
	jumpe 1,%L81
%L80:
	ibp 4
	sojn 1,%L80	; decrement_and_branch_until_zero
%L81:
	ldb 4,4
	add 3,4
	move 17,14
	move 1,3
	move 16,-5(17)
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-6,,-6]
	popj 17,

alloca_chars_plus_five:
	add 17,[6,,6]
	movem 16,-5(17)
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	movei 16,-5(17)
	move 10,1
	movei 14,(17)
	addi 10,13
	move 4,10
	iori 4,3
	subi 10,13
	ash 4,-2
	movei 11,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	tlo 11,331100
	dpb 2,11
	move 13,11
	addi 13,1
	move 12,10
	move 4,10
	andi 4,3
	ash 12,-2	; ashrsi3_pointer
	move 3,13
	add 3,12
	jumpe 4,%L87
%L86:
	ibp 3
	sojn 4,%L86	; decrement_and_branch_until_zero
%L87:
	add 2,10
	dpb 2,3
	move 2,10
	addi 2,5
	move 1,11
	pushj 17,sink_chars
	ldb 3,11
	move 1,10
	andi 1,3
	move 4,13
	add 4,12
	jumpe 1,%L90
%L89:
	ibp 4
	sojn 1,%L89	; decrement_and_branch_until_zero
%L90:
	ldb 4,4
	add 3,4
	move 17,14
	move 1,3
	move 16,-5(17)
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-6,,-6]
	popj 17,

alloca_chars_bounded:
	add 17,[5,,5]
	movem 16,-4(17)
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	movei 16,-4(17)
	move 10,1
	movei 13,(17)
	andi 10,77
	addi 10,7
	move 4,10
	iori 4,3
	subi 10,7
	ash 4,-2
	movei 11,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	tlo 11,331100
	move 12,2
	movei 1,0
	camle 1,10
	jrst %L106
	move 5,2
	move 7,10
%L107:
	move 2,1
	andi 2,3
	move 4,2
	move 6,1
	ash 6,-2	; ashrsi3_pointer
	move 3,11
	add 3,6
	jumpe 2,%L100
%L99:
	ibp 3
	sojn 4,%L99	; decrement_and_branch_until_zero
%L100:
	dpb 5,3
	move 3,11
	add 3,6
	skipn 4,2
	jrst %L103
%L102:
	ibp 3
	sojn 4,%L102	; decrement_and_branch_until_zero
%L103:
	ldb 3,3
	add 12,3
	addi 5,1
	addi 1,1
	sojge 7,%L107	; doloop_end
%L106:
	addi 10,1
	move 1,11
	move 2,10
	pushj 17,sink_chars
	move 17,13
	move 1,12
	move 16,-4(17)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-5,,-5]
	popj 17,

alloca_chars_from_mem:
	add 17,[5,,5]
	movem 16,-4(17)
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	movei 16,-4(17)
	movei 13,(17)
	move 10,(1)
	addi 10,6
	move 4,10
	iori 4,3
	subi 10,6
	ash 4,-2
	movei 11,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	tlo 11,331100
	dpb 2,11
	move 12,10
	move 3,10
	andi 3,3
	ash 12,-2	; ashrsi3_pointer
	move 4,11
	add 4,12
	jumpe 3,%L113
%L112:
	ibp 4
	sojn 3,%L112	; decrement_and_branch_until_zero
%L113:
	subi 4,1
	ibp 4
	ibp 4
	add 2,10
	idpb 2,4
	move 1,11
	move 2,10
	pushj 17,sink_chars
	ldb 3,11
	move 1,10
	andi 1,3
	move 4,11
	add 4,12
	jumpe 1,%L116
%L115:
	ibp 4
	sojn 1,%L115	; decrement_and_branch_until_zero
%L116:
	subi 4,1
	ibp 4
	ibp 4
	ildb 4,4
	add 3,4
	move 17,13
	move 1,3
	move 16,-4(17)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-5,,-5]
	popj 17,

alloca_native_char_units:
	add 17,[5,,5]
	movem 16,-4(17)
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	movei 16,-4(17)
	move 12,1
	movei 13,(17)
	andi 12,177
	addi 12,6
	move 4,12
	iori 4,3
	subi 12,6
	ash 4,-2
	movei 1,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	tlo 1,331100
	move 11,2
	movei 10,0
	caml 10,12
	jrst %L132
	move 5,2
	move 7,12
	subi 7,1
%L133:
	move 2,10
	andi 2,3
	move 4,2
	move 6,10
	ash 6,-2	; ashrsi3_pointer
	move 3,1
	add 3,6
	jumpe 2,%L126
%L125:
	ibp 3
	sojn 4,%L125	; decrement_and_branch_until_zero
%L126:
	dpb 5,3
	move 3,1
	add 3,6
	skipn 4,2
	jrst %L129
%L128:
	ibp 3
	sojn 4,%L128	; decrement_and_branch_until_zero
%L129:
	ldb 3,3
	add 11,3
	addi 5,1
	addi 10,1
	sojge 7,%L133	; doloop_end
%L132:
	move 2,12
	pushj 17,sink_chars
	move 17,13
	move 1,11
	move 16,-4(17)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-5,,-5]
	popj 17,

alloca_qint_dynamic:
	add 17,[4,,4]
	movem 16,-3(17)
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	movei 16,-3(17)
	movei 12,(17)
	andi 1,17
	addi 1,7
	move 4,1
	iori 4,3
	subi 1,7
	ash 4,-2
	movei 5,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	tlo 5,331100
	move 11,2
	movei 10,0
	camle 10,1
	jrst %L149
	move 7,2
%L150:
	move 2,10
	andi 2,3
	move 4,2
	move 6,10
	ash 6,-2	; ashrsi3_pointer
	move 3,5
	add 3,6
	jumpe 2,%L143
%L142:
	ibp 3
	sojn 4,%L142	; decrement_and_branch_until_zero
%L143:
	dpb 7,3
	move 3,5
	add 3,6
	skipn 4,2
	jrst %L146
%L145:
	ibp 3
	sojn 4,%L145	; decrement_and_branch_until_zero
%L146:
	ldb 4,3
	trne 4,400
	orcmi 4,777
	add 11,4
	addi 7,1
	addi 10,1
	sojge 1,%L150	; doloop_end
%L149:
	move 1,5
	pushj 17,sink_ptr
	move 17,12
	move 1,11
	move 16,-3(17)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-4,,-4]
	popj 17,

alloca_hint_dynamic:
	add 17,[4,,4]
	movem 16,-3(17)
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	movei 16,-3(17)
	movei 12,(17)
	andi 1,17
	move 4,1
	lsh 4,1
	addi 4,10
	iori 4,3
	ash 4,-2
	movei 5,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	tlo 5,331100
	tlc 5,3300
	tlz 5,110000
	move 11,2
	movei 10,0
	camle 10,1
	jrst %L166
	move 7,2
%L167:
	move 2,10
	andi 2,1
	move 4,2
	move 6,10
	ash 6,-1	; ashrsi3_pointer
	move 3,5
	add 3,6
	jumpe 2,%L160
%L159:
	ibp 3
	sojn 4,%L159	; decrement_and_branch_until_zero
%L160:
	dpb 7,3	; movhi
	move 3,5
	add 3,6
	skipn 4,2
	jrst %L163
%L162:
	ibp 3
	sojn 4,%L162	; decrement_and_branch_until_zero
%L163:
	ldb 4,3
	hrre 4,4
	add 11,4
	addi 7,1
	addi 10,1
	sojge 1,%L167	; doloop_end
%L166:
	move 1,5
	pushj 17,sink_ptr
	move 17,12
	move 1,11
	move 16,-3(17)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-4,,-4]
	popj 17,

alloca_expr_add:
	add 17,[6,,6]
	movem 16,-5(17)
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	movei 16,-5(17)
	move 10,1
	movei 14,(17)
	add 10,2
	andi 10,777
	addi 10,11
	move 4,10
	iori 4,3
	subi 10,11
	ash 4,-2
	movei 11,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	tlo 11,331100
	dpb 3,11
	move 13,11
	ibp 13
	move 2,13
	ibp 2
	move 12,10
	move 4,10
	andi 4,3
	ash 12,-2	; ashrsi3_pointer
	add 2,12
	jumpe 4,%L173
%L172:
	ibp 2
	sojn 4,%L172	; decrement_and_branch_until_zero
%L173:
	add 3,10
	dpb 3,2
	move 2,10
	addi 2,3
	move 1,11
	pushj 17,sink_chars
	ldb 3,11
	move 4,13
	ibp 4
	move 1,10
	andi 1,3
	add 4,12
	jumpe 1,%L176
%L175:
	ibp 4
	sojn 1,%L175	; decrement_and_branch_until_zero
%L176:
	ldb 4,4
	add 3,4
	move 17,14
	move 1,3
	move 16,-5(17)
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-6,,-6]
	popj 17,

alloca_expr_shift:
	add 17,[4,,4]
	movem 16,-3(17)
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	movei 16,-3(17)
	move 3,1
	movei 12,(17)
	lsh 3,1
	andi 3,17
	move 4,3
	lsh 4,2
	addi 4,13
	ash 4,-2
	movei 10,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	movem 2,(10)
	move 11,10
	add 11,3
	add 2,3
	movem 2,(11)
	addi 3,1
	move 1,10
	move 2,3
	pushj 17,sink_words
	move 1,(10)
	add 1,(11)
	move 17,12
	move 16,-3(17)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-4,,-4]
	popj 17,

alloca_expr_mul:
	add 17,[5,,5]
	movem 16,-4(17)
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	movei 16,-4(17)
	move 10,1
	movei 13,(17)
	imul 10,2
	andi 10,77
	addi 10,7
	move 4,10
	iori 4,3
	subi 10,7
	ash 4,-2
	movei 11,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	tlo 11,331100
	dpb 3,11
	move 12,10
	move 4,10
	andi 4,3
	ash 12,-2	; ashrsi3_pointer
	move 2,11
	add 2,12
	jumpe 4,%L187
%L186:
	ibp 2
	sojn 4,%L186	; decrement_and_branch_until_zero
%L187:
	add 3,10
	dpb 3,2
	move 2,10
	addi 2,1
	move 1,11
	pushj 17,sink_chars
	ldb 3,11
	move 1,10
	andi 1,3
	move 4,11
	add 4,12
	jumpe 1,%L190
%L189:
	ibp 4
	sojn 1,%L189	; decrement_and_branch_until_zero
%L190:
	ldb 4,4
	add 3,4
	move 17,13
	move 1,3
	move 16,-4(17)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-5,,-5]
	popj 17,

alloca_after_live_values:
	add 17,[5,,5]
	movem 16,-4(17)
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	movei 16,-4(17)
	move 3,1
	move 11,2
	movei 13,(17)
	move 2,11
	addi 2,1
	addi 11,2
	move 4,3
	lsh 4,2
	addi 4,7
	ash 4,-2
	movei 10,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	movem 2,(10)
	move 12,10
	add 12,3
	add 2,11
	movem 2,-1(12)
	move 1,10
	move 2,3
	pushj 17,sink_words
	move 1,(10)
	add 1,-1(12)
	add 1,11
	move 17,13
	move 16,-4(17)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-5,,-5]
	popj 17,

alloca_after_call:
	add 17,[6,,6]
	movem 16,-5(17)
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	movei 16,-5(17)
	move 11,1
	move 12,2
	movei 14,(17)
	move 1,12
	pushj 17,sink_int
	move 4,11
	lsh 4,2
	addi 4,7
	ash 4,-2
	movei 10,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	movem 12,(10)
	move 13,10
	add 13,11
	add 12,11
	movem 12,-1(13)
	move 1,10
	move 2,11
	pushj 17,sink_words
	move 1,(10)
	add 1,-1(13)
	move 17,14
	move 16,-5(17)
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-6,,-6]
	popj 17,

alloca_before_and_after_call:
	add 17,[7,,7]
	movem 16,-6(17)
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	movei 16,-6(17)
	move 12,1
	move 13,2
	movei 15,(17)
	move 10,12
	lsh 10,2
	move 4,10
	addi 4,7
	ash 4,-2
	movei 14,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	movem 13,(14)
	move 1,14
	move 2,12
	pushj 17,sink_words
	addi 10,13
	ash 10,-2
	movei 11,1(17)
	move 6,10
	hrl 6,10
	add 17,6
	move 6,13
	addi 6,1
	movem 6,(11)
	move 10,11
	add 10,12
	add 13,12
	movem 13,(10)
	addi 12,1
	move 1,11
	move 2,12
	pushj 17,sink_words
	move 1,(14)
	add 1,(11)
	add 1,(10)
	move 17,15
	move 16,-6(17)
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-7,,-7]
	popj 17,

alloca_two_blocks:
	add 17,[5,,5]
	movem 16,-4(17)
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	movei 16,-4(17)
	move 3,1
	move 12,2
	movei 13,(17)
	move 4,3
	lsh 4,2
	addi 4,7
	ash 4,-2
	movei 11,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	movem 3,(11)
	move 4,12
	lsh 4,2
	addi 4,7
	ash 4,-2
	movei 10,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	movem 12,(10)
	move 1,11
	move 2,3
	pushj 17,sink_words
	move 1,10
	move 2,12
	pushj 17,sink_words
	move 1,(11)
	add 1,(10)
	move 17,13
	move 16,-4(17)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-5,,-5]
	popj 17,

alloca_two_blocks_live:
	add 17,[6,,6]
	movem 16,-5(17)
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	movei 16,-5(17)
	move 6,1
	move 13,2
	move 11,3
	movei 14,(17)
	add 11,6
	move 4,6
	lsh 4,2
	addi 4,7
	ash 4,-2
	movei 12,1(17)
	move 7,4
	hrl 7,4
	add 17,7
	movem 11,(12)
	add 11,13
	move 4,13
	lsh 4,2
	addi 4,7
	ash 4,-2
	movei 10,1(17)
	move 7,4
	hrl 7,4
	add 17,7
	movem 11,(10)
	move 1,12
	move 2,6
	pushj 17,sink_words
	move 1,10
	move 2,13
	pushj 17,sink_words
	move 1,(12)
	add 1,(10)
	add 1,11
	move 17,14
	move 16,-5(17)
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-6,,-6]
	popj 17,

alloca_word_then_chars:
	add 17,[6,,6]
	movem 16,-5(17)
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	movei 16,-5(17)
	move 6,1
	move 11,2
	move 2,3
	movei 14,(17)
	move 4,6
	lsh 4,2
	addi 4,7
	ash 4,-2
	movei 3,1(17)
	move 7,4
	hrl 7,4
	add 17,7
	hrrz 13,3
	movem 2,(13)
	addi 11,7
	move 4,11
	iori 4,3
	subi 11,7
	ash 4,-2
	movei 10,1(17)
	move 7,4
	hrl 7,4
	add 17,7
	tlo 10,331100
	dpb 2,10
	move 12,11
	move 4,11
	andi 4,3
	ash 12,-2	; ashrsi3_pointer
	move 3,10
	add 3,12
	jumpe 4,%L225
%L224:
	ibp 3
	sojn 4,%L224	; decrement_and_branch_until_zero
%L225:
	add 2,11
	dpb 2,3
	move 1,13
	move 2,6
	pushj 17,sink_words
	move 2,11
	addi 2,1
	move 1,10
	pushj 17,sink_chars
	ldb 3,10
	add 3,(13)
	move 2,11
	andi 2,3
	move 1,10
	add 1,12
	jumpe 2,%L228
%L227:
	ibp 1
	sojn 2,%L227	; decrement_and_branch_until_zero
%L228:
	ldb 1,1
	add 3,1
	move 17,14
	move 1,3
	move 16,-5(17)
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-6,,-6]
	popj 17,

alloca_chars_then_word:
	add 17,[7,,7]
	movem 16,-6(17)
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	movei 16,-6(17)
	move 10,1
	move 14,2
	move 2,3
	movei 15,(17)
	addi 10,7
	move 4,10
	iori 4,3
	subi 10,7
	ash 4,-2
	movei 11,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	tlo 11,331100
	dpb 2,11
	move 13,10
	move 4,10
	andi 4,3
	ash 13,-2	; ashrsi3_pointer
	move 3,11
	add 3,13
	jumpe 4,%L234
%L233:
	ibp 3
	sojn 4,%L233	; decrement_and_branch_until_zero
%L234:
	move 4,2
	add 4,10
	dpb 4,3
	move 4,14
	lsh 4,2
	addi 4,7
	ash 4,-2
	movei 3,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	hrrz 12,3
	add 2,14
	movem 2,(12)
	move 2,10
	addi 2,1
	move 1,11
	pushj 17,sink_chars
	move 1,12
	move 2,14
	pushj 17,sink_words
	ldb 3,11
	move 1,10
	andi 1,3
	move 4,11
	add 4,13
	jumpe 1,%L239
%L238:
	ibp 4
	sojn 1,%L238	; decrement_and_branch_until_zero
%L239:
	ldb 4,4
	add 3,4
	add 3,(12)
	move 17,15
	move 1,3
	move 16,-6(17)
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-7,,-7]
	popj 17,

alloca_three_blocks:
	add 17,[7,,7]
	movem 16,-6(17)
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	movei 16,-6(17)
	move 6,1
	move 12,2
	move 14,3
	movei 15,(17)
	move 4,6
	lsh 4,2
	addi 4,7
	ash 4,-2
	movei 13,1(17)
	move 7,4
	hrl 7,4
	add 17,7
	move 4,12
	lsh 4,2
	addi 4,7
	ash 4,-2
	movei 11,1(17)
	move 7,4
	hrl 7,4
	add 17,7
	move 4,14
	lsh 4,2
	addi 4,7
	ash 4,-2
	movei 10,1(17)
	move 7,4
	hrl 7,4
	add 17,7
	movem 6,(13)
	movem 12,(11)
	movem 14,(10)
	move 1,13
	move 2,6
	pushj 17,sink_words
	move 1,11
	move 2,12
	pushj 17,sink_words
	move 1,10
	move 2,14
	pushj 17,sink_words
	move 1,(13)
	add 1,(11)
	add 1,(10)
	move 17,15
	move 16,-6(17)
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-7,,-7]
	popj 17,

alloca_branch:
	add 17,[5,,5]
	movem 16,-4(17)
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	movei 16,-4(17)
	move 12,2
	movei 13,(17)
	jumpn 1,%L262
	addi 12,7
	move 4,12
	iori 4,3
	subi 12,7
	ash 4,-2
	movei 10,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	tlo 10,331100
	dpb 3,10
	move 11,12
	move 4,12
	andi 4,3
	ash 11,-2	; ashrsi3_pointer
	move 2,10
	add 2,11
	jumpe 4,%L258
%L257:
	ibp 2
	sojn 4,%L257	; decrement_and_branch_until_zero
%L258:
	add 3,12
	dpb 3,2
	move 2,12
	addi 2,1
	move 1,10
	pushj 17,sink_chars
	ldb 4,10
	move 2,12
	andi 2,3
	move 1,10
	add 1,11
	jumpe 2,%L261
%L260:
	ibp 1
	sojn 2,%L260	; decrement_and_branch_until_zero
%L261:
	ldb 1,1
	add 1,4
%L247:
	move 17,13
	move 16,-4(17)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-5,,-5]
	popj 17,
%L262:
	move 4,12
	lsh 4,2
	addi 4,7
	ash 4,-2
	movei 10,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	movem 3,(10)
	move 11,10
	add 11,12
	add 3,12
	movem 3,-1(11)
	move 1,10
	move 2,12
	pushj 17,sink_words
	move 1,(10)
	add 1,-1(11)
	jrst %L247

alloca_branch_after_live:
	add 17,[5,,5]
	movem 16,-4(17)
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	movei 16,-4(17)
	move 12,3
	movei 13,(17)
	add 12,2
	jumpn 1,%L269
	move 1,12
	addi 1,3
%L263:
	move 17,13
	move 16,-4(17)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-5,,-5]
	popj 17,
%L269:
	move 4,2
	lsh 4,2
	addi 4,13
	ash 4,-2
	movei 10,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	movem 12,(10)
	move 11,10
	add 11,2
	move 6,12
	addi 6,1
	movem 6,(11)
	addi 2,1
	move 1,10
	pushj 17,sink_words
	move 1,(10)
	add 1,(11)
	add 1,12
	jrst %L263

alloca_loop_const_count:
	add 17,[7,,7]
	movem 16,-6(17)
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	movei 16,-6(17)
	move 14,2
	movei 15,(17)
	andi 1,7
	jumple 1,%L279
	move 13,14
	move 12,14
	move 11,1
%L277:
	movei 10,1(17)
	add 17,[3,,3]
	movem 12,(10)
	movem 13,1(10)
	move 1,10
	movei 2,2
	pushj 17,sink_words
	move 4,(10)
	add 4,1(10)
	add 14,4
	subi 13,1
	addi 12,1
	sojn 11,%L277	; decrement_and_branch_until_zero
%L279:
	move 17,15
	move 1,14
	move 16,-6(17)
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-7,,-7]
	popj 17,

alloca_loop_dynamic_count:
	add 17,[10,,10]
	movem 16,-7(17)
	movei 0,-6(17)
	hrli 0,10
	blt 0,-1(17)
	movei 16,-7(17)
	move 14,1
	move 13,2
	movem 17,7(16)
	andi 14,7
	move 15,13
	movei 12,0
	camge 12,14
	jrst %L289
%L291:
	move 17,7(16)
	move 1,13
	move 16,-7(17)
	movei 0,10
	hrli 0,-6(17)
	blt 0,15
	add 17,[-10,,-10]
	popj 17,
%L289:
	move 4,12
	lsh 4,2
	addi 4,13
	ash 4,-2
	movei 10,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	move 6,15
	add 6,12
	movem 6,(10)
	move 11,10
	add 11,12
	move 6,15
	sub 6,12
	movem 6,(11)
	addi 12,1
	move 1,10
	move 2,12
	pushj 17,sink_words
	move 4,(10)
	add 4,(11)
	add 13,4
	camge 12,14
	jrst %L289
	jrst %L291

alloca_loop_char_count:
	add 17,[11,,11]
	movem 16,-10(17)
	movei 0,-7(17)
	hrli 0,10
	blt 0,-2(17)
	movei 16,-10(17)
	move 15,1
	move 14,2
	movem 17,7(16)
	andi 15,7
	movem 14,10(16)
	movei 2,0
	caml 2,15
	jrst %L307
%L305:
	addi 2,7
	move 4,2
	iori 4,3
	subi 2,7
	ash 4,-2
	movei 10,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	tlo 10,331100
	move 4,10(16)
	add 4,2
	dpb 4,10
	move 11,2
	andi 11,3
	move 4,11
	move 13,2
	ash 13,-2	; ashrsi3_pointer
	move 3,10
	add 3,13
	jumpe 11,%L301
%L300:
	ibp 3
	sojn 4,%L300	; decrement_and_branch_until_zero
%L301:
	move 4,10(16)
	sub 4,2
	dpb 4,3
	move 12,2
	addi 12,1
	move 1,10
	move 2,12
	pushj 17,sink_chars
	ldb 3,10
	move 1,10
	add 1,13
	skipn 4,11
	jrst %L304
%L303:
	ibp 1
	sojn 4,%L303	; decrement_and_branch_until_zero
%L304:
	ldb 1,1
	add 3,1
	add 14,3
	move 2,12
	camge 12,15
	jrst %L305
%L307:
	move 17,7(16)
	move 1,14
	move 16,-10(17)
	movei 0,10
	hrli 0,-7(17)
	blt 0,15
	add 17,[-11,,-11]
	popj 17,

alloca_address_difference:
	add 17,[7,,7]
	movem 16,-6(17)
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	movei 16,-6(17)
	move 3,1
	movei 15,(17)
	addi 3,7
	move 4,3
	iori 4,3
	ash 4,-2
	movei 13,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	tlo 13,331100
	move 14,2
	addi 14,1
	addi 2,7
	iori 2,3
	ash 2,-2
	movei 12,1(17)
	move 6,2
	hrl 6,2
	add 17,6
	tlo 12,331100
	movei 4,1
	dpb 4,13
	movei 4,2
	dpb 4,12
	move 1,13
	subi 3,6
	move 2,3
	pushj 17,sink_chars
	move 1,12
	move 2,14
	pushj 17,sink_chars
	move 10,12
	sub 10,13
	muli 10,10
	move 1,11
	ash 1,-1
	add 1,%BADL9(10)
	move 17,15
	move 16,-6(17)
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-7,,-7]
	popj 17,

alloca_escape_pointer:
	add 17,[5,,5]
	movem 16,-4(17)
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	movei 16,-4(17)
	move 11,1
	movei 13,(17)
	move 4,11
	lsh 4,2
	addi 4,7
	ash 4,-2
	movei 10,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	movem 2,(10)
	move 12,10
	add 12,11
	add 2,11
	movem 2,-1(12)
	move 1,10
	pushj 17,sink_ptr
	move 1,10
	move 2,11
	pushj 17,sink_words
	move 1,(10)
	add 1,-1(12)
	move 17,13
	move 16,-4(17)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-5,,-5]
	popj 17,

alloca_dynamic_with_struct:
	add 17,[4,,4]
	movem 16,-3(17)
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	movei 16,-3(17)
	movei 12,(17)
	move 4,1
	lsh 4,3
	addi 4,7
	ash 4,-2
	movei 10,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	movem 2,(10)
	move 6,2
	addi 6,1
	movem 6,1(10)
	move 11,1
	lsh 11,1
	add 11,10
	add 2,1
	movem 2,-2(11)
	addi 2,1
	movem 2,-1(11)
	move 1,10
	pushj 17,sink_ptr
	move 1,(10)
	add 1,1(10)
	add 1,-2(11)
	add 1,-1(11)
	move 17,12
	move 16,-3(17)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-4,,-4]
	popj 17,

alloca_words_and_scalar_spills:
	add 17,[11,,11]
	movem 16,-10(17)
	movei 0,-7(17)
	hrli 0,10
	blt 0,-2(17)
	movei 16,-10(17)
	move 3,1
	move 11,2
	movem 17,7(16)
	move 13,11
	addi 13,1
	move 14,11
	addi 14,2
	move 15,11
	addi 15,3
	move 6,11
	addi 6,4
	movem 6,10(16)
	move 4,3
	lsh 4,2
	addi 4,7
	ash 4,-2
	movei 10,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	move 6,11
	add 6,13
	movem 6,(10)
	move 12,10
	add 12,3
	move 4,14
	add 4,15
	add 4,10(16)
	movem 4,-1(12)
	move 1,10
	move 2,3
	pushj 17,sink_words
	move 1,(10)
	add 1,-1(12)
	add 1,11
	add 1,13
	add 1,14
	add 1,15
	add 1,10(16)
	move 17,7(16)
	move 16,-10(17)
	movei 0,10
	hrli 0,-7(17)
	blt 0,15
	add 17,[-11,,-11]
	popj 17,

alloca_nested_call_arg:
	add 17,[4,,4]
	movem 16,-3(17)
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	movei 16,-3(17)
	move 3,1
	movei 12,(17)
	move 4,3
	lsh 4,2
	addi 4,7
	ash 4,-2
	movei 10,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	movem 2,(10)
	move 11,10
	add 11,3
	add 2,3
	movem 2,-1(11)
	move 1,10
	move 2,3
	pushj 17,sink_words
	move 1,(10)
	add 1,-1(11)
	pushj 17,sink_int
	move 1,(10)
	add 1,-1(11)
	move 17,12
	move 16,-3(17)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-4,,-4]
	popj 17,

alloca_small_runtime_rounding:
	add 17,[5,,5]
	movem 16,-4(17)
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	movei 16,-4(17)
	move 10,1
	movei 13,(17)
	andi 10,3
	addi 10,7
	move 4,10
	iori 4,3
	subi 10,7
	ash 4,-2
	movei 11,1(17)
	move 6,4
	hrl 6,4
	add 17,6
	tlo 11,331100
	dpb 2,11
	move 12,10
	move 4,10
	andi 4,3
	ash 12,-2	; ashrsi3_pointer
	move 3,11
	add 3,12
	jumpe 4,%L344
%L343:
	ibp 3
	sojn 4,%L343	; decrement_and_branch_until_zero
%L344:
	add 2,10
	dpb 2,3
	move 2,10
	addi 2,1
	move 1,11
	pushj 17,sink_chars
	ldb 3,11
	move 1,10
	andi 1,3
	move 4,11
	add 4,12
	jumpe 1,%L347
%L346:
	ibp 4
	sojn 1,%L346	; decrement_and_branch_until_zero
%L347:
	ldb 4,4
	add 3,4
	move 17,13
	move 1,3
	move 16,-4(17)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-5,,-5]
	popj 17,

use_alloca_dynamic:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 13,1
	move 12,2
	pushj 17,alloca_words
	move 10,1
	move 11,13
	aos 1,11
	move 2,12
	pushj 17,alloca_chars
	add 10,1
	move 1,13
	move 2,11
	pushj 17,alloca_two_blocks
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

