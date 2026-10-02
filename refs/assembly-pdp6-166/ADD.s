
add_reg_reg:
	add 1,2
	popj 17,

add_reg_mem:
	add 1,(2)
	popj 17,

add_mem_reg:
	add 2,(1)
	move 1,2
	popj 17,

add_mem_mem:
	move 1,(1)
	add 1,(2)
	popj 17,

addi_small:
	addi 1,123456
	popj 17,

addi_one:
	addi 1,1
	popj 17,

addi_max18:
	addi 1,777777
	popj 17,

addi_mid18:
	addi 1,400000
	popj 17,

add_literal:
	add 1,[123456123456]
	popj 17,

add_literal_left:
	add 1,[123456123456]
	popj 17,

add_literal_high:
	add 1,[377777000000]
	popj 17,

addm_reg_mem:
	addm 1,(2)
	popj 17,

addm_mem_mem:
	move 2,(2)
	addm 2,(1)
	popj 17,

addm_const:
	movei 6,123456
	addm 6,(1)
	popj 17,

addm_then_load:
	addb 1,(2)
	popj 17,

add_assign_local:
	add 1,2
	add 1,3
	popj 17,

uadd_reg_reg:
	add 1,2
	popj 17,

uadd_reg_mem:
	add 1,(2)
	popj 17,

uaddi_literal:
	addi 1,777777
	popj 17,

add_qi_promote:
	lsh 1,33
	ash 1,-33
	lsh 2,33
	ash 2,-33
	add 1,2
	popj 17,

addu_qi_promote:
	andi 1,777	; zero_extendqisi2
	andi 2,777	; zero_extendqisi2
	add 1,2
	popj 17,

add_hi_promote:
	hrre 1,1
	hrre 2,2
	add 1,2
	popj 17,

addu_hi_promote:
	hrrzi 2,(2)	; zero_extendhisi2
	addi 2,(1)
	move 1,2
	popj 17,

add_ptr_reg:
	add 1,2
	popj 17,

add_ptr_small:
	addi 1,123456
	popj 17,

add_ptr_one:
	addi 1,1
	popj 17,

add_ptr_large:
	subi 1,216544
	popj 17,

addi_index:
	addi 1,(2)
	popj 17,

addi_index_disp:
	addi 1,1234(2)
	popj 17,

add_volatile_mem:
	move 4,1
	move 1,(2)
	add 1,4
	popj 17,

addm_volatile_mem:
	move 4,(2)
	add 4,1
	movem 4,(2)
	popj 17,

addb_reg_memaa:
	addb 1,(2)
	popj 17,

addb_reg_memab:
	addb 1,(2)
	popj 17,

addb_reg_memba:
	addb 1,(2)
	popj 17,

addb_reg_membb:
	addb 1,(2)
	popj 17,

addb_mem_regaa:
	addb 1,(2)
	popj 17,

addb_mem_regab:
	addb 1,(2)
	popj 17,

addb_mem_regba:
	addb 1,(2)
	popj 17,

addb_mem_regbb:
	addb 1,(2)
	popj 17,

uaddb_reg_memaa:
	addb 1,(2)
	popj 17,

uaddb_reg_memab:
	addb 1,(2)
	popj 17,

uaddb_reg_memba:
	addb 1,(2)
	popj 17,

uaddb_reg_membb:
	addb 1,(2)
	popj 17,

