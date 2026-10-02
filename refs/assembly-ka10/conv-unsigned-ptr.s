	.data
	.align	2
init_cc:
	.long	global_cc+301989888

arg_cc:
	jrst bar_cc

stack_cc:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar_cc
	add 17,[-1,,-1]
	popj 17,

global_call_cc:
	move 1,[POINT 18,global_cc,35]
	jrst bar_cc

array_call_cc:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_cc,8]
	jumpe 4,bar_cc
%L12:
	ibp 1
	sojn 4,%L12	; decrement_and_branch_until_zero
%L13:
	jrst bar_cc

ret_arg_cc:
	popj 17,

ret_global_cc:
	move 1,[POINT 18,global_cc,35]
	popj 17,

ret_array_cc:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_cc,8]
	jumpe 4,%L25
%L24:
	ibp 1
	sojn 4,%L24	; decrement_and_branch_until_zero
%L25:
	popj 17,

roundtrip_cc:
	popj 17,

void_bridge_cc:
	popj 17,

load_cast_cc:
	ldb 1,1
	popj 17,

load_global_cc:
	ldb 1,[POINT 18,global_cc,35]
	popj 17,

load_index_cc:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_cc,8]
	jumpe 4,%L37
%L36:
	ibp 3
	sojn 4,%L36	; decrement_and_branch_until_zero
%L37:
	ldb 1,3
	popj 17,

store_cast_cc:
	dpb 2,1
	popj 17,

store_index_cc:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_cc,8]
	jumpe 4,%L43
%L42:
	ibp 3
	sojn 4,%L42	; decrement_and_branch_until_zero
%L43:
	dpb 2,3
	popj 17,

plus_one_cc:
	ibp 1
	popj 17,

plus_index_cc:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L48
%L47:
	ibp 1
	sojn 4,%L47	; decrement_and_branch_until_zero
%L48:
	popj 17,

diff_const_cc:
	move 4,[110000000002]
	move 5,[0]
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

diff_index_cc:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_cc,8]
	jumpe 4,%L58
%L57:
	ibp 3
	sojn 4,%L57	; decrement_and_branch_until_zero
%L58:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 2,[POINT 9,array_cc,8]
	jumpe 4,%L62
%L61:
	ibp 2
	sojn 4,%L61	; decrement_and_branch_until_zero
%L62:
	move 6,3
	sub 6,2
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	popj 17,

compare_roundtrip_cc:
	movei 1,1
	popj 17,

volatile_reload_cc:
	movem 1,volatile_from_cc
	move 6,volatile_from_cc
	movem 6,volatile_to_cc
	move 1,volatile_to_cc
	popj 17,

use_all_cc:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 13,1
	move 12,2
	move 10,3
	pushj 17,volatile_reload_cc
	move 14,1
	move 1,13
	pushj 17,roundtrip_cc
	move 11,1
	move 2,10
	pushj 17,store_cast_cc
	addi 10,1
	move 1,12
	move 2,10
	pushj 17,store_index_cc
	move 1,11
	pushj 17,load_cast_cc
	move 10,1
	addb 10,sink
	pushj 17,load_global_cc
	add 10,1
	movem 10,sink
	move 1,12
	pushj 17,load_index_cc
	move 10,1
	addb 10,sink
	pushj 17,diff_const_cc
	add 10,1
	movem 10,sink
	move 1,12
	movei 2,1
	pushj 17,diff_index_cc
	move 10,1
	add 10,sink
	move 1,13
	pushj 17,compare_roundtrip_cc
	add 1,10
	movem 1,sink
	ldb 14,14
	add 1,14
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

	.data
	.align	2
init_uc:
	.long	global_uc+301989888

arg_uc:
	jrst bar_uc

stack_uc:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar_uc
	add 17,[-1,,-1]
	popj 17,

global_call_uc:
	move 1,[POINT 18,global_uc,35]
	jrst bar_uc

array_call_uc:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_uc,8]
	jumpe 4,bar_uc
%L87:
	ibp 1
	sojn 4,%L87	; decrement_and_branch_until_zero
%L88:
	jrst bar_uc

ret_arg_uc:
	popj 17,

ret_global_uc:
	move 1,[POINT 18,global_uc,35]
	popj 17,

ret_array_uc:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_uc,8]
	jumpe 4,%L104
%L103:
	ibp 1
	sojn 4,%L103	; decrement_and_branch_until_zero
%L104:
	popj 17,

roundtrip_uc:
	popj 17,

void_bridge_uc:
	popj 17,

load_cast_uc:
	ldb 1,1
	popj 17,

load_global_uc:
	ldb 1,[POINT 18,global_uc,35]
	popj 17,

load_index_uc:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_uc,8]
	jumpe 4,%L121
%L120:
	ibp 3
	sojn 4,%L120	; decrement_and_branch_until_zero
%L121:
	ldb 1,3
	popj 17,

store_cast_uc:
	dpb 2,1
	popj 17,

store_index_uc:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_uc,8]
	jumpe 4,%L129
%L128:
	ibp 3
	sojn 4,%L128	; decrement_and_branch_until_zero
%L129:
	dpb 2,3
	popj 17,

plus_one_uc:
	ibp 1
	popj 17,

plus_index_uc:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L136
%L135:
	ibp 1
	sojn 4,%L135	; decrement_and_branch_until_zero
%L136:
	popj 17,

diff_const_uc:
	move 4,[110000000002]
	move 5,[0]
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

diff_index_uc:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_uc,8]
	jumpe 4,%L149
%L148:
	ibp 3
	sojn 4,%L148	; decrement_and_branch_until_zero
%L149:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 2,[POINT 9,array_uc,8]
	jumpe 4,%L154
%L153:
	ibp 2
	sojn 4,%L153	; decrement_and_branch_until_zero
%L154:
	move 6,3
	sub 6,2
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	popj 17,

compare_roundtrip_uc:
	movei 1,1
	popj 17,

volatile_reload_uc:
	movem 1,volatile_from_uc
	move 6,volatile_from_uc
	movem 6,volatile_to_uc
	move 1,volatile_to_uc
	popj 17,

use_all_uc:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 13,1
	move 12,2
	move 10,3
	pushj 17,volatile_reload_uc
	move 14,1
	move 1,13
	pushj 17,roundtrip_uc
	move 11,1
	move 2,10
	pushj 17,store_cast_uc
	addi 10,1
	move 1,12
	move 2,10
	pushj 17,store_index_uc
	move 1,11
	pushj 17,load_cast_uc
	move 10,1
	addb 10,sink
	pushj 17,load_global_uc
	add 10,1
	movem 10,sink
	move 1,12
	pushj 17,load_index_uc
	move 10,1
	addb 10,sink
	pushj 17,diff_const_uc
	add 10,1
	movem 10,sink
	move 1,12
	movei 2,1
	pushj 17,diff_index_uc
	move 10,1
	add 10,sink
	move 1,13
	pushj 17,compare_roundtrip_uc
	add 1,10
	movem 1,sink
	ldb 14,14
	add 1,14
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

	.data
	.align	2
init_cu:
	.long	global_cu+301989888

arg_cu:
	jrst bar_cu

stack_cu:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar_cu
	add 17,[-1,,-1]
	popj 17,

global_call_cu:
	move 1,[POINT 18,global_cu,35]
	jrst bar_cu

