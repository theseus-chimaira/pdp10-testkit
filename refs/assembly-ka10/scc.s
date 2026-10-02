
skipeSint:
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

skipeSintm1:
	seto 6,
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

skipeSintp1:
	movei 6,1
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cameSint1:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

cameSint2:
	came 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

cameSint3:
	move 1,(1)
	came 1,2
	tdza 2,2
	movei 2,1
	move 1,2
	popj 17,

cameSint4:
	move 1,(1)
	came 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

skipnSint:
	skipe 1
	movei 1,1
	popj 17,

skipnSintm1:
	seto 6,
	camn 1,6
	tdza 1,1
	movei 1,1
	popj 17,

skipnSintp1:
	movei 6,1
	camn 1,6
	tdza 1,1
	movei 1,1
	popj 17,

camnSint1:
	camn 1,2
	tdza 1,1
	movei 1,1
	popj 17,

camnSint2:
	camn 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

camnSint3:
	move 1,(1)
	camn 1,2
	tdza 2,2
	movei 2,1
	move 1,2
	popj 17,

camnSint4:
	move 1,(1)
	camn 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

skiplSint:
	lsh 1,-43
	popj 17,

skiplSintm1:
	seto 6,
	caml 1,6
	tdza 1,1
	movei 1,1
	popj 17,

skiplSintp1:
	skiple 1
	tdza 1,1
	movei 1,1
	popj 17,

camlSint1:
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

camlSint2:
	caml 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

camlSint3:
	move 1,(1)
	caml 1,2
	tdza 2,2
	movei 2,1
	move 1,2
	popj 17,

camlSint4:
	move 1,(1)
	caml 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

skipgSint:
	skipg 1
	tdza 1,1
	movei 1,1
	popj 17,

skipgSintm1:
	skipge 1
	tdza 1,1
	movei 1,1
	popj 17,

skipgSintp1:
	movei 6,1
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

camgSint1:
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

camgSint2:
	camg 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

camgSint3:
	move 1,(1)
	camg 1,2
	tdza 2,2
	movei 2,1
	move 1,2
	popj 17,

camgSint4:
	move 1,(1)
	camg 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

skipleSint:
	skiple 1
	tdza 1,1
	movei 1,1
	popj 17,

skipleSintm1:
	lsh 1,-43
	popj 17,

skipleSintp1:
	movei 6,1
	camle 1,6
	tdza 1,1
	movei 1,1
	popj 17,

camleSint1:
	camle 1,2
	tdza 1,1
	movei 1,1
	popj 17,

camleSint2:
	camle 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

camleSint3:
	move 1,(1)
	camle 1,2
	tdza 2,2
	movei 2,1
	move 1,2
	popj 17,

camleSint4:
	move 1,(1)
	camle 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

skipgeSint:
	skipge 1
	tdza 1,1
	movei 1,1
	popj 17,

skipgeSintm1:
	seto 6,
	camge 1,6
	tdza 1,1
	movei 1,1
	popj 17,

skipgeSintp1:
	skipg 1
	tdza 1,1
	movei 1,1
	popj 17,

camgeSint1:
	camge 1,2
	tdza 1,1
	movei 1,1
	popj 17,

camgeSint2:
	camge 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

camgeSint3:
	move 1,(1)
	camge 1,2
	tdza 2,2
	movei 2,1
	move 1,2
	popj 17,

camgeSint4:
	move 1,(1)
	camge 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

skipueuSint:
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

skipueuSintp1:
	movei 6,1
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

camueuSint1:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

camueuSint2:
	came 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

camueuSint3:
	move 1,(1)
	came 1,2
	tdza 2,2
	movei 2,1
	move 1,2
	popj 17,

camueuSint4:
	move 1,(1)
	came 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

skipunuSint:
	skipe 1
	movei 1,1
	popj 17,

skipunuSintp1:
	movei 6,1
	camn 1,6
	tdza 1,1
	movei 1,1
	popj 17,

camunuSint1:
	camn 1,2
	tdza 1,1
	movei 1,1
	popj 17,

camunuSint2:
	camn 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

