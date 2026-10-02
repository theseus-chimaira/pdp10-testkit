
dd_char:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_char
	add 17,[-1,,-1]
	popj 17,

dvl_char:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	movem 1,(17)
	move 1,(17)
	movem 1,sk_char
	add 17,[-1,,-1]
	popj 17,

dp_char:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 4,(17)
	tlo 4,2200
	ldb 4,4
	hrrm 4,sk_char
	move 1,sk_char
	add 17,[-1,,-1]
	popj 17,

dvps_char:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	ldb 6,(17)
	hrrm 6,sk_char
	move 1,sk_char
	add 17,[-2,,-2]
	popj 17,

dae_char:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	movei 1,(17)
	pushj 17,svsesc
	movei 4,(17)
	ldb 4,(4)
	hrrm 4,sk_char
	move 1,sk_char
	add 17,[-2,,-2]
	popj 17,

sta_char:
	add 17,[1,,1]
	movei 4,(17)
	tlo 4,2200
	dpb 1,4
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_char
	add 17,[-1,,-1]
	popj 17,

aed_char:
	add 17,[1,,1]
	movem 1,(17)
	addi 1,1
	dpb 1,[POINT 9,(17),17]
	addi 1,1
	dpb 1,[POINT 9,(17),26]
	movei 4,(17)
	tlo 4,331100
	ildb 4,4
	hrrm 4,sk_char
	move 1,sk_char
	add 17,[-1,,-1]
	popj 17,

sfd_char:
	add 17,[1,,1]
	move 4,(17)
	dpb 1,[POINT 9,4,8]
	addi 1,1
	dpb 1,[POINT 9,4,17]
	movem 4,(17)
	movei 4,(17)
	tlo 4,331100
	ildb 4,4
	hrrm 4,sk_char
	move 1,sk_char
	add 17,[-1,,-1]
	popj 17,

psa_char:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,svsuse
	ldb 4,[POINT 9,(17),35]
	movem 4,vsk_char
	add 17,[-1,,-1]
	popj 17,

usd_char:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,psa_char
	move 1,11
	pushj 17,dd_char
	move 10,1
	andi 10,777	; zero_extendqisi2
	move 1,11
	pushj 17,dvl_char
	add 10,1
	move 1,11
	pushj 17,dp_char
	add 10,1
	move 1,11
	pushj 17,dvps_char
	add 10,1
	move 1,11
	pushj 17,dae_char
	add 10,1
	move 1,11
	pushj 17,sta_char
	add 10,1
	move 1,11
	pushj 17,aed_char
	add 10,1
	move 1,11
	pushj 17,sfd_char
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dd_schar:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_schar
	lsh 1,33
	ash 1,-33
	add 17,[-1,,-1]
	popj 17,

dvl_schar:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	movem 1,(17)
	move 1,(17)
	movem 1,sk_schar
	lsh 1,33
	ash 1,-33
	add 17,[-1,,-1]
	popj 17,

dp_schar:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 4,(17)
	tlo 4,2200
	ldb 4,4
	hrrm 4,sk_schar
	hrre 1,sk_schar
	add 17,[-1,,-1]
	popj 17,

dvps_schar:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	ldb 6,(17)
	hrrm 6,sk_schar
	hrre 1,sk_schar
	add 17,[-2,,-2]
	popj 17,

dae_schar:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	movei 1,(17)
	pushj 17,svsesc
	movei 4,(17)
	ldb 4,(4)
	hrrm 4,sk_schar
	hrre 1,sk_schar
	add 17,[-2,,-2]
	popj 17,

sta_schar:
	add 17,[1,,1]
	movei 4,(17)
	tlo 4,2200
	dpb 1,4
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_schar
	lsh 1,33
	ash 1,-33
	add 17,[-1,,-1]
	popj 17,

aed_schar:
	add 17,[1,,1]
	movem 1,(17)
	addi 1,1
	dpb 1,[POINT 9,(17),17]
	addi 1,1
	dpb 1,[POINT 9,(17),26]
	movei 4,(17)
	tlo 4,331100
	ildb 4,4
	hrrm 4,sk_schar
	hrre 1,sk_schar
	add 17,[-1,,-1]
	popj 17,

sfd_schar:
	add 17,[1,,1]
	move 4,(17)
	dpb 1,[POINT 9,4,8]
	addi 1,1
	dpb 1,[POINT 9,4,17]
	movem 4,(17)
	movei 4,(17)
	tlo 4,331100
	ildb 4,4
	hrrm 4,sk_schar
	hrre 1,sk_schar
	add 17,[-1,,-1]
	popj 17,

psa_schar:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,svsuse
	ldb 4,[POINT 9,(17),35]
	movem 4,vsk_schar
	add 17,[-1,,-1]
	popj 17,

usd_schar:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,psa_schar
	move 1,11
	pushj 17,dd_schar
	move 10,1
	lsh 10,33
	ash 10,-33
	move 1,11
	pushj 17,dvl_schar
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,dp_schar
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,dvps_schar
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,dae_schar
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,sta_schar
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,aed_schar
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,sfd_schar
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dd_uchar:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_uchar
	add 17,[-1,,-1]
	popj 17,

dvl_uchar:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	movem 1,(17)
	move 1,(17)
	movem 1,sk_uchar
	add 17,[-1,,-1]
	popj 17,

dp_uchar:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 4,(17)
	tlo 4,2200
	ldb 4,4
	hrrm 4,sk_uchar
	move 1,sk_uchar
	add 17,[-1,,-1]
	popj 17,

dvps_uchar:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	ldb 6,(17)
	hrrm 6,sk_uchar
	move 1,sk_uchar
	add 17,[-2,,-2]
	popj 17,

dae_uchar:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	movei 1,(17)
	pushj 17,svsesc
	movei 4,(17)
	ldb 4,(4)
	hrrm 4,sk_uchar
	move 1,sk_uchar
	add 17,[-2,,-2]
	popj 17,

sta_uchar:
	add 17,[1,,1]
	movei 4,(17)
	tlo 4,2200
	dpb 1,4
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_uchar
	add 17,[-1,,-1]
	popj 17,

aed_uchar:
	add 17,[1,,1]
	movem 1,(17)
	addi 1,1
	dpb 1,[POINT 9,(17),17]
	addi 1,1
	dpb 1,[POINT 9,(17),26]
	movei 4,(17)
	tlo 4,331100
	ildb 4,4
	hrrm 4,sk_uchar
	move 1,sk_uchar
	add 17,[-1,,-1]
	popj 17,

sfd_uchar:
	add 17,[1,,1]
	move 4,(17)
	dpb 1,[POINT 9,4,8]
	addi 1,1
	dpb 1,[POINT 9,4,17]
	movem 4,(17)
	movei 4,(17)
	tlo 4,331100
	ildb 4,4
	hrrm 4,sk_uchar
	move 1,sk_uchar
	add 17,[-1,,-1]
	popj 17,

psa_uchar:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,svsuse
	ldb 4,[POINT 9,(17),35]
	movem 4,vsk_uchar
	add 17,[-1,,-1]
	popj 17,

usd_uchar:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,psa_uchar
	move 1,11
	pushj 17,dd_uchar
	move 10,1
	andi 10,777	; zero_extendqisi2
	move 1,11
	pushj 17,dvl_uchar
	add 10,1
	move 1,11
	pushj 17,dp_uchar
	add 10,1
	move 1,11
	pushj 17,dvps_uchar
	add 10,1
	move 1,11
	pushj 17,dae_uchar
	add 10,1
	move 1,11
	pushj 17,sta_uchar
	add 10,1
	move 1,11
	pushj 17,aed_uchar
	add 10,1
	move 1,11
	pushj 17,sfd_uchar
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dd_Qint:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_Qint
	lsh 1,33
	ash 1,-33
	add 17,[-1,,-1]
	popj 17,

dvl_Qint:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	movem 1,(17)
	move 1,(17)
	movem 1,sk_Qint
	lsh 1,33
	ash 1,-33
	add 17,[-1,,-1]
	popj 17,

dp_Qint:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 4,(17)
	tlo 4,2200
	ldb 4,4
	hrrm 4,sk_Qint
	hrre 1,sk_Qint
	add 17,[-1,,-1]
	popj 17,

dvps_Qint:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	ldb 6,(17)
	hrrm 6,sk_Qint
	hrre 1,sk_Qint
	add 17,[-2,,-2]
	popj 17,