array_call_cu:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_cu,8]
	jumpe 4,bar_cu
%L180:
	ibp 1
	sojn 4,%L180	; decrement_and_branch_until_zero
%L181:
	jrst bar_cu

ret_arg_cu:
	popj 17,

ret_global_cu:
	move 1,[POINT 18,global_cu,35]
	popj 17,

ret_array_cu:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_cu,8]
	jumpe 4,%L197
%L196:
	ibp 1
	sojn 4,%L196	; decrement_and_branch_until_zero
%L197:
	popj 17,

roundtrip_cu:
	popj 17,

void_bridge_cu:
	popj 17,

load_cast_cu:
	ldb 1,1
	popj 17,

load_global_cu:
	ldb 1,[POINT 18,global_cu,35]
	popj 17,

load_index_cu:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_cu,8]
	jumpe 4,%L214
%L213:
	ibp 3
	sojn 4,%L213	; decrement_and_branch_until_zero
%L214:
	ldb 1,3
	popj 17,

store_cast_cu:
	dpb 2,1
	popj 17,

store_index_cu:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_cu,8]
	jumpe 4,%L222
%L221:
	ibp 3
	sojn 4,%L221	; decrement_and_branch_until_zero
%L222:
	dpb 2,3
	popj 17,

plus_one_cu:
	ibp 1
	popj 17,

plus_index_cu:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L229
%L228:
	ibp 1
	sojn 4,%L228	; decrement_and_branch_until_zero
%L229:
	popj 17,

diff_const_cu:
	move 4,[110000000002]
	move 5,[0]
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

diff_index_cu:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_cu,8]
	jumpe 4,%L242
%L241:
	ibp 3
	sojn 4,%L241	; decrement_and_branch_until_zero
%L242:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 2,[POINT 9,array_cu,8]
	jumpe 4,%L247
%L246:
	ibp 2
	sojn 4,%L246	; decrement_and_branch_until_zero
%L247:
	move 6,3
	sub 6,2
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	popj 17,

compare_roundtrip_cu:
	movei 1,1
	popj 17,

volatile_reload_cu:
	movem 1,volatile_from_cu
	move 6,volatile_from_cu
	movem 6,volatile_to_cu
	move 1,volatile_to_cu
	popj 17,

use_all_cu:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 13,1
	move 12,2
	move 10,3
	pushj 17,volatile_reload_cu
	move 14,1
	move 1,13
	pushj 17,roundtrip_cu
	move 11,1
	move 2,10
	pushj 17,store_cast_cu
	addi 10,1
	move 1,12
	move 2,10
	pushj 17,store_index_cu
	move 1,11
	pushj 17,load_cast_cu
	move 10,1
	addb 10,sink
	pushj 17,load_global_cu
	add 10,1
	movem 10,sink
	move 1,12
	pushj 17,load_index_cu
	move 10,1
	addb 10,sink
	pushj 17,diff_const_cu
	add 10,1
	movem 10,sink
	move 1,12
	movei 2,1
	pushj 17,diff_index_cu
	move 10,1
	add 10,sink
	move 1,13
	pushj 17,compare_roundtrip_cu
	add 1,10
	movem 1,sink
	ldb 14,14
	add 1,14
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

	.data
	.align	2
init_uu:
	.long	global_uu+301989888

arg_uu:
	jrst bar_uu

stack_uu:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar_uu
	add 17,[-1,,-1]
	popj 17,

global_call_uu:
	move 1,[POINT 18,global_uu,35]
	jrst bar_uu

array_call_uu:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_uu,8]
	jumpe 4,bar_uu
%L266:
	ibp 1
	sojn 4,%L266	; decrement_and_branch_until_zero
%L267:
	jrst bar_uu

ret_arg_uu:
	popj 17,

ret_global_uu:
	move 1,[POINT 18,global_uu,35]
	popj 17,

ret_array_uu:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_uu,8]
	jumpe 4,%L279
%L278:
	ibp 1
	sojn 4,%L278	; decrement_and_branch_until_zero
%L279:
	popj 17,

roundtrip_uu:
	popj 17,

void_bridge_uu:
	popj 17,

load_cast_uu:
	ldb 1,1
	popj 17,

load_global_uu:
	ldb 1,[POINT 18,global_uu,35]
	popj 17,

load_index_uu:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_uu,8]
	jumpe 4,%L291
%L290:
	ibp 3
	sojn 4,%L290	; decrement_and_branch_until_zero
%L291:
	ldb 1,3
	popj 17,

store_cast_uu:
	dpb 2,1
	popj 17,

store_index_uu:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_uu,8]
	jumpe 4,%L297
%L296:
	ibp 3
	sojn 4,%L296	; decrement_and_branch_until_zero
%L297:
	dpb 2,3
	popj 17,

plus_one_uu:
	ibp 1
	popj 17,

plus_index_uu:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L302
%L301:
	ibp 1
	sojn 4,%L301	; decrement_and_branch_until_zero
%L302:
	popj 17,

diff_const_uu:
	move 4,[110000000002]
	move 5,[0]
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

diff_index_uu:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_uu,8]
	jumpe 4,%L312
%L311:
	ibp 3
	sojn 4,%L311	; decrement_and_branch_until_zero
%L312:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 2,[POINT 9,array_uu,8]
	jumpe 4,%L316
%L315:
	ibp 2
	sojn 4,%L315	; decrement_and_branch_until_zero
%L316:
	move 6,3
	sub 6,2
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	popj 17,

compare_roundtrip_uu:
	movei 1,1
	popj 17,

volatile_reload_uu:
	movem 1,volatile_from_uu
	move 6,volatile_from_uu
	movem 6,volatile_to_uu
	move 1,volatile_to_uu
	popj 17,

use_all_uu:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 13,1
	move 12,2
	move 10,3
	pushj 17,volatile_reload_uu
	move 14,1
	move 1,13
	pushj 17,roundtrip_uu
	move 11,1
	move 2,10
	pushj 17,store_cast_uu
	addi 10,1
	move 1,12
	move 2,10
	pushj 17,store_index_uu
	move 1,11
	pushj 17,load_cast_uu
	move 10,1
	addb 10,sink
	pushj 17,load_global_uu
	add 10,1
	movem 10,sink
	move 1,12
	pushj 17,load_index_uu
	move 10,1
	addb 10,sink
	pushj 17,diff_const_uu
	add 10,1
	movem 10,sink
	move 1,12
	movei 2,1
	pushj 17,diff_index_uu
	move 10,1
	add 10,sink
	move 1,13
	pushj 17,compare_roundtrip_uu
	add 1,10
	movem 1,sink
	ldb 14,14
	add 1,14
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

	.data
	.align	2
init_sc_c:
	.long	global_sc_c+301989888

arg_sc_c:
	jrst bar_sc_c

stack_sc_c:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar_sc_c
	add 17,[-1,,-1]
	popj 17,

global_call_sc_c:
	move 1,[POINT 18,global_sc_c,35]
	jrst bar_sc_c

array_call_sc_c:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_sc_c,8]
	jumpe 4,bar_sc_c
%L341:
	ibp 1
	sojn 4,%L341	; decrement_and_branch_until_zero
%L342:
	jrst bar_sc_c

ret_arg_sc_c:
	popj 17,

ret_global_sc_c:
	move 1,[POINT 18,global_sc_c,35]
	popj 17,

