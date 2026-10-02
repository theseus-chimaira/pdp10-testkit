
	.globl	stack_scalars_char_1
stack_scalars_char_1:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_scalars_char_2
stack_scalars_char_2:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,2200
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_char_3
stack_scalars_char_3:
	add 17,[3,,3]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-2(17)
	tlo 1,2200
	movei 2,-1(17)
	tlo 2,2200
	movei 3,(17)
	tlo 3,2200
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_char_4
stack_scalars_char_4:
	add 17,[4,,4]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-3(17)
	tlo 1,2200
	movei 2,-2(17)
	tlo 2,2200
	movei 3,-1(17)
	tlo 3,2200
	movei 4,(17)
	tlo 4,2200
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_char_5
stack_scalars_char_5:
	add 17,[6,,6]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-5(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-4(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 1,-5(17)
	tlo 1,2200
	movei 2,-4(17)
	tlo 2,2200
	movei 3,-3(17)
	tlo 3,2200
	movei 4,-2(17)
	tlo 4,2200
	movei 6,-1(17)
	tlo 6,2200
	movem 6,(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_char_1
stack_array_char_1:
	add 17,[1,,1]
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,17
	dpb 1,4
	hrrz 1,17
	tlo 1,331100
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_char_2
stack_array_char_2:
	add 17,[1,,1]
	movei 2,0
	movei 6,(17)
	tlo 6,331100
%L51:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,6
	jumpe 4,%L50
%L49:
	ibp 3
	sojn 4,%L49	; decrement_and_branch_until_zero
%L50:
	dpb 1,3
	addi 1,1
	addi 2,1
	caig 2,1
	jrst %L51
	movei 1,(17)
	tlo 1,331100
	move 2,1
	ibp 2
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_char_3
stack_array_char_3:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,331100
	movei 6,2
%L75:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L65
%L64:
	ibp 3
	sojn 4,%L64	; decrement_and_branch_until_zero
%L65:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L75	; doloop_end
	movei 1,(17)
	tlo 1,331100
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_char_4
stack_array_char_4:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,331100
	movei 6,3
%L95:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L83
%L82:
	ibp 3
	sojn 4,%L82	; decrement_and_branch_until_zero
%L83:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L95	; doloop_end
	movei 1,(17)
	tlo 1,331100
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_char_5
stack_array_char_5:
	add 17,[3,,3]
	movei 2,0
	movei 7,-2(17)
	tlo 7,331100
	movei 6,4
%L112:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L103
%L102:
	ibp 3
	sojn 4,%L102	; decrement_and_branch_until_zero
%L103:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L112	; doloop_end
	movei 1,-2(17)
	tlo 1,331100
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	move 6,1
	addi 6,1
	movem 6,(17)
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_ptr_walk_char
stack_ptr_walk_char:
	add 17,[3,,3]
	movem 10,-2(17)
	movei 2,0
	movei 7,-1(17)
	tlo 7,331100
	movei 6,5
%L126:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L120
%L119:
	ibp 3
	sojn 4,%L119	; decrement_and_branch_until_zero
%L120:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L126	; doloop_end
	movei 10,-1(17)
	tlo 10,331100
	move 1,10
	addi 1,1
	ibp 1
	move 2,1
	subi 2,1
	ibp 2
	ibp 2
	ibp 2
	move 3,1
	subi 3,1
	ibp 3
	ibp 3
	move 4,1
	subi 4,2
	ibp 4
	ibp 4
	ibp 4
	pushj 17,bar
	move 2,10
	ibp 2
	move 3,2
	ibp 3
	ibp 3
	move 4,10
	addi 4,1
	ibp 4
	move 1,10
	pushj 17,bar
	move 10,-2(17)
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_struct_char
stack_struct_char:
	add 17,[3,,3]
	movem 1,-2(17)
	addi 1,1
	dpb 1,[POINT 9,-2(17),17]
	addi 1,1
	dpb 1,[POINT 9,-2(17),26]
	addi 1,1
	dpb 1,[POINT 9,-2(17),35]
	addi 1,1
	movem 1,-1(17)
	addi 1,1
	dpb 1,[POINT 9,-1(17),17]
	addi 1,1
	dpb 1,[POINT 9,-1(17),26]
	move 6,[POINT 9,2(<fp>),8]
	movem 6,(17)
	move 1,[POINT 9,<fp>,17]
	move 2,[POINT 9,<fp>,26]
	movei 3,POINT 9,<fp>,35
	move 4,[POINT 9,1(<fp>),8]
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_volatile_char
stack_volatile_char:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	movem 4,-1(17)
	addi 1,1
	movem 1,(17)
	addi 1,1
	dpb 1,[POINT 9,(17),17]
	addi 1,1
	dpb 1,[POINT 9,(17),26]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,331100
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_schar_1
stack_scalars_schar_1:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_scalars_schar_2
stack_scalars_schar_2:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,2200
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_schar_3
stack_scalars_schar_3:
	add 17,[3,,3]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-2(17)
	tlo 1,2200
	movei 2,-1(17)
	tlo 2,2200
	movei 3,(17)
	tlo 3,2200
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_schar_4
stack_scalars_schar_4:
	add 17,[4,,4]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-3(17)
	tlo 1,2200
	movei 2,-2(17)
	tlo 2,2200
	movei 3,-1(17)
	tlo 3,2200
	movei 4,(17)
	tlo 4,2200
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_schar_5
stack_scalars_schar_5:
	add 17,[6,,6]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-5(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-4(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 1,-5(17)
	tlo 1,2200
	movei 2,-4(17)
	tlo 2,2200
	movei 3,-3(17)
	tlo 3,2200
	movei 4,-2(17)
	tlo 4,2200
	movei 6,-1(17)
	tlo 6,2200
	movem 6,(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_schar_1
stack_array_schar_1:
	add 17,[1,,1]
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,17
	dpb 1,4
	hrrz 1,17
	tlo 1,331100
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_schar_2
stack_array_schar_2:
	add 17,[1,,1]
	movei 2,0
	movei 6,(17)
	tlo 6,331100
%L195:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,6
	jumpe 4,%L194
%L193:
	ibp 3
	sojn 4,%L193	; decrement_and_branch_until_zero
%L194:
	dpb 1,3
	addi 1,1
	addi 2,1
	caig 2,1
	jrst %L195
	movei 1,(17)
	tlo 1,331100
	move 2,1
	ibp 2
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_schar_3
stack_array_schar_3:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,331100
	movei 6,2
%L219:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L209
%L208:
	ibp 3
	sojn 4,%L208	; decrement_and_branch_until_zero
%L209:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L219	; doloop_end
	movei 1,(17)
	tlo 1,331100
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_schar_4
stack_array_schar_4:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,331100
	movei 6,3
%L239:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L227
%L226:
	ibp 3
	sojn 4,%L226	; decrement_and_branch_until_zero
%L227:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L239	; doloop_end
	movei 1,(17)
	tlo 1,331100
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_schar_5
stack_array_schar_5:
	add 17,[3,,3]
	movei 2,0
	movei 7,-2(17)
	tlo 7,331100
	movei 6,4
%L256:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L247
%L246:
	ibp 3
	sojn 4,%L246	; decrement_and_branch_until_zero
%L247:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L256	; doloop_end
	movei 1,-2(17)
	tlo 1,331100
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	move 6,1
	addi 6,1
	movem 6,(17)
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_ptr_walk_schar
stack_ptr_walk_schar:
	add 17,[3,,3]
	movem 10,-2(17)
	movei 2,0
	movei 7,-1(17)
	tlo 7,331100
	movei 6,5
%L270:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L264
%L263:
	ibp 3
	sojn 4,%L263	; decrement_and_branch_until_zero
%L264:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L270	; doloop_end
	movei 10,-1(17)
	tlo 10,331100
	move 1,10
	addi 1,1
	ibp 1
	move 2,1
	subi 2,1
	ibp 2
	ibp 2
	ibp 2
	move 3,1
	subi 3,1
	ibp 3
	ibp 3
	move 4,1
	subi 4,2
	ibp 4
	ibp 4
	ibp 4
	pushj 17,bar
	move 2,10
	ibp 2
	move 3,2
	ibp 3
	ibp 3
	move 4,10
	addi 4,1
	ibp 4
	move 1,10
	pushj 17,bar
	move 10,-2(17)
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_struct_schar
stack_struct_schar:
	add 17,[3,,3]
	movem 1,-2(17)
	addi 1,1
	dpb 1,[POINT 9,-2(17),17]
	addi 1,1
	dpb 1,[POINT 9,-2(17),26]
	addi 1,1
	dpb 1,[POINT 9,-2(17),35]
	addi 1,1
	movem 1,-1(17)
	addi 1,1
	dpb 1,[POINT 9,-1(17),17]
	addi 1,1
	dpb 1,[POINT 9,-1(17),26]
	move 6,[POINT 9,2(<fp>),8]
	movem 6,(17)
	move 1,[POINT 9,<fp>,17]
	move 2,[POINT 9,<fp>,26]
	movei 3,POINT 9,<fp>,35
	move 4,[POINT 9,1(<fp>),8]
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_volatile_schar
stack_volatile_schar:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	movem 4,-1(17)
	addi 1,1
	movem 1,(17)
	addi 1,1
	dpb 1,[POINT 9,(17),17]
	addi 1,1
	dpb 1,[POINT 9,(17),26]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,331100
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_uchar_1
stack_scalars_uchar_1:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_scalars_uchar_2
stack_scalars_uchar_2:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,2200
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_uchar_3
stack_scalars_uchar_3:
	add 17,[3,,3]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-2(17)
	tlo 1,2200
	movei 2,-1(17)
	tlo 2,2200
	movei 3,(17)
	tlo 3,2200
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_uchar_4
stack_scalars_uchar_4:
	add 17,[4,,4]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-3(17)
	tlo 1,2200
	movei 2,-2(17)
	tlo 2,2200
	movei 3,-1(17)
	tlo 3,2200
	movei 4,(17)
	tlo 4,2200
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_uchar_5
stack_scalars_uchar_5:
	add 17,[6,,6]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-5(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-4(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 1,-5(17)
	tlo 1,2200
	movei 2,-4(17)
	tlo 2,2200
	movei 3,-3(17)
	tlo 3,2200
	movei 4,-2(17)
	tlo 4,2200
	movei 6,-1(17)
	tlo 6,2200
	movem 6,(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_uchar_1
stack_array_uchar_1:
	add 17,[1,,1]
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,17
	dpb 1,4
	hrrz 1,17
	tlo 1,331100
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uchar_2
stack_array_uchar_2:
	add 17,[1,,1]
	movei 2,0
	movei 6,(17)
	tlo 6,331100
%L339:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,6
	jumpe 4,%L338
%L337:
	ibp 3
	sojn 4,%L337	; decrement_and_branch_until_zero
%L338:
	dpb 1,3
	addi 1,1
	addi 2,1
	caig 2,1
	jrst %L339
	movei 1,(17)
	tlo 1,331100
	move 2,1
	ibp 2
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uchar_3
stack_array_uchar_3:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,331100
	movei 6,2
%L363:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L353
%L352:
	ibp 3
	sojn 4,%L352	; decrement_and_branch_until_zero
%L353:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L363	; doloop_end
	movei 1,(17)
	tlo 1,331100
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uchar_4
stack_array_uchar_4:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,331100
	movei 6,3
%L383:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L371
%L370:
	ibp 3
	sojn 4,%L370	; decrement_and_branch_until_zero
%L371:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L383	; doloop_end
	movei 1,(17)
	tlo 1,331100
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uchar_5
stack_array_uchar_5:
	add 17,[3,,3]
	movei 2,0
	movei 7,-2(17)
	tlo 7,331100
	movei 6,4
%L400:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L391
%L390:
	ibp 3
	sojn 4,%L390	; decrement_and_branch_until_zero
%L391:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L400	; doloop_end
	movei 1,-2(17)
	tlo 1,331100
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	move 6,1
	addi 6,1
	movem 6,(17)
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_ptr_walk_uchar
stack_ptr_walk_uchar:
	add 17,[3,,3]
	movem 10,-2(17)
	movei 2,0
	movei 7,-1(17)
	tlo 7,331100
	movei 6,5
%L414:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L408
%L407:
	ibp 3
	sojn 4,%L407	; decrement_and_branch_until_zero
%L408:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L414	; doloop_end
	movei 10,-1(17)
	tlo 10,331100
	move 1,10
	addi 1,1
	ibp 1
	move 2,1
	subi 2,1
	ibp 2
	ibp 2
	ibp 2
	move 3,1
	subi 3,1
	ibp 3
	ibp 3
	move 4,1
	subi 4,2
	ibp 4
	ibp 4
	ibp 4
	pushj 17,bar
	move 2,10
	ibp 2
	move 3,2
	ibp 3
	ibp 3
	move 4,10
	addi 4,1
	ibp 4
	move 1,10
	pushj 17,bar
	move 10,-2(17)
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_struct_uchar
stack_struct_uchar:
	add 17,[3,,3]
	movem 1,-2(17)
	addi 1,1
	dpb 1,[POINT 9,-2(17),17]
	addi 1,1
	dpb 1,[POINT 9,-2(17),26]
	addi 1,1
	dpb 1,[POINT 9,-2(17),35]
	addi 1,1
	movem 1,-1(17)
	addi 1,1
	dpb 1,[POINT 9,-1(17),17]
	addi 1,1
	dpb 1,[POINT 9,-1(17),26]
	move 6,[POINT 9,2(<fp>),8]
	movem 6,(17)
	move 1,[POINT 9,<fp>,17]
	move 2,[POINT 9,<fp>,26]
	movei 3,POINT 9,<fp>,35
	move 4,[POINT 9,1(<fp>),8]
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_volatile_uchar
stack_volatile_uchar:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	movem 4,-1(17)
	addi 1,1
	movem 1,(17)
	addi 1,1
	dpb 1,[POINT 9,(17),17]
	addi 1,1
	dpb 1,[POINT 9,(17),26]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,331100
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_Qint_1
stack_scalars_Qint_1:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_scalars_Qint_2
stack_scalars_Qint_2:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,2200
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_Qint_3
stack_scalars_Qint_3:
	add 17,[3,,3]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-2(17)
	tlo 1,2200
	movei 2,-1(17)
	tlo 2,2200
	movei 3,(17)
	tlo 3,2200
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_Qint_4
stack_scalars_Qint_4:
	add 17,[4,,4]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-3(17)
	tlo 1,2200
	movei 2,-2(17)
	tlo 2,2200
	movei 3,-1(17)
	tlo 3,2200
	movei 4,(17)
	tlo 4,2200
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_Qint_5
stack_scalars_Qint_5:
	add 17,[6,,6]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-5(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-4(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 1,-5(17)
	tlo 1,2200
	movei 2,-4(17)
	tlo 2,2200
	movei 3,-3(17)
	tlo 3,2200
	movei 4,-2(17)
	tlo 4,2200
	movei 6,-1(17)
	tlo 6,2200
	movem 6,(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_Qint_1
stack_array_Qint_1:
	add 17,[1,,1]
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,17
	dpb 1,4
	hrrz 1,17
	tlo 1,331100
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_Qint_2
stack_array_Qint_2:
	add 17,[1,,1]
	movei 2,0
	movei 6,(17)
	tlo 6,331100
%L483:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,6
	jumpe 4,%L482
%L481:
	ibp 3
	sojn 4,%L481	; decrement_and_branch_until_zero
%L482:
	dpb 1,3
	addi 1,1
	addi 2,1
	caig 2,1
	jrst %L483
	movei 1,(17)
	tlo 1,331100
	move 2,1
	ibp 2
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_Qint_3
stack_array_Qint_3:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,331100
	movei 6,2
%L507:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L497
%L496:
	ibp 3
	sojn 4,%L496	; decrement_and_branch_until_zero
%L497:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L507	; doloop_end
	movei 1,(17)
	tlo 1,331100
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_Qint_4
stack_array_Qint_4:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,331100
	movei 6,3
%L527:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L515
%L514:
	ibp 3
	sojn 4,%L514	; decrement_and_branch_until_zero
%L515:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L527	; doloop_end
	movei 1,(17)
	tlo 1,331100
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_Qint_5
stack_array_Qint_5:
	add 17,[3,,3]
	movei 2,0
	movei 7,-2(17)
	tlo 7,331100
	movei 6,4
%L544:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L535
%L534:
	ibp 3
	sojn 4,%L534	; decrement_and_branch_until_zero
%L535:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L544	; doloop_end
	movei 1,-2(17)
	tlo 1,331100
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	move 6,1
	addi 6,1
	movem 6,(17)
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_ptr_walk_Qint
stack_ptr_walk_Qint:
	add 17,[3,,3]
	movem 10,-2(17)
	movei 2,0
	movei 7,-1(17)
	tlo 7,331100
	movei 6,5
%L558:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L552
%L551:
	ibp 3
	sojn 4,%L551	; decrement_and_branch_until_zero
%L552:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L558	; doloop_end
	movei 10,-1(17)
	tlo 10,331100
	move 1,10
	addi 1,1
	ibp 1
	move 2,1
	subi 2,1
	ibp 2
	ibp 2
	ibp 2
	move 3,1
	subi 3,1
	ibp 3
	ibp 3
	move 4,1
	subi 4,2
	ibp 4
	ibp 4
	ibp 4
	pushj 17,bar
	move 2,10
	ibp 2
	move 3,2
	ibp 3
	ibp 3
	move 4,10
	addi 4,1
	ibp 4
	move 1,10
	pushj 17,bar
	move 10,-2(17)
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_struct_Qint
stack_struct_Qint:
	add 17,[3,,3]
	movem 1,-2(17)
	addi 1,1
	dpb 1,[POINT 9,-2(17),17]
	addi 1,1
	dpb 1,[POINT 9,-2(17),26]
	addi 1,1
	dpb 1,[POINT 9,-2(17),35]
	addi 1,1
	movem 1,-1(17)
	addi 1,1
	dpb 1,[POINT 9,-1(17),17]
	addi 1,1
	dpb 1,[POINT 9,-1(17),26]
	move 6,[POINT 9,2(<fp>),8]
	movem 6,(17)
	move 1,[POINT 9,<fp>,17]
	move 2,[POINT 9,<fp>,26]
	movei 3,POINT 9,<fp>,35
	move 4,[POINT 9,1(<fp>),8]
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_volatile_Qint
stack_volatile_Qint:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	movem 4,-1(17)
	addi 1,1
	movem 1,(17)
	addi 1,1
	dpb 1,[POINT 9,(17),17]
	addi 1,1
	dpb 1,[POINT 9,(17),26]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,331100
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_sQint_1
stack_scalars_sQint_1:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_scalars_sQint_2
stack_scalars_sQint_2:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,2200
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_sQint_3
stack_scalars_sQint_3:
	add 17,[3,,3]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-2(17)
	tlo 1,2200
	movei 2,-1(17)
	tlo 2,2200
	movei 3,(17)
	tlo 3,2200
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_sQint_4
stack_scalars_sQint_4:
	add 17,[4,,4]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-3(17)
	tlo 1,2200
	movei 2,-2(17)
	tlo 2,2200
	movei 3,-1(17)
	tlo 3,2200
	movei 4,(17)
	tlo 4,2200
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_sQint_5
stack_scalars_sQint_5:
	add 17,[6,,6]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-5(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-4(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 1,-5(17)
	tlo 1,2200
	movei 2,-4(17)
	tlo 2,2200
	movei 3,-3(17)
	tlo 3,2200
	movei 4,-2(17)
	tlo 4,2200
	movei 6,-1(17)
	tlo 6,2200
	movem 6,(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_sQint_1
stack_array_sQint_1:
	add 17,[1,,1]
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,17
	dpb 1,4
	hrrz 1,17
	tlo 1,331100
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_sQint_2
stack_array_sQint_2:
	add 17,[1,,1]
	movei 2,0
	movei 6,(17)
	tlo 6,331100
%L627:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,6
	jumpe 4,%L626
%L625:
	ibp 3
	sojn 4,%L625	; decrement_and_branch_until_zero
%L626:
	dpb 1,3
	addi 1,1
	addi 2,1
	caig 2,1
	jrst %L627
	movei 1,(17)
	tlo 1,331100
	move 2,1
	ibp 2
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_sQint_3
stack_array_sQint_3:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,331100
	movei 6,2
%L651:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L641
%L640:
	ibp 3
	sojn 4,%L640	; decrement_and_branch_until_zero
%L641:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L651	; doloop_end
	movei 1,(17)
	tlo 1,331100
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_sQint_4
stack_array_sQint_4:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,331100
	movei 6,3
%L671:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L659
%L658:
	ibp 3
	sojn 4,%L658	; decrement_and_branch_until_zero
%L659:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L671	; doloop_end
	movei 1,(17)
	tlo 1,331100
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_sQint_5
stack_array_sQint_5:
	add 17,[3,,3]
	movei 2,0
	movei 7,-2(17)
	tlo 7,331100
	movei 6,4
%L688:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L679
%L678:
	ibp 3
	sojn 4,%L678	; decrement_and_branch_until_zero
%L679:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L688	; doloop_end
	movei 1,-2(17)
	tlo 1,331100
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	move 6,1
	addi 6,1
	movem 6,(17)
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_ptr_walk_sQint
stack_ptr_walk_sQint:
	add 17,[3,,3]
	movem 10,-2(17)
	movei 2,0
	movei 7,-1(17)
	tlo 7,331100
	movei 6,5
%L702:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L696
%L695:
	ibp 3
	sojn 4,%L695	; decrement_and_branch_until_zero
%L696:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L702	; doloop_end
	movei 10,-1(17)
	tlo 10,331100
	move 1,10
	addi 1,1
	ibp 1
	move 2,1
	subi 2,1
	ibp 2
	ibp 2
	ibp 2
	move 3,1
	subi 3,1
	ibp 3
	ibp 3
	move 4,1
	subi 4,2
	ibp 4
	ibp 4
	ibp 4
	pushj 17,bar
	move 2,10
	ibp 2
	move 3,2
	ibp 3
	ibp 3
	move 4,10
	addi 4,1
	ibp 4
	move 1,10
	pushj 17,bar
	move 10,-2(17)
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_struct_sQint
stack_struct_sQint:
	add 17,[3,,3]
	movem 1,-2(17)
	addi 1,1
	dpb 1,[POINT 9,-2(17),17]
	addi 1,1
	dpb 1,[POINT 9,-2(17),26]
	addi 1,1
	dpb 1,[POINT 9,-2(17),35]
	addi 1,1
	movem 1,-1(17)
	addi 1,1
	dpb 1,[POINT 9,-1(17),17]
	addi 1,1
	dpb 1,[POINT 9,-1(17),26]
	move 6,[POINT 9,2(<fp>),8]
	movem 6,(17)
	move 1,[POINT 9,<fp>,17]
	move 2,[POINT 9,<fp>,26]
	movei 3,POINT 9,<fp>,35
	move 4,[POINT 9,1(<fp>),8]
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_volatile_sQint
stack_volatile_sQint:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	movem 4,-1(17)
	addi 1,1
	movem 1,(17)
	addi 1,1
	dpb 1,[POINT 9,(17),17]
	addi 1,1
	dpb 1,[POINT 9,(17),26]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,331100
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_uQint_1
stack_scalars_uQint_1:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_scalars_uQint_2
stack_scalars_uQint_2:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,2200
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_uQint_3
stack_scalars_uQint_3:
	add 17,[3,,3]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-2(17)
	tlo 1,2200
	movei 2,-1(17)
	tlo 2,2200
	movei 3,(17)
	tlo 3,2200
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_uQint_4
stack_scalars_uQint_4:
	add 17,[4,,4]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-3(17)
	tlo 1,2200
	movei 2,-2(17)
	tlo 2,2200
	movei 3,-1(17)
	tlo 3,2200
	movei 4,(17)
	tlo 4,2200
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_uQint_5
stack_scalars_uQint_5:
	add 17,[6,,6]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-5(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-4(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 1,-5(17)
	tlo 1,2200
	movei 2,-4(17)
	tlo 2,2200
	movei 3,-3(17)
	tlo 3,2200
	movei 4,-2(17)
	tlo 4,2200
	movei 6,-1(17)
	tlo 6,2200
	movem 6,(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_uQint_1
stack_array_uQint_1:
	add 17,[1,,1]
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,17
	dpb 1,4
	hrrz 1,17
	tlo 1,331100
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uQint_2
stack_array_uQint_2:
	add 17,[1,,1]
	movei 2,0
	movei 6,(17)
	tlo 6,331100
%L771:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,6
	jumpe 4,%L770
%L769:
	ibp 3
	sojn 4,%L769	; decrement_and_branch_until_zero
%L770:
	dpb 1,3
	addi 1,1
	addi 2,1
	caig 2,1
	jrst %L771
	movei 1,(17)
	tlo 1,331100
	move 2,1
	ibp 2
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uQint_3
stack_array_uQint_3:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,331100
	movei 6,2
%L795:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L785
%L784:
	ibp 3
	sojn 4,%L784	; decrement_and_branch_until_zero
%L785:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L795	; doloop_end
	movei 1,(17)
	tlo 1,331100
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uQint_4
stack_array_uQint_4:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,331100
	movei 6,3
%L815:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L803
%L802:
	ibp 3
	sojn 4,%L802	; decrement_and_branch_until_zero
%L803:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L815	; doloop_end
	movei 1,(17)
	tlo 1,331100
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uQint_5
stack_array_uQint_5:
	add 17,[3,,3]
	movei 2,0
	movei 7,-2(17)
	tlo 7,331100
	movei 6,4
%L832:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L823
%L822:
	ibp 3
	sojn 4,%L822	; decrement_and_branch_until_zero
%L823:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L832	; doloop_end
	movei 1,-2(17)
	tlo 1,331100
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	move 6,1
	addi 6,1
	movem 6,(17)
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_ptr_walk_uQint
stack_ptr_walk_uQint:
	add 17,[3,,3]
	movem 10,-2(17)
	movei 2,0
	movei 7,-1(17)
	tlo 7,331100
	movei 6,5
%L846:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L840
%L839:
	ibp 3
	sojn 4,%L839	; decrement_and_branch_until_zero
%L840:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L846	; doloop_end
	movei 10,-1(17)
	tlo 10,331100
	move 1,10
	addi 1,1
	ibp 1
	move 2,1
	subi 2,1
	ibp 2
	ibp 2
	ibp 2
	move 3,1
	subi 3,1
	ibp 3
	ibp 3
	move 4,1
	subi 4,2
	ibp 4
	ibp 4
	ibp 4
	pushj 17,bar
	move 2,10
	ibp 2
	move 3,2
	ibp 3
	ibp 3
	move 4,10
	addi 4,1
	ibp 4
	move 1,10
	pushj 17,bar
	move 10,-2(17)
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_struct_uQint
stack_struct_uQint:
	add 17,[3,,3]
	movem 1,-2(17)
	addi 1,1
	dpb 1,[POINT 9,-2(17),17]
	addi 1,1
	dpb 1,[POINT 9,-2(17),26]
	addi 1,1
	dpb 1,[POINT 9,-2(17),35]
	addi 1,1
	movem 1,-1(17)
	addi 1,1
	dpb 1,[POINT 9,-1(17),17]
	addi 1,1
	dpb 1,[POINT 9,-1(17),26]
	move 6,[POINT 9,2(<fp>),8]
	movem 6,(17)
	move 1,[POINT 9,<fp>,17]
	move 2,[POINT 9,<fp>,26]
	movei 3,POINT 9,<fp>,35
	move 4,[POINT 9,1(<fp>),8]
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_volatile_uQint
stack_volatile_uQint:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	movem 4,-1(17)
	addi 1,1
	movem 1,(17)
	addi 1,1
	dpb 1,[POINT 9,(17),17]
	addi 1,1
	dpb 1,[POINT 9,(17),26]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,331100
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_Hint_1
stack_scalars_Hint_1:
	add 17,[1,,1]
	hrrm 1,(17)
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_scalars_Hint_2
stack_scalars_Hint_2:
	add 17,[2,,2]
	hrrm 1,-1(17)
	movei 1,1(1)
	hrrm 1,(17)
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,2200
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_Hint_3
stack_scalars_Hint_3:
	add 17,[3,,3]
	hrrm 1,-2(17)
	movei 4,1(1)
	hrrm 4,-1(17)
	movei 1,2(1)
	hrrm 1,(17)
	movei 1,-2(17)
	tlo 1,2200
	movei 2,-1(17)
	tlo 2,2200
	movei 3,(17)
	tlo 3,2200
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_Hint_4
stack_scalars_Hint_4:
	add 17,[4,,4]
	hrrm 1,-3(17)
	movei 4,1(1)
	hrrm 4,-2(17)
	movei 4,2(1)
	hrrm 4,-1(17)
	movei 1,3(1)
	hrrm 1,(17)
	movei 1,-3(17)
	tlo 1,2200
	movei 2,-2(17)
	tlo 2,2200
	movei 3,-1(17)
	tlo 3,2200
	movei 4,(17)
	tlo 4,2200
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_Hint_5
stack_scalars_Hint_5:
	add 17,[6,,6]
	hrrm 1,-5(17)
	movei 4,1(1)
	hrrm 4,-4(17)
	movei 4,2(1)
	hrrm 4,-3(17)
	movei 4,3(1)
	hrrm 4,-2(17)
	movei 1,4(1)
	hrrm 1,-1(17)
	movei 1,-5(17)
	tlo 1,2200
	movei 2,-4(17)
	tlo 2,2200
	movei 3,-3(17)
	tlo 3,2200
	movei 4,-2(17)
	tlo 4,2200
	movei 6,-1(17)
	tlo 6,2200
	movem 6,(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_Hint_1
stack_array_Hint_1:
	add 17,[1,,1]
	movei 4,0
	ash 4,-1	; ashrsi3_pointer
	add 4,17
	dpb 1,4	; movhi
	hrrz 1,17
	tlo 1,222200
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_Hint_2
stack_array_Hint_2:
	add 17,[1,,1]
	movei 2,0
	movei 6,(17)
	tlo 6,222200
%L915:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,6
	jumpe 4,%L914
%L913:
	ibp 3
	sojn 4,%L913	; decrement_and_branch_until_zero
%L914:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	caig 2,1
	jrst %L915
	movei 1,(17)
	tlo 1,222200
	move 2,1
	ibp 2
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_Hint_3
stack_array_Hint_3:
	add 17,[2,,2]
	movei 2,0
	movei 7,-1(17)
	tlo 7,222200
	movei 6,2
%L939:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L929
%L928:
	ibp 3
	sojn 4,%L928	; decrement_and_branch_until_zero
%L929:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	sojge 6,%L939	; doloop_end
	movei 3,-1(17)
	tlo 3,222200
	move 2,3
	ibp 2
	move 1,3
	addi 3,1
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_array_Hint_4
stack_array_Hint_4:
	add 17,[2,,2]
	movei 2,0
	movei 7,-1(17)
	tlo 7,222200
	movei 6,3
%L959:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L947
%L946:
	ibp 3
	sojn 4,%L946	; decrement_and_branch_until_zero
%L947:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	sojge 6,%L959	; doloop_end
	movei 1,-1(17)
	tlo 1,222200
	move 2,1
	ibp 2
	move 3,1
	aos 4,3
	ibp 4
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_array_Hint_5
stack_array_Hint_5:
	add 17,[4,,4]
	movei 2,0
	movei 7,-3(17)
	tlo 7,222200
	movei 6,4
%L976:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L967
%L966:
	ibp 3
	sojn 4,%L966	; decrement_and_branch_until_zero
%L967:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	sojge 6,%L976	; doloop_end
	movei 1,-3(17)
	tlo 1,222200
	move 2,1
	ibp 2
	move 3,1
	aos 4,3
	ibp 4
	move 6,1
	addi 6,2
	movem 6,(17)
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_ptr_walk_Hint
stack_ptr_walk_Hint:
	add 17,[4,,4]
	movem 10,-3(17)
	movei 2,0
	movei 7,-2(17)
	tlo 7,222200
	movei 6,5
%L990:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L984
%L983:
	ibp 3
	sojn 4,%L983	; decrement_and_branch_until_zero
%L984:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	sojge 6,%L990	; doloop_end
	movei 10,-2(17)
	tlo 10,222200
	move 3,10
	addi 3,2
	ibp 3
	move 2,3
	subi 2,1
	ibp 2
	move 4,3
	subi 4,3
	ibp 4
	move 1,3
	subi 3,1
	pushj 17,bar
	move 2,10
	ibp 2
	move 3,10
	addi 3,1
	ibp 3
	move 4,10
	addi 4,2
	ibp 4
	move 1,10
	pushj 17,bar
	move 10,-3(17)
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_struct_Hint
stack_struct_Hint:
	add 17,[5,,5]
	movem 1,-4(17)
	addi 1,1
	hrrm 1,-4(17)
	addi 1,1
	hrlm 1,-3(17)
	addi 1,1
	hrrm 1,-3(17)
	addi 1,1
	movem 1,-2(17)
	addi 1,1
	hrrm 1,-2(17)
	subi 1,5
	lsh 1,33
	add 1,[6000000000]
	movem 1,-1(17)
	movei 2,-3(17)
	tlo 2,2200
	movei 4,-2(17)
	tlo 4,2200
	move 6,[POINT 18,3(<fp>),17]
	movem 6,(17)
	move 1,[POINT 18,<fp>,26]
	move 3,[POINT 18,1(<fp>),26]
	pushj 17,bar
	add 17,[-5,,-5]
	popj 17,

	.globl	stack_volatile_Hint
stack_volatile_Hint:
	add 17,[3,,3]
	move 4,1
	hrrzi 4,(4)	; zero_extendhisi2
	movem 4,-2(17)
	addi 1,1
	movem 1,-1(17)
	addi 1,1
	hrrm 1,-1(17)
	addi 1,1
	hrlm 1,(17)
	movei 1,-2(17)
	tlo 1,2200
	movei 4,-1(17)
	tlo 4,222200
	move 3,4
	ibp 3
	move 2,4
	addi 4,1
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_uHint_1
stack_scalars_uHint_1:
	add 17,[1,,1]
	hrrm 1,(17)
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_scalars_uHint_2
stack_scalars_uHint_2:
	add 17,[2,,2]
	hrrm 1,-1(17)
	movei 1,1(1)
	hrrm 1,(17)
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,2200
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_uHint_3
stack_scalars_uHint_3:
	add 17,[3,,3]
	hrrm 1,-2(17)
	movei 4,1(1)
	hrrm 4,-1(17)
	movei 1,2(1)
	hrrm 1,(17)
	movei 1,-2(17)
	tlo 1,2200
	movei 2,-1(17)
	tlo 2,2200
	movei 3,(17)
	tlo 3,2200
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_uHint_4
stack_scalars_uHint_4:
	add 17,[4,,4]
	hrrm 1,-3(17)
	movei 4,1(1)
	hrrm 4,-2(17)
	movei 4,2(1)
	hrrm 4,-1(17)
	movei 1,3(1)
	hrrm 1,(17)
	movei 1,-3(17)
	tlo 1,2200
	movei 2,-2(17)
	tlo 2,2200
	movei 3,-1(17)
	tlo 3,2200
	movei 4,(17)
	tlo 4,2200
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_uHint_5
stack_scalars_uHint_5:
	add 17,[6,,6]
	hrrm 1,-5(17)
	movei 4,1(1)
	hrrm 4,-4(17)
	movei 4,2(1)
	hrrm 4,-3(17)
	movei 4,3(1)
	hrrm 4,-2(17)
	movei 1,4(1)
	hrrm 1,-1(17)
	movei 1,-5(17)
	tlo 1,2200
	movei 2,-4(17)
	tlo 2,2200
	movei 3,-3(17)
	tlo 3,2200
	movei 4,-2(17)
	tlo 4,2200
	movei 6,-1(17)
	tlo 6,2200
	movem 6,(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_uHint_1
stack_array_uHint_1:
	add 17,[1,,1]
	movei 4,0
	ash 4,-1	; ashrsi3_pointer
	add 4,17
	dpb 1,4	; movhi
	hrrz 1,17
	tlo 1,222200
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uHint_2
stack_array_uHint_2:
	add 17,[1,,1]
	movei 2,0
	movei 6,(17)
	tlo 6,222200
%L1061:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,6
	jumpe 4,%L1060
%L1059:
	ibp 3
	sojn 4,%L1059	; decrement_and_branch_until_zero
%L1060:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	caig 2,1
	jrst %L1061
	movei 1,(17)
	tlo 1,222200
	move 2,1
	ibp 2
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uHint_3
stack_array_uHint_3:
	add 17,[2,,2]
	movei 2,0
	movei 7,-1(17)
	tlo 7,222200
	movei 6,2
%L1085:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L1075
%L1074:
	ibp 3
	sojn 4,%L1074	; decrement_and_branch_until_zero
%L1075:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	sojge 6,%L1085	; doloop_end
	movei 3,-1(17)
	tlo 3,222200
	move 2,3
	ibp 2
	move 1,3
	addi 3,1
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_array_uHint_4
stack_array_uHint_4:
	add 17,[2,,2]
	movei 2,0
	movei 7,-1(17)
	tlo 7,222200
	movei 6,3
%L1105:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L1093
%L1092:
	ibp 3
	sojn 4,%L1092	; decrement_and_branch_until_zero
%L1093:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	sojge 6,%L1105	; doloop_end
	movei 1,-1(17)
	tlo 1,222200
	move 2,1
	ibp 2
	move 3,1
	aos 4,3
	ibp 4
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_array_uHint_5
stack_array_uHint_5:
	add 17,[4,,4]
	movei 2,0
	movei 7,-3(17)
	tlo 7,222200
	movei 6,4
%L1122:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L1113
%L1112:
	ibp 3
	sojn 4,%L1112	; decrement_and_branch_until_zero
%L1113:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	sojge 6,%L1122	; doloop_end
	movei 1,-3(17)
	tlo 1,222200
	move 2,1
	ibp 2
	move 3,1
	aos 4,3
	ibp 4
	move 6,1
	addi 6,2
	movem 6,(17)
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_ptr_walk_uHint
stack_ptr_walk_uHint:
	add 17,[4,,4]
	movem 10,-3(17)
	movei 2,0
	movei 7,-2(17)
	tlo 7,222200
	movei 6,5
%L1136:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L1130
%L1129:
	ibp 3
	sojn 4,%L1129	; decrement_and_branch_until_zero
%L1130:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	sojge 6,%L1136	; doloop_end
	movei 10,-2(17)
	tlo 10,222200
	move 3,10
	addi 3,2
	ibp 3
	move 2,3
	subi 2,1
	ibp 2
	move 4,3
	subi 4,3
	ibp 4
	move 1,3
	subi 3,1
	pushj 17,bar
	move 2,10
	ibp 2
	move 3,10
	addi 3,1
	ibp 3
	move 4,10
	addi 4,2
	ibp 4
	move 1,10
	pushj 17,bar
	move 10,-3(17)
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_struct_uHint
stack_struct_uHint:
	add 17,[5,,5]
	movem 1,-4(17)
	addi 1,1
	hrrm 1,-4(17)
	addi 1,1
	hrlm 1,-3(17)
	addi 1,1
	hrrm 1,-3(17)
	addi 1,1
	movem 1,-2(17)
	addi 1,1
	hrrm 1,-2(17)
	subi 1,5
	lsh 1,33
	add 1,[6000000000]
	movem 1,-1(17)
	movei 2,-3(17)
	tlo 2,2200
	movei 4,-2(17)
	tlo 4,2200
	move 6,[POINT 18,3(<fp>),17]
	movem 6,(17)
	move 1,[POINT 18,<fp>,26]
	move 3,[POINT 18,1(<fp>),26]
	pushj 17,bar
	add 17,[-5,,-5]
	popj 17,

	.globl	stack_volatile_uHint
stack_volatile_uHint:
	add 17,[3,,3]
	move 4,1
	hrrzi 4,(4)	; zero_extendhisi2
	movem 4,-2(17)
	addi 1,1
	movem 1,-1(17)
	addi 1,1
	hrrm 1,-1(17)
	addi 1,1
	hrlm 1,(17)
	movei 1,-2(17)
	tlo 1,2200
	movei 4,-1(17)
	tlo 4,222200
	move 3,4
	ibp 3
	move 2,4
	addi 4,1
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_Sint_1
stack_scalars_Sint_1:
	add 17,[1,,1]
	movem 1,(17)
	movei 1,(17)
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_scalars_Sint_2
stack_scalars_Sint_2:
	add 17,[2,,2]
	movem 1,-1(17)
	addi 1,1
	movem 1,(17)
	movei 1,-1(17)
	movei 2,(17)
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_Sint_3
stack_scalars_Sint_3:
	add 17,[3,,3]
	movem 1,-2(17)
	move 6,1
	addi 6,1
	movem 6,-1(17)
	addi 1,2
	movem 1,(17)
	movei 1,-2(17)
	movei 2,-1(17)
	movei 3,(17)
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_Sint_4
stack_scalars_Sint_4:
	add 17,[4,,4]
	movem 1,-3(17)
	move 6,1
	addi 6,1
	movem 6,-2(17)
	addi 6,1
	movem 6,-1(17)
	addi 1,3
	movem 1,(17)
	movei 1,-3(17)
	movei 2,-2(17)
	movei 3,-1(17)
	movei 4,(17)
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_Sint_5
stack_scalars_Sint_5:
	add 17,[6,,6]
	movem 1,-4(17)
	move 6,1
	addi 6,1
	movem 6,-3(17)
	addi 6,1
	movem 6,-2(17)
	addi 6,1
	movem 6,-1(17)
	addi 1,4
	movem 1,-5(17)
	movei 4,-5(17)
	movem 4,(17)
	movei 1,-4(17)
	movei 2,-3(17)
	movei 3,-2(17)
	movei 4,-1(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_Sint_1
stack_array_Sint_1:
	add 17,[1,,1]
	movei 4,(17)
	movem 1,(4)
	move 1,4
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_Sint_2
stack_array_Sint_2:
	add 17,[2,,2]
	movei 2,-1(17)
	movem 1,(2)
	addi 1,1
	movem 1,1(2)
	move 1,2
	addi 2,1
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_array_Sint_3
stack_array_Sint_3:
	add 17,[3,,3]
	movei 3,-2(17)
	movei 4,2
%L1227:
	movem 1,(3)
	addi 3,1
	addi 1,1
	sojge 4,%L1227	; doloop_end
	movei 2,-2(17)
	move 3,2
	addi 3,2
	move 1,2
	addi 2,1
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_array_Sint_4
stack_array_Sint_4:
	add 17,[4,,4]
	movei 3,-3(17)
	movei 4,3
%L1244:
	movem 1,(3)
	addi 3,1
	addi 1,1
	sojge 4,%L1244	; doloop_end
	movei 2,-3(17)
	move 3,2
	addi 3,2
	move 4,2
	addi 4,3
	move 1,2
	addi 2,1
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_array_Sint_5
stack_array_Sint_5:
	add 17,[6,,6]
	movei 3,-5(17)
	movei 4,4
%L1258:
	movem 1,(3)
	addi 3,1
	addi 1,1
	sojge 4,%L1258	; doloop_end
	movei 2,-5(17)
	move 3,2
	addi 3,2
	move 4,2
	addi 4,3
	move 6,2
	addi 6,4
	movem 6,(17)
	move 1,2
	addi 2,1
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_ptr_walk_Sint
stack_ptr_walk_Sint:
	add 17,[10,,10]
	movem 10,-7(17)
	movem 11,-6(17)
	movei 3,-5(17)
	movei 4,5
%L1269:
	movem 1,(3)
	addi 3,1
	addi 1,1
	sojge 4,%L1269	; doloop_end
	movei 10,-5(17)
	move 1,10
	addi 1,5
	move 2,10
	addi 2,4
	move 11,10
	addi 11,3
	move 3,11
	move 4,10
	pushj 17,bar
	move 4,10
	addi 4,5
	move 1,10
	aos 2,10
	move 3,11
	pushj 17,bar
	move 10,-7(17)
	move 11,-6(17)
	add 17,[-10,,-10]
	popj 17,

	.globl	stack_struct_Sint
stack_struct_Sint:
	add 17,[10,,10]
	move 4,1
	lsh 4,33
	movem 4,-7(17)
	move 6,1
	addi 6,1
	movem 6,-6(17)
	addi 6,1
	movem 6,-5(17)
	addi 6,1
	movem 6,-4(17)
	addi 6,1
	movem 6,-3(17)
	addi 6,1
	movem 6,-2(17)
	addi 1,6
	movem 1,-1(17)
	movei 1,-7(17)
	move 4,1
	addi 4,2
	move 3,1
	addi 3,3
	move 6,1
	addi 6,5
	movem 6,(17)
	addi 1,1
	move 2,4
	addi 4,2
	pushj 17,bar
	add 17,[-10,,-10]
	popj 17,

	.globl	stack_volatile_Sint
stack_volatile_Sint:
	add 17,[4,,4]
	movem 1,-3(17)
	addi 1,1
	movem 1,-2(17)
	addi 1,1
	movem 1,-1(17)
	addi 1,1
	movem 1,(17)
	movei 3,-2(17)
	move 4,3
	addi 4,2
	movei 1,-3(17)
	move 2,3
	addi 3,1
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_uSint_1
stack_scalars_uSint_1:
	add 17,[1,,1]
	movem 1,(17)
	movei 1,(17)
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_scalars_uSint_2
stack_scalars_uSint_2:
	add 17,[2,,2]
	movem 1,-1(17)
	addi 1,1
	movem 1,(17)
	movei 1,-1(17)
	movei 2,(17)
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_uSint_3
stack_scalars_uSint_3:
	add 17,[3,,3]
	movem 1,-2(17)
	move 6,1
	addi 6,1
	movem 6,-1(17)
	addi 1,2
	movem 1,(17)
	movei 1,-2(17)
	movei 2,-1(17)
	movei 3,(17)
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_uSint_4
stack_scalars_uSint_4:
	add 17,[4,,4]
	movem 1,-3(17)
	move 6,1
	addi 6,1
	movem 6,-2(17)
	addi 6,1
	movem 6,-1(17)
	addi 1,3
	movem 1,(17)
	movei 1,-3(17)
	movei 2,-2(17)
	movei 3,-1(17)
	movei 4,(17)
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_uSint_5
stack_scalars_uSint_5:
	add 17,[6,,6]
	movem 1,-4(17)
	move 6,1
	addi 6,1
	movem 6,-3(17)
	addi 6,1
	movem 6,-2(17)
	addi 6,1
	movem 6,-1(17)
	addi 1,4
	movem 1,-5(17)
	movei 4,-5(17)
	movem 4,(17)
	movei 1,-4(17)
	movei 2,-3(17)
	movei 3,-2(17)
	movei 4,-1(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_uSint_1
stack_array_uSint_1:
	add 17,[1,,1]
	movei 4,(17)
	movem 1,(4)
	move 1,4
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uSint_2
stack_array_uSint_2:
	add 17,[2,,2]
	movei 2,-1(17)
	movem 1,(2)
	addi 1,1
	movem 1,1(2)
	move 1,2
	addi 2,1
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_array_uSint_3
stack_array_uSint_3:
	add 17,[3,,3]
	movei 3,-2(17)
	movei 4,2
%L1371:
	movem 1,(3)
	addi 3,1
	addi 1,1
	sojge 4,%L1371	; doloop_end
	movei 2,-2(17)
	move 3,2
	addi 3,2
	move 1,2
	addi 2,1
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_array_uSint_4
stack_array_uSint_4:
	add 17,[4,,4]
	movei 3,-3(17)
	movei 4,3
%L1388:
	movem 1,(3)
	addi 3,1
	addi 1,1
	sojge 4,%L1388	; doloop_end
	movei 2,-3(17)
	move 3,2
	addi 3,2
	move 4,2
	addi 4,3
	move 1,2
	addi 2,1
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_array_uSint_5
stack_array_uSint_5:
	add 17,[6,,6]
	movei 3,-5(17)
	movei 4,4
%L1402:
	movem 1,(3)
	addi 3,1
	addi 1,1
	sojge 4,%L1402	; doloop_end
	movei 2,-5(17)
	move 3,2
	addi 3,2
	move 4,2
	addi 4,3
	move 6,2
	addi 6,4
	movem 6,(17)
	move 1,2
	addi 2,1
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_ptr_walk_uSint
stack_ptr_walk_uSint:
	add 17,[10,,10]
	movem 10,-7(17)
	movem 11,-6(17)
	movei 3,-5(17)
	movei 4,5
%L1413:
	movem 1,(3)
	addi 3,1
	addi 1,1
	sojge 4,%L1413	; doloop_end
	movei 10,-5(17)
	move 1,10
	addi 1,5
	move 2,10
	addi 2,4
	move 11,10
	addi 11,3
	move 3,11
	move 4,10
	pushj 17,bar
	move 4,10
	addi 4,5
	move 1,10
	aos 2,10
	move 3,11
	pushj 17,bar
	move 10,-7(17)
	move 11,-6(17)
	add 17,[-10,,-10]
	popj 17,

	.globl	stack_struct_uSint
stack_struct_uSint:
	add 17,[10,,10]
	move 4,1
	lsh 4,33
	movem 4,-7(17)
	move 6,1
	addi 6,1
	movem 6,-6(17)
	addi 6,1
	movem 6,-5(17)
	addi 6,1
	movem 6,-4(17)
	addi 6,1
	movem 6,-3(17)
	addi 6,1
	movem 6,-2(17)
	addi 1,6
	movem 1,-1(17)
	movei 1,-7(17)
	move 4,1
	addi 4,2
	move 3,1
	addi 3,3
	move 6,1
	addi 6,5
	movem 6,(17)
	addi 1,1
	move 2,4
	addi 4,2
	pushj 17,bar
	add 17,[-10,,-10]
	popj 17,

	.globl	stack_volatile_uSint
stack_volatile_uSint:
	add 17,[4,,4]
	movem 1,-3(17)
	addi 1,1
	movem 1,-2(17)
	addi 1,1
	movem 1,-1(17)
	addi 1,1
	movem 1,(17)
	movei 3,-2(17)
	move 4,3
	addi 4,2
	movei 1,-3(17)
	move 2,3
	addi 3,1
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_Dint_1
stack_scalars_Dint_1:
	add 17,[2,,2]
	move 5,1
	ash 1,-43
	movem 1,-1(17)
	movei 3,-1(17)
	movem 5,1(3)
	movei 1,-1(17)
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_Dint_2
stack_scalars_Dint_2:
	add 17,[4,,4]
	move 3,1
	ash 3,-43
	movem 3,-3(17)
	movei 3,-3(17)
	movem 1,1(3)
	aos 5,1
	ash 1,-43
	movem 1,-1(17)
	movei 2,-1(17)
	movem 5,1(2)
	movei 1,-3(17)
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_Dint_3
stack_scalars_Dint_3:
	add 17,[6,,6]
	move 3,1
	ash 3,-43
	movem 3,-5(17)
	movei 3,-5(17)
	movem 1,1(3)
	move 3,1
	aos 5,3
	ash 3,-43
	movem 3,-3(17)
	movei 2,-3(17)
	movem 5,1(2)
	addi 1,2
	move 5,1
	ash 1,-43
	movem 1,-1(17)
	movei 3,-1(17)
	movem 5,1(3)
	movei 1,-5(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_scalars_Dint_4
stack_scalars_Dint_4:
	add 17,[10,,10]
	move 3,1
	ash 3,-43
	movem 3,-7(17)
	movei 3,-7(17)
	movem 1,1(3)
	move 3,1
	aos 5,3
	ash 3,-43
	movem 3,-5(17)
	movei 2,-5(17)
	movem 5,1(2)
	move 3,1
	addi 3,2
	move 5,3
	ash 3,-43
	movem 3,-3(17)
	movei 3,-3(17)
	movem 5,1(3)
	addi 1,3
	move 7,1
	ash 1,-43
	movem 1,-1(17)
	movei 4,-1(17)
	movem 7,1(4)
	movei 1,-7(17)
	pushj 17,bar
	add 17,[-10,,-10]
	popj 17,

	.globl	stack_scalars_Dint_5
stack_scalars_Dint_5:
	add 17,[13,,13]
	move 3,1
	ash 3,-43
	movem 3,-12(17)
	movei 3,-12(17)
	movem 1,1(3)
	move 3,1
	aos 5,3
	ash 3,-43
	movem 3,-10(17)
	movei 2,-10(17)
	movem 5,1(2)
	move 3,1
	addi 3,2
	move 5,3
	ash 3,-43
	movem 3,-6(17)
	movei 3,-6(17)
	movem 5,1(3)
	move 4,1
	addi 4,3
	move 7,4
	ash 4,-43
	movem 4,-4(17)
	movei 4,-4(17)
	movem 7,1(4)
	addi 1,4
	move 7,1
	ash 1,-43
	movem 1,-2(17)
	movei 1,-2(17)
	movem 7,1(1)
	movem 1,(17)
	movei 1,-12(17)
	pushj 17,bar
	add 17,[-13,,-13]
	popj 17,

	.globl	stack_array_Dint_1
stack_array_Dint_1:
	add 17,[2,,2]
	movei 3,-1(17)
	move 5,1
	ash 1,-43
	movem 1,(3)
	movem 5,1(3)
	move 1,3
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_array_Dint_2
stack_array_Dint_2:
	add 17,[4,,4]
	movei 2,-3(17)
	movei 6,1
%L1490:
	move 3,1
	ash 3,-43
	movem 3,(2)
	movem 1,1(2)
	addi 1,1
	addi 2,2
	sojge 6,%L1490	; decrement_and_branch_until_zero
	movei 2,-3(17)
	move 1,2
	addi 2,2
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_array_Dint_3
stack_array_Dint_3:
	add 17,[6,,6]
	movei 2,-5(17)
	movei 6,2
%L1511:
	move 3,1
	ash 3,-43
	movem 3,(2)
	movem 1,1(2)
	addi 1,1
	addi 2,2
	sojge 6,%L1511	; doloop_end
	movei 2,-5(17)
	move 3,2
	addi 3,4
	move 1,2
	addi 2,2
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_Dint_4
stack_array_Dint_4:
	add 17,[10,,10]
	movei 2,-7(17)
	movei 6,3
%L1528:
	move 3,1
	ash 3,-43
	movem 3,(2)
	movem 1,1(2)
	addi 1,1
	addi 2,2
	sojge 6,%L1528	; doloop_end
	movei 2,-7(17)
	move 3,2
	addi 3,4
	move 4,2
	addi 4,6
	move 1,2
	addi 2,2
	pushj 17,bar
	add 17,[-10,,-10]
	popj 17,

	.globl	stack_array_Dint_5
stack_array_Dint_5:
	add 17,[13,,13]
	movei 2,-12(17)
	movei 6,4
%L1542:
	move 3,1
	ash 3,-43
	movem 3,(2)
	movem 1,1(2)
	addi 1,1
	addi 2,2
	sojge 6,%L1542	; doloop_end
	movei 2,-12(17)
	move 3,2
	addi 3,4
	move 4,2
	addi 4,6
	move 6,2
	addi 6,10
	movem 6,(17)
	move 1,2
	addi 2,2
	pushj 17,bar
	add 17,[-13,,-13]
	popj 17,

	.globl	stack_ptr_walk_Dint
stack_ptr_walk_Dint:
	add 17,[16,,16]
	movem 10,-15(17)
	movem 11,-14(17)
	movei 2,-13(17)
	movei 6,5
%L1553:
	move 3,1
	ash 3,-43
	movem 3,(2)
	movem 1,1(2)
	addi 1,1
	addi 2,2
	sojge 6,%L1553	; doloop_end
	movei 10,-13(17)
	move 1,10
	addi 1,12
	move 2,10
	addi 2,10
	move 11,10
	addi 11,6
	move 3,11
	move 4,10
	pushj 17,bar
	move 4,10
	addi 4,12
	move 1,10
	addi 10,2
	move 2,10
	move 3,11
	pushj 17,bar
	move 10,-15(17)
	move 11,-14(17)
	add 17,[-16,,-16]
	popj 17,

	.globl	stack_struct_Dint
stack_struct_Dint:
	add 17,[15,,15]
	move 4,1
	lsh 4,33
	movem 4,-14(17)
	move 3,1
	aos 5,3
	ash 3,-43
	movem 3,-13(17)
	movem 5,-12(17)
	move 3,1
	addi 3,2
	move 5,3
	ash 3,-43
	movem 3,-11(17)
	movem 5,-10(17)
	move 3,1
	addi 3,3
	move 5,3
	ash 3,-43
	movem 3,-7(17)
	movem 5,-6(17)
	move 3,1
	addi 3,4
	move 5,3
	ash 3,-43
	movem 3,-5(17)
	movem 5,-4(17)
	move 3,1
	addi 3,5
	move 5,3
	ash 3,-43
	movem 3,-3(17)
	movem 5,-2(17)
	addi 1,6
	movem 1,-1(17)
	movei 1,-14(17)
	move 2,1
	addi 2,3
	move 3,1
	addi 3,5
	move 4,1
	addi 4,7
	move 6,1
	addi 6,11
	movem 6,(17)
	addi 1,1
	pushj 17,bar
	add 17,[-15,,-15]
	popj 17,

	.globl	stack_volatile_Dint
stack_volatile_Dint:
	add 17,[10,,10]
	move 3,1
	ash 3,-43
	movem 3,-7(17)
	movem 1,-6(17)
	move 3,1
	aos 5,3
	ash 3,-43
	movem 3,-5(17)
	movem 5,-4(17)
	move 3,1
	addi 3,2
	move 5,3
	ash 3,-43
	movem 3,-3(17)
	movem 5,-2(17)
	addi 1,3
	move 5,1
	ash 1,-43
	movem 1,-1(17)
	movem 5,(17)
	movei 3,-5(17)
	move 4,3
	addi 4,4
	movei 1,-7(17)
	move 2,3
	addi 3,2
	pushj 17,bar
	add 17,[-10,,-10]
	popj 17,

	.globl	stack_scalars_uDint_1
stack_scalars_uDint_1:
	add 17,[2,,2]
	move 5,1
	ash 1,-43
	movem 1,-1(17)
	movei 3,-1(17)
	movem 5,1(3)
	movei 1,-1(17)
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_uDint_2
stack_scalars_uDint_2:
	add 17,[4,,4]
	move 3,1
	ash 3,-43
	movem 3,-3(17)
	movei 3,-3(17)
	movem 1,1(3)
	aos 5,1
	ash 1,-43
	movem 1,-1(17)
	movei 2,-1(17)
	movem 5,1(2)
	movei 1,-3(17)
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_uDint_3
stack_scalars_uDint_3:
	add 17,[6,,6]
	move 3,1
	ash 3,-43
	movem 3,-5(17)
	movei 3,-5(17)
	movem 1,1(3)
	move 3,1
	aos 5,3
	ash 3,-43
	movem 3,-3(17)
	movei 2,-3(17)
	movem 5,1(2)
	addi 1,2
	move 5,1
	ash 1,-43
	movem 1,-1(17)
	movei 3,-1(17)
	movem 5,1(3)
	movei 1,-5(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_scalars_uDint_4
stack_scalars_uDint_4:
	add 17,[10,,10]
	move 3,1
	ash 3,-43
	movem 3,-7(17)
	movei 3,-7(17)
	movem 1,1(3)
	move 3,1
	aos 5,3
	ash 3,-43
	movem 3,-5(17)
	movei 2,-5(17)
	movem 5,1(2)
	move 3,1
	addi 3,2
	move 5,3
	ash 3,-43
	movem 3,-3(17)
	movei 3,-3(17)
	movem 5,1(3)
	addi 1,3
	move 7,1
	ash 1,-43
	movem 1,-1(17)
	movei 4,-1(17)
	movem 7,1(4)
	movei 1,-7(17)
	pushj 17,bar
	add 17,[-10,,-10]
	popj 17,

	.globl	stack_scalars_uDint_5
stack_scalars_uDint_5:
	add 17,[13,,13]
	move 3,1
	ash 3,-43
	movem 3,-12(17)
	movei 3,-12(17)
	movem 1,1(3)
	move 3,1
	aos 5,3
	ash 3,-43
	movem 3,-10(17)
	movei 2,-10(17)
	movem 5,1(2)
	move 3,1
	addi 3,2
	move 5,3
	ash 3,-43
	movem 3,-6(17)
	movei 3,-6(17)
	movem 5,1(3)
	move 4,1
	addi 4,3
	move 7,4
	ash 4,-43
	movem 4,-4(17)
	movei 4,-4(17)
	movem 7,1(4)
	addi 1,4
	move 7,1
	ash 1,-43
	movem 1,-2(17)
	movei 1,-2(17)
	movem 7,1(1)
	movem 1,(17)
	movei 1,-12(17)
	pushj 17,bar
	add 17,[-13,,-13]
	popj 17,

	.globl	stack_array_uDint_1
stack_array_uDint_1:
	add 17,[2,,2]
	movei 3,-1(17)
	move 5,1
	ash 1,-43
	movem 1,(3)
	movem 5,1(3)
	move 1,3
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_array_uDint_2
stack_array_uDint_2:
	add 17,[4,,4]
	movei 2,-3(17)
	movei 6,1
%L1630:
	move 3,1
	ash 3,-43
	movem 3,(2)
	movem 1,1(2)
	addi 1,1
	addi 2,2
	sojge 6,%L1630	; decrement_and_branch_until_zero
	movei 2,-3(17)
	move 1,2
	addi 2,2
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_array_uDint_3
stack_array_uDint_3:
	add 17,[6,,6]
	movei 2,-5(17)
	movei 6,2
%L1651:
	move 3,1
	ash 3,-43
	movem 3,(2)
	movem 1,1(2)
	addi 1,1
	addi 2,2
	sojge 6,%L1651	; doloop_end
	movei 2,-5(17)
	move 3,2
	addi 3,4
	move 1,2
	addi 2,2
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_uDint_4
stack_array_uDint_4:
	add 17,[10,,10]
	movei 2,-7(17)
	movei 6,3
%L1668:
	move 3,1
	ash 3,-43
	movem 3,(2)
	movem 1,1(2)
	addi 1,1
	addi 2,2
	sojge 6,%L1668	; doloop_end
	movei 2,-7(17)
	move 3,2
	addi 3,4
	move 4,2
	addi 4,6
	move 1,2
	addi 2,2
	pushj 17,bar
	add 17,[-10,,-10]
	popj 17,

	.globl	stack_array_uDint_5
stack_array_uDint_5:
	add 17,[13,,13]
	movei 2,-12(17)
	movei 6,4
%L1682:
	move 3,1
	ash 3,-43
	movem 3,(2)
	movem 1,1(2)
	addi 1,1
	addi 2,2
	sojge 6,%L1682	; doloop_end
	movei 2,-12(17)
	move 3,2
	addi 3,4
	move 4,2
	addi 4,6
	move 6,2
	addi 6,10
	movem 6,(17)
	move 1,2
	addi 2,2
	pushj 17,bar
	add 17,[-13,,-13]
	popj 17,

	.globl	stack_ptr_walk_uDint
stack_ptr_walk_uDint:
	add 17,[16,,16]
	movem 10,-15(17)
	movem 11,-14(17)
	movei 2,-13(17)
	movei 6,5
%L1693:
	move 3,1
	ash 3,-43
	movem 3,(2)
	movem 1,1(2)
	addi 1,1
	addi 2,2
	sojge 6,%L1693	; doloop_end
	movei 10,-13(17)
	move 1,10
	addi 1,12
	move 2,10
	addi 2,10
	move 11,10
	addi 11,6
	move 3,11
	move 4,10
	pushj 17,bar
	move 4,10
	addi 4,12
	move 1,10
	addi 10,2
	move 2,10
	move 3,11
	pushj 17,bar
	move 10,-15(17)
	move 11,-14(17)
	add 17,[-16,,-16]
	popj 17,

	.globl	stack_struct_uDint
stack_struct_uDint:
	add 17,[15,,15]
	move 4,1
	lsh 4,33
	movem 4,-14(17)
	move 3,1
	aos 5,3
	ash 3,-43
	movem 3,-13(17)
	movem 5,-12(17)
	move 3,1
	addi 3,2
	move 5,3
	ash 3,-43
	movem 3,-11(17)
	movem 5,-10(17)
	move 3,1
	addi 3,3
	move 5,3
	ash 3,-43
	movem 3,-7(17)
	movem 5,-6(17)
	move 3,1
	addi 3,4
	move 5,3
	ash 3,-43
	movem 3,-5(17)
	movem 5,-4(17)
	move 3,1
	addi 3,5
	move 5,3
	ash 3,-43
	movem 3,-3(17)
	movem 5,-2(17)
	addi 1,6
	movem 1,-1(17)
	movei 1,-14(17)
	move 2,1
	addi 2,3
	move 3,1
	addi 3,5
	move 4,1
	addi 4,7
	move 6,1
	addi 6,11
	movem 6,(17)
	addi 1,1
	pushj 17,bar
	add 17,[-15,,-15]
	popj 17,

	.globl	stack_volatile_uDint
stack_volatile_uDint:
	add 17,[10,,10]
	move 3,1
	ash 3,-43
	movem 3,-7(17)
	movem 1,-6(17)
	move 3,1
	aos 5,3
	ash 3,-43
	movem 3,-5(17)
	movem 5,-4(17)
	move 3,1
	addi 3,2
	move 5,3
	ash 3,-43
	movem 3,-3(17)
	movem 5,-2(17)
	addi 1,3
	move 5,1
	ash 1,-43
	movem 1,-1(17)
	movem 5,(17)
	movei 3,-5(17)
	move 4,3
	addi 4,4
	movei 1,-7(17)
	move 2,3
	addi 3,2
	pushj 17,bar
	add 17,[-10,,-10]
	popj 17,

	.globl	stack_scalars_char6_1
stack_scalars_char6_1:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_scalars_char6_2
stack_scalars_char6_2:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,2200
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_char6_3
stack_scalars_char6_3:
	add 17,[3,,3]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-2(17)
	tlo 1,2200
	movei 2,-1(17)
	tlo 2,2200
	movei 3,(17)
	tlo 3,2200
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_char6_4
stack_scalars_char6_4:
	add 17,[4,,4]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-3(17)
	tlo 1,2200
	movei 2,-2(17)
	tlo 2,2200
	movei 3,-1(17)
	tlo 3,2200
	movei 4,(17)
	tlo 4,2200
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_char6_5
stack_scalars_char6_5:
	add 17,[6,,6]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-5(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-4(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 1,-5(17)
	tlo 1,2200
	movei 2,-4(17)
	tlo 2,2200
	movei 3,-3(17)
	tlo 3,2200
	movei 4,-2(17)
	tlo 4,2200
	movei 6,-1(17)
	tlo 6,2200
	movem 6,(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_char6_1
stack_array_char6_1:
	add 17,[1,,1]
	move 4,17
	movei 3,0
	jumpe 3,%L1763
%L1762:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L1762
%L1763:
	dpb 1,4
	hrrz 1,17
	tlo 1,360600
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_char6_2
stack_array_char6_2:
	add 17,[1,,1]
	movei 2,0
	movei 6,(17)
	tlo 6,360600
%L1779:
	move 4,6
	move 3,2
	jumple 2,%L1776
%L1775:
	ibp 4
	sojg 3,%L1775	; decrement_and_branch_until_zero
%L1776:
	jumpe 3,%L1778
%L1777:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L1777
%L1778:
	dpb 1,4
	addi 1,1
	addi 2,1
	caig 2,1
	jrst %L1779
	movei 1,(17)
	tlo 1,360600
	move 2,1
	ibp 2
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_char6_3
stack_array_char6_3:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,360600
	movei 6,2
%L1805:
	move 4,7
	move 3,2
	jumple 2,%L1793
%L1792:
	ibp 4
	sojg 3,%L1792	; decrement_and_branch_until_zero
%L1793:
	jumpe 3,%L1795
%L1794:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L1794
%L1795:
	dpb 1,4
	addi 1,1
	addi 2,1
	sojge 6,%L1805	; doloop_end
	movei 1,(17)
	tlo 1,360600
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_char6_4
stack_array_char6_4:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,360600
	movei 6,3
%L1827:
	move 4,7
	move 3,2
	jumple 2,%L1813
%L1812:
	ibp 4
	sojg 3,%L1812	; decrement_and_branch_until_zero
%L1813:
	jumpe 3,%L1815
%L1814:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L1814
%L1815:
	dpb 1,4
	addi 1,1
	addi 2,1
	sojge 6,%L1827	; doloop_end
	movei 1,(17)
	tlo 1,360600
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_char6_5
stack_array_char6_5:
	add 17,[3,,3]
	movei 2,0
	movei 7,-2(17)
	tlo 7,360600
	movei 6,4
%L1846:
	move 4,7
	move 3,2
	jumple 2,%L1835
%L1834:
	ibp 4
	sojg 3,%L1834	; decrement_and_branch_until_zero
%L1835:
	jumpe 3,%L1837
%L1836:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L1836
%L1837:
	dpb 1,4
	addi 1,1
	addi 2,1
	sojge 6,%L1846	; doloop_end
	movei 1,-2(17)
	tlo 1,360600
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	move 6,4
	ibp 6
	movem 6,(17)
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_ptr_walk_char6
stack_ptr_walk_char6:
	add 17,[3,,3]
	movem 10,-2(17)
	movei 2,0
	movei 7,-1(17)
	tlo 7,360600
	movei 6,5
%L1862:
	move 4,7
	move 3,2
	jumple 2,%L1854
%L1853:
	ibp 4
	sojg 3,%L1853	; decrement_and_branch_until_zero
%L1854:
	jumpe 3,%L1856
%L1855:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L1855
%L1856:
	dpb 1,4
	addi 1,1
	addi 2,1
	sojge 6,%L1862	; doloop_end
	movei 10,-1(17)
	tlo 10,360600
	move 1,10
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	move 2,1
	subi 2,1
	ibp 2
	ibp 2
	ibp 2
	ibp 2
	ibp 2
	move 3,1
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	move 4,1
	subi 4,1
	ibp 4
	pushj 17,bar
	move 2,10
	ibp 2
	move 3,2
	ibp 3
	ibp 3
	move 4,3
	ibp 4
	ibp 4
	move 1,10
	pushj 17,bar
	move 10,-2(17)
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_struct_char6
stack_struct_char6:
	add 17,[3,,3]
	move 4,-2(17)
	dpb 1,[POINT 9,4,8]
	addi 1,1
	dpb 1,[POINT 6,4,17]
	addi 1,1
	dpb 1,[POINT 6,4,23]
	addi 1,1
	dpb 1,[POINT 6,4,29]
	addi 1,1
	dpb 1,[POINT 6,4,35]
	movem 4,-2(17)
	addi 1,1
	movei 4,-2(17)
	dpb 1,[POINT 6,1(4),5]
	addi 1,1
	dpb 1,[POINT 9,1(4),17]
	move 6,[POINT 6,2(<fp>),5]
	movem 6,(17)
	move 1,[POINT 6,<fp>,14]
	move 2,[POINT 6,<fp>,20]
	move 3,[POINT 6,<fp>,26]
	move 4,[POINT 6,<fp>,32]
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_volatile_char6
stack_volatile_char6:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	movem 4,-1(17)
	addi 1,1
	dpb 1,[POINT 6,(17),5]
	addi 1,1
	dpb 1,[POINT 6,(17),11]
	addi 1,1
	dpb 1,[POINT 6,(17),17]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,360600
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_uchar6_1
stack_scalars_uchar6_1:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_scalars_uchar6_2
stack_scalars_uchar6_2:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,2200
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_uchar6_3
stack_scalars_uchar6_3:
	add 17,[3,,3]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-2(17)
	tlo 1,2200
	movei 2,-1(17)
	tlo 2,2200
	movei 3,(17)
	tlo 3,2200
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_uchar6_4
stack_scalars_uchar6_4:
	add 17,[4,,4]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-3(17)
	tlo 1,2200
	movei 2,-2(17)
	tlo 2,2200
	movei 3,-1(17)
	tlo 3,2200
	movei 4,(17)
	tlo 4,2200
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_uchar6_5
stack_scalars_uchar6_5:
	add 17,[6,,6]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-5(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-4(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 1,-5(17)
	tlo 1,2200
	movei 2,-4(17)
	tlo 2,2200
	movei 3,-3(17)
	tlo 3,2200
	movei 4,-2(17)
	tlo 4,2200
	movei 6,-1(17)
	tlo 6,2200
	movem 6,(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_uchar6_1
stack_array_uchar6_1:
	add 17,[1,,1]
	move 4,17
	movei 3,0
	jumpe 3,%L1919
%L1918:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L1918
%L1919:
	dpb 1,4
	hrrz 1,17
	tlo 1,360600
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uchar6_2
stack_array_uchar6_2:
	add 17,[1,,1]
	movei 2,0
	movei 6,(17)
	tlo 6,360600
%L1935:
	move 4,6
	move 3,2
	jumple 2,%L1932
%L1931:
	ibp 4
	sojg 3,%L1931	; decrement_and_branch_until_zero
%L1932:
	jumpe 3,%L1934
%L1933:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L1933
%L1934:
	dpb 1,4
	addi 1,1
	addi 2,1
	caig 2,1
	jrst %L1935
	movei 1,(17)
	tlo 1,360600
	move 2,1
	ibp 2
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uchar6_3
stack_array_uchar6_3:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,360600
	movei 6,2
%L1961:
	move 4,7
	move 3,2
	jumple 2,%L1949
%L1948:
	ibp 4
	sojg 3,%L1948	; decrement_and_branch_until_zero
%L1949:
	jumpe 3,%L1951
%L1950:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L1950
%L1951:
	dpb 1,4
	addi 1,1
	addi 2,1
	sojge 6,%L1961	; doloop_end
	movei 1,(17)
	tlo 1,360600
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uchar6_4
stack_array_uchar6_4:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,360600
	movei 6,3
%L1983:
	move 4,7
	move 3,2
	jumple 2,%L1969
%L1968:
	ibp 4
	sojg 3,%L1968	; decrement_and_branch_until_zero
%L1969:
	jumpe 3,%L1971
%L1970:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L1970
%L1971:
	dpb 1,4
	addi 1,1
	addi 2,1
	sojge 6,%L1983	; doloop_end
	movei 1,(17)
	tlo 1,360600
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uchar6_5
stack_array_uchar6_5:
	add 17,[3,,3]
	movei 2,0
	movei 7,-2(17)
	tlo 7,360600
	movei 6,4
%L2002:
	move 4,7
	move 3,2
	jumple 2,%L1991
%L1990:
	ibp 4
	sojg 3,%L1990	; decrement_and_branch_until_zero
%L1991:
	jumpe 3,%L1993
%L1992:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L1992
%L1993:
	dpb 1,4
	addi 1,1
	addi 2,1
	sojge 6,%L2002	; doloop_end
	movei 1,-2(17)
	tlo 1,360600
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	move 6,4
	ibp 6
	movem 6,(17)
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_ptr_walk_uchar6
stack_ptr_walk_uchar6:
	add 17,[3,,3]
	movem 10,-2(17)
	movei 2,0
	movei 7,-1(17)
	tlo 7,360600
	movei 6,5
%L2018:
	move 4,7
	move 3,2
	jumple 2,%L2010
%L2009:
	ibp 4
	sojg 3,%L2009	; decrement_and_branch_until_zero
%L2010:
	jumpe 3,%L2012
%L2011:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L2011
%L2012:
	dpb 1,4
	addi 1,1
	addi 2,1
	sojge 6,%L2018	; doloop_end
	movei 10,-1(17)
	tlo 10,360600
	move 1,10
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	move 2,1
	subi 2,1
	ibp 2
	ibp 2
	ibp 2
	ibp 2
	ibp 2
	move 3,1
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	move 4,1
	subi 4,1
	ibp 4
	pushj 17,bar
	move 2,10
	ibp 2
	move 3,2
	ibp 3
	ibp 3
	move 4,3
	ibp 4
	ibp 4
	move 1,10
	pushj 17,bar
	move 10,-2(17)
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_struct_uchar6
stack_struct_uchar6:
	add 17,[3,,3]
	move 4,-2(17)
	dpb 1,[POINT 9,4,8]
	addi 1,1
	dpb 1,[POINT 6,4,17]
	addi 1,1
	dpb 1,[POINT 6,4,23]
	addi 1,1
	dpb 1,[POINT 6,4,29]
	addi 1,1
	dpb 1,[POINT 6,4,35]
	movem 4,-2(17)
	addi 1,1
	movei 4,-2(17)
	dpb 1,[POINT 6,1(4),5]
	addi 1,1
	dpb 1,[POINT 9,1(4),17]
	move 6,[POINT 6,2(<fp>),5]
	movem 6,(17)
	move 1,[POINT 6,<fp>,14]
	move 2,[POINT 6,<fp>,20]
	move 3,[POINT 6,<fp>,26]
	move 4,[POINT 6,<fp>,32]
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_volatile_uchar6
stack_volatile_uchar6:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	movem 4,-1(17)
	addi 1,1
	dpb 1,[POINT 6,(17),5]
	addi 1,1
	dpb 1,[POINT 6,(17),11]
	addi 1,1
	dpb 1,[POINT 6,(17),17]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,360600
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_char7_1
stack_scalars_char7_1:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_scalars_char7_2
stack_scalars_char7_2:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,2200
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_char7_3
stack_scalars_char7_3:
	add 17,[3,,3]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-2(17)
	tlo 1,2200
	movei 2,-1(17)
	tlo 2,2200
	movei 3,(17)
	tlo 3,2200
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_char7_4
stack_scalars_char7_4:
	add 17,[4,,4]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-3(17)
	tlo 1,2200
	movei 2,-2(17)
	tlo 2,2200
	movei 3,-1(17)
	tlo 3,2200
	movei 4,(17)
	tlo 4,2200
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_char7_5
stack_scalars_char7_5:
	add 17,[6,,6]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-5(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-4(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 1,-5(17)
	tlo 1,2200
	movei 2,-4(17)
	tlo 2,2200
	movei 3,-3(17)
	tlo 3,2200
	movei 4,-2(17)
	tlo 4,2200
	movei 6,-1(17)
	tlo 6,2200
	movem 6,(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_char7_1
stack_array_char7_1:
	add 17,[1,,1]
	move 4,17
	movei 3,0
	jumpe 3,%L2075
%L2074:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L2074
%L2075:
	dpb 1,4
	hrrz 1,17
	tlo 1,350700
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_char7_2
stack_array_char7_2:
	add 17,[1,,1]
	movei 2,0
	movei 6,(17)
	tlo 6,350700
%L2091:
	move 4,6
	move 3,2
	jumple 2,%L2088
%L2087:
	ibp 4
	sojg 3,%L2087	; decrement_and_branch_until_zero
%L2088:
	jumpe 3,%L2090
%L2089:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L2089
%L2090:
	dpb 1,4
	addi 1,1
	addi 2,1
	caig 2,1
	jrst %L2091
	movei 1,(17)
	tlo 1,350700
	move 2,1
	ibp 2
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_char7_3
stack_array_char7_3:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,350700
	movei 6,2
%L2117:
	move 4,7
	move 3,2
	jumple 2,%L2105
%L2104:
	ibp 4
	sojg 3,%L2104	; decrement_and_branch_until_zero
%L2105:
	jumpe 3,%L2107
%L2106:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L2106
%L2107:
	dpb 1,4
	addi 1,1
	addi 2,1
	sojge 6,%L2117	; doloop_end
	movei 1,(17)
	tlo 1,350700
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_char7_4
stack_array_char7_4:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,350700
	movei 6,3
%L2139:
	move 4,7
	move 3,2
	jumple 2,%L2125
%L2124:
	ibp 4
	sojg 3,%L2124	; decrement_and_branch_until_zero
%L2125:
	jumpe 3,%L2127
%L2126:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L2126
%L2127:
	dpb 1,4
	addi 1,1
	addi 2,1
	sojge 6,%L2139	; doloop_end
	movei 1,(17)
	tlo 1,350700
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_char7_5
stack_array_char7_5:
	add 17,[3,,3]
	movei 2,0
	movei 7,-2(17)
	tlo 7,350700
	movei 6,4
%L2158:
	move 4,7
	move 3,2
	jumple 2,%L2147
%L2146:
	ibp 4
	sojg 3,%L2146	; decrement_and_branch_until_zero
%L2147:
	jumpe 3,%L2149
%L2148:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L2148
%L2149:
	dpb 1,4
	addi 1,1
	addi 2,1
	sojge 6,%L2158	; doloop_end
	movei 1,-2(17)
	tlo 1,350700
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	move 6,4
	ibp 6
	movem 6,(17)
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_ptr_walk_char7
stack_ptr_walk_char7:
	add 17,[3,,3]
	movem 10,-2(17)
	movei 2,0
	movei 7,-1(17)
	tlo 7,350700
	movei 6,5
%L2174:
	move 4,7
	move 3,2
	jumple 2,%L2166
%L2165:
	ibp 4
	sojg 3,%L2165	; decrement_and_branch_until_zero
%L2166:
	jumpe 3,%L2168
%L2167:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L2167
%L2168:
	dpb 1,4
	addi 1,1
	addi 2,1
	sojge 6,%L2174	; doloop_end
	movei 10,-1(17)
	tlo 10,350700
	move 1,10
	addi 1,1
	move 2,10
	ibp 2
	ibp 2
	ibp 2
	ibp 2
	move 3,10
	ibp 3
	ibp 3
	ibp 3
	move 4,10
	pushj 17,bar
	move 2,10
	ibp 2
	move 3,2
	ibp 3
	ibp 3
	move 1,10
	aos 4,10
	pushj 17,bar
	move 10,-2(17)
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_struct_char7
stack_struct_char7:
	add 17,[5,,5]
	movem 1,-4(17)
	addi 1,1
	dpb 1,[POINT 7,-4(17),20]
	addi 1,1
	dpb 1,[POINT 7,-4(17),33]
	subi 1,2
	move 3,1
	addi 3,3
	ldb 4,[POINT 2,3,30]
	dpb 4,[POINT 2,-4(17),35]
	lsh 3,37
	move 4,-3(17)
	tlz 4,760000
	ior 4,3
	movem 4,-3(17)
	addi 1,4
	dpb 1,[POINT 7,-3(17),11]
	subi 1,4
	move 4,1
	addi 4,5
	lsh 4,10
	andi 4,377400
	movem 4,-3(17)
	lsh 1,33
	add 1,[6000000000]
	movem 1,-2(17)
	move 4,-3(17)
	lsh 4,5
	ash 4,-35
	movem 4,-1(17)
	movei 4,-1(17)
	tlo 4,2200
	move 6,[POINT 7,2(<fp>),6]
	movem 6,(17)
	move 1,[POINT 7,<fp>,15]
	move 2,[POINT 7,<fp>,22]
	move 3,[POINT 7,<fp>,29]
	pushj 17,bar
	add 17,[-5,,-5]
	popj 17,

	.globl	stack_volatile_char7
stack_volatile_char7:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	movem 4,-1(17)
	addi 1,1
	dpb 1,[POINT 7,(17),6]
	addi 1,1
	dpb 1,[POINT 7,(17),13]
	addi 1,1
	dpb 1,[POINT 7,(17),20]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,350700
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_uchar7_1
stack_scalars_uchar7_1:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_scalars_uchar7_2
stack_scalars_uchar7_2:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,2200
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_uchar7_3
stack_scalars_uchar7_3:
	add 17,[3,,3]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-2(17)
	tlo 1,2200
	movei 2,-1(17)
	tlo 2,2200
	movei 3,(17)
	tlo 3,2200
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_uchar7_4
stack_scalars_uchar7_4:
	add 17,[4,,4]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-3(17)
	tlo 1,2200
	movei 2,-2(17)
	tlo 2,2200
	movei 3,-1(17)
	tlo 3,2200
	movei 4,(17)
	tlo 4,2200
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_uchar7_5
stack_scalars_uchar7_5:
	add 17,[6,,6]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-5(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-4(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 1,-5(17)
	tlo 1,2200
	movei 2,-4(17)
	tlo 2,2200
	movei 3,-3(17)
	tlo 3,2200
	movei 4,-2(17)
	tlo 4,2200
	movei 6,-1(17)
	tlo 6,2200
	movem 6,(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_uchar7_1
stack_array_uchar7_1:
	add 17,[1,,1]
	move 4,17
	movei 3,0
	jumpe 3,%L2232
%L2231:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L2231
%L2232:
	dpb 1,4
	hrrz 1,17
	tlo 1,350700
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uchar7_2
stack_array_uchar7_2:
	add 17,[1,,1]
	movei 2,0
	movei 6,(17)
	tlo 6,350700
%L2248:
	move 4,6
	move 3,2
	jumple 2,%L2245
%L2244:
	ibp 4
	sojg 3,%L2244	; decrement_and_branch_until_zero
%L2245:
	jumpe 3,%L2247
%L2246:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L2246
%L2247:
	dpb 1,4
	addi 1,1
	addi 2,1
	caig 2,1
	jrst %L2248
	movei 1,(17)
	tlo 1,350700
	move 2,1
	ibp 2
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uchar7_3
stack_array_uchar7_3:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,350700
	movei 6,2
%L2274:
	move 4,7
	move 3,2
	jumple 2,%L2262
%L2261:
	ibp 4
	sojg 3,%L2261	; decrement_and_branch_until_zero
%L2262:
	jumpe 3,%L2264
%L2263:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L2263
%L2264:
	dpb 1,4
	addi 1,1
	addi 2,1
	sojge 6,%L2274	; doloop_end
	movei 1,(17)
	tlo 1,350700
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uchar7_4
stack_array_uchar7_4:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,350700
	movei 6,3
%L2296:
	move 4,7
	move 3,2
	jumple 2,%L2282
%L2281:
	ibp 4
	sojg 3,%L2281	; decrement_and_branch_until_zero
%L2282:
	jumpe 3,%L2284
%L2283:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L2283
%L2284:
	dpb 1,4
	addi 1,1
	addi 2,1
	sojge 6,%L2296	; doloop_end
	movei 1,(17)
	tlo 1,350700
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uchar7_5
stack_array_uchar7_5:
	add 17,[3,,3]
	movei 2,0
	movei 7,-2(17)
	tlo 7,350700
	movei 6,4
%L2315:
	move 4,7
	move 3,2
	jumple 2,%L2304
%L2303:
	ibp 4
	sojg 3,%L2303	; decrement_and_branch_until_zero
%L2304:
	jumpe 3,%L2306
%L2305:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L2305
%L2306:
	dpb 1,4
	addi 1,1
	addi 2,1
	sojge 6,%L2315	; doloop_end
	movei 1,-2(17)
	tlo 1,350700
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	move 6,4
	ibp 6
	movem 6,(17)
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_ptr_walk_uchar7
stack_ptr_walk_uchar7:
	add 17,[3,,3]
	movem 10,-2(17)
	movei 2,0
	movei 7,-1(17)
	tlo 7,350700
	movei 6,5
%L2331:
	move 4,7
	move 3,2
	jumple 2,%L2323
%L2322:
	ibp 4
	sojg 3,%L2322	; decrement_and_branch_until_zero
%L2323:
	jumpe 3,%L2325
%L2324:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L2324
%L2325:
	dpb 1,4
	addi 1,1
	addi 2,1
	sojge 6,%L2331	; doloop_end
	movei 10,-1(17)
	tlo 10,350700
	move 1,10
	addi 1,1
	move 2,10
	ibp 2
	ibp 2
	ibp 2
	ibp 2
	move 3,10
	ibp 3
	ibp 3
	ibp 3
	move 4,10
	pushj 17,bar
	move 2,10
	ibp 2
	move 3,2
	ibp 3
	ibp 3
	move 1,10
	aos 4,10
	pushj 17,bar
	move 10,-2(17)
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_struct_uchar7
stack_struct_uchar7:
	add 17,[5,,5]
	movem 1,-4(17)
	addi 1,1
	dpb 1,[POINT 7,-4(17),20]
	addi 1,1
	dpb 1,[POINT 7,-4(17),33]
	subi 1,2
	move 3,1
	addi 3,3
	ldb 4,[POINT 2,3,30]
	dpb 4,[POINT 2,-4(17),35]
	lsh 3,37
	move 4,-3(17)
	tlz 4,760000
	ior 4,3
	movem 4,-3(17)
	addi 1,4
	dpb 1,[POINT 7,-3(17),11]
	subi 1,4
	move 4,1
	addi 4,5
	lsh 4,10
	andi 4,377400
	movem 4,-3(17)
	lsh 1,33
	add 1,[6000000000]
	movem 1,-2(17)
	ldb 4,[POINT 7,-3(17),11]
	movem 4,-1(17)
	movei 4,-1(17)
	tlo 4,2200
	move 6,[POINT 7,2(<fp>),6]
	movem 6,(17)
	move 1,[POINT 7,<fp>,15]
	move 2,[POINT 7,<fp>,22]
	move 3,[POINT 7,<fp>,29]
	pushj 17,bar
	add 17,[-5,,-5]
	popj 17,

	.globl	stack_volatile_uchar7
stack_volatile_uchar7:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	movem 4,-1(17)
	addi 1,1
	dpb 1,[POINT 7,(17),6]
	addi 1,1
	dpb 1,[POINT 7,(17),13]
	addi 1,1
	dpb 1,[POINT 7,(17),20]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,350700
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_char8_1
stack_scalars_char8_1:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_scalars_char8_2
stack_scalars_char8_2:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,2200
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_char8_3
stack_scalars_char8_3:
	add 17,[3,,3]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-2(17)
	tlo 1,2200
	movei 2,-1(17)
	tlo 2,2200
	movei 3,(17)
	tlo 3,2200
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_char8_4
stack_scalars_char8_4:
	add 17,[4,,4]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-3(17)
	tlo 1,2200
	movei 2,-2(17)
	tlo 2,2200
	movei 3,-1(17)
	tlo 3,2200
	movei 4,(17)
	tlo 4,2200
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_char8_5
stack_scalars_char8_5:
	add 17,[6,,6]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-5(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-4(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 1,-5(17)
	tlo 1,2200
	movei 2,-4(17)
	tlo 2,2200
	movei 3,-3(17)
	tlo 3,2200
	movei 4,-2(17)
	tlo 4,2200
	movei 6,-1(17)
	tlo 6,2200
	movem 6,(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_char8_1
stack_array_char8_1:
	add 17,[1,,1]
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,17
	dpb 1,4
	hrrz 1,17
	tlo 1,341000
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_char8_2
stack_array_char8_2:
	add 17,[1,,1]
	movei 2,0
	movei 6,(17)
	tlo 6,341000
%L2401:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,6
	jumpe 4,%L2400
%L2399:
	ibp 3
	sojn 4,%L2399	; decrement_and_branch_until_zero
%L2400:
	dpb 1,3
	addi 1,1
	addi 2,1
	caig 2,1
	jrst %L2401
	movei 1,(17)
	tlo 1,341000
	move 2,1
	ibp 2
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_char8_3
stack_array_char8_3:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,341000
	movei 6,2
%L2425:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L2415
%L2414:
	ibp 3
	sojn 4,%L2414	; decrement_and_branch_until_zero
%L2415:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L2425	; doloop_end
	movei 1,(17)
	tlo 1,341000
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_char8_4
stack_array_char8_4:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,341000
	movei 6,3
%L2445:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L2433
%L2432:
	ibp 3
	sojn 4,%L2432	; decrement_and_branch_until_zero
%L2433:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L2445	; doloop_end
	movei 1,(17)
	tlo 1,341000
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_char8_5
stack_array_char8_5:
	add 17,[3,,3]
	movei 2,0
	movei 7,-2(17)
	tlo 7,341000
	movei 6,4
%L2462:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L2453
%L2452:
	ibp 3
	sojn 4,%L2452	; decrement_and_branch_until_zero
%L2453:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L2462	; doloop_end
	movei 1,-2(17)
	tlo 1,341000
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	move 6,1
	addi 6,1
	movem 6,(17)
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_ptr_walk_char8
stack_ptr_walk_char8:
	add 17,[3,,3]
	movem 10,-2(17)
	movei 2,0
	movei 7,-1(17)
	tlo 7,341000
	movei 6,5
%L2476:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L2470
%L2469:
	ibp 3
	sojn 4,%L2469	; decrement_and_branch_until_zero
%L2470:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L2476	; doloop_end
	movei 10,-1(17)
	tlo 10,341000
	move 1,10
	addi 1,1
	ibp 1
	move 2,1
	subi 2,1
	ibp 2
	ibp 2
	ibp 2
	move 3,1
	subi 3,1
	ibp 3
	ibp 3
	move 4,1
	subi 4,2
	ibp 4
	ibp 4
	ibp 4
	pushj 17,bar
	move 2,10
	ibp 2
	move 3,2
	ibp 3
	ibp 3
	move 4,10
	addi 4,1
	ibp 4
	move 1,10
	pushj 17,bar
	move 10,-2(17)
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_struct_char8
stack_struct_char8:
	add 17,[5,,5]
	movem 1,-4(17)
	addi 1,1
	dpb 1,[POINT 8,-4(17),23]
	addi 1,1
	dpb 1,[POINT 8,-4(17),34]
	subi 1,2
	move 3,1
	addi 3,3
	ldb 4,[POINT 1,3,28]
	dpb 4,[POINT 1,-4(17),35]
	lsh 3,35
	move 4,-3(17)
	tlz 4,774000
	ior 4,3
	movem 4,-3(17)
	addi 1,4
	dpb 1,[POINT 8,-3(17),14]
	subi 1,4
	move 4,1
	addi 4,5
	lsh 4,4
	andi 4,17760
	movem 4,-3(17)
	lsh 1,33
	add 1,[6000000000]
	movem 1,-2(17)
	move 4,-3(17)
	lsh 4,7
	ash 4,-34
	movem 4,-1(17)
	movei 4,-1(17)
	tlo 4,2200
	move 6,[POINT 8,2(<fp>),7]
	movem 6,(17)
	move 1,[POINT 8,<fp>,16]
	move 2,[POINT 8,<fp>,24]
	move 3,[POINT 8,<fp>,32]
	pushj 17,bar
	add 17,[-5,,-5]
	popj 17,

	.globl	stack_volatile_char8
stack_volatile_char8:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	movem 4,-1(17)
	addi 1,1
	dpb 1,[POINT 8,(17),7]
	addi 1,1
	dpb 1,[POINT 8,(17),15]
	addi 1,1
	dpb 1,[POINT 8,(17),23]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,341000
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_uchar8_1
stack_scalars_uchar8_1:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_scalars_uchar8_2
stack_scalars_uchar8_2:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,2200
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_uchar8_3
stack_scalars_uchar8_3:
	add 17,[3,,3]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-2(17)
	tlo 1,2200
	movei 2,-1(17)
	tlo 2,2200
	movei 3,(17)
	tlo 3,2200
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_uchar8_4
stack_scalars_uchar8_4:
	add 17,[4,,4]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-3(17)
	tlo 1,2200
	movei 2,-2(17)
	tlo 2,2200
	movei 3,-1(17)
	tlo 3,2200
	movei 4,(17)
	tlo 4,2200
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_uchar8_5
stack_scalars_uchar8_5:
	add 17,[6,,6]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-5(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-4(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 1,-5(17)
	tlo 1,2200
	movei 2,-4(17)
	tlo 2,2200
	movei 3,-3(17)
	tlo 3,2200
	movei 4,-2(17)
	tlo 4,2200
	movei 6,-1(17)
	tlo 6,2200
	movem 6,(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_uchar8_1
stack_array_uchar8_1:
	add 17,[1,,1]
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,17
	dpb 1,4
	hrrz 1,17
	tlo 1,341000
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uchar8_2
stack_array_uchar8_2:
	add 17,[1,,1]
	movei 2,0
	movei 6,(17)
	tlo 6,341000
%L2546:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,6
	jumpe 4,%L2545
%L2544:
	ibp 3
	sojn 4,%L2544	; decrement_and_branch_until_zero
%L2545:
	dpb 1,3
	addi 1,1
	addi 2,1
	caig 2,1
	jrst %L2546
	movei 1,(17)
	tlo 1,341000
	move 2,1
	ibp 2
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uchar8_3
stack_array_uchar8_3:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,341000
	movei 6,2
%L2570:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L2560
%L2559:
	ibp 3
	sojn 4,%L2559	; decrement_and_branch_until_zero
%L2560:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L2570	; doloop_end
	movei 1,(17)
	tlo 1,341000
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uchar8_4
stack_array_uchar8_4:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,341000
	movei 6,3
%L2590:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L2578
%L2577:
	ibp 3
	sojn 4,%L2577	; decrement_and_branch_until_zero
%L2578:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L2590	; doloop_end
	movei 1,(17)
	tlo 1,341000
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uchar8_5
stack_array_uchar8_5:
	add 17,[3,,3]
	movei 2,0
	movei 7,-2(17)
	tlo 7,341000
	movei 6,4
%L2607:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L2598
%L2597:
	ibp 3
	sojn 4,%L2597	; decrement_and_branch_until_zero
%L2598:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L2607	; doloop_end
	movei 1,-2(17)
	tlo 1,341000
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	move 6,1
	addi 6,1
	movem 6,(17)
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_ptr_walk_uchar8
stack_ptr_walk_uchar8:
	add 17,[3,,3]
	movem 10,-2(17)
	movei 2,0
	movei 7,-1(17)
	tlo 7,341000
	movei 6,5
%L2621:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L2615
%L2614:
	ibp 3
	sojn 4,%L2614	; decrement_and_branch_until_zero
%L2615:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L2621	; doloop_end
	movei 10,-1(17)
	tlo 10,341000
	move 1,10
	addi 1,1
	ibp 1
	move 2,1
	subi 2,1
	ibp 2
	ibp 2
	ibp 2
	move 3,1
	subi 3,1
	ibp 3
	ibp 3
	move 4,1
	subi 4,2
	ibp 4
	ibp 4
	ibp 4
	pushj 17,bar
	move 2,10
	ibp 2
	move 3,2
	ibp 3
	ibp 3
	move 4,10
	addi 4,1
	ibp 4
	move 1,10
	pushj 17,bar
	move 10,-2(17)
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_struct_uchar8
stack_struct_uchar8:
	add 17,[5,,5]
	movem 1,-4(17)
	addi 1,1
	dpb 1,[POINT 8,-4(17),23]
	addi 1,1
	dpb 1,[POINT 8,-4(17),34]
	subi 1,2
	move 3,1
	addi 3,3
	ldb 4,[POINT 1,3,28]
	dpb 4,[POINT 1,-4(17),35]
	lsh 3,35
	move 4,-3(17)
	tlz 4,774000
	ior 4,3
	movem 4,-3(17)
	addi 1,4
	dpb 1,[POINT 8,-3(17),14]
	subi 1,4
	move 4,1
	addi 4,5
	lsh 4,4
	andi 4,17760
	movem 4,-3(17)
	lsh 1,33
	add 1,[6000000000]
	movem 1,-2(17)
	ldb 4,[POINT 8,-3(17),14]
	movem 4,-1(17)
	movei 4,-1(17)
	tlo 4,2200
	move 6,[POINT 8,2(<fp>),7]
	movem 6,(17)
	move 1,[POINT 8,<fp>,16]
	move 2,[POINT 8,<fp>,24]
	move 3,[POINT 8,<fp>,32]
	pushj 17,bar
	add 17,[-5,,-5]
	popj 17,

	.globl	stack_volatile_uchar8
stack_volatile_uchar8:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	movem 4,-1(17)
	addi 1,1
	dpb 1,[POINT 8,(17),7]
	addi 1,1
	dpb 1,[POINT 8,(17),15]
	addi 1,1
	dpb 1,[POINT 8,(17),23]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,341000
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_char9_1
stack_scalars_char9_1:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_scalars_char9_2
stack_scalars_char9_2:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,2200
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_char9_3
stack_scalars_char9_3:
	add 17,[3,,3]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-2(17)
	tlo 1,2200
	movei 2,-1(17)
	tlo 2,2200
	movei 3,(17)
	tlo 3,2200
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_char9_4
stack_scalars_char9_4:
	add 17,[4,,4]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-3(17)
	tlo 1,2200
	movei 2,-2(17)
	tlo 2,2200
	movei 3,-1(17)
	tlo 3,2200
	movei 4,(17)
	tlo 4,2200
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_char9_5
stack_scalars_char9_5:
	add 17,[6,,6]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-5(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-4(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 1,-5(17)
	tlo 1,2200
	movei 2,-4(17)
	tlo 2,2200
	movei 3,-3(17)
	tlo 3,2200
	movei 4,-2(17)
	tlo 4,2200
	movei 6,-1(17)
	tlo 6,2200
	movem 6,(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_char9_1
stack_array_char9_1:
	add 17,[1,,1]
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,17
	dpb 1,4
	hrrz 1,17
	tlo 1,331100
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_char9_2
stack_array_char9_2:
	add 17,[1,,1]
	movei 2,0
	movei 6,(17)
	tlo 6,331100
%L2691:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,6
	jumpe 4,%L2690
%L2689:
	ibp 3
	sojn 4,%L2689	; decrement_and_branch_until_zero
%L2690:
	dpb 1,3
	addi 1,1
	addi 2,1
	caig 2,1
	jrst %L2691
	movei 1,(17)
	tlo 1,331100
	move 2,1
	ibp 2
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_char9_3
stack_array_char9_3:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,331100
	movei 6,2
%L2715:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L2705
%L2704:
	ibp 3
	sojn 4,%L2704	; decrement_and_branch_until_zero
%L2705:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L2715	; doloop_end
	movei 1,(17)
	tlo 1,331100
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_char9_4
stack_array_char9_4:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,331100
	movei 6,3
%L2735:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L2723
%L2722:
	ibp 3
	sojn 4,%L2722	; decrement_and_branch_until_zero
%L2723:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L2735	; doloop_end
	movei 1,(17)
	tlo 1,331100
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_char9_5
stack_array_char9_5:
	add 17,[3,,3]
	movei 2,0
	movei 7,-2(17)
	tlo 7,331100
	movei 6,4
%L2752:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L2743
%L2742:
	ibp 3
	sojn 4,%L2742	; decrement_and_branch_until_zero
%L2743:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L2752	; doloop_end
	movei 1,-2(17)
	tlo 1,331100
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	move 6,1
	addi 6,1
	movem 6,(17)
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_ptr_walk_char9
stack_ptr_walk_char9:
	add 17,[3,,3]
	movem 10,-2(17)
	movei 2,0
	movei 7,-1(17)
	tlo 7,331100
	movei 6,5
%L2766:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L2760
%L2759:
	ibp 3
	sojn 4,%L2759	; decrement_and_branch_until_zero
%L2760:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L2766	; doloop_end
	movei 10,-1(17)
	tlo 10,331100
	move 1,10
	addi 1,1
	ibp 1
	move 2,1
	subi 2,1
	ibp 2
	ibp 2
	ibp 2
	move 3,1
	subi 3,1
	ibp 3
	ibp 3
	move 4,1
	subi 4,2
	ibp 4
	ibp 4
	ibp 4
	pushj 17,bar
	move 2,10
	ibp 2
	move 3,2
	ibp 3
	ibp 3
	move 4,10
	addi 4,1
	ibp 4
	move 1,10
	pushj 17,bar
	move 10,-2(17)
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_struct_char9
stack_struct_char9:
	add 17,[3,,3]
	movem 1,-2(17)
	addi 1,1
	dpb 1,[POINT 9,-2(17),17]
	addi 1,1
	dpb 1,[POINT 9,-2(17),26]
	addi 1,1
	dpb 1,[POINT 9,-2(17),35]
	addi 1,1
	movem 1,-1(17)
	addi 1,1
	dpb 1,[POINT 9,-1(17),17]
	addi 1,1
	dpb 1,[POINT 9,-1(17),26]
	move 6,[POINT 9,2(<fp>),8]
	movem 6,(17)
	move 1,[POINT 9,<fp>,17]
	move 2,[POINT 9,<fp>,26]
	movei 3,POINT 9,<fp>,35
	move 4,[POINT 9,1(<fp>),8]
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_volatile_char9
stack_volatile_char9:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	movem 4,-1(17)
	addi 1,1
	movem 1,(17)
	addi 1,1
	dpb 1,[POINT 9,(17),17]
	addi 1,1
	dpb 1,[POINT 9,(17),26]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,331100
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_uchar9_1
stack_scalars_uchar9_1:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_scalars_uchar9_2
stack_scalars_uchar9_2:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,2200
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_uchar9_3
stack_scalars_uchar9_3:
	add 17,[3,,3]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-2(17)
	tlo 1,2200
	movei 2,-1(17)
	tlo 2,2200
	movei 3,(17)
	tlo 3,2200
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_uchar9_4
stack_scalars_uchar9_4:
	add 17,[4,,4]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-1(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,-3(17)
	tlo 1,2200
	movei 2,-2(17)
	tlo 2,2200
	movei 3,-1(17)
	tlo 3,2200
	movei 4,(17)
	tlo 4,2200
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_uchar9_5
stack_scalars_uchar9_5:
	add 17,[6,,6]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-5(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-4(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-3(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-2(17),35]
	addi 1,1
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 1,-5(17)
	tlo 1,2200
	movei 2,-4(17)
	tlo 2,2200
	movei 3,-3(17)
	tlo 3,2200
	movei 4,-2(17)
	tlo 4,2200
	movei 6,-1(17)
	tlo 6,2200
	movem 6,(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_uchar9_1
stack_array_uchar9_1:
	add 17,[1,,1]
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,17
	dpb 1,4
	hrrz 1,17
	tlo 1,331100
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uchar9_2
stack_array_uchar9_2:
	add 17,[1,,1]
	movei 2,0
	movei 6,(17)
	tlo 6,331100
%L2835:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,6
	jumpe 4,%L2834
%L2833:
	ibp 3
	sojn 4,%L2833	; decrement_and_branch_until_zero
%L2834:
	dpb 1,3
	addi 1,1
	addi 2,1
	caig 2,1
	jrst %L2835
	movei 1,(17)
	tlo 1,331100
	move 2,1
	ibp 2
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uchar9_3
stack_array_uchar9_3:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,331100
	movei 6,2
%L2859:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L2849
%L2848:
	ibp 3
	sojn 4,%L2848	; decrement_and_branch_until_zero
%L2849:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L2859	; doloop_end
	movei 1,(17)
	tlo 1,331100
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uchar9_4
stack_array_uchar9_4:
	add 17,[1,,1]
	movei 2,0
	movei 7,(17)
	tlo 7,331100
	movei 6,3
%L2879:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L2867
%L2866:
	ibp 3
	sojn 4,%L2866	; decrement_and_branch_until_zero
%L2867:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L2879	; doloop_end
	movei 1,(17)
	tlo 1,331100
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uchar9_5
stack_array_uchar9_5:
	add 17,[3,,3]
	movei 2,0
	movei 7,-2(17)
	tlo 7,331100
	movei 6,4
%L2896:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L2887
%L2886:
	ibp 3
	sojn 4,%L2886	; decrement_and_branch_until_zero
%L2887:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L2896	; doloop_end
	movei 1,-2(17)
	tlo 1,331100
	move 2,1
	ibp 2
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	move 6,1
	addi 6,1
	movem 6,(17)
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_ptr_walk_uchar9
stack_ptr_walk_uchar9:
	add 17,[3,,3]
	movem 10,-2(17)
	movei 2,0
	movei 7,-1(17)
	tlo 7,331100
	movei 6,5
%L2910:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L2904
%L2903:
	ibp 3
	sojn 4,%L2903	; decrement_and_branch_until_zero
%L2904:
	dpb 1,3
	addi 1,1
	addi 2,1
	sojge 6,%L2910	; doloop_end
	movei 10,-1(17)
	tlo 10,331100
	move 1,10
	addi 1,1
	ibp 1
	move 2,1
	subi 2,1
	ibp 2
	ibp 2
	ibp 2
	move 3,1
	subi 3,1
	ibp 3
	ibp 3
	move 4,1
	subi 4,2
	ibp 4
	ibp 4
	ibp 4
	pushj 17,bar
	move 2,10
	ibp 2
	move 3,2
	ibp 3
	ibp 3
	move 4,10
	addi 4,1
	ibp 4
	move 1,10
	pushj 17,bar
	move 10,-2(17)
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_struct_uchar9
stack_struct_uchar9:
	add 17,[3,,3]
	movem 1,-2(17)
	addi 1,1
	dpb 1,[POINT 9,-2(17),17]
	addi 1,1
	dpb 1,[POINT 9,-2(17),26]
	addi 1,1
	dpb 1,[POINT 9,-2(17),35]
	addi 1,1
	movem 1,-1(17)
	addi 1,1
	dpb 1,[POINT 9,-1(17),17]
	addi 1,1
	dpb 1,[POINT 9,-1(17),26]
	move 6,[POINT 9,2(<fp>),8]
	movem 6,(17)
	move 1,[POINT 9,<fp>,17]
	move 2,[POINT 9,<fp>,26]
	movei 3,POINT 9,<fp>,35
	move 4,[POINT 9,1(<fp>),8]
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_volatile_uchar9
stack_volatile_uchar9:
	add 17,[2,,2]
	move 4,1
	andi 4,777	; zero_extendqisi2
	movem 4,-1(17)
	addi 1,1
	movem 1,(17)
	addi 1,1
	dpb 1,[POINT 9,(17),17]
	addi 1,1
	dpb 1,[POINT 9,(17),26]
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,331100
	move 3,2
	ibp 3
	move 4,3
	ibp 4
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_short16_1
stack_scalars_short16_1:
	add 17,[1,,1]
	hrrm 1,(17)
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_scalars_short16_2
stack_scalars_short16_2:
	add 17,[2,,2]
	hrrm 1,-1(17)
	movei 1,1(1)
	hrrm 1,(17)
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,2200
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_short16_3
stack_scalars_short16_3:
	add 17,[3,,3]
	hrrm 1,-2(17)
	movei 4,1(1)
	hrrm 4,-1(17)
	movei 1,2(1)
	hrrm 1,(17)
	movei 1,-2(17)
	tlo 1,2200
	movei 2,-1(17)
	tlo 2,2200
	movei 3,(17)
	tlo 3,2200
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_short16_4
stack_scalars_short16_4:
	add 17,[4,,4]
	hrrm 1,-3(17)
	movei 4,1(1)
	hrrm 4,-2(17)
	movei 4,2(1)
	hrrm 4,-1(17)
	movei 1,3(1)
	hrrm 1,(17)
	movei 1,-3(17)
	tlo 1,2200
	movei 2,-2(17)
	tlo 2,2200
	movei 3,-1(17)
	tlo 3,2200
	movei 4,(17)
	tlo 4,2200
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_short16_5
stack_scalars_short16_5:
	add 17,[6,,6]
	hrrm 1,-5(17)
	movei 4,1(1)
	hrrm 4,-4(17)
	movei 4,2(1)
	hrrm 4,-3(17)
	movei 4,3(1)
	hrrm 4,-2(17)
	movei 1,4(1)
	hrrm 1,-1(17)
	movei 1,-5(17)
	tlo 1,2200
	movei 2,-4(17)
	tlo 2,2200
	movei 3,-3(17)
	tlo 3,2200
	movei 4,-2(17)
	tlo 4,2200
	movei 6,-1(17)
	tlo 6,2200
	movem 6,(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_short16_1
stack_array_short16_1:
	add 17,[1,,1]
	movei 3,0
	movei 4,(17)
	tlo 4,222200
	ash 3,-1	; ashrsi3_pointer
	add 4,3
	dpb 1,4	; movhi
	movei 1,(17)
	tlo 1,222200
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_short16_2
stack_array_short16_2:
	add 17,[1,,1]
	movei 2,0
	movei 6,(17)
	tlo 6,222200
%L2980:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,6
	jumpe 4,%L2979
%L2978:
	ibp 3
	sojn 4,%L2978	; decrement_and_branch_until_zero
%L2979:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	caig 2,1
	jrst %L2980
	movei 1,(17)
	tlo 1,222200
	move 2,1
	ibp 2
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_short16_3
stack_array_short16_3:
	add 17,[2,,2]
	movei 2,0
	movei 7,-1(17)
	tlo 7,222200
	movei 6,2
%L3004:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L2994
%L2993:
	ibp 3
	sojn 4,%L2993	; decrement_and_branch_until_zero
%L2994:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	sojge 6,%L3004	; doloop_end
	movei 3,-1(17)
	tlo 3,222200
	move 2,3
	ibp 2
	move 1,3
	addi 3,1
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_array_short16_4
stack_array_short16_4:
	add 17,[2,,2]
	movei 2,0
	movei 7,-1(17)
	tlo 7,222200
	movei 6,3
%L3024:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L3012
%L3011:
	ibp 3
	sojn 4,%L3011	; decrement_and_branch_until_zero
%L3012:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	sojge 6,%L3024	; doloop_end
	movei 1,-1(17)
	tlo 1,222200
	move 2,1
	ibp 2
	move 3,1
	aos 4,3
	ibp 4
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_array_short16_5
stack_array_short16_5:
	add 17,[4,,4]
	movei 2,0
	movei 7,-3(17)
	tlo 7,222200
	movei 6,4
%L3041:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L3032
%L3031:
	ibp 3
	sojn 4,%L3031	; decrement_and_branch_until_zero
%L3032:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	sojge 6,%L3041	; doloop_end
	movei 1,-3(17)
	tlo 1,222200
	move 2,1
	ibp 2
	move 3,1
	aos 4,3
	ibp 4
	move 6,1
	addi 6,2
	movem 6,(17)
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_ptr_walk_short16
stack_ptr_walk_short16:
	add 17,[4,,4]
	movem 10,-3(17)
	movei 2,0
	movei 7,-2(17)
	tlo 7,222200
	movei 6,5
%L3055:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L3049
%L3048:
	ibp 3
	sojn 4,%L3048	; decrement_and_branch_until_zero
%L3049:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	sojge 6,%L3055	; doloop_end
	movei 10,-2(17)
	tlo 10,222200
	move 3,10
	addi 3,2
	ibp 3
	move 2,3
	subi 2,1
	ibp 2
	move 4,3
	subi 4,3
	ibp 4
	move 1,3
	subi 3,1
	pushj 17,bar
	move 2,10
	ibp 2
	move 3,10
	addi 3,1
	ibp 3
	move 4,10
	addi 4,2
	ibp 4
	move 1,10
	pushj 17,bar
	move 10,-3(17)
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_struct_short16
stack_struct_short16:
	add 17,[7,,7]
	movem 1,-6(17)
	addi 1,1
	dpb 1,[POINT 16,-6(17),31]
	addi 1,1
	dpb 1,[POINT 16,-5(17),15]
	addi 1,1
	dpb 1,[POINT 16,-5(17),31]
	addi 1,1
	dpb 1,[POINT 16,-4(17),15]
	addi 1,1
	dpb 1,[POINT 16,-4(17),31]
	subi 1,5
	lsh 1,33
	add 1,[6000000000]
	movem 1,-3(17)
	move 4,-5(17)
	ash 4,-24
	movem 4,-2(17)
	movei 2,-2(17)
	tlo 2,2200
	move 4,-4(17)
	ash 4,-24
	movem 4,-1(17)
	movei 4,-1(17)
	tlo 4,2200
	move 6,[POINT 18,3(<fp>),17]
	movem 6,(17)
	move 1,[POINT 18,<fp>,26]
	move 3,[POINT 18,1(<fp>),26]
	pushj 17,bar
	add 17,[-7,,-7]
	popj 17,

	.globl	stack_volatile_short16
stack_volatile_short16:
	add 17,[3,,3]
	move 4,1
	hrrzi 4,(4)	; zero_extendhisi2
	movem 4,-2(17)
	addi 1,1
	dpb 1,[POINT 16,-1(17),15]
	addi 1,1
	dpb 1,[POINT 16,-1(17),31]
	addi 1,1
	dpb 1,[POINT 16,(17),15]
	movei 1,-2(17)
	tlo 1,2200
	movei 4,-1(17)
	tlo 4,222200
	move 3,4
	ibp 3
	move 2,4
	addi 4,1
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_ushort16_1
stack_scalars_ushort16_1:
	add 17,[1,,1]
	hrrm 1,(17)
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_scalars_ushort16_2
stack_scalars_ushort16_2:
	add 17,[2,,2]
	hrrm 1,-1(17)
	movei 1,1(1)
	hrrm 1,(17)
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,2200
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_ushort16_3
stack_scalars_ushort16_3:
	add 17,[3,,3]
	hrrm 1,-2(17)
	movei 4,1(1)
	hrrm 4,-1(17)
	movei 1,2(1)
	hrrm 1,(17)
	movei 1,-2(17)
	tlo 1,2200
	movei 2,-1(17)
	tlo 2,2200
	movei 3,(17)
	tlo 3,2200
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_ushort16_4
stack_scalars_ushort16_4:
	add 17,[4,,4]
	hrrm 1,-3(17)
	movei 4,1(1)
	hrrm 4,-2(17)
	movei 4,2(1)
	hrrm 4,-1(17)
	movei 1,3(1)
	hrrm 1,(17)
	movei 1,-3(17)
	tlo 1,2200
	movei 2,-2(17)
	tlo 2,2200
	movei 3,-1(17)
	tlo 3,2200
	movei 4,(17)
	tlo 4,2200
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_ushort16_5
stack_scalars_ushort16_5:
	add 17,[6,,6]
	hrrm 1,-5(17)
	movei 4,1(1)
	hrrm 4,-4(17)
	movei 4,2(1)
	hrrm 4,-3(17)
	movei 4,3(1)
	hrrm 4,-2(17)
	movei 1,4(1)
	hrrm 1,-1(17)
	movei 1,-5(17)
	tlo 1,2200
	movei 2,-4(17)
	tlo 2,2200
	movei 3,-3(17)
	tlo 3,2200
	movei 4,-2(17)
	tlo 4,2200
	movei 6,-1(17)
	tlo 6,2200
	movem 6,(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_ushort16_1
stack_array_ushort16_1:
	add 17,[1,,1]
	movei 3,0
	movei 4,(17)
	tlo 4,222200
	ash 3,-1	; ashrsi3_pointer
	add 4,3
	dpb 1,4	; movhi
	movei 1,(17)
	tlo 1,222200
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_ushort16_2
stack_array_ushort16_2:
	add 17,[1,,1]
	movei 2,0
	movei 6,(17)
	tlo 6,222200
%L3127:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,6
	jumpe 4,%L3126
%L3125:
	ibp 3
	sojn 4,%L3125	; decrement_and_branch_until_zero
%L3126:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	caig 2,1
	jrst %L3127
	movei 1,(17)
	tlo 1,222200
	move 2,1
	ibp 2
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_ushort16_3
stack_array_ushort16_3:
	add 17,[2,,2]
	movei 2,0
	movei 7,-1(17)
	tlo 7,222200
	movei 6,2
%L3151:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L3141
%L3140:
	ibp 3
	sojn 4,%L3140	; decrement_and_branch_until_zero
%L3141:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	sojge 6,%L3151	; doloop_end
	movei 3,-1(17)
	tlo 3,222200
	move 2,3
	ibp 2
	move 1,3
	addi 3,1
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_array_ushort16_4
stack_array_ushort16_4:
	add 17,[2,,2]
	movei 2,0
	movei 7,-1(17)
	tlo 7,222200
	movei 6,3
%L3171:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L3159
%L3158:
	ibp 3
	sojn 4,%L3158	; decrement_and_branch_until_zero
%L3159:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	sojge 6,%L3171	; doloop_end
	movei 1,-1(17)
	tlo 1,222200
	move 2,1
	ibp 2
	move 3,1
	aos 4,3
	ibp 4
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_array_ushort16_5
stack_array_ushort16_5:
	add 17,[4,,4]
	movei 2,0
	movei 7,-3(17)
	tlo 7,222200
	movei 6,4
%L3188:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L3179
%L3178:
	ibp 3
	sojn 4,%L3178	; decrement_and_branch_until_zero
%L3179:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	sojge 6,%L3188	; doloop_end
	movei 1,-3(17)
	tlo 1,222200
	move 2,1
	ibp 2
	move 3,1
	aos 4,3
	ibp 4
	move 6,1
	addi 6,2
	movem 6,(17)
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_ptr_walk_ushort16
stack_ptr_walk_ushort16:
	add 17,[4,,4]
	movem 10,-3(17)
	movei 2,0
	movei 7,-2(17)
	tlo 7,222200
	movei 6,5
%L3202:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L3196
%L3195:
	ibp 3
	sojn 4,%L3195	; decrement_and_branch_until_zero
%L3196:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	sojge 6,%L3202	; doloop_end
	movei 10,-2(17)
	tlo 10,222200
	move 3,10
	addi 3,2
	ibp 3
	move 2,3
	subi 2,1
	ibp 2
	move 4,3
	subi 4,3
	ibp 4
	move 1,3
	subi 3,1
	pushj 17,bar
	move 2,10
	ibp 2
	move 3,10
	addi 3,1
	ibp 3
	move 4,10
	addi 4,2
	ibp 4
	move 1,10
	pushj 17,bar
	move 10,-3(17)
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_struct_ushort16
stack_struct_ushort16:
	add 17,[7,,7]
	movem 1,-6(17)
	addi 1,1
	dpb 1,[POINT 16,-6(17),31]
	addi 1,1
	dpb 1,[POINT 16,-5(17),15]
	addi 1,1
	dpb 1,[POINT 16,-5(17),31]
	addi 1,1
	dpb 1,[POINT 16,-4(17),15]
	addi 1,1
	dpb 1,[POINT 16,-4(17),31]
	subi 1,5
	lsh 1,33
	add 1,[6000000000]
	movem 1,-3(17)
	move 4,-5(17)
	lsh 4,-24
	hrrzm 4,-2(17)
	movei 2,-2(17)
	tlo 2,2200
	move 4,-4(17)
	lsh 4,-24
	hrrzm 4,-1(17)
	movei 4,-1(17)
	tlo 4,2200
	move 6,[POINT 18,3(<fp>),17]
	movem 6,(17)
	move 1,[POINT 18,<fp>,26]
	move 3,[POINT 18,1(<fp>),26]
	pushj 17,bar
	add 17,[-7,,-7]
	popj 17,

	.globl	stack_volatile_ushort16
stack_volatile_ushort16:
	add 17,[3,,3]
	move 4,1
	hrrzi 4,(4)	; zero_extendhisi2
	movem 4,-2(17)
	addi 1,1
	dpb 1,[POINT 16,-1(17),15]
	addi 1,1
	dpb 1,[POINT 16,-1(17),31]
	addi 1,1
	dpb 1,[POINT 16,(17),15]
	movei 1,-2(17)
	tlo 1,2200
	movei 4,-1(17)
	tlo 4,222200
	move 3,4
	ibp 3
	move 2,4
	addi 4,1
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_short18_1
stack_scalars_short18_1:
	add 17,[1,,1]
	hrrm 1,(17)
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_scalars_short18_2
stack_scalars_short18_2:
	add 17,[2,,2]
	hrrm 1,-1(17)
	movei 1,1(1)
	hrrm 1,(17)
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,2200
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_short18_3
stack_scalars_short18_3:
	add 17,[3,,3]
	hrrm 1,-2(17)
	movei 4,1(1)
	hrrm 4,-1(17)
	movei 1,2(1)
	hrrm 1,(17)
	movei 1,-2(17)
	tlo 1,2200
	movei 2,-1(17)
	tlo 2,2200
	movei 3,(17)
	tlo 3,2200
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_short18_4
stack_scalars_short18_4:
	add 17,[4,,4]
	hrrm 1,-3(17)
	movei 4,1(1)
	hrrm 4,-2(17)
	movei 4,2(1)
	hrrm 4,-1(17)
	movei 1,3(1)
	hrrm 1,(17)
	movei 1,-3(17)
	tlo 1,2200
	movei 2,-2(17)
	tlo 2,2200
	movei 3,-1(17)
	tlo 3,2200
	movei 4,(17)
	tlo 4,2200
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_short18_5
stack_scalars_short18_5:
	add 17,[6,,6]
	hrrm 1,-5(17)
	movei 4,1(1)
	hrrm 4,-4(17)
	movei 4,2(1)
	hrrm 4,-3(17)
	movei 4,3(1)
	hrrm 4,-2(17)
	movei 1,4(1)
	hrrm 1,-1(17)
	movei 1,-5(17)
	tlo 1,2200
	movei 2,-4(17)
	tlo 2,2200
	movei 3,-3(17)
	tlo 3,2200
	movei 4,-2(17)
	tlo 4,2200
	movei 6,-1(17)
	tlo 6,2200
	movem 6,(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_short18_1
stack_array_short18_1:
	add 17,[1,,1]
	movei 4,0
	ash 4,-1	; ashrsi3_pointer
	add 4,17
	dpb 1,4	; movhi
	hrrz 1,17
	tlo 1,222200
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_short18_2
stack_array_short18_2:
	add 17,[1,,1]
	movei 2,0
	movei 6,(17)
	tlo 6,222200
%L3273:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,6
	jumpe 4,%L3272
%L3271:
	ibp 3
	sojn 4,%L3271	; decrement_and_branch_until_zero
%L3272:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	caig 2,1
	jrst %L3273
	movei 1,(17)
	tlo 1,222200
	move 2,1
	ibp 2
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_short18_3
stack_array_short18_3:
	add 17,[2,,2]
	movei 2,0
	movei 7,-1(17)
	tlo 7,222200
	movei 6,2
%L3297:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L3287
%L3286:
	ibp 3
	sojn 4,%L3286	; decrement_and_branch_until_zero
%L3287:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	sojge 6,%L3297	; doloop_end
	movei 3,-1(17)
	tlo 3,222200
	move 2,3
	ibp 2
	move 1,3
	addi 3,1
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_array_short18_4
stack_array_short18_4:
	add 17,[2,,2]
	movei 2,0
	movei 7,-1(17)
	tlo 7,222200
	movei 6,3
%L3317:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L3305
%L3304:
	ibp 3
	sojn 4,%L3304	; decrement_and_branch_until_zero
%L3305:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	sojge 6,%L3317	; doloop_end
	movei 1,-1(17)
	tlo 1,222200
	move 2,1
	ibp 2
	move 3,1
	aos 4,3
	ibp 4
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_array_short18_5
stack_array_short18_5:
	add 17,[4,,4]
	movei 2,0
	movei 7,-3(17)
	tlo 7,222200
	movei 6,4
%L3334:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L3325
%L3324:
	ibp 3
	sojn 4,%L3324	; decrement_and_branch_until_zero
%L3325:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	sojge 6,%L3334	; doloop_end
	movei 1,-3(17)
	tlo 1,222200
	move 2,1
	ibp 2
	move 3,1
	aos 4,3
	ibp 4
	move 6,1
	addi 6,2
	movem 6,(17)
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_ptr_walk_short18
stack_ptr_walk_short18:
	add 17,[4,,4]
	movem 10,-3(17)
	movei 2,0
	movei 7,-2(17)
	tlo 7,222200
	movei 6,5
%L3348:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L3342
%L3341:
	ibp 3
	sojn 4,%L3341	; decrement_and_branch_until_zero
%L3342:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	sojge 6,%L3348	; doloop_end
	movei 10,-2(17)
	tlo 10,222200
	move 3,10
	addi 3,2
	ibp 3
	move 2,3
	subi 2,1
	ibp 2
	move 4,3
	subi 4,3
	ibp 4
	move 1,3
	subi 3,1
	pushj 17,bar
	move 2,10
	ibp 2
	move 3,10
	addi 3,1
	ibp 3
	move 4,10
	addi 4,2
	ibp 4
	move 1,10
	pushj 17,bar
	move 10,-3(17)
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_struct_short18
stack_struct_short18:
	add 17,[5,,5]
	movem 1,-4(17)
	addi 1,1
	hrrm 1,-4(17)
	addi 1,1
	hrlm 1,-3(17)
	addi 1,1
	hrrm 1,-3(17)
	addi 1,1
	movem 1,-2(17)
	addi 1,1
	hrrm 1,-2(17)
	subi 1,5
	lsh 1,33
	add 1,[6000000000]
	movem 1,-1(17)
	movei 2,-3(17)
	tlo 2,2200
	movei 4,-2(17)
	tlo 4,2200
	move 6,[POINT 18,3(<fp>),17]
	movem 6,(17)
	move 1,[POINT 18,<fp>,26]
	move 3,[POINT 18,1(<fp>),26]
	pushj 17,bar
	add 17,[-5,,-5]
	popj 17,

	.globl	stack_volatile_short18
stack_volatile_short18:
	add 17,[3,,3]
	move 4,1
	hrrzi 4,(4)	; zero_extendhisi2
	movem 4,-2(17)
	addi 1,1
	movem 1,-1(17)
	addi 1,1
	hrrm 1,-1(17)
	addi 1,1
	hrlm 1,(17)
	movei 1,-2(17)
	tlo 1,2200
	movei 4,-1(17)
	tlo 4,222200
	move 3,4
	ibp 3
	move 2,4
	addi 4,1
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_ushort18_1
stack_scalars_ushort18_1:
	add 17,[1,,1]
	hrrm 1,(17)
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_scalars_ushort18_2
stack_scalars_ushort18_2:
	add 17,[2,,2]
	hrrm 1,-1(17)
	movei 1,1(1)
	hrrm 1,(17)
	movei 1,-1(17)
	tlo 1,2200
	movei 2,(17)
	tlo 2,2200
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_ushort18_3
stack_scalars_ushort18_3:
	add 17,[3,,3]
	hrrm 1,-2(17)
	movei 4,1(1)
	hrrm 4,-1(17)
	movei 1,2(1)
	hrrm 1,(17)
	movei 1,-2(17)
	tlo 1,2200
	movei 2,-1(17)
	tlo 2,2200
	movei 3,(17)
	tlo 3,2200
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_ushort18_4
stack_scalars_ushort18_4:
	add 17,[4,,4]
	hrrm 1,-3(17)
	movei 4,1(1)
	hrrm 4,-2(17)
	movei 4,2(1)
	hrrm 4,-1(17)
	movei 1,3(1)
	hrrm 1,(17)
	movei 1,-3(17)
	tlo 1,2200
	movei 2,-2(17)
	tlo 2,2200
	movei 3,-1(17)
	tlo 3,2200
	movei 4,(17)
	tlo 4,2200
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_ushort18_5
stack_scalars_ushort18_5:
	add 17,[6,,6]
	hrrm 1,-5(17)
	movei 4,1(1)
	hrrm 4,-4(17)
	movei 4,2(1)
	hrrm 4,-3(17)
	movei 4,3(1)
	hrrm 4,-2(17)
	movei 1,4(1)
	hrrm 1,-1(17)
	movei 1,-5(17)
	tlo 1,2200
	movei 2,-4(17)
	tlo 2,2200
	movei 3,-3(17)
	tlo 3,2200
	movei 4,-2(17)
	tlo 4,2200
	movei 6,-1(17)
	tlo 6,2200
	movem 6,(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_ushort18_1
stack_array_ushort18_1:
	add 17,[1,,1]
	movei 4,0
	ash 4,-1	; ashrsi3_pointer
	add 4,17
	dpb 1,4	; movhi
	hrrz 1,17
	tlo 1,222200
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_ushort18_2
stack_array_ushort18_2:
	add 17,[1,,1]
	movei 2,0
	movei 6,(17)
	tlo 6,222200
%L3419:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,6
	jumpe 4,%L3418
%L3417:
	ibp 3
	sojn 4,%L3417	; decrement_and_branch_until_zero
%L3418:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	caig 2,1
	jrst %L3419
	movei 1,(17)
	tlo 1,222200
	move 2,1
	ibp 2
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_ushort18_3
stack_array_ushort18_3:
	add 17,[2,,2]
	movei 2,0
	movei 7,-1(17)
	tlo 7,222200
	movei 6,2
%L3443:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L3433
%L3432:
	ibp 3
	sojn 4,%L3432	; decrement_and_branch_until_zero
%L3433:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	sojge 6,%L3443	; doloop_end
	movei 3,-1(17)
	tlo 3,222200
	move 2,3
	ibp 2
	move 1,3
	addi 3,1
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_array_ushort18_4
stack_array_ushort18_4:
	add 17,[2,,2]
	movei 2,0
	movei 7,-1(17)
	tlo 7,222200
	movei 6,3
%L3463:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L3451
%L3450:
	ibp 3
	sojn 4,%L3450	; decrement_and_branch_until_zero
%L3451:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	sojge 6,%L3463	; doloop_end
	movei 1,-1(17)
	tlo 1,222200
	move 2,1
	ibp 2
	move 3,1
	aos 4,3
	ibp 4
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_array_ushort18_5
stack_array_ushort18_5:
	add 17,[4,,4]
	movei 2,0
	movei 7,-3(17)
	tlo 7,222200
	movei 6,4
%L3480:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L3471
%L3470:
	ibp 3
	sojn 4,%L3470	; decrement_and_branch_until_zero
%L3471:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	sojge 6,%L3480	; doloop_end
	movei 1,-3(17)
	tlo 1,222200
	move 2,1
	ibp 2
	move 3,1
	aos 4,3
	ibp 4
	move 6,1
	addi 6,2
	movem 6,(17)
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_ptr_walk_ushort18
stack_ptr_walk_ushort18:
	add 17,[4,,4]
	movem 10,-3(17)
	movei 2,0
	movei 7,-2(17)
	tlo 7,222200
	movei 6,5
%L3494:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L3488
%L3487:
	ibp 3
	sojn 4,%L3487	; decrement_and_branch_until_zero
%L3488:
	dpb 1,3	; movhi
	addi 1,1
	addi 2,1
	sojge 6,%L3494	; doloop_end
	movei 10,-2(17)
	tlo 10,222200
	move 3,10
	addi 3,2
	ibp 3
	move 2,3
	subi 2,1
	ibp 2
	move 4,3
	subi 4,3
	ibp 4
	move 1,3
	subi 3,1
	pushj 17,bar
	move 2,10
	ibp 2
	move 3,10
	addi 3,1
	ibp 3
	move 4,10
	addi 4,2
	ibp 4
	move 1,10
	pushj 17,bar
	move 10,-3(17)
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_struct_ushort18
stack_struct_ushort18:
	add 17,[5,,5]
	movem 1,-4(17)
	addi 1,1
	hrrm 1,-4(17)
	addi 1,1
	hrlm 1,-3(17)
	addi 1,1
	hrrm 1,-3(17)
	addi 1,1
	movem 1,-2(17)
	addi 1,1
	hrrm 1,-2(17)
	subi 1,5
	lsh 1,33
	add 1,[6000000000]
	movem 1,-1(17)
	movei 2,-3(17)
	tlo 2,2200
	movei 4,-2(17)
	tlo 4,2200
	move 6,[POINT 18,3(<fp>),17]
	movem 6,(17)
	move 1,[POINT 18,<fp>,26]
	move 3,[POINT 18,1(<fp>),26]
	pushj 17,bar
	add 17,[-5,,-5]
	popj 17,

	.globl	stack_volatile_ushort18
stack_volatile_ushort18:
	add 17,[3,,3]
	move 4,1
	hrrzi 4,(4)	; zero_extendhisi2
	movem 4,-2(17)
	addi 1,1
	movem 1,-1(17)
	addi 1,1
	hrrm 1,-1(17)
	addi 1,1
	hrlm 1,(17)
	movei 1,-2(17)
	tlo 1,2200
	movei 4,-1(17)
	tlo 4,222200
	move 3,4
	ibp 3
	move 2,4
	addi 4,1
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_int32_1
stack_scalars_int32_1:
	add 17,[1,,1]
	movem 1,(17)
	movei 1,(17)
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_scalars_int32_2
stack_scalars_int32_2:
	add 17,[2,,2]
	movem 1,-1(17)
	addi 1,1
	movem 1,(17)
	movei 1,-1(17)
	movei 2,(17)
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_int32_3
stack_scalars_int32_3:
	add 17,[3,,3]
	movem 1,-2(17)
	move 6,1
	addi 6,1
	movem 6,-1(17)
	addi 1,2
	movem 1,(17)
	movei 1,-2(17)
	movei 2,-1(17)
	movei 3,(17)
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_int32_4
stack_scalars_int32_4:
	add 17,[4,,4]
	movem 1,-3(17)
	move 6,1
	addi 6,1
	movem 6,-2(17)
	addi 6,1
	movem 6,-1(17)
	addi 1,3
	movem 1,(17)
	movei 1,-3(17)
	movei 2,-2(17)
	movei 3,-1(17)
	movei 4,(17)
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_int32_5
stack_scalars_int32_5:
	add 17,[6,,6]
	movem 1,-4(17)
	move 6,1
	addi 6,1
	movem 6,-3(17)
	addi 6,1
	movem 6,-2(17)
	addi 6,1
	movem 6,-1(17)
	addi 1,4
	movem 1,-5(17)
	movei 4,-5(17)
	movem 4,(17)
	movei 1,-4(17)
	movei 2,-3(17)
	movei 3,-2(17)
	movei 4,-1(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_int32_1
stack_array_int32_1:
	add 17,[1,,1]
	movei 3,(17)
	movei 4,0
	jumpe 4,%L3554
%L3553:
	subi 3,1
	aojl 4,%L3553
%L3554:
	dpb 1,[POINT 32,(3),31]
	movei 1,(17)
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_int32_2
stack_array_int32_2:
	add 17,[2,,2]
	movei 2,0
	movei 6,-1(17)
	tlo 6,222200
%L3571:
	move 3,6
	move 4,2
	jumple 2,%L3568
%L3567:
	ibp 3
	sojg 4,%L3567	; decrement_and_branch_until_zero
%L3568:
	jumpe 4,%L3570
%L3569:
	subi 3,1
	aojl 4,%L3569
%L3570:
	dpb 1,[POINT 32,(3),31]
	addi 1,1
	addi 2,1
	caig 2,1
	jrst %L3571
	movei 2,-1(17)
	move 1,2
	addi 2,1
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_array_int32_3
stack_array_int32_3:
	add 17,[3,,3]
	movei 2,0
	movei 7,-2(17)
	tlo 7,222200
	movei 6,2
%L3598:
	move 3,7
	move 4,2
	jumple 2,%L3586
%L3585:
	ibp 3
	sojg 4,%L3585	; decrement_and_branch_until_zero
%L3586:
	jumpe 4,%L3588
%L3587:
	subi 3,1
	aojl 4,%L3587
%L3588:
	dpb 1,[POINT 32,(3),31]
	addi 1,1
	addi 2,1
	sojge 6,%L3598	; doloop_end
	movei 2,-2(17)
	move 3,2
	addi 3,2
	move 1,2
	addi 2,1
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_array_int32_4
stack_array_int32_4:
	add 17,[4,,4]
	movei 2,0
	movei 7,-3(17)
	tlo 7,222200
	movei 6,3
%L3621:
	move 3,7
	move 4,2
	jumple 2,%L3607
%L3606:
	ibp 3
	sojg 4,%L3606	; decrement_and_branch_until_zero
%L3607:
	jumpe 4,%L3609
%L3608:
	subi 3,1
	aojl 4,%L3608
%L3609:
	dpb 1,[POINT 32,(3),31]
	addi 1,1
	addi 2,1
	sojge 6,%L3621	; doloop_end
	movei 2,-3(17)
	move 3,2
	addi 3,2
	move 4,2
	addi 4,3
	move 1,2
	addi 2,1
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_array_int32_5
stack_array_int32_5:
	add 17,[6,,6]
	movei 2,0
	movei 7,-5(17)
	tlo 7,222200
	movei 6,4
%L3641:
	move 3,7
	move 4,2
	jumple 2,%L3630
%L3629:
	ibp 3
	sojg 4,%L3629	; decrement_and_branch_until_zero
%L3630:
	jumpe 4,%L3632
%L3631:
	subi 3,1
	aojl 4,%L3631
%L3632:
	dpb 1,[POINT 32,(3),31]
	addi 1,1
	addi 2,1
	sojge 6,%L3641	; doloop_end
	movei 2,-5(17)
	move 3,2
	addi 3,2
	move 4,2
	addi 4,3
	move 6,2
	addi 6,4
	movem 6,(17)
	move 1,2
	addi 2,1
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_ptr_walk_int32
stack_ptr_walk_int32:
	add 17,[10,,10]
	movem 10,-7(17)
	movem 11,-6(17)
	movei 2,0
	movei 7,-5(17)
	tlo 7,222200
	movei 6,5
%L3658:
	move 3,7
	move 4,2
	jumple 2,%L3650
%L3649:
	ibp 3
	sojg 4,%L3649	; decrement_and_branch_until_zero
%L3650:
	jumpe 4,%L3652
%L3651:
	subi 3,1
	aojl 4,%L3651
%L3652:
	dpb 1,[POINT 32,(3),31]
	addi 1,1
	addi 2,1
	sojge 6,%L3658	; doloop_end
	movei 10,-5(17)
	move 1,10
	addi 1,5
	move 2,10
	addi 2,4
	move 11,10
	addi 11,3
	move 3,11
	move 4,10
	pushj 17,bar
	move 4,10
	addi 4,5
	move 1,10
	aos 2,10
	move 3,11
	pushj 17,bar
	move 10,-7(17)
	move 11,-6(17)
	add 17,[-10,,-10]
	popj 17,

	.globl	stack_struct_int32
stack_struct_int32:
	add 17,[10,,10]
	move 4,1
	lsh 4,33
	movem 4,-7(17)
	move 4,1
	lsh 4,4
	addi 4,20
	movem 4,-6(17)
	addi 1,2
	dpb 1,[POINT 32,-5(17),31]
	addi 1,1
	dpb 1,[POINT 32,-4(17),31]
	addi 1,1
	dpb 1,[POINT 32,-3(17),31]
	addi 1,1
	dpb 1,[POINT 32,-2(17),31]
	addi 1,1
	movem 1,-1(17)
	movei 1,-7(17)
	move 4,1
	addi 4,2
	move 3,1
	addi 3,3
	move 6,1
	addi 6,5
	movem 6,(17)
	addi 1,1
	move 2,4
	addi 4,2
	pushj 17,bar
	add 17,[-10,,-10]
	popj 17,

	.globl	stack_volatile_int32
stack_volatile_int32:
	add 17,[4,,4]
	movem 1,-3(17)
	addi 1,1
	dpb 1,[POINT 32,-2(17),31]
	addi 1,1
	dpb 1,[POINT 32,-1(17),31]
	addi 1,1
	dpb 1,[POINT 32,(17),31]
	movei 3,-2(17)
	move 4,3
	addi 4,2
	movei 1,-3(17)
	move 2,3
	addi 3,1
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_uint32_1
stack_scalars_uint32_1:
	add 17,[1,,1]
	movem 1,(17)
	movei 1,(17)
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_scalars_uint32_2
stack_scalars_uint32_2:
	add 17,[2,,2]
	movem 1,-1(17)
	addi 1,1
	movem 1,(17)
	movei 1,-1(17)
	movei 2,(17)
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_uint32_3
stack_scalars_uint32_3:
	add 17,[3,,3]
	movem 1,-2(17)
	move 6,1
	addi 6,1
	movem 6,-1(17)
	addi 1,2
	movem 1,(17)
	movei 1,-2(17)
	movei 2,-1(17)
	movei 3,(17)
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_uint32_4
stack_scalars_uint32_4:
	add 17,[4,,4]
	movem 1,-3(17)
	move 6,1
	addi 6,1
	movem 6,-2(17)
	addi 6,1
	movem 6,-1(17)
	addi 1,3
	movem 1,(17)
	movei 1,-3(17)
	movei 2,-2(17)
	movei 3,-1(17)
	movei 4,(17)
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_uint32_5
stack_scalars_uint32_5:
	add 17,[6,,6]
	movem 1,-4(17)
	move 6,1
	addi 6,1
	movem 6,-3(17)
	addi 6,1
	movem 6,-2(17)
	addi 6,1
	movem 6,-1(17)
	addi 1,4
	movem 1,-5(17)
	movei 4,-5(17)
	movem 4,(17)
	movei 1,-4(17)
	movei 2,-3(17)
	movei 3,-2(17)
	movei 4,-1(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_uint32_1
stack_array_uint32_1:
	add 17,[1,,1]
	movei 3,(17)
	movei 4,0
	jumpe 4,%L3729
%L3728:
	subi 3,1
	aojl 4,%L3728
%L3729:
	dpb 1,[POINT 32,(3),31]
	movei 1,(17)
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uint32_2
stack_array_uint32_2:
	add 17,[2,,2]
	movei 2,0
	movei 6,-1(17)
	tlo 6,222200
%L3746:
	move 3,6
	move 4,2
	jumple 2,%L3743
%L3742:
	ibp 3
	sojg 4,%L3742	; decrement_and_branch_until_zero
%L3743:
	jumpe 4,%L3745
%L3744:
	subi 3,1
	aojl 4,%L3744
%L3745:
	dpb 1,[POINT 32,(3),31]
	addi 1,1
	addi 2,1
	caig 2,1
	jrst %L3746
	movei 2,-1(17)
	move 1,2
	addi 2,1
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_array_uint32_3
stack_array_uint32_3:
	add 17,[3,,3]
	movei 2,0
	movei 7,-2(17)
	tlo 7,222200
	movei 6,2
%L3773:
	move 3,7
	move 4,2
	jumple 2,%L3761
%L3760:
	ibp 3
	sojg 4,%L3760	; decrement_and_branch_until_zero
%L3761:
	jumpe 4,%L3763
%L3762:
	subi 3,1
	aojl 4,%L3762
%L3763:
	dpb 1,[POINT 32,(3),31]
	addi 1,1
	addi 2,1
	sojge 6,%L3773	; doloop_end
	movei 2,-2(17)
	move 3,2
	addi 3,2
	move 1,2
	addi 2,1
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_array_uint32_4
stack_array_uint32_4:
	add 17,[4,,4]
	movei 2,0
	movei 7,-3(17)
	tlo 7,222200
	movei 6,3
%L3796:
	move 3,7
	move 4,2
	jumple 2,%L3782
%L3781:
	ibp 3
	sojg 4,%L3781	; decrement_and_branch_until_zero
%L3782:
	jumpe 4,%L3784
%L3783:
	subi 3,1
	aojl 4,%L3783
%L3784:
	dpb 1,[POINT 32,(3),31]
	addi 1,1
	addi 2,1
	sojge 6,%L3796	; doloop_end
	movei 2,-3(17)
	move 3,2
	addi 3,2
	move 4,2
	addi 4,3
	move 1,2
	addi 2,1
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_array_uint32_5
stack_array_uint32_5:
	add 17,[6,,6]
	movei 2,0
	movei 7,-5(17)
	tlo 7,222200
	movei 6,4
%L3816:
	move 3,7
	move 4,2
	jumple 2,%L3805
%L3804:
	ibp 3
	sojg 4,%L3804	; decrement_and_branch_until_zero
%L3805:
	jumpe 4,%L3807
%L3806:
	subi 3,1
	aojl 4,%L3806
%L3807:
	dpb 1,[POINT 32,(3),31]
	addi 1,1
	addi 2,1
	sojge 6,%L3816	; doloop_end
	movei 2,-5(17)
	move 3,2
	addi 3,2
	move 4,2
	addi 4,3
	move 6,2
	addi 6,4
	movem 6,(17)
	move 1,2
	addi 2,1
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_ptr_walk_uint32
stack_ptr_walk_uint32:
	add 17,[10,,10]
	movem 10,-7(17)
	movem 11,-6(17)
	movei 2,0
	movei 7,-5(17)
	tlo 7,222200
	movei 6,5
%L3833:
	move 3,7
	move 4,2
	jumple 2,%L3825
%L3824:
	ibp 3
	sojg 4,%L3824	; decrement_and_branch_until_zero
%L3825:
	jumpe 4,%L3827
%L3826:
	subi 3,1
	aojl 4,%L3826
%L3827:
	dpb 1,[POINT 32,(3),31]
	addi 1,1
	addi 2,1
	sojge 6,%L3833	; doloop_end
	movei 10,-5(17)
	move 1,10
	addi 1,5
	move 2,10
	addi 2,4
	move 11,10
	addi 11,3
	move 3,11
	move 4,10
	pushj 17,bar
	move 4,10
	addi 4,5
	move 1,10
	aos 2,10
	move 3,11
	pushj 17,bar
	move 10,-7(17)
	move 11,-6(17)
	add 17,[-10,,-10]
	popj 17,

	.globl	stack_struct_uint32
stack_struct_uint32:
	add 17,[10,,10]
	move 4,1
	lsh 4,33
	movem 4,-7(17)
	move 4,1
	lsh 4,4
	addi 4,20
	movem 4,-6(17)
	addi 1,2
	dpb 1,[POINT 32,-5(17),31]
	addi 1,1
	dpb 1,[POINT 32,-4(17),31]
	addi 1,1
	dpb 1,[POINT 32,-3(17),31]
	addi 1,1
	dpb 1,[POINT 32,-2(17),31]
	addi 1,1
	movem 1,-1(17)
	movei 1,-7(17)
	move 4,1
	addi 4,2
	move 3,1
	addi 3,3
	move 6,1
	addi 6,5
	movem 6,(17)
	addi 1,1
	move 2,4
	addi 4,2
	pushj 17,bar
	add 17,[-10,,-10]
	popj 17,

	.globl	stack_volatile_uint32
stack_volatile_uint32:
	add 17,[4,,4]
	movem 1,-3(17)
	addi 1,1
	dpb 1,[POINT 32,-2(17),31]
	addi 1,1
	dpb 1,[POINT 32,-1(17),31]
	addi 1,1
	dpb 1,[POINT 32,(17),31]
	movei 3,-2(17)
	move 4,3
	addi 4,2
	movei 1,-3(17)
	move 2,3
	addi 3,1
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_int36_1
stack_scalars_int36_1:
	add 17,[1,,1]
	movem 1,(17)
	movei 1,(17)
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_scalars_int36_2
stack_scalars_int36_2:
	add 17,[2,,2]
	movem 1,-1(17)
	addi 1,1
	movem 1,(17)
	movei 1,-1(17)
	movei 2,(17)
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_int36_3
stack_scalars_int36_3:
	add 17,[3,,3]
	movem 1,-2(17)
	move 6,1
	addi 6,1
	movem 6,-1(17)
	addi 1,2
	movem 1,(17)
	movei 1,-2(17)
	movei 2,-1(17)
	movei 3,(17)
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_int36_4
stack_scalars_int36_4:
	add 17,[4,,4]
	movem 1,-3(17)
	move 6,1
	addi 6,1
	movem 6,-2(17)
	addi 6,1
	movem 6,-1(17)
	addi 1,3
	movem 1,(17)
	movei 1,-3(17)
	movei 2,-2(17)
	movei 3,-1(17)
	movei 4,(17)
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_int36_5
stack_scalars_int36_5:
	add 17,[6,,6]
	movem 1,-4(17)
	move 6,1
	addi 6,1
	movem 6,-3(17)
	addi 6,1
	movem 6,-2(17)
	addi 6,1
	movem 6,-1(17)
	addi 1,4
	movem 1,-5(17)
	movei 4,-5(17)
	movem 4,(17)
	movei 1,-4(17)
	movei 2,-3(17)
	movei 3,-2(17)
	movei 4,-1(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_int36_1
stack_array_int36_1:
	add 17,[1,,1]
	movei 4,(17)
	movem 1,(4)
	move 1,4
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_int36_2
stack_array_int36_2:
	add 17,[2,,2]
	movei 2,-1(17)
	movem 1,(2)
	addi 1,1
	movem 1,1(2)
	move 1,2
	addi 2,1
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_array_int36_3
stack_array_int36_3:
	add 17,[3,,3]
	movei 3,-2(17)
	movei 4,2
%L3935:
	movem 1,(3)
	addi 3,1
	addi 1,1
	sojge 4,%L3935	; doloop_end
	movei 2,-2(17)
	move 3,2
	addi 3,2
	move 1,2
	addi 2,1
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_array_int36_4
stack_array_int36_4:
	add 17,[4,,4]
	movei 3,-3(17)
	movei 4,3
%L3952:
	movem 1,(3)
	addi 3,1
	addi 1,1
	sojge 4,%L3952	; doloop_end
	movei 2,-3(17)
	move 3,2
	addi 3,2
	move 4,2
	addi 4,3
	move 1,2
	addi 2,1
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_array_int36_5
stack_array_int36_5:
	add 17,[6,,6]
	movei 3,-5(17)
	movei 4,4
%L3966:
	movem 1,(3)
	addi 3,1
	addi 1,1
	sojge 4,%L3966	; doloop_end
	movei 2,-5(17)
	move 3,2
	addi 3,2
	move 4,2
	addi 4,3
	move 6,2
	addi 6,4
	movem 6,(17)
	move 1,2
	addi 2,1
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_ptr_walk_int36
stack_ptr_walk_int36:
	add 17,[10,,10]
	movem 10,-7(17)
	movem 11,-6(17)
	movei 3,-5(17)
	movei 4,5
%L3977:
	movem 1,(3)
	addi 3,1
	addi 1,1
	sojge 4,%L3977	; doloop_end
	movei 10,-5(17)
	move 1,10
	addi 1,5
	move 2,10
	addi 2,4
	move 11,10
	addi 11,3
	move 3,11
	move 4,10
	pushj 17,bar
	move 4,10
	addi 4,5
	move 1,10
	aos 2,10
	move 3,11
	pushj 17,bar
	move 10,-7(17)
	move 11,-6(17)
	add 17,[-10,,-10]
	popj 17,

	.globl	stack_struct_int36
stack_struct_int36:
	add 17,[10,,10]
	move 4,1
	lsh 4,33
	movem 4,-7(17)
	move 6,1
	addi 6,1
	movem 6,-6(17)
	addi 6,1
	movem 6,-5(17)
	addi 6,1
	movem 6,-4(17)
	addi 6,1
	movem 6,-3(17)
	addi 6,1
	movem 6,-2(17)
	addi 1,6
	movem 1,-1(17)
	movei 1,-7(17)
	move 4,1
	addi 4,2
	move 3,1
	addi 3,3
	move 6,1
	addi 6,5
	movem 6,(17)
	addi 1,1
	move 2,4
	addi 4,2
	pushj 17,bar
	add 17,[-10,,-10]
	popj 17,

	.globl	stack_volatile_int36
stack_volatile_int36:
	add 17,[4,,4]
	movem 1,-3(17)
	addi 1,1
	movem 1,-2(17)
	addi 1,1
	movem 1,-1(17)
	addi 1,1
	movem 1,(17)
	movei 3,-2(17)
	move 4,3
	addi 4,2
	movei 1,-3(17)
	move 2,3
	addi 3,1
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_uint36_1
stack_scalars_uint36_1:
	add 17,[1,,1]
	movem 1,(17)
	movei 1,(17)
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_scalars_uint36_2
stack_scalars_uint36_2:
	add 17,[2,,2]
	movem 1,-1(17)
	addi 1,1
	movem 1,(17)
	movei 1,-1(17)
	movei 2,(17)
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_scalars_uint36_3
stack_scalars_uint36_3:
	add 17,[3,,3]
	movem 1,-2(17)
	move 6,1
	addi 6,1
	movem 6,-1(17)
	addi 1,2
	movem 1,(17)
	movei 1,-2(17)
	movei 2,-1(17)
	movei 3,(17)
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_scalars_uint36_4
stack_scalars_uint36_4:
	add 17,[4,,4]
	movem 1,-3(17)
	move 6,1
	addi 6,1
	movem 6,-2(17)
	addi 6,1
	movem 6,-1(17)
	addi 1,3
	movem 1,(17)
	movei 1,-3(17)
	movei 2,-2(17)
	movei 3,-1(17)
	movei 4,(17)
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_scalars_uint36_5
stack_scalars_uint36_5:
	add 17,[6,,6]
	movem 1,-4(17)
	move 6,1
	addi 6,1
	movem 6,-3(17)
	addi 6,1
	movem 6,-2(17)
	addi 6,1
	movem 6,-1(17)
	addi 1,4
	movem 1,-5(17)
	movei 4,-5(17)
	movem 4,(17)
	movei 1,-4(17)
	movei 2,-3(17)
	movei 3,-2(17)
	movei 4,-1(17)
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_array_uint36_1
stack_array_uint36_1:
	add 17,[1,,1]
	movei 4,(17)
	movem 1,(4)
	move 1,4
	pushj 17,bar
	add 17,[-1,,-1]
	popj 17,

	.globl	stack_array_uint36_2
stack_array_uint36_2:
	add 17,[2,,2]
	movei 2,-1(17)
	movem 1,(2)
	addi 1,1
	movem 1,1(2)
	move 1,2
	addi 2,1
	pushj 17,bar
	add 17,[-2,,-2]
	popj 17,

	.globl	stack_array_uint36_3
stack_array_uint36_3:
	add 17,[3,,3]
	movei 3,-2(17)
	movei 4,2
%L4079:
	movem 1,(3)
	addi 3,1
	addi 1,1
	sojge 4,%L4079	; doloop_end
	movei 2,-2(17)
	move 3,2
	addi 3,2
	move 1,2
	addi 2,1
	pushj 17,bar
	add 17,[-3,,-3]
	popj 17,

	.globl	stack_array_uint36_4
stack_array_uint36_4:
	add 17,[4,,4]
	movei 3,-3(17)
	movei 4,3
%L4096:
	movem 1,(3)
	addi 3,1
	addi 1,1
	sojge 4,%L4096	; doloop_end
	movei 2,-3(17)
	move 3,2
	addi 3,2
	move 4,2
	addi 4,3
	move 1,2
	addi 2,1
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_array_uint36_5
stack_array_uint36_5:
	add 17,[6,,6]
	movei 3,-5(17)
	movei 4,4
%L4110:
	movem 1,(3)
	addi 3,1
	addi 1,1
	sojge 4,%L4110	; doloop_end
	movei 2,-5(17)
	move 3,2
	addi 3,2
	move 4,2
	addi 4,3
	move 6,2
	addi 6,4
	movem 6,(17)
	move 1,2
	addi 2,1
	pushj 17,bar
	add 17,[-6,,-6]
	popj 17,

	.globl	stack_ptr_walk_uint36
stack_ptr_walk_uint36:
	add 17,[10,,10]
	movem 10,-7(17)
	movem 11,-6(17)
	movei 3,-5(17)
	movei 4,5
%L4121:
	movem 1,(3)
	addi 3,1
	addi 1,1
	sojge 4,%L4121	; doloop_end
	movei 10,-5(17)
	move 1,10
	addi 1,5
	move 2,10
	addi 2,4
	move 11,10
	addi 11,3
	move 3,11
	move 4,10
	pushj 17,bar
	move 4,10
	addi 4,5
	move 1,10
	aos 2,10
	move 3,11
	pushj 17,bar
	move 10,-7(17)
	move 11,-6(17)
	add 17,[-10,,-10]
	popj 17,

	.globl	stack_struct_uint36
stack_struct_uint36:
	add 17,[10,,10]
	move 4,1
	lsh 4,33
	movem 4,-7(17)
	move 6,1
	addi 6,1
	movem 6,-6(17)
	addi 6,1
	movem 6,-5(17)
	addi 6,1
	movem 6,-4(17)
	addi 6,1
	movem 6,-3(17)
	addi 6,1
	movem 6,-2(17)
	addi 1,6
	movem 1,-1(17)
	movei 1,-7(17)
	move 4,1
	addi 4,2
	move 3,1
	addi 3,3
	move 6,1
	addi 6,5
	movem 6,(17)
	addi 1,1
	move 2,4
	addi 4,2
	pushj 17,bar
	add 17,[-10,,-10]
	popj 17,

	.globl	stack_volatile_uint36
stack_volatile_uint36:
	add 17,[4,,4]
	movem 1,-3(17)
	addi 1,1
	movem 1,-2(17)
	addi 1,1
	movem 1,-1(17)
	addi 1,1
	movem 1,(17)
	movei 3,-2(17)
	move 4,3
	addi 4,2
	movei 1,-3(17)
	move 2,3
	addi 3,1
	pushj 17,bar
	add 17,[-4,,-4]
	popj 17,

	.globl	stack_mixed_frame
stack_mixed_frame:
	add 17,[40,,40]
	move 4,1
	andi 4,777	; zero_extendqisi2
	dpb 4,[POINT 9,-37(17),35]
	addi 1,1
	move 4,1
	andi 4,777	; zero_extendqisi2
	subi 1,1
	dpb 4,[POINT 9,-36(17),35]
	movei 4,2(1)
	hrrm 4,-35(17)
	move 6,1
	addi 6,3
	movem 6,-2(17)
	move 3,1
	addi 3,4
	move 5,3
	ash 3,-43
	movem 3,-4(17)
	movei 6,-4(17)
	movem 5,1(6)
	addi 1,5
	dpb 1,[POINT 6,-34(17),5]
	addi 1,1
	dpb 1,[POINT 6,-33(17),5]
	addi 1,1
	dpb 1,[POINT 7,-32(17),6]
	addi 1,1
	dpb 1,[POINT 7,-31(17),6]
	addi 1,1
	dpb 1,[POINT 8,-30(17),7]
	addi 1,1
	dpb 1,[POINT 8,-27(17),7]
	addi 1,1
	movem 1,-26(17)
	addi 1,1
	movem 1,-25(17)
	addi 1,1
	movem 1,-24(17)
	addi 1,1
	hrlm 1,-23(17)
	move 7,-37(17)
	dpb 7,[POINT 9,-22(17),8]
	ldb 4,[POINT 9,-36(17),35]
	dpb 4,[POINT 9,-22(17),17]
	move 7,-35(17)
	hrrm 7,-22(17)
	move 7,-2(17)
	movem 7,-21(17)
	move 7,(6)
	movem 7,-20(17)
	move 7,1(6)
	movem 7,-17(17)
	move 4,-34(17)
	ash 4,-36
	dpb 4,[POINT 6,-16(17),5]
	move 4,-33(17)
	ash 4,-36
	dpb 4,[POINT 6,-15(17),5]
	move 4,-32(17)
	ash 4,-35
	dpb 4,[POINT 7,-15(17),15]
	move 4,-31(17)
	ash 4,-35
	dpb 4,[POINT 7,-14(17),15]
	move 4,-30(17)
	ash 4,-34
	dpb 4,[POINT 8,-14(17),25]
	move 4,-27(17)
	ash 4,-34
	dpb 4,[POINT 8,-13(17),25]
	ldb 4,[POINT 9,-26(17),8]
	dpb 4,[POINT 9,-13(17),35]
	ldb 4,[POINT 9,-25(17),8]
	dpb 4,[POINT 9,-12(17),35]
	move 7,-24(17)
	hllm 7,-11(17)
	hlrz 4,-23(17)
	movem 4,-10(17)
	movei 1,-37(17)
	tlo 1,2200
	movei 2,-36(17)
	tlo 2,2200
	movei 3,-35(17)
	tlo 3,2200
	movem 6,(17)
	movei 4,-2(17)
	pushj 17,bar
	movei 2,-34(17)
	tlo 2,360600
	movei 4,-32(17)
	tlo 4,350700
	movei 3,-30(17)
	tlo 3,341000
	movem 3,(17)
	addi 3,1
	movem 3,-1(17)
	move 1,2
	addi 2,1
	move 3,4
	addi 4,1
	pushj 17,bar
	movei 2,-26(17)
	tlo 2,331100
	movei 4,-24(17)
	tlo 4,222200
	move 1,2
	addi 2,1
	move 3,4
	addi 4,1
	pushj 17,bar
	movei 4,-22(17)
	move 6,4
	addi 6,2
	movem 6,(17)
	move 1,[POINT 9,15(<fp>),8]
	move 2,[POINT 9,15(<fp>),17]
	movei 3,POINT 18,15(<fp>),35
	addi 4,1
	pushj 17,bar
	move 4,-14(17)
	lsh 4,11
	ash 4,-35
	movem 4,-6(17)
	movei 4,-6(17)
	tlo 4,2200
	move 1,[POINT 6,20(<fp>),5]
	move 2,[POINT 6,21(<fp>),5]
	move 3,[POINT 7,22(<fp>),6]
	pushj 17,bar
	move 4,-13(17)
	lsh 4,22
	ash 4,-34
	movem 4,-5(17)
	movei 2,-5(17)
	tlo 2,2200
	move 7,[POINT 18,30(<fp>),17]
	movem 7,(17)
	move 6,[POINT 18,31(<fp>),17]
	movem 6,-1(17)
	move 1,[POINT 8,24(<fp>),7]
	move 3,[POINT 9,26(<fp>),8]
	move 4,[POINT 9,27(<fp>),8]
	pushj 17,bar
	add 17,[-40,,-40]
	popj 17,

	.globl	stack_address_values
stack_address_values:
	add 17,[37,,37]
	movem 16,-36(17)
	movei 0,-35(17)
	hrli 0,10
	blt 0,-30(17)
	setzm -11(17)
	setzm -10(17)
	setzm -7(17)
	setzm -6(17)
	setzm -5(17)
	setzm -4(17)
	movem 1,-27(17)
	addi 1,1
	movem 1,-26(17)
	addi 1,1
	movem 1,-25(17)
	addi 1,1
	movem 1,-23(17)
	subi 1,3
	move 3,1
	addi 3,4
	move 5,3
	ash 3,-43
	movem 3,-22(17)
	movem 5,-21(17)
	move 3,1
	addi 3,5
	move 5,3
	ash 3,-43
	movem 3,-16(17)
	movem 5,-15(17)
	addi 1,6
	movem 1,-14(17)
	addi 1,1
	movem 1,-13(17)
	movei 10,-27(17)
	tlo 10,331100
	move 16,10
	addi 16,1
	movei 11,-25(17)
	tlo 11,222200
	move 13,11
	addi 13,2
	movei 14,-22(17)
	move 15,14
	addi 15,4
	movei 12,-14(17)
	tlo 12,331100
	move 6,12
	addi 6,1
	movem 6,-12(17)
	movem 15,(17)
	movem 14,-1(17)
	movem 6,-2(17)
	movem 12,-3(17)
	move 1,16
	move 2,10
	move 3,13
	move 4,11
	pushj 17,bar
	sub 16,10
	movem 16,-11(17)
	move 6,16
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	pushj 17,use_int
	sub 13,11
	movem 13,-7(17)
	move 6,13
	muli 6,4
	move 1,7
	ash 1,-1
	add 1,%BADLH(6)
	pushj 17,use_int
	sub 15,14
	ash 15,-1
	move 1,15
	pushj 17,use_int
	move 7,-12(17)
	sub 7,12
	movem 7,-5(17)
	move 6,7
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	pushj 17,use_int
	move 16,-36(17)
	movei 0,10
	hrli 0,-35(17)
	blt 0,15
	add 17,[-37,,-37]
	popj 17,

	.globl	use_stackvar_pointers
use_stackvar_pointers:
	push 17,10
	move 10,1
	pushj 17,stack_scalars_Qint_5
	move 1,10
	pushj 17,stack_array_Qint_5
	move 1,10
	pushj 17,stack_ptr_walk_Qint
	move 1,10
	pushj 17,stack_struct_Qint
	move 1,10
	pushj 17,stack_volatile_Qint
	move 1,10
	pushj 17,stack_scalars_Hint_5
	move 1,10
	pushj 17,stack_array_Hint_5
	move 1,10
	pushj 17,stack_ptr_walk_Hint
	move 1,10
	pushj 17,stack_struct_Hint
	move 1,10
	pushj 17,stack_volatile_Hint
	move 1,10
	pushj 17,stack_scalars_Sint_5
	move 1,10
	pushj 17,stack_array_Sint_5
	move 1,10
	pushj 17,stack_ptr_walk_Sint
	move 1,10
	pushj 17,stack_struct_Sint
	move 1,10
	pushj 17,stack_volatile_Sint
	move 1,10
	pushj 17,stack_scalars_Dint_5
	move 1,10
	pushj 17,stack_array_Dint_5
	move 1,10
	pushj 17,stack_ptr_walk_Dint
	move 1,10
	pushj 17,stack_struct_Dint
	move 1,10
	pushj 17,stack_volatile_Dint
	move 1,10
	pushj 17,stack_scalars_char9_5
	move 1,10
	pushj 17,stack_array_char9_5
	move 1,10
	pushj 17,stack_ptr_walk_char9
	move 1,10
	pushj 17,stack_struct_char9
	move 1,10
	pushj 17,stack_volatile_char9
	move 1,10
	pushj 17,stack_scalars_short18_5
	move 1,10
	pushj 17,stack_array_short18_5
	move 1,10
	pushj 17,stack_ptr_walk_short18
	move 1,10
	pushj 17,stack_struct_short18
	move 1,10
	pushj 17,stack_volatile_short18
	move 1,10
	pushj 17,stack_mixed_frame
	move 1,10
	pop 17,10
	jrst stack_address_values

