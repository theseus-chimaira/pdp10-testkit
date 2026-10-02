
and_reg_reg:
	and 1,2
	popj 17,

and_reg_mem:
	and 1,(2)
	popj 17,

and_mem_reg:
	and 2,(1)
	move 1,2
	popj 17,

and_mem_mem:
	move 1,(1)
	and 1,(2)
	popj 17,

andi_small:
	andi 1,123456
	popj 17,

andi_one:
	andi 1,1
	popj 17,

andi_low6:
	andi 1,77
	popj 17,

andi_low9:
	andi 1,777
	popj 17,

andi_low18:
	hrrz 1,1
	popj 17,

and_literal:
	and 1,[123456123456]
	popj 17,

and_literal_left:
	and 1,[123456123456]
	popj 17,

and_literal_sparse:
	and 1,[-252525525253]
	popj 17,

and_keep_left:
	hllz 1,1
	popj 17,

and_keep_right:
	hrrz 1,1
	popj 17,

and_keep_left_some_right:
	andcmi 1,765432
	popj 17,

and_keep_right_some_left:
	tlz 1,654321
	popj 17,

and_clear_low_bit:
	andcmi 1,1
	popj 17,

and_clear_high_bit:
	tlz 1,400000
	popj 17,

andm_reg_mem:
	andm 1,(2)
	popj 17,

andm_void:
	andm 1,(2)
	popj 17,

andm_const:
	movei 6,123456
	andm 6,(1)
	popj 17,

andm_then_load:
	andb 1,(2)
	popj 17,

and_assign_local:
	and 1,2
	and 1,3
	popj 17,

uand_reg_reg:
	and 1,2
	popj 17,

uand_reg_mem:
	and 1,(2)
	popj 17,

uandi_low18:
	hrrz 1,1
	popj 17,

uand_literal:
	and 1,[123456123456]
	popj 17,

uand_keep_left:
	hllz 1,1
	popj 17,

uand_keep_right:
	hrrz 1,1
	popj 17,

uand_tlz_const:
	tlz 1,654321
	popj 17,

uand_andcmi_const:
	andcmi 1,765432
	popj 17,

and_qi_promote:
	and 2,1
	lsh 2,33
	ash 2,-33
	move 1,2
	popj 17,

andu_qi_promote:
	and 2,1
	andi 2,777
	move 1,2
	popj 17,

and_hi_promote:
	and 2,1
	hrre 2,2
	move 1,2
	popj 17,

andu_hi_promote:
	hrrzi 2,(2)	; zero_extendhisi2
	andi 2,(1)
	move 1,2
	popj 17,

and_qi_mask:
	andi 1,777	; zero_extendqisi2
	popj 17,

and_hi_mask:
	hrrzi 1,(1)	; zero_extendhisi2
	popj 17,

and_volatile_mem:
	move 4,1
	move 1,(2)
	and 1,4
	popj 17,

andm_volatile_mem:
	move 4,(2)
	and 4,1
	movem 4,(2)
	popj 17,

andi_reg_form:
	and 2,1
	hrrz 2,2
	move 1,2
	popj 17,

andi_reg_plus_form:
	addi 1,1234
	and 2,1
	hrrz 2,2
	move 1,2
	popj 17,

tlz_reg_form:
	tlz 2,(1)
	move 1,2
	popj 17,

tlz_reg_plus_form:
	tlz 2,123456(1)
	move 1,2
	popj 17,

andcmi_reg_form:
	andcmi 2,(1)
	move 1,2
	popj 17,

andcmi_reg_plus_form:
	andcmi 2,1234(1)
	move 1,2
	popj 17,

andb_reg_memaa:
	andb 1,(2)
	popj 17,

andb_reg_memab:
	andb 1,(2)
	popj 17,

andb_reg_memba:
	andb 1,(2)
	popj 17,

andb_reg_membb:
	andb 1,(2)
	popj 17,

andb_mem_regaa:
	andb 1,(2)
	popj 17,

andb_mem_regab:
	andb 1,(2)
	popj 17,

andb_mem_regba:
	andb 1,(2)
	popj 17,

andb_mem_regbb:
	andb 1,(2)
	popj 17,

uandb_reg_memaa:
	andb 1,(2)
	popj 17,

uandb_reg_memab:
	andb 1,(2)
	popj 17,

uandb_reg_memba:
	andb 1,(2)
	popj 17,

uandb_reg_membb:
	andb 1,(2)
	popj 17,