ret_array_sc_c:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_sc_c,8]
	jumpe 4,%L358
%L357:
	ibp 1
	sojn 4,%L357	; decrement_and_branch_until_zero
%L358:
	popj 17,

roundtrip_sc_c:
	popj 17,

void_bridge_sc_c:
	popj 17,

load_cast_sc_c:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

load_global_sc_c:
	ldb 1,[POINT 18,global_sc_c,35]
	trne 1,400
	orcmi 1,777
	popj 17,

load_index_sc_c:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_sc_c,8]
	jumpe 4,%L375
%L374:
	ibp 3
	sojn 4,%L374	; decrement_and_branch_until_zero
%L375:
	ldb 1,3
	trne 1,400
	orcmi 1,777
	popj 17,

store_cast_sc_c:
	dpb 2,1
	popj 17,

store_index_sc_c:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_sc_c,8]
	jumpe 4,%L383
%L382:
	ibp 3
	sojn 4,%L382	; decrement_and_branch_until_zero
%L383:
	dpb 2,3
	popj 17,

plus_one_sc_c:
	ibp 1
	popj 17,

plus_index_sc_c:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L390
%L389:
	ibp 1
	sojn 4,%L389	; decrement_and_branch_until_zero
%L390:
	popj 17,

diff_const_sc_c:
	move 4,[110000000002]
	move 5,[0]
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

diff_index_sc_c:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_sc_c,8]
	jumpe 4,%L403
%L402:
	ibp 3
	sojn 4,%L402	; decrement_and_branch_until_zero
%L403:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 2,[POINT 9,array_sc_c,8]
	jumpe 4,%L408
%L407:
	ibp 2
	sojn 4,%L407	; decrement_and_branch_until_zero
%L408:
	move 6,3
	sub 6,2
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	popj 17,

compare_roundtrip_sc_c:
	movei 1,1
	popj 17,

volatile_reload_sc_c:
	movem 1,volatile_from_sc_c
	move 6,volatile_from_sc_c
	movem 6,volatile_to_sc_c
	move 1,volatile_to_sc_c
	popj 17,

use_all_sc_c:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 13,1
	move 12,2
	move 10,3
	pushj 17,volatile_reload_sc_c
	move 14,1
	move 1,13
	pushj 17,roundtrip_sc_c
	move 11,1
	move 2,10
	pushj 17,store_cast_sc_c
	addi 10,1
	move 1,12
	move 2,10
	pushj 17,store_index_sc_c
	move 1,11
	pushj 17,load_cast_sc_c
	move 10,1
	addb 10,sink
	pushj 17,load_global_sc_c
	add 10,1
	movem 10,sink
	move 1,12
	pushj 17,load_index_sc_c
	move 10,1
	addb 10,sink
	pushj 17,diff_const_sc_c
	add 10,1
	movem 10,sink
	move 1,12
	movei 2,1
	pushj 17,diff_index_sc_c
	move 10,1
	add 10,sink
	move 1,13
	pushj 17,compare_roundtrip_sc_c
	move 4,1
	add 4,10
	movem 4,sink
	ldb 1,14
	trne 1,400
	orcmi 1,777
	add 1,4
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

	.data
	.align	2
init_c_sc:
	.long	global_c_sc+301989888

arg_c_sc:
	jrst bar_c_sc

stack_c_sc:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar_c_sc
	add 17,[-1,,-1]
	popj 17,

global_call_c_sc:
	move 1,[POINT 18,global_c_sc,35]
	jrst bar_c_sc

array_call_c_sc:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_c_sc,8]
	jumpe 4,bar_c_sc
%L434:
	ibp 1
	sojn 4,%L434	; decrement_and_branch_until_zero
%L435:
	jrst bar_c_sc

ret_arg_c_sc:
	popj 17,

ret_global_c_sc:
	move 1,[POINT 18,global_c_sc,35]
	popj 17,

ret_array_c_sc:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_c_sc,8]
	jumpe 4,%L451
%L450:
	ibp 1
	sojn 4,%L450	; decrement_and_branch_until_zero
%L451:
	popj 17,

roundtrip_c_sc:
	popj 17,

void_bridge_c_sc:
	popj 17,

load_cast_c_sc:
	ldb 1,1
	popj 17,

load_global_c_sc:
	ldb 1,[POINT 18,global_c_sc,35]
	popj 17,

load_index_c_sc:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_c_sc,8]
	jumpe 4,%L468
%L467:
	ibp 3
	sojn 4,%L467	; decrement_and_branch_until_zero
%L468:
	ldb 1,3
	popj 17,

store_cast_c_sc:
	dpb 2,1
	popj 17,

store_index_c_sc:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_c_sc,8]
	jumpe 4,%L476
%L475:
	ibp 3
	sojn 4,%L475	; decrement_and_branch_until_zero
%L476:
	dpb 2,3
	popj 17,

plus_one_c_sc:
	ibp 1
	popj 17,

plus_index_c_sc:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L483
%L482:
	ibp 1
	sojn 4,%L482	; decrement_and_branch_until_zero
%L483:
	popj 17,

diff_const_c_sc:
	move 4,[110000000002]
	move 5,[0]
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

diff_index_c_sc:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_c_sc,8]
	jumpe 4,%L496
%L495:
	ibp 3
	sojn 4,%L495	; decrement_and_branch_until_zero
%L496:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 2,[POINT 9,array_c_sc,8]
	jumpe 4,%L501
%L500:
	ibp 2
	sojn 4,%L500	; decrement_and_branch_until_zero
%L501:
	move 6,3
	sub 6,2
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	popj 17,

compare_roundtrip_c_sc:
	movei 1,1
	popj 17,

volatile_reload_c_sc:
	movem 1,volatile_from_c_sc
	move 6,volatile_from_c_sc
	movem 6,volatile_to_c_sc
	move 1,volatile_to_c_sc
	popj 17,

use_all_c_sc:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 13,1
	move 12,2
	move 10,3
	pushj 17,volatile_reload_c_sc
	move 14,1
	move 1,13
	pushj 17,roundtrip_c_sc
	move 11,1
	move 2,10
	pushj 17,store_cast_c_sc
	addi 10,1
	move 1,12
	move 2,10
	pushj 17,store_index_c_sc
	move 1,11
	pushj 17,load_cast_c_sc
	move 10,1
	addb 10,sink
	pushj 17,load_global_c_sc
	add 10,1
	movem 10,sink
	move 1,12
	pushj 17,load_index_c_sc
	move 10,1
	addb 10,sink
	pushj 17,diff_const_c_sc
	add 10,1
	movem 10,sink
	move 1,12
	movei 2,1
	pushj 17,diff_index_c_sc
	move 10,1
	add 10,sink
	move 1,13
	pushj 17,compare_roundtrip_c_sc
	add 1,10
	movem 1,sink
	ldb 14,14
	add 1,14
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

	.data
	.align	2
init_sc_uc:
	.long	global_sc_uc+301989888

arg_sc_uc:
	jrst bar_sc_uc

stack_sc_uc:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar_sc_uc
	add 17,[-1,,-1]
	popj 17,

global_call_sc_uc:
	move 1,[POINT 18,global_sc_uc,35]
	jrst bar_sc_uc

array_call_sc_uc:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_sc_uc,8]
	jumpe 4,bar_sc_uc
%L527:
	ibp 1
	sojn 4,%L527	; decrement_and_branch_until_zero