camunuSint3:
	move 1,(1)
	camn 1,2
	tdza 2,2
	movei 2,1
	move 1,2
	popj 17,

camunuSint4:
	move 1,(1)
	camn 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

skipuluSint:
	movei 1,0
	popj 17,

skipuluSintp1:
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

camuluSint1:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

camuluSint2:
	tlc 1,400000
	move 4,(2)
	tlc 4,400000
	caml 1,4
	tdza 1,1
	movei 1,1
	popj 17,

camuluSint3:
	move 1,(1)
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

camuluSint4:
	move 1,(1)
	tlc 1,400000
	move 4,(2)
	tlc 4,400000
	caml 1,4
	tdza 1,1
	movei 1,1
	popj 17,

skipuguSint:
	skipe 1
	movei 1,1
	popj 17,

skipuguSintp1:
	skipl 1,1
	cail 1,2
	trna
	tdza 1,1
	movei 1,1
	popj 17,

camuguSint1:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

camuguSint2:
	tlc 1,400000
	move 4,(2)
	tlc 4,400000
	camg 1,4
	tdza 1,1
	movei 1,1
	popj 17,

camuguSint3:
	move 1,(1)
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

camuguSint4:
	move 1,(1)
	tlc 1,400000
	move 4,(2)
	tlc 4,400000
	camg 1,4
	tdza 1,1
	movei 1,1
	popj 17,

skipuleuSint:
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

skipuleuSintp1:
	skipl 1,1
	cail 1,2
	tdza 1,1
	movei 1,1
	popj 17,

camuleuSint1:
	tlc 1,400000
	tlc 2,400000
	camle 1,2
	tdza 1,1
	movei 1,1
	popj 17,

camuleuSint2:
	tlc 1,400000
	move 4,(2)
	tlc 4,400000
	camle 1,4
	tdza 1,1
	movei 1,1
	popj 17,

camuleuSint3:
	move 1,(1)
	tlc 1,400000
	tlc 2,400000
	camle 1,2
	tdza 1,1
	movei 1,1
	popj 17,

camuleuSint4:
	move 1,(1)
	tlc 1,400000
	move 4,(2)
	tlc 4,400000
	camle 1,4
	tdza 1,1
	movei 1,1
	popj 17,

skipugeuSint:
	movei 1,1
	popj 17,

skipugeuSintp1:
	skipe 1
	movei 1,1
	popj 17,

camugeuSint1:
	tlc 1,400000
	tlc 2,400000
	camge 1,2
	tdza 1,1
	movei 1,1
	popj 17,

camugeuSint2:
	tlc 1,400000
	move 4,(2)
	tlc 4,400000
	camge 1,4
	tdza 1,1
	movei 1,1
	popj 17,

camugeuSint3:
	move 1,(1)
	tlc 1,400000
	tlc 2,400000
	camge 1,2
	tdza 1,1
	movei 1,1
	popj 17,

camugeuSint4:
	move 1,(1)
	tlc 1,400000
	move 4,(2)
	tlc 4,400000
	camge 1,4
	tdza 1,1
	movei 1,1
	popj 17,

scc_add_eq:
	came 1,2
	tdza 1,1
	movei 1,1
	add 1,3
	popj 17,

scc_add_ne:
	camn 1,2
	tdza 1,1
	movei 1,1
	add 1,3
	popj 17,

scc_add_lt:
	caml 1,2
	tdza 1,1
	movei 1,1
	add 1,3
	popj 17,

scc_add_gt:
	camg 1,2
	tdza 1,1
	movei 1,1
	add 1,3
	popj 17,

scc_add_le:
	camle 1,2
	tdza 1,1
	movei 1,1
	add 1,3
	popj 17,

scc_add_ge:
	camge 1,2
	tdza 1,1
	movei 1,1
	add 1,3
	popj 17,

scc_and_eq:
	andi 3,1
	came 1,2
	movei 3,0
	move 1,3
	popj 17,

scc_or_ne:
	camn 1,2
	tdza 1,1
	movei 1,1
	ior 1,3
	popj 17,