dae_Qint:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	movei 1,(17)
	pushj 17,svsesc
	movei 4,(17)
	ldb 4,(4)
	hrrm 4,sk_Qint
	hrre 1,sk_Qint
	add 17,[-2,,-2]
	popj 17,

sta_Qint:
	add 17,[1,,1]
	movei 4,(17)
	tlo 4,2200
	dpb 1,4
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_Qint
	lsh 1,33
	ash 1,-33
	add 17,[-1,,-1]
	popj 17,

aed_Qint:
	add 17,[1,,1]
	movem 1,(17)
	addi 1,1
	dpb 1,[POINT 9,(17),17]
	addi 1,1
	dpb 1,[POINT 9,(17),26]
	movei 4,(17)
	tlo 4,331100
	ildb 4,4
	hrrm 4,sk_Qint
	hrre 1,sk_Qint
	add 17,[-1,,-1]
	popj 17,

sfd_Qint:
	add 17,[1,,1]
	move 4,(17)
	dpb 1,[POINT 9,4,8]
	addi 1,1
	dpb 1,[POINT 9,4,17]
	movem 4,(17)
	movei 4,(17)
	tlo 4,331100
	ildb 4,4
	hrrm 4,sk_Qint
	hrre 1,sk_Qint
	add 17,[-1,,-1]
	popj 17,

psa_Qint:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,svsuse
	ldb 4,[POINT 9,(17),35]
	movem 4,vsk_Qint
	add 17,[-1,,-1]
	popj 17,

usd_Qint:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,psa_Qint
	move 1,11
	pushj 17,dd_Qint
	move 10,1
	lsh 10,33
	ash 10,-33
	move 1,11
	pushj 17,dvl_Qint
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,dp_Qint
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,dvps_Qint
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,dae_Qint
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,sta_Qint
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,aed_Qint
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,sfd_Qint
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dd_sQint:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_sQint
	lsh 1,33
	ash 1,-33
	add 17,[-1,,-1]
	popj 17,

dvl_sQint:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	movem 1,(17)
	move 1,(17)
	movem 1,sk_sQint
	lsh 1,33
	ash 1,-33
	add 17,[-1,,-1]
	popj 17,

dp_sQint:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 4,(17)
	tlo 4,2200
	ldb 4,4
	hrrm 4,sk_sQint
	hrre 1,sk_sQint
	add 17,[-1,,-1]
	popj 17,

dvps_sQint:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	ldb 6,(17)
	hrrm 6,sk_sQint
	hrre 1,sk_sQint
	add 17,[-2,,-2]
	popj 17,

dae_sQint:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	movei 1,(17)
	pushj 17,svsesc
	movei 4,(17)
	ldb 4,(4)
	hrrm 4,sk_sQint
	hrre 1,sk_sQint
	add 17,[-2,,-2]
	popj 17,

sta_sQint:
	add 17,[1,,1]
	movei 4,(17)
	tlo 4,2200
	dpb 1,4
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_sQint
	lsh 1,33
	ash 1,-33
	add 17,[-1,,-1]
	popj 17,

aed_sQint:
	add 17,[1,,1]
	movem 1,(17)
	addi 1,1
	dpb 1,[POINT 9,(17),17]
	addi 1,1
	dpb 1,[POINT 9,(17),26]
	movei 4,(17)
	tlo 4,331100
	ildb 4,4
	hrrm 4,sk_sQint
	hrre 1,sk_sQint
	add 17,[-1,,-1]
	popj 17,

sfd_sQint:
	add 17,[1,,1]
	move 4,(17)
	dpb 1,[POINT 9,4,8]
	addi 1,1
	dpb 1,[POINT 9,4,17]
	movem 4,(17)
	movei 4,(17)
	tlo 4,331100
	ildb 4,4
	hrrm 4,sk_sQint
	hrre 1,sk_sQint
	add 17,[-1,,-1]
	popj 17,

psa_sQint:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,svsuse
	ldb 4,[POINT 9,(17),35]
	movem 4,vsk_sQint
	add 17,[-1,,-1]
	popj 17,

usd_sQint:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,psa_sQint
	move 1,11
	pushj 17,dd_sQint
	move 10,1
	lsh 10,33
	ash 10,-33
	move 1,11
	pushj 17,dvl_sQint
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,dp_sQint
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,dvps_sQint
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,dae_sQint
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,sta_sQint
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,aed_sQint
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,sfd_sQint
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dd_uQint:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_uQint
	add 17,[-1,,-1]
	popj 17,

dvl_uQint:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	movem 1,(17)
	move 1,(17)
	movem 1,sk_uQint
	add 17,[-1,,-1]
	popj 17,

dp_uQint:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 4,(17)
	tlo 4,2200
	ldb 4,4
	hrrm 4,sk_uQint
	move 1,sk_uQint
	add 17,[-1,,-1]
	popj 17,

dvps_uQint:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	ldb 6,(17)
	hrrm 6,sk_uQint
	move 1,sk_uQint
	add 17,[-2,,-2]
	popj 17,

dae_uQint:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	movei 1,(17)
	pushj 17,svsesc
	movei 4,(17)
	ldb 4,(4)
	hrrm 4,sk_uQint
	move 1,sk_uQint
	add 17,[-2,,-2]
	popj 17,

sta_uQint:
	add 17,[1,,1]
	movei 4,(17)
	tlo 4,2200
	dpb 1,4
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_uQint
	add 17,[-1,,-1]
	popj 17,

aed_uQint:
	add 17,[1,,1]
	movem 1,(17)
	addi 1,1
	dpb 1,[POINT 9,(17),17]
	addi 1,1
	dpb 1,[POINT 9,(17),26]
	movei 4,(17)
	tlo 4,331100
	ildb 4,4
	hrrm 4,sk_uQint
	move 1,sk_uQint
	add 17,[-1,,-1]
	popj 17,

sfd_uQint:
	add 17,[1,,1]
	move 4,(17)
	dpb 1,[POINT 9,4,8]
	addi 1,1
	dpb 1,[POINT 9,4,17]
	movem 4,(17)
	movei 4,(17)
	tlo 4,331100
	ildb 4,4
	hrrm 4,sk_uQint
	move 1,sk_uQint
	add 17,[-1,,-1]
	popj 17,

psa_uQint:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,svsuse
	ldb 4,[POINT 9,(17),35]
	movem 4,vsk_uQint
	add 17,[-1,,-1]
	popj 17,

usd_uQint:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,psa_uQint
	move 1,11
	pushj 17,dd_uQint
	move 10,1
	andi 10,777	; zero_extendqisi2
	move 1,11
	pushj 17,dvl_uQint
	add 10,1
	move 1,11
	pushj 17,dp_uQint
	add 10,1
	move 1,11
	pushj 17,dvps_uQint
	add 10,1
	move 1,11
	pushj 17,dae_uQint
	add 10,1
	move 1,11
	pushj 17,sta_uQint
	add 10,1
	move 1,11
	pushj 17,aed_uQint
	add 10,1
	move 1,11
	pushj 17,sfd_uQint
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dd_Hint:
	add 17,[1,,1]
	hrrm 1,(17)
	hrrz 1,(17)
	movem 1,sk_Hint
	hrre 1,1
	add 17,[-1,,-1]
	popj 17,

dvl_Hint:
	add 17,[1,,1]
	hrrzi 1,(1)	; zero_extendhisi2
	movem 1,(17)
	move 1,(17)
	movem 1,sk_Hint
	hrre 1,1
	add 17,[-1,,-1]
	popj 17,

dp_Hint:
	add 17,[1,,1]
	hrrm 1,(17)
	movei 4,(17)
	tlo 4,2200
	ldb 4,4
	hrrm 4,sk_Hint
	hrre 1,sk_Hint
	add 17,[-1,,-1]
	popj 17,

dvps_Hint:
	add 17,[2,,2]
	hrrm 1,-1(17)
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	ldb 6,(17)
	hrrm 6,sk_Hint
	hrre 1,sk_Hint
	add 17,[-2,,-2]
	popj 17,

dae_Hint:
	add 17,[2,,2]
	hrrm 1,-1(17)
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	movei 1,(17)
	pushj 17,svsesc
	movei 4,(17)
	ldb 4,(4)
	hrrm 4,sk_Hint
	hrre 1,sk_Hint
	add 17,[-2,,-2]
	popj 17,