%L528:
	jrst bar_sc_uc

ret_arg_sc_uc:
	popj 17,

ret_global_sc_uc:
	move 1,[POINT 18,global_sc_uc,35]
	popj 17,

ret_array_sc_uc:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_sc_uc,8]
	jumpe 4,%L544
%L543:
	ibp 1
	sojn 4,%L543	; decrement_and_branch_until_zero
%L544:
	popj 17,

roundtrip_sc_uc:
	popj 17,

void_bridge_sc_uc:
	popj 17,

load_cast_sc_uc:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

load_global_sc_uc:
	ldb 1,[POINT 18,global_sc_uc,35]
	trne 1,400
	orcmi 1,777
	popj 17,

load_index_sc_uc:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_sc_uc,8]
	jumpe 4,%L561
%L560:
	ibp 3
	sojn 4,%L560	; decrement_and_branch_until_zero
%L561:
	ldb 1,3
	trne 1,400
	orcmi 1,777
	popj 17,

store_cast_sc_uc:
	dpb 2,1
	popj 17,

store_index_sc_uc:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_sc_uc,8]
	jumpe 4,%L569
%L568:
	ibp 3
	sojn 4,%L568	; decrement_and_branch_until_zero
%L569:
	dpb 2,3
	popj 17,

plus_one_sc_uc:
	ibp 1
	popj 17,

plus_index_sc_uc:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L576
%L575:
	ibp 1
	sojn 4,%L575	; decrement_and_branch_until_zero
%L576:
	popj 17,

diff_const_sc_uc:
	move 4,[110000000002]
	move 5,[0]
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

diff_index_sc_uc:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_sc_uc,8]
	jumpe 4,%L589
%L588:
	ibp 3
	sojn 4,%L588	; decrement_and_branch_until_zero
%L589:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 2,[POINT 9,array_sc_uc,8]
	jumpe 4,%L594
%L593:
	ibp 2
	sojn 4,%L593	; decrement_and_branch_until_zero
%L594:
	move 6,3
	sub 6,2
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	popj 17,

compare_roundtrip_sc_uc:
	movei 1,1
	popj 17,

volatile_reload_sc_uc:
	movem 1,volatile_from_sc_uc
	move 6,volatile_from_sc_uc
	movem 6,volatile_to_sc_uc
	move 1,volatile_to_sc_uc
	popj 17,

use_all_sc_uc:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 13,1
	move 12,2
	move 10,3
	pushj 17,volatile_reload_sc_uc
	move 14,1
	move 1,13
	pushj 17,roundtrip_sc_uc
	move 11,1
	move 2,10
	pushj 17,store_cast_sc_uc
	addi 10,1
	move 1,12
	move 2,10
	pushj 17,store_index_sc_uc
	move 1,11
	pushj 17,load_cast_sc_uc
	move 10,1
	addb 10,sink
	pushj 17,load_global_sc_uc
	add 10,1
	movem 10,sink
	move 1,12
	pushj 17,load_index_sc_uc
	move 10,1
	addb 10,sink
	pushj 17,diff_const_sc_uc
	add 10,1
	movem 10,sink
	move 1,12
	movei 2,1
	pushj 17,diff_index_sc_uc
	move 10,1
	add 10,sink
	move 1,13
	pushj 17,compare_roundtrip_sc_uc
	move 4,1
	add 4,10
	movem 4,sink
	ldb 1,14
	trne 1,400
	orcmi 1,777
	add 1,4
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

	.data
	.align	2
init_uc_sc:
	.long	global_uc_sc+301989888

arg_uc_sc:
	jrst bar_uc_sc

stack_uc_sc:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar_uc_sc
	add 17,[-1,,-1]
	popj 17,

global_call_uc_sc:
	move 1,[POINT 18,global_uc_sc,35]
	jrst bar_uc_sc

array_call_uc_sc:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_uc_sc,8]
	jumpe 4,bar_uc_sc
%L620:
	ibp 1
	sojn 4,%L620	; decrement_and_branch_until_zero
%L621:
	jrst bar_uc_sc

ret_arg_uc_sc:
	popj 17,

ret_global_uc_sc:
	move 1,[POINT 18,global_uc_sc,35]
	popj 17,

ret_array_uc_sc:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_uc_sc,8]
	jumpe 4,%L637
%L636:
	ibp 1
	sojn 4,%L636	; decrement_and_branch_until_zero
%L637:
	popj 17,

roundtrip_uc_sc:
	popj 17,

void_bridge_uc_sc:
	popj 17,

load_cast_uc_sc:
	ldb 1,1
	popj 17,

load_global_uc_sc:
	ldb 1,[POINT 18,global_uc_sc,35]
	popj 17,

load_index_uc_sc:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_uc_sc,8]
	jumpe 4,%L654
%L653:
	ibp 3
	sojn 4,%L653	; decrement_and_branch_until_zero
%L654:
	ldb 1,3
	popj 17,

store_cast_uc_sc:
	dpb 2,1
	popj 17,

store_index_uc_sc:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_uc_sc,8]
	jumpe 4,%L662
%L661:
	ibp 3
	sojn 4,%L661	; decrement_and_branch_until_zero
%L662:
	dpb 2,3
	popj 17,

plus_one_uc_sc:
	ibp 1
	popj 17,

plus_index_uc_sc:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L669
%L668:
	ibp 1
	sojn 4,%L668	; decrement_and_branch_until_zero
%L669:
	popj 17,

diff_const_uc_sc:
	move 4,[110000000002]
	move 5,[0]
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

diff_index_uc_sc:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_uc_sc,8]
	jumpe 4,%L682
%L681:
	ibp 3
	sojn 4,%L681	; decrement_and_branch_until_zero
%L682:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 2,[POINT 9,array_uc_sc,8]
	jumpe 4,%L687
%L686:
	ibp 2
	sojn 4,%L686	; decrement_and_branch_until_zero
%L687:
	move 6,3
	sub 6,2
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	popj 17,

compare_roundtrip_uc_sc:
	movei 1,1
	popj 17,

volatile_reload_uc_sc:
	movem 1,volatile_from_uc_sc
	move 6,volatile_from_uc_sc
	movem 6,volatile_to_uc_sc
	move 1,volatile_to_uc_sc
	popj 17,

use_all_uc_sc:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 13,1
	move 12,2
	move 10,3
	pushj 17,volatile_reload_uc_sc
	move 14,1
	move 1,13
	pushj 17,roundtrip_uc_sc
	move 11,1
	move 2,10
	pushj 17,store_cast_uc_sc
	addi 10,1
	move 1,12
	move 2,10
	pushj 17,store_index_uc_sc
	move 1,11
	pushj 17,load_cast_uc_sc
	move 10,1
	addb 10,sink
	pushj 17,load_global_uc_sc
	add 10,1
	movem 10,sink
	move 1,12
	pushj 17,load_index_uc_sc
	move 10,1
	addb 10,sink
	pushj 17,diff_const_uc_sc
	add 10,1
	movem 10,sink
	move 1,12
	movei 2,1
	pushj 17,diff_index_uc_sc
	move 10,1
	add 10,sink
	move 1,13
	pushj 17,compare_roundtrip_uc_sc
	add 1,10
	movem 1,sink
	ldb 14,14
	add 1,14
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

	.data
	.align	2
