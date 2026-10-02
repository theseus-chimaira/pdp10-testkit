
setz_return:
	movei 1,0
	popj 17,

setz_arg:
	movei 1,0
	popj 17,

setz_local:
	movei 1,0
	popj 17,

setz_local_after_use:
	movei 1,0
	popj 17,

setz_after_call:
	pushj 17,f
	movei 1,0
	popj 17,

setz_call_value_killed:
	pushj 17,f
	movei 1,0
	popj 17,

setz_global_value_killed:
	movei 1,0
	popj 17,

setz_volatile_value_killed:
	move 4,setz_vga
	movei 1,0
	popj 17,

setz_struct_value_killed:
	movei 1,0
	popj 17,

setz_and_zero:
	movei 1,0
	popj 17,

setz_mul_zero:
	movei 1,0
	popj 17,

setz_sub_self:
	movei 1,0
	popj 17,

setz_xor_self:
	movei 1,0
	popj 17,

setz_compare_self_lt:
	movei 1,0
	popj 17,

setz_compare_self_gt:
	movei 1,0
	popj 17,

setz_if_true:
	movei 4,0
	jumpn 1,%L18
	move 4,2
%L18:
	move 1,4
	popj 17,

setz_if_false:
	movei 4,0
	jumpe 1,%L20
	move 4,2
%L20:
	move 1,4
	popj 17,

setz_if_eq:
	movei 4,0
	came 1,2
	move 4,1
	move 1,4
	popj 17,

setz_if_ne:
	movei 4,0
	camn 1,2
	jrst %L26
%L24:
	move 1,4
	popj 17,
%L26:
	move 4,1
	jrst %L24

setz_if_lt:
	movei 4,0
	caml 1,2
	move 4,1
	move 1,4
	popj 17,

setz_if_le:
	movei 4,0
	camle 1,2
	move 4,1
	move 1,4
	popj 17,

setz_if_ge:
	movei 4,0
	camge 1,2
	move 4,1
	move 1,4
	popj 17,

setz_if_gt:
	movei 4,0
	camg 1,2
	move 4,1
	move 1,4
	popj 17,

setz_if_global:
	movei 4,0
	skipn setz_ga
	move 4,1
	move 1,4
	popj 17,

setz_if_volatile:
	move 4,setz_vga
	movei 3,0
	jumpn 4,%L37
	move 3,1
%L37:
	move 1,3
	popj 17,

setz_if_call:
	push 17,10
	move 10,1
	pushj 17,f
	movei 4,0
	jumpn 1,%L39
	move 4,10
%L39:
	move 1,4
	pop 17,10
	popj 17,

setz_if_struct:
	movei 4,0
	skipn setz_gp
	move 4,1
	move 1,4
	popj 17,

setz_likely:
	movei 1,0
	popj 17,

setz_unlikely:
	movei 1,0
	popj 17,

setz_bool_eq:
	camn 1,2
	tdza 1,1
	movei 1,1
	popj 17,

setz_bool_ne:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

setz_bool_lt:
	camge 1,2
	tdza 1,1
	movei 1,1
	popj 17,

setz_bool_le:
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

setz_bool_ge:
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

setz_bool_gt:
	camle 1,2
	tdza 1,1
	movei 1,1
	popj 17,

setz_loop_sum:
	movei 3,0
	move 4,1
	subi 1,1
	jumple 4,%L59
%L57:
	add 3,1
	move 4,1
	subi 1,1
	jumpg 4,%L57
%L59:
	move 1,3
	popj 17,

setz_loop_clear:
	move 3,1
	subi 3,1
	jumple 1,%L66
	movei 1,0
%L64:
	move 4,3
	subi 3,1
	jumpg 4,%L64
%L66:
	popj 17,

setz_loop_break:
	jumple 1,%L74
%L72:
	movei 4,0
	cain 1,3
	jrst %L67
	sojg 1,%L72	; decrement_and_branch_until_zero
%L74:
	move 4,1
%L67:
	move 1,4
	popj 17,

setz_switch:
	movei 4,0
	cain 1,1
	jrst %L75
	movei 4,2
	caie 1,2
	movei 4,0
%L75:
	move 1,4
	popj 17,

setz_switch_mixed:
	move 4,1
	andi 4,3
	move 3,1
	cain 4,1
	jrst %L81
	caig 4,1
	jrst %L89
	movn 3,1
	caie 4,2
%L86:
	movei 3,0
%L81:
	move 1,3
	popj 17,
%L89:
	movei 3,0
	jumpe 4,%L81
	jrst %L86

usetz_return:
	movei 1,0
	popj 17,

usetz_arg:
	movei 1,0
	popj 17,

usetz_local:
	movei 1,0
	popj 17,

usetz_global_value_killed:
	movei 1,0
	popj 17,

usetz_if_lt:
	move 4,1
	tlc 4,400000
	tlc 2,400000
	movei 3,0
	caml 4,2
	move 3,1
	move 1,3
	popj 17,

usetz_if_ne:
	movei 4,0
	camn 1,2
	jrst %L98
%L96:
	move 1,4
	popj 17,
%L98:
	move 4,1
	jrst %L96

usetz_and_zero:
	movei 1,0
	popj 17,

usetz_mul_zero:
	movei 1,0
	popj 17,

usetz_sub_self:
	movei 1,0
	popj 17,

usetz_xor_self:
	movei 1,0
	popj 17,

setz_sqi_return:
	movei 1,0
	popj 17,

setz_uqi_return:
	movei 1,0
	popj 17,

setz_hi_return:
	movei 1,0
	popj 17,

setz_uhi_return:
	movei 1,0
	popj 17,

setz_sqi_arg:
	movei 1,0
	popj 17,

setz_uqi_arg:
	movei 1,0
	popj 17,

setz_hi_arg:
	movei 1,0
	popj 17,

setz_uhi_arg:
	movei 1,0
	popj 17,

setz_null_ptr:
	movei 1,0
	popj 17,

setz_null_ptr_if:
	movei 4,0
	jumpn 1,%L112
	move 4,2
%L112:
	move 1,4
	popj 17,

setz_null_ptr_after_use:
	movei 1,0
	popj 17,

setz_ptr_is_null:
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

setz_ptr_is_not_null:
	skipe 1
	movei 1,1
	popj 17,

setzi_mem_operand:
	movei 1,0
	popj 17,

setzi_index_operand:
	movei 1,0
	popj 17,

setzi_struct_operand:
	movei 1,0
	popj 17,

setzi_call_operand:
	pushj 17,f
	movei 1,0
	popj 17,

setz_live_across_call:
	jumpn 1,%L124
%L123:
	movei 1,0
	popj 17,
%L124:
	pushj 17,f
	jrst %L123

setz_live_across_branch:
	movei 4,0
	camge 1,2
	move 2,4
	move 1,2
	popj 17,

setz_two_zero_values:
	movei 1,0
	popj 17,

	.bss
setz_ga:
	.space	4
setz_uga:
	.space	4
setz_vga:
	.space	4
setz_gp:
	.space	8