sta_Hint:
	add 17,[1,,1]
	movei 4,(17)
	tlo 4,2200
	dpb 1,4	; movhi
	hrrz 1,(17)
	movem 1,sk_Hint
	hrre 1,1
	add 17,[-1,,-1]
	popj 17,

aed_Hint:
	add 17,[2,,2]
	movem 1,-1(17)
	addi 1,1
	hrrm 1,-1(17)
	addi 1,1
	hrlm 1,(17)
	movei 4,-1(17)
	tlo 4,222200
	ibp 4
	ldb 4,4
	hrrm 4,sk_Hint
	hrre 1,sk_Hint
	add 17,[-2,,-2]
	popj 17,

sfd_Hint:
	add 17,[1,,1]
	hrlz 4,1
	iori 4,1(1)
	movem 4,(17)
	movei 4,(17)
	tlo 4,222200
	ibp 4
	ldb 4,4
	hrrm 4,sk_Hint
	hrre 1,sk_Hint
	add 17,[-1,,-1]
	popj 17,

psa_Hint:
	add 17,[1,,1]
	hrrm 1,(17)
	movei 1,(17)
	tlo 1,2200
	pushj 17,svsuse
	hrrz 4,(17)
	movem 4,vsk_Hint
	add 17,[-1,,-1]
	popj 17,

usd_Hint:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,psa_Hint
	move 1,11
	pushj 17,dd_Hint
	hrre 10,1	; extendhisi2
	move 1,11
	pushj 17,dvl_Hint
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,11
	pushj 17,dp_Hint
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,11
	pushj 17,dvps_Hint
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,11
	pushj 17,dae_Hint
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,11
	pushj 17,sta_Hint
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,11
	pushj 17,aed_Hint
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,11
	pushj 17,sfd_Hint
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dd_uHint:
	add 17,[1,,1]
	hrrm 1,(17)
	hrrz 1,(17)
	movem 1,sk_uHint
	add 17,[-1,,-1]
	popj 17,

dvl_uHint:
	add 17,[1,,1]
	hrrzi 1,(1)	; zero_extendhisi2
	movem 1,(17)
	move 1,(17)
	movem 1,sk_uHint
	add 17,[-1,,-1]
	popj 17,

dp_uHint:
	add 17,[1,,1]
	hrrm 1,(17)
	movei 4,(17)
	tlo 4,2200
	ldb 4,4
	hrrm 4,sk_uHint
	move 1,sk_uHint
	add 17,[-1,,-1]
	popj 17,

dvps_uHint:
	add 17,[2,,2]
	hrrm 1,-1(17)
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	ldb 6,(17)
	hrrm 6,sk_uHint
	move 1,sk_uHint
	add 17,[-2,,-2]
	popj 17,

dae_uHint:
	add 17,[2,,2]
	hrrm 1,-1(17)
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	movei 1,(17)
	pushj 17,svsesc
	movei 4,(17)
	ldb 4,(4)
	hrrm 4,sk_uHint
	move 1,sk_uHint
	add 17,[-2,,-2]
	popj 17,

sta_uHint:
	add 17,[1,,1]
	movei 4,(17)
	tlo 4,2200
	dpb 1,4	; movhi
	hrrz 1,(17)
	movem 1,sk_uHint
	add 17,[-1,,-1]
	popj 17,

aed_uHint:
	add 17,[2,,2]
	movem 1,-1(17)
	addi 1,1
	hrrm 1,-1(17)
	addi 1,1
	hrlm 1,(17)
	movei 4,-1(17)
	tlo 4,222200
	ibp 4
	ldb 4,4
	hrrm 4,sk_uHint
	move 1,sk_uHint
	add 17,[-2,,-2]
	popj 17,

sfd_uHint:
	add 17,[1,,1]
	hrlz 4,1
	iori 4,1(1)
	movem 4,(17)
	movei 4,(17)
	tlo 4,222200
	ibp 4
	ldb 4,4
	hrrm 4,sk_uHint
	move 1,sk_uHint
	add 17,[-1,,-1]
	popj 17,

psa_uHint:
	add 17,[1,,1]
	hrrm 1,(17)
	movei 1,(17)
	tlo 1,2200
	pushj 17,svsuse
	hrrz 4,(17)
	movem 4,vsk_uHint
	add 17,[-1,,-1]
	popj 17,

usd_uHint:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,psa_uHint
	move 1,11
	pushj 17,dd_uHint
	move 10,1
	hrrzi 10,(10)	; zero_extendhisi2
	move 1,11
	pushj 17,dvl_uHint
	add 10,1
	move 1,11
	pushj 17,dp_uHint
	add 10,1
	move 1,11
	pushj 17,dvps_uHint
	add 10,1
	move 1,11
	pushj 17,dae_uHint
	add 10,1
	move 1,11
	pushj 17,sta_uHint
	add 10,1
	move 1,11
	pushj 17,aed_uHint
	add 10,1
	move 1,11
	pushj 17,sfd_uHint
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dd_char6:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_char6
	lsh 1,36
	ash 1,-36
	add 17,[-1,,-1]
	popj 17,

dvl_char6:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	movem 1,(17)
	move 1,(17)
	movem 1,sk_char6
	lsh 1,36
	ash 1,-36
	add 17,[-1,,-1]
	popj 17,

dp_char6:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 4,(17)
	tlo 4,2200
	ldb 4,4
	hrrm 4,sk_char6
	hrre 1,sk_char6
	add 17,[-1,,-1]
	popj 17,

dvps_char6:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	ldb 6,(17)
	hrrm 6,sk_char6
	hrre 1,sk_char6
	add 17,[-2,,-2]
	popj 17,

dae_char6:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	movei 1,(17)
	pushj 17,svsesc
	movei 4,(17)
	ldb 4,(4)
	hrrm 4,sk_char6
	hrre 1,sk_char6
	add 17,[-2,,-2]
	popj 17,

sta_char6:
	add 17,[1,,1]
	movei 4,(17)
	tlo 4,2200
	dpb 1,4
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_char6
	lsh 1,36
	ash 1,-36
	add 17,[-1,,-1]
	popj 17,

aed_char6:
	add 17,[1,,1]
	dpb 1,[POINT 6,(17),5]
	addi 1,1
	dpb 1,[POINT 6,(17),11]
	addi 1,1
	dpb 1,[POINT 6,(17),17]
	movei 4,(17)
	tlo 4,360600
	ildb 4,4
	hrrm 4,sk_char6
	hrre 1,sk_char6
	add 17,[-1,,-1]
	popj 17,

sfd_char6:
	add 17,[1,,1]
	move 4,(17)
	dpb 1,[POINT 6,4,5]
	addi 1,1
	dpb 1,[POINT 6,4,11]
	movem 4,(17)
	movei 4,(17)
	tlo 4,360600
	ldb 4,4
	hrrm 4,sk_char6
	hrre 1,sk_char6
	add 17,[-1,,-1]
	popj 17,

psa_char6:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,svsuse
	ldb 4,[POINT 9,(17),35]
	movem 4,vsk_char6
	add 17,[-1,,-1]
	popj 17,

usd_char6:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,psa_char6
	move 1,11
	pushj 17,dd_char6
	move 10,1
	lsh 10,36
	ash 10,-36
	move 1,11
	pushj 17,dvl_char6
	lsh 1,36
	ash 1,-36
	add 10,1
	move 1,11
	pushj 17,dp_char6
	lsh 1,36
	ash 1,-36
	add 10,1
	move 1,11
	pushj 17,dvps_char6
	lsh 1,36
	ash 1,-36
	add 10,1
	move 1,11
	pushj 17,dae_char6
	lsh 1,36
	ash 1,-36
	add 10,1
	move 1,11
	pushj 17,sta_char6
	lsh 1,36
	ash 1,-36
	add 10,1
	move 1,11
	pushj 17,aed_char6
	lsh 1,36
	ash 1,-36
	add 10,1
	move 1,11
	pushj 17,sfd_char6
	lsh 1,36
	ash 1,-36
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dd_uchar6:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_uchar6
	andi 1,77
	add 17,[-1,,-1]
	popj 17,

dvl_uchar6:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	movem 1,(17)
	move 1,(17)
	movem 1,sk_uchar6
	andi 1,77
	add 17,[-1,,-1]
	popj 17,

dp_uchar6:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 4,(17)
	tlo 4,2200
	ldb 4,4
	hrrm 4,sk_uchar6
	move 1,sk_uchar6
	add 17,[-1,,-1]
	popj 17,