init_sc_sc:
	.long	global_sc_sc+301989888

arg_sc_sc:
	jrst bar_sc_sc

stack_sc_sc:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar_sc_sc
	add 17,[-1,,-1]
	popj 17,

global_call_sc_sc:
	move 1,[POINT 18,global_sc_sc,35]
	jrst bar_sc_sc

array_call_sc_sc:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_sc_sc,8]
	jumpe 4,bar_sc_sc
%L706:
	ibp 1
	sojn 4,%L706	; decrement_and_branch_until_zero
%L707:
	jrst bar_sc_sc

ret_arg_sc_sc:
	popj 17,

ret_global_sc_sc:
	move 1,[POINT 18,global_sc_sc,35]
	popj 17,

ret_array_sc_sc:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_sc_sc,8]
	jumpe 4,%L719
%L718:
	ibp 1
	sojn 4,%L718	; decrement_and_branch_until_zero
%L719:
	popj 17,

roundtrip_sc_sc:
	popj 17,

void_bridge_sc_sc:
	popj 17,

load_cast_sc_sc:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

load_global_sc_sc:
	ldb 1,[POINT 18,global_sc_sc,35]
	trne 1,400
	orcmi 1,777
	popj 17,

load_index_sc_sc:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_sc_sc,8]
	jumpe 4,%L731
%L730:
	ibp 3
	sojn 4,%L730	; decrement_and_branch_until_zero
%L731:
	ldb 1,3
	trne 1,400
	orcmi 1,777
	popj 17,

store_cast_sc_sc:
	dpb 2,1
	popj 17,

store_index_sc_sc:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_sc_sc,8]
	jumpe 4,%L737
%L736:
	ibp 3
	sojn 4,%L736	; decrement_and_branch_until_zero
%L737:
	dpb 2,3
	popj 17,

plus_one_sc_sc:
	ibp 1
	popj 17,

plus_index_sc_sc:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L742
%L741:
	ibp 1
	sojn 4,%L741	; decrement_and_branch_until_zero
%L742:
	popj 17,

diff_const_sc_sc:
	move 4,[110000000002]
	move 5,[0]
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

diff_index_sc_sc:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_sc_sc,8]
	jumpe 4,%L752
%L751:
	ibp 3
	sojn 4,%L751	; decrement_and_branch_until_zero
%L752:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 2,[POINT 9,array_sc_sc,8]
	jumpe 4,%L756
%L755:
	ibp 2
	sojn 4,%L755	; decrement_and_branch_until_zero
%L756:
	move 6,3
	sub 6,2
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	popj 17,

compare_roundtrip_sc_sc:
	movei 1,1
	popj 17,

volatile_reload_sc_sc:
	movem 1,volatile_from_sc_sc
	move 6,volatile_from_sc_sc
	movem 6,volatile_to_sc_sc
	move 1,volatile_to_sc_sc
	popj 17,

use_all_sc_sc:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 13,1
	move 12,2
	move 10,3
	pushj 17,volatile_reload_sc_sc
	move 14,1
	move 1,13
	pushj 17,roundtrip_sc_sc
	move 11,1
	move 2,10
	pushj 17,store_cast_sc_sc
	addi 10,1
	move 1,12
	move 2,10
	pushj 17,store_index_sc_sc
	move 1,11
	pushj 17,load_cast_sc_sc
	move 10,1
	addb 10,sink
	pushj 17,load_global_sc_sc
	add 10,1
	movem 10,sink
	move 1,12
	pushj 17,load_index_sc_sc
	move 10,1
	addb 10,sink
	pushj 17,diff_const_sc_sc
	add 10,1
	movem 10,sink
	move 1,12
	movei 2,1
	pushj 17,diff_index_sc_sc
	move 10,1
	add 10,sink
	move 1,13
	pushj 17,compare_roundtrip_sc_sc
	move 4,1
	add 4,10
	movem 4,sink
	ldb 1,14
	trne 1,400
	orcmi 1,777
	add 1,4
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

	.data
	.align	2
init_c9_u9:
	.long	global_c9_u9+301989888

arg_c9_u9:
	jrst bar_c9_u9

stack_c9_u9:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar_c9_u9
	add 17,[-1,,-1]
	popj 17,

global_call_c9_u9:
	move 1,[POINT 18,global_c9_u9,35]
	jrst bar_c9_u9

array_call_c9_u9:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_c9_u9,8]
	jumpe 4,bar_c9_u9
%L781:
	ibp 1
	sojn 4,%L781	; decrement_and_branch_until_zero
%L782:
	jrst bar_c9_u9

ret_arg_c9_u9:
	popj 17,

ret_global_c9_u9:
	move 1,[POINT 18,global_c9_u9,35]
	popj 17,

ret_array_c9_u9:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_c9_u9,8]
	jumpe 4,%L798
%L797:
	ibp 1
	sojn 4,%L797	; decrement_and_branch_until_zero
%L798:
	popj 17,

roundtrip_c9_u9:
	popj 17,

void_bridge_c9_u9:
	popj 17,

load_cast_c9_u9:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

load_global_c9_u9:
	ldb 1,[POINT 18,global_c9_u9,35]
	trne 1,400
	orcmi 1,777
	popj 17,

load_index_c9_u9:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_c9_u9,8]
	jumpe 4,%L815
%L814:
	ibp 3
	sojn 4,%L814	; decrement_and_branch_until_zero
%L815:
	ldb 1,3
	trne 1,400
	orcmi 1,777
	popj 17,

store_cast_c9_u9:
	dpb 2,1
	popj 17,

store_index_c9_u9:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_c9_u9,8]
	jumpe 4,%L823
%L822:
	ibp 3
	sojn 4,%L822	; decrement_and_branch_until_zero
%L823:
	dpb 2,3
	popj 17,

plus_one_c9_u9:
	ibp 1
	popj 17,

plus_index_c9_u9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L830
%L829:
	ibp 1
	sojn 4,%L829	; decrement_and_branch_until_zero
%L830:
	popj 17,

diff_const_c9_u9:
	move 4,[110000000002]
	move 5,[0]
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

diff_index_c9_u9:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_c9_u9,8]
	jumpe 4,%L843
%L842:
	ibp 3
	sojn 4,%L842	; decrement_and_branch_until_zero
%L843:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 2,[POINT 9,array_c9_u9,8]
	jumpe 4,%L848
%L847:
	ibp 2
	sojn 4,%L847	; decrement_and_branch_until_zero
%L848:
	move 6,3
	sub 6,2
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	popj 17,

compare_roundtrip_c9_u9:
	movei 1,1
	popj 17,

volatile_reload_c9_u9:
	movem 1,volatile_from_c9_u9
	move 6,volatile_from_c9_u9
	movem 6,volatile_to_c9_u9
	move 1,volatile_to_c9_u9
	popj 17,

