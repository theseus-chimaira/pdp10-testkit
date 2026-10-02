
seto_void:
	seto 1,
	popj 17,

seto_arg_ignored:
	seto 1,
	popj 17,

seto_two_args_ignored:
	seto 1,
	popj 17,

seto_after_expr:
	seto 1,
	popj 17,

seto_after_load:
	seto 1,
	popj 17,

seto_global_ignored:
	seto 1,
	popj 17,

seto_literal_or:
	seto 1,
	popj 17,

seto_literal_assign:
	seto 1,
	popj 17,

setom_mem:
	setom (1)
	popj 17,

setom_global_a:
	setom seto_ga
	popj 17,

setom_global_b:
	setom seto_gb
	popj 17,

setom_array:
	andi 2,17
	add 1,2
	setom (1)
	popj 17,

setom_global_array:
	andi 1,17
	setom seto_buf(1)
	popj 17,

setom_struct_a:
	setom (1)
	popj 17,

setom_struct_b:
	setom 1(1)
	popj 17,

setom_global_struct_a:
	setom seto_gp
	popj 17,

setom_global_struct_b:
	setom seto_gp+1
	popj 17,

setom_indirect:
	setom @(1)
	popj 17,

setom_volatile:
	setom (1)
	popj 17,

setom_return_mem:
	setom (1)
	seto 1,
	popj 17,

setom_return_global:
	setom seto_ga
	seto 1,
	popj 17,

setom_return_array:
	andi 2,17
	add 1,2
	setom (1)
	seto 1,
	popj 17,

setom_return_struct_a:
	setom (1)
	seto 1,
	popj 17,

setom_return_struct_b:
	setom 1(1)
	seto 1,
	popj 17,

setob_mem_return:
	setom (1)
	seto 1,
	popj 17,

setob_global_return:
	setom seto_ga
	seto 1,
	popj 17,

setob_array_return:
	andi 2,17
	add 1,2
	setom (1)
	seto 1,
	popj 17,

setob_struct_a_return:
	setom (1)
	seto 1,
	popj 17,

setob_struct_b_return:
	setom 1(1)
	seto 1,
	popj 17,

useto_void:
	seto 1,
	popj 17,

useto_literal:
	seto 1,
	popj 17,

usetom_mem:
	setom (1)
	popj 17,

usetom_global:
	setom seto_uga
	popj 17,

usetob_mem_return:
	setom (1)
	seto 1,
	popj 17,

seto_qi:
	seto 1,
	popj 17,

seto_uqi:
	movei 1,777
	popj 17,

seto_hi:
	seto 1,
	popj 17,

seto_uhi:
	movei 1,777777
	popj 17,

setom_qi:
	seto 4,
	dpb 4,1
	popj 17,

setom_uqi:
	seto 4,
	dpb 4,1
	popj 17,

setom_hi:
	seto 4,
	dpb 4,1	; movhi
	popj 17,

setom_uhi:
	seto 4,
	dpb 4,1	; movhi
	popj 17,

seto_compare_form:
	seto 1,
	popj 17,

seto_branch_form:
	jumpl 1,%L53
	setom seto_gb
%L52:
	seto 1,
	popj 17,
%L53:
	setom seto_ga
	jrst %L52

seto_chain:
	setom (1)
	setom (2)
	seto 1,
	popj 17,

setob_memaa:
	setom (2)
	seto 1,
	popj 17,

setob_memab:
	setom (2)
	seto 1,
	popj 17,

setob_memba:
	setom (2)
	seto 1,
	popj 17,

setob_membb:
	setom (2)
	seto 1,
	popj 17,

usetob_memaa:
	setom (2)
	seto 1,
	popj 17,

usetob_memab:
	setom (2)
	seto 1,
	popj 17,

usetob_memba:
	setom (2)
	seto 1,
	popj 17,

usetob_membb:
	setom (2)
	seto 1,
	popj 17,

	.bss
seto_ga:
	.space	4
seto_gb:
	.space	4
seto_uga:
	.space	4
seto_buf:
	.space	64
seto_gp:
	.space	8