dvps_uchar6:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	ldb 6,(17)
	hrrm 6,sk_uchar6
	move 1,sk_uchar6
	add 17,[-2,,-2]
	popj 17,

dae_uchar6:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	movei 1,(17)
	pushj 17,svsesc
	movei 4,(17)
	ldb 4,(4)
	hrrm 4,sk_uchar6
	move 1,sk_uchar6
	add 17,[-2,,-2]
	popj 17,

sta_uchar6:
	add 17,[1,,1]
	movei 4,(17)
	tlo 4,2200
	dpb 1,4
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_uchar6
	andi 1,77
	add 17,[-1,,-1]
	popj 17,

aed_uchar6:
	add 17,[1,,1]
	dpb 1,[POINT 6,(17),5]
	addi 1,1
	dpb 1,[POINT 6,(17),11]
	addi 1,1
	dpb 1,[POINT 6,(17),17]
	movei 4,(17)
	tlo 4,360600
	ildb 4,4
	hrrm 4,sk_uchar6
	move 1,sk_uchar6
	add 17,[-1,,-1]
	popj 17,

sfd_uchar6:
	add 17,[1,,1]
	move 4,(17)
	dpb 1,[POINT 6,4,5]
	addi 1,1
	dpb 1,[POINT 6,4,11]
	movem 4,(17)
	movei 4,(17)
	tlo 4,360600
	ldb 4,4
	hrrm 4,sk_uchar6
	move 1,sk_uchar6
	add 17,[-1,,-1]
	popj 17,

psa_uchar6:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,svsuse
	ldb 4,[POINT 9,(17),35]
	movem 4,vsk_uchar6
	add 17,[-1,,-1]
	popj 17,

usd_uchar6:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,psa_uchar6
	move 1,11
	pushj 17,dd_uchar6
	move 10,1
	andi 10,77
	move 1,11
	pushj 17,dvl_uchar6
	andi 1,77
	add 10,1
	move 1,11
	pushj 17,dp_uchar6
	andi 1,77
	add 10,1
	move 1,11
	pushj 17,dvps_uchar6
	andi 1,77
	add 10,1
	move 1,11
	pushj 17,dae_uchar6
	andi 1,77
	add 10,1
	move 1,11
	pushj 17,sta_uchar6
	andi 1,77
	add 10,1
	move 1,11
	pushj 17,aed_uchar6
	andi 1,77
	add 10,1
	move 1,11
	pushj 17,sfd_uchar6
	andi 1,77
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dd_char7:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_char7
	lsh 1,35
	ash 1,-35
	add 17,[-1,,-1]
	popj 17,

dvl_char7:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	movem 1,(17)
	move 1,(17)
	movem 1,sk_char7
	lsh 1,35
	ash 1,-35
	add 17,[-1,,-1]
	popj 17,

dp_char7:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 4,(17)
	tlo 4,2200
	ldb 4,4
	hrrm 4,sk_char7
	hrre 1,sk_char7
	add 17,[-1,,-1]
	popj 17,

dvps_char7:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	ldb 6,(17)
	hrrm 6,sk_char7
	hrre 1,sk_char7
	add 17,[-2,,-2]
	popj 17,

dae_char7:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	movei 1,(17)
	pushj 17,svsesc
	movei 4,(17)
	ldb 4,(4)
	hrrm 4,sk_char7
	hrre 1,sk_char7
	add 17,[-2,,-2]
	popj 17,

sta_char7:
	add 17,[1,,1]
	movei 4,(17)
	tlo 4,2200
	dpb 1,4
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_char7
	lsh 1,35
	ash 1,-35
	add 17,[-1,,-1]
	popj 17,

aed_char7:
	add 17,[1,,1]
	dpb 1,[POINT 7,(17),6]
	addi 1,1
	dpb 1,[POINT 7,(17),13]
	addi 1,1
	dpb 1,[POINT 7,(17),20]
	movei 4,(17)
	tlo 4,350700
	ildb 4,4
	hrrm 4,sk_char7
	hrre 1,sk_char7
	add 17,[-1,,-1]
	popj 17,

sfd_char7:
	add 17,[1,,1]
	move 4,(17)
	dpb 1,[POINT 7,4,6]
	addi 1,1
	dpb 1,[POINT 7,4,13]
	movem 4,(17)
	movei 4,(17)
	tlo 4,350700
	ldb 4,4
	hrrm 4,sk_char7
	hrre 1,sk_char7
	add 17,[-1,,-1]
	popj 17,

psa_char7:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,svsuse
	ldb 4,[POINT 9,(17),35]
	movem 4,vsk_char7
	add 17,[-1,,-1]
	popj 17,

usd_char7:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,psa_char7
	move 1,11
	pushj 17,dd_char7
	move 10,1
	lsh 10,35
	ash 10,-35
	move 1,11
	pushj 17,dvl_char7
	lsh 1,35
	ash 1,-35
	add 10,1
	move 1,11
	pushj 17,dp_char7
	lsh 1,35
	ash 1,-35
	add 10,1
	move 1,11
	pushj 17,dvps_char7
	lsh 1,35
	ash 1,-35
	add 10,1
	move 1,11
	pushj 17,dae_char7
	lsh 1,35
	ash 1,-35
	add 10,1
	move 1,11
	pushj 17,sta_char7
	lsh 1,35
	ash 1,-35
	add 10,1
	move 1,11
	pushj 17,aed_char7
	lsh 1,35
	ash 1,-35
	add 10,1
	move 1,11
	pushj 17,sfd_char7
	lsh 1,35
	ash 1,-35
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dd_uchar7:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_uchar7
	andi 1,177
	add 17,[-1,,-1]
	popj 17,

dvl_uchar7:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	movem 1,(17)
	move 1,(17)
	movem 1,sk_uchar7
	andi 1,177
	add 17,[-1,,-1]
	popj 17,

dp_uchar7:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 4,(17)
	tlo 4,2200
	ldb 4,4
	hrrm 4,sk_uchar7
	move 1,sk_uchar7
	add 17,[-1,,-1]
	popj 17,

dvps_uchar7:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	ldb 6,(17)
	hrrm 6,sk_uchar7
	move 1,sk_uchar7
	add 17,[-2,,-2]
	popj 17,

dae_uchar7:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	movei 1,(17)
	pushj 17,svsesc
	movei 4,(17)
	ldb 4,(4)
	hrrm 4,sk_uchar7
	move 1,sk_uchar7
	add 17,[-2,,-2]
	popj 17,

sta_uchar7:
	add 17,[1,,1]
	movei 4,(17)
	tlo 4,2200
	dpb 1,4
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_uchar7
	andi 1,177
	add 17,[-1,,-1]
	popj 17,

aed_uchar7:
	add 17,[1,,1]
	dpb 1,[POINT 7,(17),6]
	addi 1,1
	dpb 1,[POINT 7,(17),13]
	addi 1,1
	dpb 1,[POINT 7,(17),20]
	movei 4,(17)
	tlo 4,350700
	ildb 4,4
	hrrm 4,sk_uchar7
	move 1,sk_uchar7
	add 17,[-1,,-1]
	popj 17,

sfd_uchar7:
	add 17,[1,,1]
	move 4,(17)
	dpb 1,[POINT 7,4,6]
	addi 1,1
	dpb 1,[POINT 7,4,13]
	movem 4,(17)
	movei 4,(17)
	tlo 4,350700
	ldb 4,4
	hrrm 4,sk_uchar7
	move 1,sk_uchar7
	add 17,[-1,,-1]
	popj 17,

psa_uchar7:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,svsuse
	ldb 4,[POINT 9,(17),35]
	movem 4,vsk_uchar7
	add 17,[-1,,-1]
	popj 17,

usd_uchar7:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,psa_uchar7
	move 1,11
	pushj 17,dd_uchar7
	move 10,1
	andi 10,177
	move 1,11
	pushj 17,dvl_uchar7
	andi 1,177
	add 10,1
	move 1,11
	pushj 17,dp_uchar7
	andi 1,177
	add 10,1
	move 1,11
	pushj 17,dvps_uchar7
	andi 1,177
	add 10,1
	move 1,11
	pushj 17,dae_uchar7
	andi 1,177
	add 10,1
	move 1,11
	pushj 17,sta_uchar7
	andi 1,177
	add 10,1
	move 1,11
	pushj 17,aed_uchar7
	andi 1,177
	add 10,1
	move 1,11
	pushj 17,sfd_uchar7
	andi 1,177
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dd_char8:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_char8
	lsh 1,34
	ash 1,-34
	add 17,[-1,,-1]
	popj 17,