use_all_c9_u9:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 13,1
	move 12,2
	move 10,3
	pushj 17,volatile_reload_c9_u9
	move 14,1
	move 1,13
	pushj 17,roundtrip_c9_u9
	move 11,1
	move 2,10
	pushj 17,store_cast_c9_u9
	addi 10,1
	move 1,12
	move 2,10
	pushj 17,store_index_c9_u9
	move 1,11
	pushj 17,load_cast_c9_u9
	move 10,1
	addb 10,sink
	pushj 17,load_global_c9_u9
	add 10,1
	movem 10,sink
	move 1,12
	pushj 17,load_index_c9_u9
	move 10,1
	addb 10,sink
	pushj 17,diff_const_c9_u9
	add 10,1
	movem 10,sink
	move 1,12
	movei 2,1
	pushj 17,diff_index_c9_u9
	move 10,1
	add 10,sink
	move 1,13
	pushj 17,compare_roundtrip_c9_u9
	move 4,1
	add 4,10
	movem 4,sink
	ldb 1,14
	trne 1,400
	orcmi 1,777
	add 1,4
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

	.data
	.align	2
init_u9_c9:
	.long	global_u9_c9+301989888

arg_u9_c9:
	jrst bar_u9_c9

stack_u9_c9:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar_u9_c9
	add 17,[-1,,-1]
	popj 17,

global_call_u9_c9:
	move 1,[POINT 18,global_u9_c9,35]
	jrst bar_u9_c9

array_call_u9_c9:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_u9_c9,8]
	jumpe 4,bar_u9_c9
%L874:
	ibp 1
	sojn 4,%L874	; decrement_and_branch_until_zero
%L875:
	jrst bar_u9_c9

ret_arg_u9_c9:
	popj 17,

ret_global_u9_c9:
	move 1,[POINT 18,global_u9_c9,35]
	popj 17,

ret_array_u9_c9:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_u9_c9,8]
	jumpe 4,%L891
%L890:
	ibp 1
	sojn 4,%L890	; decrement_and_branch_until_zero
%L891:
	popj 17,

roundtrip_u9_c9:
	popj 17,

void_bridge_u9_c9:
	popj 17,

load_cast_u9_c9:
	ldb 1,1
	popj 17,

load_global_u9_c9:
	ldb 1,[POINT 18,global_u9_c9,35]
	popj 17,

load_index_u9_c9:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_u9_c9,8]
	jumpe 4,%L908
%L907:
	ibp 3
	sojn 4,%L907	; decrement_and_branch_until_zero
%L908:
	ldb 1,3
	popj 17,

store_cast_u9_c9:
	dpb 2,1
	popj 17,

store_index_u9_c9:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_u9_c9,8]
	jumpe 4,%L916
%L915:
	ibp 3
	sojn 4,%L915	; decrement_and_branch_until_zero
%L916:
	dpb 2,3
	popj 17,

plus_one_u9_c9:
	ibp 1
	popj 17,

plus_index_u9_c9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L923
%L922:
	ibp 1
	sojn 4,%L922	; decrement_and_branch_until_zero
%L923:
	popj 17,

diff_const_u9_c9:
	move 4,[110000000002]
	move 5,[0]
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

diff_index_u9_c9:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_u9_c9,8]
	jumpe 4,%L936
%L935:
	ibp 3
	sojn 4,%L935	; decrement_and_branch_until_zero
%L936:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 2,[POINT 9,array_u9_c9,8]
	jumpe 4,%L941
%L940:
	ibp 2
	sojn 4,%L940	; decrement_and_branch_until_zero
%L941:
	move 6,3
	sub 6,2
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	popj 17,

compare_roundtrip_u9_c9:
	movei 1,1
	popj 17,

volatile_reload_u9_c9:
	movem 1,volatile_from_u9_c9
	move 6,volatile_from_u9_c9
	movem 6,volatile_to_u9_c9
	move 1,volatile_to_u9_c9
	popj 17,

use_all_u9_c9:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 13,1
	move 12,2
	move 10,3
	pushj 17,volatile_reload_u9_c9
	move 14,1
	move 1,13
	pushj 17,roundtrip_u9_c9
	move 11,1
	move 2,10
	pushj 17,store_cast_u9_c9
	addi 10,1
	move 1,12
	move 2,10
	pushj 17,store_index_u9_c9
	move 1,11
	pushj 17,load_cast_u9_c9
	move 10,1
	addb 10,sink
	pushj 17,load_global_u9_c9
	add 10,1
	movem 10,sink
	move 1,12
	pushj 17,load_index_u9_c9
	move 10,1
	addb 10,sink
	pushj 17,diff_const_u9_c9
	add 10,1
	movem 10,sink
	move 1,12
	movei 2,1
	pushj 17,diff_index_u9_c9
	move 10,1
	add 10,sink
	move 1,13
	pushj 17,compare_roundtrip_u9_c9
	add 1,10
	movem 1,sink
	ldb 14,14
	add 1,14
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

	.data
	.align	2
init_c_c9:
	.long	global_c_c9+301989888

arg_c_c9:
	jrst bar_c_c9

stack_c_c9:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar_c_c9
	add 17,[-1,,-1]
	popj 17,

global_call_c_c9:
	move 1,[POINT 18,global_c_c9,35]
	jrst bar_c_c9

array_call_c_c9:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_c_c9,8]
	jumpe 4,bar_c_c9
%L967:
	ibp 1
	sojn 4,%L967	; decrement_and_branch_until_zero
%L968:
	jrst bar_c_c9

ret_arg_c_c9:
	popj 17,

ret_global_c_c9:
	move 1,[POINT 18,global_c_c9,35]
	popj 17,

ret_array_c_c9:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_c_c9,8]
	jumpe 4,%L984
%L983:
	ibp 1
	sojn 4,%L983	; decrement_and_branch_until_zero
%L984:
	popj 17,

roundtrip_c_c9:
	popj 17,

void_bridge_c_c9:
	popj 17,

load_cast_c_c9:
	ldb 1,1
	popj 17,

load_global_c_c9:
	ldb 1,[POINT 18,global_c_c9,35]
	popj 17,

load_index_c_c9:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_c_c9,8]
	jumpe 4,%L1001
%L1000:
	ibp 3
	sojn 4,%L1000	; decrement_and_branch_until_zero
%L1001:
	ldb 1,3
	popj 17,

store_cast_c_c9:
	dpb 2,1
	popj 17,

store_index_c_c9:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_c_c9,8]
	jumpe 4,%L1009
%L1008:
	ibp 3
	sojn 4,%L1008	; decrement_and_branch_until_zero
%L1009:
	dpb 2,3
	popj 17,

plus_one_c_c9:
	ibp 1
	popj 17,

plus_index_c_c9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1016
%L1015:
	ibp 1
	sojn 4,%L1015	; decrement_and_branch_until_zero
%L1016:
	popj 17,

diff_const_c_c9:
	move 4,[110000000002]
	move 5,[0]
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

diff_index_c_c9:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_c_c9,8]
	jumpe 4,%L1029
%L1028:
	ibp 3
	sojn 4,%L1028	; decrement_and_branch_until_zero
%L1029:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 2,[POINT 9,array_c_c9,8]
	jumpe 4,%L1034
%L1033:
	ibp 2
	sojn 4,%L1033	; decrement_and_branch_until_zero
%L1034:
	move 6,3
	sub 6,2
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	popj 17,

compare_roundtrip_c_c9:
	movei 1,1
	popj 17,

volatile_reload_c_c9:
	movem 1,volatile_from_c_c9
	move 6,volatile_from_c_c9
	movem 6,volatile_to_c_c9
	move 1,volatile_to_c_c9
	popj 17,

