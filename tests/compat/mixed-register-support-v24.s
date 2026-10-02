.text
.globl abi_clobber_v24
abi_clobber_v24:
	setz 0,
	movei 2,202
	movei 3,203
	movei 4,204
	movei 5,205
	movei 6,206
	movei 7,207
	addi 1,1
	popj 17,

.globl abi_check_preserved_v24
abi_check_preserved_v24:
	push 17,10
	push 17,11
	push 17,12
	push 17,13
	push 17,14
	push 17,15
	push 17,16
	movei 10,110
	movei 11,111
	movei 12,112
	movei 13,113
	movei 14,114
	movei 15,115
	movei 16,116
	movei 1,1
	movei 2,2
	movei 3,3
	movei 4,4
	pushj 17,abi_pressure_v24
	caie 1,52
	 jrst abi_preserved_fail_v24
	caie 10,110
	 jrst abi_preserved_fail_v24
	caie 11,111
	 jrst abi_preserved_fail_v24
	caie 12,112
	 jrst abi_preserved_fail_v24
	caie 13,113
	 jrst abi_preserved_fail_v24
	caie 14,114
	 jrst abi_preserved_fail_v24
	caie 15,115
	 jrst abi_preserved_fail_v24
	caie 16,116
	 jrst abi_preserved_fail_v24
	setz 1,
	jrst abi_preserved_restore_v24
abi_preserved_fail_v24:
	movei 1,1
abi_preserved_restore_v24:
	pop 17,16
	pop 17,15
	pop 17,14
	pop 17,13
	pop 17,12
	pop 17,11
	pop 17,10
	popj 17,