dvl_char8:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	movem 1,(17)
	move 1,(17)
	movem 1,sk_char8
	lsh 1,34
	ash 1,-34
	add 17,[-1,,-1]
	popj 17,

dp_char8:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 4,(17)
	tlo 4,2200
	ldb 4,4
	hrrm 4,sk_char8
	hrre 1,sk_char8
	add 17,[-1,,-1]
	popj 17,

dvps_char8:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	ldb 6,(17)
	hrrm 6,sk_char8
	hrre 1,sk_char8
	add 17,[-2,,-2]
	popj 17,

dae_char8:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	movei 1,(17)
	pushj 17,svsesc
	movei 4,(17)
	ldb 4,(4)
	hrrm 4,sk_char8
	hrre 1,sk_char8
	add 17,[-2,,-2]
	popj 17,

sta_char8:
	add 17,[1,,1]
	movei 4,(17)
	tlo 4,2200
	dpb 1,4
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_char8
	lsh 1,34
	ash 1,-34
	add 17,[-1,,-1]
	popj 17,

aed_char8:
	add 17,[1,,1]
	dpb 1,[POINT 8,(17),7]
	addi 1,1
	dpb 1,[POINT 8,(17),15]
	addi 1,1
	dpb 1,[POINT 8,(17),23]
	movei 4,(17)
	tlo 4,341000
	ildb 4,4
	hrrm 4,sk_char8
	hrre 1,sk_char8
	add 17,[-1,,-1]
	popj 17,

sfd_char8:
	add 17,[1,,1]
	move 4,(17)
	dpb 1,[POINT 8,4,7]
	addi 1,1
	dpb 1,[POINT 8,4,15]
	movem 4,(17)
	movei 4,(17)
	tlo 4,341000
	ldb 4,4
	hrrm 4,sk_char8
	hrre 1,sk_char8
	add 17,[-1,,-1]
	popj 17,

psa_char8:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,svsuse
	ldb 4,[POINT 9,(17),35]
	movem 4,vsk_char8
	add 17,[-1,,-1]
	popj 17,

usd_char8:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,psa_char8
	move 1,11
	pushj 17,dd_char8
	move 10,1
	lsh 10,34
	ash 10,-34
	move 1,11
	pushj 17,dvl_char8
	lsh 1,34
	ash 1,-34
	add 10,1
	move 1,11
	pushj 17,dp_char8
	lsh 1,34
	ash 1,-34
	add 10,1
	move 1,11
	pushj 17,dvps_char8
	lsh 1,34
	ash 1,-34
	add 10,1
	move 1,11
	pushj 17,dae_char8
	lsh 1,34
	ash 1,-34
	add 10,1
	move 1,11
	pushj 17,sta_char8
	lsh 1,34
	ash 1,-34
	add 10,1
	move 1,11
	pushj 17,aed_char8
	lsh 1,34
	ash 1,-34
	add 10,1
	move 1,11
	pushj 17,sfd_char8
	lsh 1,34
	ash 1,-34
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dd_uchar8:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_uchar8
	andi 1,377
	add 17,[-1,,-1]
	popj 17,

dvl_uchar8:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	movem 1,(17)
	move 1,(17)
	movem 1,sk_uchar8
	andi 1,377
	add 17,[-1,,-1]
	popj 17,

dp_uchar8:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 4,(17)
	tlo 4,2200
	ldb 4,4
	hrrm 4,sk_uchar8
	move 1,sk_uchar8
	add 17,[-1,,-1]
	popj 17,

dvps_uchar8:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	ldb 6,(17)
	hrrm 6,sk_uchar8
	move 1,sk_uchar8
	add 17,[-2,,-2]
	popj 17,

dae_uchar8:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	movei 1,(17)
	pushj 17,svsesc
	movei 4,(17)
	ldb 4,(4)
	hrrm 4,sk_uchar8
	move 1,sk_uchar8
	add 17,[-2,,-2]
	popj 17,

sta_uchar8:
	add 17,[1,,1]
	movei 4,(17)
	tlo 4,2200
	dpb 1,4
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_uchar8
	andi 1,377
	add 17,[-1,,-1]
	popj 17,

aed_uchar8:
	add 17,[1,,1]
	dpb 1,[POINT 8,(17),7]
	addi 1,1
	dpb 1,[POINT 8,(17),15]
	addi 1,1
	dpb 1,[POINT 8,(17),23]
	movei 4,(17)
	tlo 4,341000
	ildb 4,4
	hrrm 4,sk_uchar8
	move 1,sk_uchar8
	add 17,[-1,,-1]
	popj 17,

sfd_uchar8:
	add 17,[1,,1]
	move 4,(17)
	dpb 1,[POINT 8,4,7]
	addi 1,1
	dpb 1,[POINT 8,4,15]
	movem 4,(17)
	movei 4,(17)
	tlo 4,341000
	ldb 4,4
	hrrm 4,sk_uchar8
	move 1,sk_uchar8
	add 17,[-1,,-1]
	popj 17,

psa_uchar8:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,svsuse
	ldb 4,[POINT 9,(17),35]
	movem 4,vsk_uchar8
	add 17,[-1,,-1]
	popj 17,

usd_uchar8:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,psa_uchar8
	move 1,11
	pushj 17,dd_uchar8
	move 10,1
	andi 10,377
	move 1,11
	pushj 17,dvl_uchar8
	andi 1,377
	add 10,1
	move 1,11
	pushj 17,dp_uchar8
	andi 1,377
	add 10,1
	move 1,11
	pushj 17,dvps_uchar8
	andi 1,377
	add 10,1
	move 1,11
	pushj 17,dae_uchar8
	andi 1,377
	add 10,1
	move 1,11
	pushj 17,sta_uchar8
	andi 1,377
	add 10,1
	move 1,11
	pushj 17,aed_uchar8
	andi 1,377
	add 10,1
	move 1,11
	pushj 17,sfd_uchar8
	andi 1,377
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dd_char9:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_char9
	lsh 1,33
	ash 1,-33
	add 17,[-1,,-1]
	popj 17,

dvl_char9:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	movem 1,(17)
	move 1,(17)
	movem 1,sk_char9
	lsh 1,33
	ash 1,-33
	add 17,[-1,,-1]
	popj 17,

dp_char9:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 4,(17)
	tlo 4,2200
	ldb 4,4
	hrrm 4,sk_char9
	hrre 1,sk_char9
	add 17,[-1,,-1]
	popj 17,

dvps_char9:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	ldb 6,(17)
	hrrm 6,sk_char9
	hrre 1,sk_char9
	add 17,[-2,,-2]
	popj 17,

dae_char9:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	movei 1,(17)
	pushj 17,svsesc
	movei 4,(17)
	ldb 4,(4)
	hrrm 4,sk_char9
	hrre 1,sk_char9
	add 17,[-2,,-2]
	popj 17,

sta_char9:
	add 17,[1,,1]
	movei 4,(17)
	tlo 4,2200
	dpb 1,4
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_char9
	lsh 1,33
	ash 1,-33
	add 17,[-1,,-1]
	popj 17,

aed_char9:
	add 17,[1,,1]
	movem 1,(17)
	addi 1,1
	dpb 1,[POINT 9,(17),17]
	addi 1,1
	dpb 1,[POINT 9,(17),26]
	movei 4,(17)
	tlo 4,331100
	ildb 4,4
	hrrm 4,sk_char9
	hrre 1,sk_char9
	add 17,[-1,,-1]
	popj 17,

sfd_char9:
	add 17,[1,,1]
	move 4,(17)
	dpb 1,[POINT 9,4,8]
	addi 1,1
	dpb 1,[POINT 9,4,17]
	movem 4,(17)
	movei 4,(17)
	tlo 4,331100
	ildb 4,4
	hrrm 4,sk_char9
	hrre 1,sk_char9
	add 17,[-1,,-1]
	popj 17,

psa_char9:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,svsuse
	ldb 4,[POINT 9,(17),35]
	movem 4,vsk_char9
	add 17,[-1,,-1]
	popj 17,

usd_char9:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,psa_char9
	move 1,11
	pushj 17,dd_char9
	move 10,1
	lsh 10,33
	ash 10,-33
	move 1,11
	pushj 17,dvl_char9
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,dp_char9
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,dvps_char9
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,dae_char9
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,sta_char9
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,aed_char9
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	pushj 17,sfd_char9
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dd_uchar9:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_uchar9
	add 17,[-1,,-1]
	popj 17,