use_all_c_c9:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 13,1
	move 12,2
	move 10,3
	pushj 17,volatile_reload_c_c9
	move 14,1
	move 1,13
	pushj 17,roundtrip_c_c9
	move 11,1
	move 2,10
	pushj 17,store_cast_c_c9
	addi 10,1
	move 1,12
	move 2,10
	pushj 17,store_index_c_c9
	move 1,11
	pushj 17,load_cast_c_c9
	move 10,1
	addb 10,sink
	pushj 17,load_global_c_c9
	add 10,1
	movem 10,sink
	move 1,12
	pushj 17,load_index_c_c9
	move 10,1
	addb 10,sink
	pushj 17,diff_const_c_c9
	add 10,1
	movem 10,sink
	move 1,12
	movei 2,1
	pushj 17,diff_index_c_c9
	move 10,1
	add 10,sink
	move 1,13
	pushj 17,compare_roundtrip_c_c9
	add 1,10
	movem 1,sink
	ldb 14,14
	add 1,14
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

	.data
	.align	2
init_u_u9:
	.long	global_u_u9+301989888

arg_u_u9:
	jrst bar_u_u9

stack_u_u9:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar_u_u9
	add 17,[-1,,-1]
	popj 17,

global_call_u_u9:
	move 1,[POINT 18,global_u_u9,35]
	jrst bar_u_u9

array_call_u_u9:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_u_u9,8]
	jumpe 4,bar_u_u9
%L1060:
	ibp 1
	sojn 4,%L1060	; decrement_and_branch_until_zero
%L1061:
	jrst bar_u_u9

ret_arg_u_u9:
	popj 17,

ret_global_u_u9:
	move 1,[POINT 18,global_u_u9,35]
	popj 17,

ret_array_u_u9:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_u_u9,8]
	jumpe 4,%L1077
%L1076:
	ibp 1
	sojn 4,%L1076	; decrement_and_branch_until_zero
%L1077:
	popj 17,

roundtrip_u_u9:
	popj 17,

void_bridge_u_u9:
	popj 17,

load_cast_u_u9:
	ldb 1,1
	popj 17,

load_global_u_u9:
	ldb 1,[POINT 18,global_u_u9,35]
	popj 17,

load_index_u_u9:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_u_u9,8]
	jumpe 4,%L1094
%L1093:
	ibp 3
	sojn 4,%L1093	; decrement_and_branch_until_zero
%L1094:
	ldb 1,3
	popj 17,

store_cast_u_u9:
	dpb 2,1
	popj 17,

store_index_u_u9:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_u_u9,8]
	jumpe 4,%L1102
%L1101:
	ibp 3
	sojn 4,%L1101	; decrement_and_branch_until_zero
%L1102:
	dpb 2,3
	popj 17,

plus_one_u_u9:
	ibp 1
	popj 17,

plus_index_u_u9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1109
%L1108:
	ibp 1
	sojn 4,%L1108	; decrement_and_branch_until_zero
%L1109:
	popj 17,

diff_const_u_u9:
	move 4,[110000000002]
	move 5,[0]
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

diff_index_u_u9:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_u_u9,8]
	jumpe 4,%L1122
%L1121:
	ibp 3
	sojn 4,%L1121	; decrement_and_branch_until_zero
%L1122:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 2,[POINT 9,array_u_u9,8]
	jumpe 4,%L1127
%L1126:
	ibp 2
	sojn 4,%L1126	; decrement_and_branch_until_zero
%L1127:
	move 6,3
	sub 6,2
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	popj 17,

compare_roundtrip_u_u9:
	movei 1,1
	popj 17,

volatile_reload_u_u9:
	movem 1,volatile_from_u_u9
	move 6,volatile_from_u_u9
	movem 6,volatile_to_u_u9
	move 1,volatile_to_u_u9
	popj 17,

use_all_u_u9:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 13,1
	move 12,2
	move 10,3
	pushj 17,volatile_reload_u_u9
	move 14,1
	move 1,13
	pushj 17,roundtrip_u_u9
	move 11,1
	move 2,10
	pushj 17,store_cast_u_u9
	addi 10,1
	move 1,12
	move 2,10
	pushj 17,store_index_u_u9
	move 1,11
	pushj 17,load_cast_u_u9
	move 10,1
	addb 10,sink
	pushj 17,load_global_u_u9
	add 10,1
	movem 10,sink
	move 1,12
	pushj 17,load_index_u_u9
	move 10,1
	addb 10,sink
	pushj 17,diff_const_u_u9
	add 10,1
	movem 10,sink
	move 1,12
	movei 2,1
	pushj 17,diff_index_u_u9
	move 10,1
	add 10,sink
	move 1,13
	pushj 17,compare_roundtrip_u_u9
	add 1,10
	movem 1,sink
	ldb 14,14
	add 1,14
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

	.data
	.align	2
init_c9_c:
	.long	global_c9_c+301989888

arg_c9_c:
	jrst bar_c9_c

stack_c9_c:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar_c9_c
	add 17,[-1,,-1]
	popj 17,

global_call_c9_c:
	move 1,[POINT 18,global_c9_c,35]
	jrst bar_c9_c

array_call_c9_c:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_c9_c,8]
	jumpe 4,bar_c9_c
%L1153:
	ibp 1
	sojn 4,%L1153	; decrement_and_branch_until_zero
%L1154:
	jrst bar_c9_c

ret_arg_c9_c:
	popj 17,

ret_global_c9_c:
	move 1,[POINT 18,global_c9_c,35]
	popj 17,

ret_array_c9_c:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_c9_c,8]
	jumpe 4,%L1170
%L1169:
	ibp 1
	sojn 4,%L1169	; decrement_and_branch_until_zero
%L1170:
	popj 17,

roundtrip_c9_c:
	popj 17,

void_bridge_c9_c:
	popj 17,

load_cast_c9_c:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

load_global_c9_c:
	ldb 1,[POINT 18,global_c9_c,35]
	trne 1,400
	orcmi 1,777
	popj 17,

load_index_c9_c:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_c9_c,8]
	jumpe 4,%L1187
%L1186:
	ibp 3
	sojn 4,%L1186	; decrement_and_branch_until_zero
%L1187:
	ldb 1,3
	trne 1,400
	orcmi 1,777
	popj 17,

store_cast_c9_c:
	dpb 2,1
	popj 17,

store_index_c9_c:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_c9_c,8]
	jumpe 4,%L1195
%L1194:
	ibp 3
	sojn 4,%L1194	; decrement_and_branch_until_zero
%L1195:
	dpb 2,3
	popj 17,

plus_one_c9_c:
	ibp 1
	popj 17,

plus_index_c9_c:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1202
%L1201:
	ibp 1
	sojn 4,%L1201	; decrement_and_branch_until_zero
%L1202:
	popj 17,

diff_const_c9_c:
	move 4,[110000000002]
	move 5,[0]
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

diff_index_c9_c:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_c9_c,8]
	jumpe 4,%L1215
%L1214:
	ibp 3
	sojn 4,%L1214	; decrement_and_branch_until_zero
%L1215:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 2,[POINT 9,array_c9_c,8]
	jumpe 4,%L1220
%L1219:
	ibp 2
	sojn 4,%L1219	; decrement_and_branch_until_zero
%L1220:
	move 6,3
	sub 6,2
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	popj 17,

compare_roundtrip_c9_c:
	movei 1,1
	popj 17,

volatile_reload_c9_c:
	movem 1,volatile_from_c9_c
	move 6,volatile_from_c9_c
	movem 6,volatile_to_c9_c
	move 1,volatile_to_c9_c
	popj 17,

