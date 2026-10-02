
sos_mem:
	sos (1)
	popj 17,

sos_ac:
	sos 1,(1)
	popj 17,

sos_global_a:
	sos sos_ga
	popj 17,

sos_global_b:
	sos sos_gb
	popj 17,

sos_global_a_ac:
	sos 1,sos_ga
	popj 17,

sos_global_b_ac:
	sos 1,sos_gb
	popj 17,

sos_array:
	andi 2,17
	add 1,2
	sos (1)
	popj 17,

sos_array_ac:
	andi 2,17
	add 1,2
	sos 1,(1)
	popj 17,

sos_global_array:
	andi 1,17
	sos sos_buf(1)
	popj 17,

sos_global_array_ac:
	andi 1,17
	move 4,sos_buf(1)
	move 6,4
	subi 6,1
	movem 6,sos_buf(1)
	move 1,6
	popj 17,

sos_struct_a:
	sos (1)
	popj 17,

sos_struct_b:
	sos 1(1)
	popj 17,

sos_struct_a_ac:
	sos 1,(1)
	popj 17,

sos_struct_b_ac:
	move 4,1
	move 1,1(1)
	move 6,1
	subi 6,1
	movem 6,1(4)
	move 1,6
	popj 17,

sos_global_struct_a:
	sos sos_gp
	popj 17,

sos_global_struct_b:
	sos sos_gp+1
	popj 17,

sos_global_struct_a_ac:
	sos 1,sos_gp
	popj 17,

sos_global_struct_b_ac:
	sos 1,sos_gp+1
	popj 17,

sos_indirect:
	sos @(1)
	popj 17,

sos_indirect_ac:
	move 4,(1)
	sos 1,(4)
	popj 17,

sos_volatile:
	move 4,(1)
	subi 4,1
	movem 4,(1)
	popj 17,

sos_volatile_ac:
	move 4,(1)
	subi 4,1
	movem 4,(1)
	move 1,(1)
	popj 17,

sosl:
	sosl (1)	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sosl_unlikely:
	sosl (1)	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sosl_ac:
	sosle 1,(1)
	movei 1,0
	popj 17,

sosl_ac_unlikely:
	sosle 1,(1)
	movei 1,0
	popj 17,

sosl_direct:
	sosl (1)	; decrement_and_branch_until_zero
	move 2,3
	move 1,2
	popj 17,

sosl_direct_ac:
	sos (1)
	skipge 1,(1)
	jrst %L37
%L36:
	move 1,2
	popj 17,
%L37:
	move 2,1
	jrst %L36

sose:
	sose (1)	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sose_unlikely:
	sose (1)	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sose_ac:
	sos (1)
	skipe 1,(1)
	movei 1,0
	popj 17,

sose_ac_unlikely:
	sos (1)
	skipn 1,(1)
%L45:
	popj 17,
	movei 1,0
	popj 17,

sose_direct:
	sose (1)	; decrement_and_branch_until_zero
	move 2,3
	move 1,2
	popj 17,

sose_direct_ac:
	sosn (1)	; decrement_and_branch_until_zero
	movei 2,0
	move 1,2
	popj 17,

sosle:
	sosle (1)	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sosle_unlikely:
	sosle (1)	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sosle_ac:
	sosle 1,(1)
	movei 1,0
	popj 17,

sosle_ac_unlikely:
	sosle 1,(1)
	movei 1,0
	popj 17,

sosle_direct:
	sosle (1)	; decrement_and_branch_until_zero
	move 2,3
	move 1,2
	popj 17,

sosle_direct_ac:
	sos (1)
	skipg 1,(1)
	jrst %L63
%L62:
	move 1,2
	popj 17,
%L63:
	move 2,1
	jrst %L62

sosge:
	sosge (1)	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sosge_unlikely:
	sosge (1)	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sosge_ac:
	sosge 1,(1)
	movei 1,0
	popj 17,

sosge_ac_unlikely:
	sosge 1,(1)
	movei 1,0
	popj 17,

sosge_direct:
	sosge (1)	; decrement_and_branch_until_zero
	move 2,3
	move 1,2
	popj 17,

sosge_direct_ac:
	sos (1)
	skipl 1,(1)
	move 2,1
	move 1,2
	popj 17,

sosn:
	sosn (1)	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sosn_unlikely:
	sosn (1)	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sosn_ac:
	sos 1,(1)
	popj 17,

sosn_ac_unlikely:
	sos 1,(1)
	popj 17,

sosn_direct:
	sosn (1)	; decrement_and_branch_until_zero
	move 2,3
	move 1,2
	popj 17,

sosn_direct_ac:
	sos (1)
	skipe 1,(1)
	move 2,1
	move 1,2
	popj 17,

sosg:
	sosg (1)	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sosg_unlikely:
	sosg (1)	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sosg_ac:
	sosge 1,(1)
	movei 1,0
	popj 17,

sosg_ac_unlikely:
	sosge 1,(1)
	movei 1,0
	popj 17,

sosg_direct:
	sosg (1)	; decrement_and_branch_until_zero
	move 2,3
	move 1,2
	popj 17,

sosg_direct_ac:
	sos (1)
	skiple 1,(1)
	move 2,1
	move 1,2
	popj 17,

sosl_global:
	sosl sos_ga	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sose_global:
	sose sos_ga	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sosle_global:
	sosle sos_ga	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sosge_global:
	sosge sos_ga	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sosn_global:
	sosn sos_ga	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sosg_global:
	sosg sos_ga	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sosl_global_ac:
	sosle 1,sos_ga
	movei 1,0
	popj 17,