dvl_uchar9:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	movem 1,(17)
	move 1,(17)
	movem 1,sk_uchar9
	add 17,[-1,,-1]
	popj 17,

dp_uchar9:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 4,(17)
	tlo 4,2200
	ldb 4,4
	hrrm 4,sk_uchar9
	move 1,sk_uchar9
	add 17,[-1,,-1]
	popj 17,

dvps_uchar9:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	ldb 6,(17)
	hrrm 6,sk_uchar9
	move 1,sk_uchar9
	add 17,[-2,,-2]
	popj 17,

dae_uchar9:
	add 17,[2,,2]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,-1(17),35]
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	movei 1,(17)
	pushj 17,svsesc
	movei 4,(17)
	ldb 4,(4)
	hrrm 4,sk_uchar9
	move 1,sk_uchar9
	add 17,[-2,,-2]
	popj 17,

sta_uchar9:
	add 17,[1,,1]
	movei 4,(17)
	tlo 4,2200
	dpb 1,4
	ldb 1,[POINT 9,(17),35]
	movem 1,sk_uchar9
	add 17,[-1,,-1]
	popj 17,

aed_uchar9:
	add 17,[1,,1]
	movem 1,(17)
	addi 1,1
	dpb 1,[POINT 9,(17),17]
	addi 1,1
	dpb 1,[POINT 9,(17),26]
	movei 4,(17)
	tlo 4,331100
	ildb 4,4
	hrrm 4,sk_uchar9
	move 1,sk_uchar9
	add 17,[-1,,-1]
	popj 17,

sfd_uchar9:
	add 17,[1,,1]
	move 4,(17)
	dpb 1,[POINT 9,4,8]
	addi 1,1
	dpb 1,[POINT 9,4,17]
	movem 4,(17)
	movei 4,(17)
	tlo 4,331100
	ildb 4,4
	hrrm 4,sk_uchar9
	move 1,sk_uchar9
	add 17,[-1,,-1]
	popj 17,

psa_uchar9:
	add 17,[1,,1]
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,(17),35]
	movei 1,(17)
	tlo 1,2200
	pushj 17,svsuse
	ldb 4,[POINT 9,(17),35]
	movem 4,vsk_uchar9
	add 17,[-1,,-1]
	popj 17,

usd_uchar9:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,psa_uchar9
	move 1,11
	pushj 17,dd_uchar9
	move 10,1
	andi 10,777	; zero_extendqisi2
	move 1,11
	pushj 17,dvl_uchar9
	add 10,1
	move 1,11
	pushj 17,dp_uchar9
	add 10,1
	move 1,11
	pushj 17,dvps_uchar9
	add 10,1
	move 1,11
	pushj 17,dae_uchar9
	add 10,1
	move 1,11
	pushj 17,sta_uchar9
	add 10,1
	move 1,11
	pushj 17,aed_uchar9
	add 10,1
	move 1,11
	pushj 17,sfd_uchar9
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dd_short16:
	add 17,[1,,1]
	hrrm 1,(17)
	hrrz 1,(17)
	movem 1,sk_short16
	lsh 1,24
	ash 1,-24
	add 17,[-1,,-1]
	popj 17,

dvl_short16:
	add 17,[1,,1]
	hrrzi 1,(1)	; zero_extendhisi2
	movem 1,(17)
	move 1,(17)
	movem 1,sk_short16
	lsh 1,24
	ash 1,-24
	add 17,[-1,,-1]
	popj 17,

dp_short16:
	add 17,[1,,1]
	hrrm 1,(17)
	movei 4,(17)
	tlo 4,2200
	ldb 4,4
	hrrm 4,sk_short16
	hlrz 1,sk_short16
	lsh 1,24
	ash 1,-24
	add 17,[-1,,-1]
	popj 17,

dvps_short16:
	add 17,[2,,2]
	hrrm 1,-1(17)
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	ldb 6,(17)
	hrrm 6,sk_short16
	hlrz 1,sk_short16
	lsh 1,24
	ash 1,-24
	add 17,[-2,,-2]
	popj 17,

dae_short16:
	add 17,[2,,2]
	hrrm 1,-1(17)
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	movei 1,(17)
	pushj 17,svsesc
	movei 4,(17)
	ldb 4,(4)
	hrrm 4,sk_short16
	hlrz 1,sk_short16
	lsh 1,24
	ash 1,-24
	add 17,[-2,,-2]
	popj 17,

sta_short16:
	add 17,[1,,1]
	movei 4,(17)
	tlo 4,2200
	dpb 1,4	; movhi
	hrrz 1,(17)
	movem 1,sk_short16
	lsh 1,24
	ash 1,-24
	add 17,[-1,,-1]
	popj 17,

aed_short16:
	add 17,[2,,2]
	dpb 1,[POINT 16,-1(17),15]
	addi 1,1
	dpb 1,[POINT 16,-1(17),31]
	addi 1,1
	dpb 1,[POINT 16,(17),15]
	movei 4,-1(17)
	tlo 4,222200
	ibp 4
	ldb 4,4
	hrrm 4,sk_short16
	hlrz 1,sk_short16
	lsh 1,24
	ash 1,-24
	add 17,[-2,,-2]
	popj 17,

sfd_short16:
	add 17,[1,,1]
	move 4,(17)
	dpb 1,[POINT 16,4,15]
	addi 1,1
	dpb 1,[POINT 16,4,31]
	movem 4,(17)
	movei 4,(17)
	tlo 4,222200
	ldb 4,4
	hrrm 4,sk_short16
	hlrz 1,sk_short16
	lsh 1,24
	ash 1,-24
	add 17,[-1,,-1]
	popj 17,

psa_short16:
	add 17,[1,,1]
	hrrm 1,(17)
	movei 1,(17)
	tlo 1,2200
	pushj 17,svsuse
	hrrz 4,(17)
	movem 4,vsk_short16
	add 17,[-1,,-1]
	popj 17,

usd_short16:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,psa_short16
	move 1,11
	pushj 17,dd_short16
	move 10,1
	lsh 10,24
	ash 10,-24
	move 1,11
	pushj 17,dvl_short16
	lsh 1,24
	ash 1,-24
	add 10,1
	move 1,11
	pushj 17,dp_short16
	lsh 1,24
	ash 1,-24
	add 10,1
	move 1,11
	pushj 17,dvps_short16
	lsh 1,24
	ash 1,-24
	add 10,1
	move 1,11
	pushj 17,dae_short16
	lsh 1,24
	ash 1,-24
	add 10,1
	move 1,11
	pushj 17,sta_short16
	lsh 1,24
	ash 1,-24
	add 10,1
	move 1,11
	pushj 17,aed_short16
	lsh 1,24
	ash 1,-24
	add 10,1
	move 1,11
	pushj 17,sfd_short16
	lsh 1,24
	ash 1,-24
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dd_ushort16:
	add 17,[1,,1]
	hrrm 1,(17)
	hrrz 1,(17)
	movem 1,sk_ushort16
	andi 1,177777
	add 17,[-1,,-1]
	popj 17,

dvl_ushort16:
	add 17,[1,,1]
	hrrzi 1,(1)	; zero_extendhisi2
	movem 1,(17)
	move 1,(17)
	movem 1,sk_ushort16
	andi 1,177777
	add 17,[-1,,-1]
	popj 17,

dp_ushort16:
	add 17,[1,,1]
	hrrm 1,(17)
	movei 4,(17)
	tlo 4,2200
	ldb 4,4
	hrrm 4,sk_ushort16
	hlrz 1,sk_ushort16
	andi 1,177777
	add 17,[-1,,-1]
	popj 17,

dvps_ushort16:
	add 17,[2,,2]
	hrrm 1,-1(17)
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	ldb 6,(17)
	hrrm 6,sk_ushort16
	hlrz 1,sk_ushort16
	andi 1,177777
	add 17,[-2,,-2]
	popj 17,

dae_ushort16:
	add 17,[2,,2]
	hrrm 1,-1(17)
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	movei 1,(17)
	pushj 17,svsesc
	movei 4,(17)
	ldb 4,(4)
	hrrm 4,sk_ushort16
	hlrz 1,sk_ushort16
	andi 1,177777
	add 17,[-2,,-2]
	popj 17,