use_all_c9_c:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 13,1
	move 12,2
	move 10,3
	pushj 17,volatile_reload_c9_c
	move 14,1
	move 1,13
	pushj 17,roundtrip_c9_c
	move 11,1
	move 2,10
	pushj 17,store_cast_c9_c
	addi 10,1
	move 1,12
	move 2,10
	pushj 17,store_index_c9_c
	move 1,11
	pushj 17,load_cast_c9_c
	move 10,1
	addb 10,sink
	pushj 17,load_global_c9_c
	add 10,1
	movem 10,sink
	move 1,12
	pushj 17,load_index_c9_c
	move 10,1
	addb 10,sink
	pushj 17,diff_const_c9_c
	add 10,1
	movem 10,sink
	move 1,12
	movei 2,1
	pushj 17,diff_index_c9_c
	move 10,1
	add 10,sink
	move 1,13
	pushj 17,compare_roundtrip_c9_c
	move 4,1
	add 4,10
	movem 4,sink
	ldb 1,14
	trne 1,400
	orcmi 1,777
	add 1,4
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

	.data
	.align	2
init_u9_u:
	.long	global_u9_u+301989888

arg_u9_u:
	jrst bar_u9_u

stack_u9_u:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar_u9_u
	add 17,[-1,,-1]
	popj 17,

global_call_u9_u:
	move 1,[POINT 18,global_u9_u,35]
	jrst bar_u9_u

array_call_u9_u:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_u9_u,8]
	jumpe 4,bar_u9_u
%L1246:
	ibp 1
	sojn 4,%L1246	; decrement_and_branch_until_zero
%L1247:
	jrst bar_u9_u

ret_arg_u9_u:
	popj 17,

ret_global_u9_u:
	move 1,[POINT 18,global_u9_u,35]
	popj 17,

ret_array_u9_u:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,array_u9_u,8]
	jumpe 4,%L1263
%L1262:
	ibp 1
	sojn 4,%L1262	; decrement_and_branch_until_zero
%L1263:
	popj 17,

roundtrip_u9_u:
	popj 17,

void_bridge_u9_u:
	popj 17,

load_cast_u9_u:
	ldb 1,1
	popj 17,

load_global_u9_u:
	ldb 1,[POINT 18,global_u9_u,35]
	popj 17,

load_index_u9_u:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_u9_u,8]
	jumpe 4,%L1280
%L1279:
	ibp 3
	sojn 4,%L1279	; decrement_and_branch_until_zero
%L1280:
	ldb 1,3
	popj 17,

store_cast_u9_u:
	dpb 2,1
	popj 17,

store_index_u9_u:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_u9_u,8]
	jumpe 4,%L1288
%L1287:
	ibp 3
	sojn 4,%L1287	; decrement_and_branch_until_zero
%L1288:
	dpb 2,3
	popj 17,

plus_one_u9_u:
	ibp 1
	popj 17,

plus_index_u9_u:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1295
%L1294:
	ibp 1
	sojn 4,%L1294	; decrement_and_branch_until_zero
%L1295:
	popj 17,

diff_const_u9_u:
	move 4,[110000000002]
	move 5,[0]
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

diff_index_u9_u:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,array_u9_u,8]
	jumpe 4,%L1308
%L1307:
	ibp 3
	sojn 4,%L1307	; decrement_and_branch_until_zero
%L1308:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 2,[POINT 9,array_u9_u,8]
	jumpe 4,%L1313
%L1312:
	ibp 2
	sojn 4,%L1312	; decrement_and_branch_until_zero
%L1313:
	move 6,3
	sub 6,2
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	popj 17,

compare_roundtrip_u9_u:
	movei 1,1
	popj 17,

volatile_reload_u9_u:
	movem 1,volatile_from_u9_u
	move 6,volatile_from_u9_u
	movem 6,volatile_to_u9_u
	move 1,volatile_to_u9_u
	popj 17,

use_all_u9_u:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 13,1
	move 12,2
	move 10,3
	pushj 17,volatile_reload_u9_u
	move 14,1
	move 1,13
	pushj 17,roundtrip_u9_u
	move 11,1
	move 2,10
	pushj 17,store_cast_u9_u
	addi 10,1
	move 1,12
	move 2,10
	pushj 17,store_index_u9_u
	move 1,11
	pushj 17,load_cast_u9_u
	move 10,1
	addb 10,sink
	pushj 17,load_global_u9_u
	add 10,1
	movem 10,sink
	move 1,12
	pushj 17,load_index_u9_u
	move 10,1
	addb 10,sink
	pushj 17,diff_const_u9_u
	add 10,1
	movem 10,sink
	move 1,12
	movei 2,1
	pushj 17,diff_index_u9_u
	move 10,1
	add 10,sink
	move 1,13
	pushj 17,compare_roundtrip_u9_u
	add 1,10
	movem 1,sink
	ldb 14,14
	add 1,14
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

	.bss
sink:
	.space	4
global_cc:
	.space	4
array_cc:
	.space	12
volatile_from_cc:
	.space	4
volatile_to_cc:
	.space	4
global_uc:
	.space	4
array_uc:
	.space	12
volatile_from_uc:
	.space	4
volatile_to_uc:
	.space	4
global_cu:
	.space	4
array_cu:
	.space	12
volatile_from_cu:
	.space	4
volatile_to_cu:
	.space	4
global_uu:
	.space	4
array_uu:
	.space	12
volatile_from_uu:
	.space	4
volatile_to_uu:
	.space	4
global_sc_c:
	.space	4
array_sc_c:
	.space	12
volatile_from_sc_c:
	.space	4
volatile_to_sc_c:
	.space	4
global_c_sc:
	.space	4
array_c_sc:
	.space	12
volatile_from_c_sc:
	.space	4
volatile_to_c_sc:
	.space	4
global_sc_uc:
	.space	4
array_sc_uc:
	.space	12
volatile_from_sc_uc:
	.space	4
volatile_to_sc_uc:
	.space	4
global_uc_sc:
	.space	4
array_uc_sc:
	.space	12
volatile_from_uc_sc:
	.space	4
volatile_to_uc_sc:
	.space	4
global_sc_sc:
	.space	4
array_sc_sc:
	.space	12
volatile_from_sc_sc:
	.space	4
volatile_to_sc_sc:
	.space	4
global_c9_u9:
	.space	4
array_c9_u9:
	.space	12
volatile_from_c9_u9:
	.space	4
volatile_to_c9_u9:
	.space	4
global_u9_c9:
	.space	4
array_u9_c9:
	.space	12
volatile_from_u9_c9:
	.space	4
volatile_to_u9_c9:
	.space	4
global_c_c9:
	.space	4
array_c_c9:
	.space	12
volatile_from_c_c9:
	.space	4
volatile_to_c_c9:
	.space	4
global_u_u9:
	.space	4
array_u_u9:
	.space	12
volatile_from_u_u9:
	.space	4
volatile_to_u_u9:
	.space	4
global_c9_c:
	.space	4
array_c9_c:
	.space	12
volatile_from_c9_c:
	.space	4
volatile_to_c9_c:
	.space	4
global_u9_u:
	.space	4
array_u9_u:
	.space	12
volatile_from_u9_u:
	.space	4
volatile_to_u9_u:
	.space	4