sose_global_ac:
	sos sos_ga
	skipe 1,sos_ga
	movei 1,0
	popj 17,

sosle_global_ac:
	sosle 1,sos_ga
	movei 1,0
	popj 17,

sosge_global_ac:
	sosge 1,sos_ga
	movei 1,0
	popj 17,

sosn_global_ac:
	sos 1,sos_ga
	popj 17,

sosg_global_ac:
	sosge 1,sos_ga
	movei 1,0
	popj 17,

sosl_array:
	andi 2,17
	add 1,2
	sosl (1)	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sose_array:
	andi 2,17
	add 1,2
	sose (1)	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sosle_array:
	andi 2,17
	add 1,2
	sosle (1)	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sosge_array:
	andi 2,17
	add 1,2
	sosge (1)	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sosn_array:
	andi 2,17
	add 1,2
	sosn (1)	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sosg_array:
	andi 2,17
	add 1,2
	sosg (1)	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sosl_array_ac:
	andi 2,17
	add 1,2
	sosle 1,(1)
	movei 1,0
	popj 17,

sose_array_ac:
	andi 2,17
	add 1,2
	sos (1)
	skipe 1,(1)
	movei 1,0
	popj 17,

sosle_array_ac:
	andi 2,17
	add 1,2
	sosle 1,(1)
	movei 1,0
	popj 17,

sosge_array_ac:
	andi 2,17
	add 1,2
	sosge 1,(1)
	movei 1,0
	popj 17,

sosn_array_ac:
	andi 2,17
	add 1,2
	sos 1,(1)
	popj 17,

sosg_array_ac:
	andi 2,17
	add 1,2
	sosge 1,(1)
	movei 1,0
	popj 17,

sosl_struct_a:
	sosl (1)	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sose_struct_a:
	sose (1)	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sosle_struct_a:
	sosle (1)	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sosge_struct_b:
	move 4,1(1)
	move 6,4
	subi 6,1
	movem 6,1(1)
	jumpl 6,f
	popj 17,
%L168:
	jrst f

sosn_struct_b:
	move 4,1(1)
	move 6,4
	subi 6,1
	movem 6,1(1)
	caie 4,1
	popj 17,
	jrst f

sosg_struct_b:
	move 4,1(1)
	move 6,4
	subi 6,1
	movem 6,1(1)
	jumple 6,f
	popj 17,
%L174:
	jrst f

sosl_struct_a_ac:
	sosle 1,(1)
	movei 1,0
	popj 17,

sose_struct_a_ac:
	sos (1)
	skipe 1,(1)
	movei 1,0
	popj 17,

sosle_struct_a_ac:
	sosle 1,(1)
	movei 1,0
	popj 17,

sosge_struct_b_ac:
	move 4,1
	move 1,1(1)
	move 6,1
	subi 6,1
	movem 6,1(4)
	move 1,6
	caige 1,0
	movei 1,0
	popj 17,

sosn_struct_b_ac:
	move 4,1
	move 1,1(1)
	move 6,1
	subi 6,1
	movem 6,1(4)
	move 1,6
	popj 17,

sosg_struct_b_ac:
	move 4,1
	move 1,1(1)
	move 6,1
	subi 6,1
	movem 6,1(4)
	move 1,6
	caige 1,0
	movei 1,0
	popj 17,

sosa_goto:
	sos (1)
%L188:
	jrst f

sosa_ac_goto:
	sos 1,(1)
%L190:
	popj 17,

sosa_select:
	sos 1,(1)
%L193:
	popj 17,

sos_two:
	sos (1)
	sos (2)
	popj 17,

sos_two_ac:
	sos 1,(1)
	sos (2)
	add 1,(2)
	popj 17,

sos_chain_branch:
	sosn (1)	; decrement_and_branch_until_zero
	sos (2)
	popj 17,

sos_chain_branch_ac:
	sos (1)
	skipn 1,(1)
	popj 17,
	sos (2)
	add 1,(2)
	popj 17,

sos_loop_count:
	move 2,1
	movei 1,0
	sos (2)
	skipg 4,(2)
	popj 17,
%L204:
	add 1,4
	sos 3,4
	jumpg 3,%L204
	movem 3,(2)
	popj 17,

sos_loop_until_zero:
	move 6,1
	movei 1,0
	move 3,(6)
	move 7,3
	subi 7,1
	movem 7,(6)
	skipn 4,7
	popj 17,
	subi 3,2
%L216:
	add 1,4
	sos 2,4
	sojge 3,%L216	; doloop_end
	movem 2,(6)
	popj 17,

sos_qi:
	ldb 4,1
	subi 4,1
	dpb 4,1
	popj 17,

sos_qi_ac:
	move 4,1
	ldb 1,1
	subi 1,1
	dpb 1,4
	lsh 1,33
	ash 1,-33
	popj 17,

sos_hi:
	ldb 4,1
	subi 4,1
	dpb 4,1	; movhi
	popj 17,

sos_hi_ac:
	move 4,1
	ldb 1,1
	subi 1,1
	dpb 1,4	; movhi
	hrre 1,1
	popj 17,

sos_unsigned_eq:
	sose (1)	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sos_unsigned_ne:
	sosn (1)	; decrement_and_branch_until_zero
	jrst f
	popj 17,

sos_unsigned_ac:
	sos 1,(1)
	popj 17,

	.bss
sos_ga:
	.space	4
sos_gb:
	.space	4
sos_buf:
	.space	64
sos_gp:
	.space	8