scc_xor_lt:
	caml 1,2
	tdza 1,1
	movei 1,1
	xor 1,3
	popj 17,

scc_mul_gt:
	camg 1,2
	movei 3,0
	move 1,3
	popj 17,

scc_local_eq:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

scc_local_ne:
	camn 1,2
	tdza 1,1
	movei 1,1
	popj 17,

scc_local_lt:
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

scc_local_gt:
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

scc_local_le:
	camle 1,2
	tdza 1,1
	movei 1,1
	popj 17,

scc_local_ge:
	camge 1,2
	tdza 1,1
	movei 1,1
	popj 17,

scc_uadd_lt:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	add 1,3
	popj 17,

scc_uadd_gt:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	add 1,3
	popj 17,

scc_uadd_le:
	tlc 1,400000
	tlc 2,400000
	camle 1,2
	tdza 1,1
	movei 1,1
	add 1,3
	popj 17,

scc_uadd_ge:
	tlc 1,400000
	tlc 2,400000
	camge 1,2
	tdza 1,1
	movei 1,1
	add 1,3
	popj 17,

scc_qi_eq:
	lsh 1,33
	ash 1,-33
	lsh 2,33
	ash 2,-33
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

scc_qi_ne:
	lsh 1,33
	ash 1,-33
	lsh 2,33
	ash 2,-33
	camn 1,2
	tdza 1,1
	movei 1,1
	popj 17,

scc_qi_lt:
	lsh 1,33
	ash 1,-33
	lsh 2,33
	ash 2,-33
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

scc_qi_ge:
	lsh 1,33
	ash 1,-33
	lsh 2,33
	ash 2,-33
	camge 1,2
	tdza 1,1
	movei 1,1
	popj 17,

scc_uqi_lt:
	andi 1,777	; zero_extendqisi2
	andi 2,777	; zero_extendqisi2
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

scc_uqi_ge:
	andi 1,777	; zero_extendqisi2
	andi 2,777	; zero_extendqisi2
	tlc 1,400000
	tlc 2,400000
	camge 1,2
	tdza 1,1
	movei 1,1
	popj 17,

scc_hi_eq:
	hrre 1,1
	hrre 2,2
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

scc_hi_ne:
	hrre 1,1
	hrre 2,2
	camn 1,2
	tdza 1,1
	movei 1,1
	popj 17,

scc_hi_lt:
	hrre 1,1
	hrre 2,2
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

scc_hi_ge:
	hrre 1,1
	hrre 2,2
	camge 1,2
	tdza 1,1
	movei 1,1
	popj 17,

scc_uhi_lt:
	hrrzi 1,(1)	; zero_extendhisi2
	hrrzi 2,(2)	; zero_extendhisi2
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

scc_uhi_ge:
	hrrzi 1,(1)	; zero_extendhisi2
	hrrzi 2,(2)	; zero_extendhisi2
	tlc 1,400000
	tlc 2,400000
	camge 1,2
	tdza 1,1
	movei 1,1
	popj 17,

scc_ptr_eq:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

scc_ptr_ne:
	camn 1,2
	tdza 1,1
	movei 1,1
	popj 17,

scc_ptr_null_eq:
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

scc_ptr_null_ne:
	skipe 1
	movei 1,1
	popj 17,

scc_ptr_lt:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

scc_ptr_ge:
	tlc 1,400000
	tlc 2,400000
	camge 1,2
	tdza 1,1
	movei 1,1
	popj 17,

scc_two_values:
	caml 1,2
	tdza 1,1
	movei 1,1
	caml 2,3
	tdza 2,2
	movei 2,1
	add 1,2
	popj 17,

scc_three_values:
	move 4,1
	came 1,2
	tdza 1,1
	movei 1,1
	camn 2,3
	tdza 2,2
	movei 2,1
	add 1,2
	caml 4,3
	tdza 4,4
	movei 4,1
	add 1,4
	popj 17,

scc_mixed_signed_unsigned:
	caml 1,2
	tdza 1,1
	movei 1,1
	tlc 3,400000
	tlc 4,400000
	caml 3,4
	tdza 3,3
	movei 3,1
	add 1,3
	popj 17,