sta_ushort16:
	add 17,[1,,1]
	movei 4,(17)
	tlo 4,2200
	dpb 1,4	; movhi
	hrrz 1,(17)
	movem 1,sk_ushort16
	andi 1,177777
	add 17,[-1,,-1]
	popj 17,

aed_ushort16:
	add 17,[2,,2]
	dpb 1,[POINT 16,-1(17),15]
	addi 1,1
	dpb 1,[POINT 16,-1(17),31]
	addi 1,1
	dpb 1,[POINT 16,(17),15]
	movei 4,-1(17)
	tlo 4,222200
	ibp 4
	ldb 4,4
	hrrm 4,sk_ushort16
	hlrz 1,sk_ushort16
	andi 1,177777
	add 17,[-2,,-2]
	popj 17,

sfd_ushort16:
	add 17,[1,,1]
	move 4,(17)
	dpb 1,[POINT 16,4,15]
	addi 1,1
	dpb 1,[POINT 16,4,31]
	movem 4,(17)
	movei 4,(17)
	tlo 4,222200
	ldb 4,4
	hrrm 4,sk_ushort16
	hlrz 1,sk_ushort16
	andi 1,177777
	add 17,[-1,,-1]
	popj 17,

psa_ushort16:
	add 17,[1,,1]
	hrrm 1,(17)
	movei 1,(17)
	tlo 1,2200
	pushj 17,svsuse
	hrrz 4,(17)
	movem 4,vsk_ushort16
	add 17,[-1,,-1]
	popj 17,

usd_ushort16:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,psa_ushort16
	move 1,11
	pushj 17,dd_ushort16
	move 10,1
	andi 10,177777
	move 1,11
	pushj 17,dvl_ushort16
	andi 1,177777
	add 10,1
	move 1,11
	pushj 17,dp_ushort16
	andi 1,177777
	add 10,1
	move 1,11
	pushj 17,dvps_ushort16
	andi 1,177777
	add 10,1
	move 1,11
	pushj 17,dae_ushort16
	andi 1,177777
	add 10,1
	move 1,11
	pushj 17,sta_ushort16
	andi 1,177777
	add 10,1
	move 1,11
	pushj 17,aed_ushort16
	andi 1,177777
	add 10,1
	move 1,11
	pushj 17,sfd_ushort16
	andi 1,177777
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dd_short18:
	add 17,[1,,1]
	hrrm 1,(17)
	hrrz 1,(17)
	movem 1,sk_short18
	hrre 1,1
	add 17,[-1,,-1]
	popj 17,

dvl_short18:
	add 17,[1,,1]
	hrrzi 1,(1)	; zero_extendhisi2
	movem 1,(17)
	move 1,(17)
	movem 1,sk_short18
	hrre 1,1
	add 17,[-1,,-1]
	popj 17,

dp_short18:
	add 17,[1,,1]
	hrrm 1,(17)
	movei 4,(17)
	tlo 4,2200
	ldb 4,4
	hrrm 4,sk_short18
	hrre 1,sk_short18
	add 17,[-1,,-1]
	popj 17,

dvps_short18:
	add 17,[2,,2]
	hrrm 1,-1(17)
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	ldb 6,(17)
	hrrm 6,sk_short18
	hrre 1,sk_short18
	add 17,[-2,,-2]
	popj 17,

dae_short18:
	add 17,[2,,2]
	hrrm 1,-1(17)
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	movei 1,(17)
	pushj 17,svsesc
	movei 4,(17)
	ldb 4,(4)
	hrrm 4,sk_short18
	hrre 1,sk_short18
	add 17,[-2,,-2]
	popj 17,

sta_short18:
	add 17,[1,,1]
	movei 4,(17)
	tlo 4,2200
	dpb 1,4	; movhi
	hrrz 1,(17)
	movem 1,sk_short18
	hrre 1,1
	add 17,[-1,,-1]
	popj 17,

aed_short18:
	add 17,[2,,2]
	movem 1,-1(17)
	addi 1,1
	hrrm 1,-1(17)
	addi 1,1
	hrlm 1,(17)
	movei 4,-1(17)
	tlo 4,222200
	ibp 4
	ldb 4,4
	hrrm 4,sk_short18
	hrre 1,sk_short18
	add 17,[-2,,-2]
	popj 17,

sfd_short18:
	add 17,[1,,1]
	hrlz 4,1
	iori 4,1(1)
	movem 4,(17)
	movei 4,(17)
	tlo 4,222200
	ibp 4
	ldb 4,4
	hrrm 4,sk_short18
	hrre 1,sk_short18
	add 17,[-1,,-1]
	popj 17,

psa_short18:
	add 17,[1,,1]
	hrrm 1,(17)
	movei 1,(17)
	tlo 1,2200
	pushj 17,svsuse
	hrrz 4,(17)
	movem 4,vsk_short18
	add 17,[-1,,-1]
	popj 17,

usd_short18:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,psa_short18
	move 1,11
	pushj 17,dd_short18
	hrre 10,1	; extendhisi2
	move 1,11
	pushj 17,dvl_short18
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,11
	pushj 17,dp_short18
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,11
	pushj 17,dvps_short18
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,11
	pushj 17,dae_short18
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,11
	pushj 17,sta_short18
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,11
	pushj 17,aed_short18
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,11
	pushj 17,sfd_short18
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dd_ushort18:
	add 17,[1,,1]
	hrrm 1,(17)
	hrrz 1,(17)
	movem 1,sk_ushort18
	add 17,[-1,,-1]
	popj 17,

dvl_ushort18:
	add 17,[1,,1]
	hrrzi 1,(1)	; zero_extendhisi2
	movem 1,(17)
	move 1,(17)
	movem 1,sk_ushort18
	add 17,[-1,,-1]
	popj 17,

dp_ushort18:
	add 17,[1,,1]
	hrrm 1,(17)
	movei 4,(17)
	tlo 4,2200
	ldb 4,4
	hrrm 4,sk_ushort18
	move 1,sk_ushort18
	add 17,[-1,,-1]
	popj 17,

dvps_ushort18:
	add 17,[2,,2]
	hrrm 1,-1(17)
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	ldb 6,(17)
	hrrm 6,sk_ushort18
	move 1,sk_ushort18
	add 17,[-2,,-2]
	popj 17,

dae_ushort18:
	add 17,[2,,2]
	hrrm 1,-1(17)
	movei 4,-1(17)
	tlo 4,2200
	movem 4,(17)
	movei 1,(17)
	pushj 17,svsesc
	movei 4,(17)
	ldb 4,(4)
	hrrm 4,sk_ushort18
	move 1,sk_ushort18
	add 17,[-2,,-2]
	popj 17,

sta_ushort18:
	add 17,[1,,1]
	movei 4,(17)
	tlo 4,2200
	dpb 1,4	; movhi
	hrrz 1,(17)
	movem 1,sk_ushort18
	add 17,[-1,,-1]
	popj 17,

aed_ushort18:
	add 17,[2,,2]
	movem 1,-1(17)
	addi 1,1
	hrrm 1,-1(17)
	addi 1,1
	hrlm 1,(17)
	movei 4,-1(17)
	tlo 4,222200
	ibp 4
	ldb 4,4
	hrrm 4,sk_ushort18
	move 1,sk_ushort18
	add 17,[-2,,-2]
	popj 17,

sfd_ushort18:
	add 17,[1,,1]
	hrlz 4,1
	iori 4,1(1)
	movem 4,(17)
	movei 4,(17)
	tlo 4,222200
	ibp 4
	ldb 4,4
	hrrm 4,sk_ushort18
	move 1,sk_ushort18
	add 17,[-1,,-1]
	popj 17,

psa_ushort18:
	add 17,[1,,1]
	hrrm 1,(17)
	movei 1,(17)
	tlo 1,2200
	pushj 17,svsuse
	hrrz 4,(17)
	movem 4,vsk_ushort18
	add 17,[-1,,-1]
	popj 17,

usd_ushort18:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,psa_ushort18
	move 1,11
	pushj 17,dd_ushort18
	move 10,1
	hrrzi 10,(10)	; zero_extendhisi2
	move 1,11
	pushj 17,dvl_ushort18
	add 10,1
	move 1,11
	pushj 17,dp_ushort18
	add 10,1
	move 1,11
	pushj 17,dvps_ushort18
	add 10,1
	move 1,11
	pushj 17,dae_ushort18
	add 10,1
	move 1,11
	pushj 17,sta_ushort18
	add 10,1
	move 1,11
	pushj 17,aed_ushort18
	add 10,1
	move 1,11
	pushj 17,sfd_ushort18
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dd_int32:
	movem 1,sk_int32
	popj 17,

dvl_int32:
	add 17,[1,,1]
	movem 1,(17)
	move 6,(17)
	movem 6,sk_int32
	move 1,6
	add 17,[-1,,-1]
	popj 17,

dp_int32:
	movem 1,sk_int32
	popj 17,

dvps_int32:
	add 17,[2,,2]
	movem 1,(17)
	movei 4,(17)
	movem 4,-1(17)
	move 6,@-1(17)
	movem 6,sk_int32
	move 1,6
	add 17,[-2,,-2]
	popj 17,

dae_int32:
	add 17,[2,,2]
	movem 1,-1(17)
	movei 4,-1(17)
	movem 4,(17)
	movei 1,(17)
	pushj 17,svsesc
	movei 4,(17)
	move 4,@(4)
	movem 4,sk_int32
	move 1,4
	add 17,[-2,,-2]
	popj 17,

sta_int32:
	movem 1,sk_int32
	popj 17,

aed_int32:
	add 17,[3,,3]
	dpb 1,[POINT 32,-2(17),31]
	addi 1,1
	dpb 1,[POINT 32,-1(17),31]
	addi 1,1
	dpb 1,[POINT 32,(17),31]
	movei 4,-2(17)
	move 4,1(4)
	movem 4,sk_int32
	move 1,4
	add 17,[-3,,-3]
	popj 17,

sfd_int32:
	add 17,[2,,2]
	move 4,1
	lsh 4,4
	movem 4,-1(17)
	addi 1,1
	movei 4,-1(17)
	dpb 1,[POINT 32,1(4),31]
	move 4,1(4)
	movem 4,sk_int32
	move 1,4
	add 17,[-2,,-2]
	popj 17,

psa_int32:
	add 17,[1,,1]
	movem 1,(17)
	movei 1,(17)
	pushj 17,svsuse
	movei 4,(17)
	move 4,(4)
	movem 4,vsk_int32
	add 17,[-1,,-1]
	popj 17,

usd_int32:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,psa_int32
	move 1,11
	pushj 17,dd_int32
	move 10,1
	move 1,11
	pushj 17,dvl_int32
	add 10,1
	move 1,11
	pushj 17,dp_int32
	add 10,1
	move 1,11
	pushj 17,dvps_int32
	add 10,1
	move 1,11
	pushj 17,dae_int32
	add 10,1
	move 1,11
	pushj 17,sta_int32
	add 10,1
	move 1,11
	pushj 17,aed_int32
	add 10,1
	move 1,11
	pushj 17,sfd_int32
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dd_uint32:
	movem 1,sk_uint32
	popj 17,

dvl_uint32:
	add 17,[1,,1]
	movem 1,(17)
	move 6,(17)
	movem 6,sk_uint32
	move 1,6
	add 17,[-1,,-1]
	popj 17,

dp_uint32:
	movem 1,sk_uint32
	popj 17,

dvps_uint32:
	add 17,[2,,2]
	movem 1,(17)
	movei 4,(17)
	movem 4,-1(17)
	move 6,@-1(17)
	movem 6,sk_uint32
	move 1,6
	add 17,[-2,,-2]
	popj 17,

dae_uint32:
	add 17,[2,,2]
	movem 1,-1(17)
	movei 4,-1(17)
	movem 4,(17)
	movei 1,(17)
	pushj 17,svsesc
	movei 4,(17)
	move 4,@(4)
	movem 4,sk_uint32
	move 1,4
	add 17,[-2,,-2]
	popj 17,

sta_uint32:
	movem 1,sk_uint32
	popj 17,

aed_uint32:
	add 17,[3,,3]
	dpb 1,[POINT 32,-2(17),31]
	addi 1,1
	dpb 1,[POINT 32,-1(17),31]
	addi 1,1
	dpb 1,[POINT 32,(17),31]
	movei 4,-2(17)
	move 4,1(4)
	movem 4,sk_uint32
	move 1,4
	add 17,[-3,,-3]
	popj 17,

sfd_uint32:
	add 17,[2,,2]
	move 4,1
	lsh 4,4
	movem 4,-1(17)
	addi 1,1
	movei 4,-1(17)
	dpb 1,[POINT 32,1(4),31]
	move 4,1(4)
	movem 4,sk_uint32
	move 1,4
	add 17,[-2,,-2]
	popj 17,

psa_uint32:
	add 17,[1,,1]
	movem 1,(17)
	movei 1,(17)
	pushj 17,svsuse
	movei 4,(17)
	move 4,(4)
	movem 4,vsk_uint32
	add 17,[-1,,-1]
	popj 17,

usd_uint32:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,psa_uint32
	move 1,11
	pushj 17,dd_uint32
	move 10,1
	move 1,11
	pushj 17,dvl_uint32
	add 10,1
	move 1,11
	pushj 17,dp_uint32
	add 10,1
	move 1,11
	pushj 17,dvps_uint32
	add 10,1
	move 1,11
	pushj 17,dae_uint32
	add 10,1
	move 1,11
	pushj 17,sta_uint32
	add 10,1
	move 1,11
	pushj 17,aed_uint32
	add 10,1
	move 1,11
	pushj 17,sfd_uint32
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.globl	use_svst_deref
use_svst_deref:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,usd_char
	move 10,1
	move 1,11
	pushj 17,usd_schar
	add 10,1
	move 1,11
	pushj 17,usd_uchar
	add 10,1
	move 1,11
	pushj 17,usd_Qint
	add 10,1
	move 1,11
	pushj 17,usd_sQint
	add 10,1
	move 1,11
	pushj 17,usd_uQint
	add 10,1
	move 1,11
	pushj 17,usd_Hint
	add 10,1
	move 1,11
	pushj 17,usd_uHint
	add 10,1
	move 1,11
	pushj 17,usd_char6
	add 10,1
	move 1,11
	pushj 17,usd_uchar6
	add 10,1
	move 1,11
	pushj 17,usd_char7
	add 10,1
	move 1,11
	pushj 17,usd_uchar7
	add 10,1
	move 1,11
	pushj 17,usd_char8
	add 10,1
	move 1,11
	pushj 17,usd_uchar8
	add 10,1
	move 1,11
	pushj 17,usd_char9
	add 10,1
	move 1,11
	pushj 17,usd_uchar9
	add 10,1
	move 1,11
	pushj 17,usd_short16
	add 10,1
	move 1,11
	pushj 17,usd_ushort16
	add 10,1
	move 1,11
	pushj 17,usd_short18
	add 10,1
	move 1,11
	pushj 17,usd_ushort18
	add 10,1
	move 1,11
	pushj 17,usd_int32
	add 10,1
	move 1,11
	pushj 17,usd_uint32
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
sk_char:
	.space	4
vsk_char:
	.space	4
sk_schar:
	.space	4
vsk_schar:
	.space	4
sk_uchar:
	.space	4
vsk_uchar:
	.space	4
sk_Qint:
	.space	4
vsk_Qint:
	.space	4
sk_sQint:
	.space	4
vsk_sQint:
	.space	4
sk_uQint:
	.space	4
vsk_uQint:
	.space	4
sk_Hint:
	.space	4
vsk_Hint:
	.space	4
sk_uHint:
	.space	4
vsk_uHint:
	.space	4
sk_char6:
	.space	4
vsk_char6:
	.space	4
sk_uchar6:
	.space	4
vsk_uchar6:
	.space	4
sk_char7:
	.space	4
vsk_char7:
	.space	4
sk_uchar7:
	.space	4
vsk_uchar7:
	.space	4
sk_char8:
	.space	4
vsk_char8:
	.space	4
sk_uchar8:
	.space	4
vsk_uchar8:
	.space	4
sk_char9:
	.space	4
vsk_char9:
	.space	4
sk_uchar9:
	.space	4
vsk_uchar9:
	.space	4
sk_short16:
	.space	4
vsk_short16:
	.space	4
sk_ushort16:
	.space	4
vsk_ushort16:
	.space	4
sk_short18:
	.space	4
vsk_short18:
	.space	4
sk_ushort18:
	.space	4
vsk_ushort18:
	.space	4
sk_int32:
	.space	4
vsk_int32:
	.space	4
sk_uint32:
	.space	4
vsk_uint32:
	.space	4
