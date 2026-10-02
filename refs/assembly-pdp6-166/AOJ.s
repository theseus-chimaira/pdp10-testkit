
aojl:
%L2:
	add 1,2
	aojl 2,%L2
	add 1,2
	popj 17,

aoje:
%L7:
	add 1,2
	aoje 2,%L7
	add 1,2
	popj 17,

aojle:
%L12:
	add 1,2
	aojle 2,%L12
	add 1,2
	popj 17,

aojge:
%L17:
	add 1,2
	aojge 2,%L17
	add 1,2
	popj 17,

aojn:
%L22:
	add 1,2
	aojn 2,%L22
	popj 17,

aojg:
%L27:
	add 1,2
	aojg 2,%L27
	add 1,2
	popj 17,

aoja:
	move 4,1
	move 1,2
%L32:
	add 4,1
	caie 4,123456
	aoja 1,%L32
	addi 1,123456
	popj 17,

aoja_two_exits:
%L36:
	add 1,2
	move 4,1
	add 4,2
	jumpl 1,%L35
	move 4,2
	jumpe 1,%L35
	aoja 2,%L36
%L35:
	move 1,4
	popj 17,

aoj_plain_increment:
	addi 2,1
	add 1,2
	popj 17,

aoj_preinc_value:
	addi 2,1
	add 1,2
	add 1,2
	popj 17,

aoj_nested_l_g:
%L42:
	add 1,2
%L45:
	add 1,3
	aojg 3,%L45
	aojl 2,%L42
	add 1,2
	add 1,3
	popj 17,

aoj_nested_n_le:
%L51:
	add 1,2
%L54:
	add 1,3
	aojle 3,%L54
	aojn 2,%L51
	add 1,3
	popj 17,

aoj_with_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
%L60:
	add 11,10
	pushj 17,clobber
	aojg 10,%L60
	add 11,10
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

aoj_with_memory_use:
	move 3,(3)
%L65:
	add 1,3
	add 1,2
	aojn 2,%L65
	add 3,1
	move 1,3
	popj 17,

aoj_threshold_l:
%L70:
	xor 1,2
	aojl 2,%L70
	add 1,2
	popj 17,

aoj_threshold_ge:
%L75:
	xor 1,2
	aojge 2,%L75
	add 1,2
	popj 17,

aoje_from_minus_one:
	move 4,1
	seto 1,
%L80:
	add 4,1
	aoje 1,%L80
	add 1,4
	popj 17,

aojn_from_minus_two:
	hrroi 4,777776
%L85:
	add 1,4
	aojn 4,%L85
	popj 17,

uaojn:
%L90:
	add 1,2
	aojn 2,%L90
	popj 17,

uaoja:
	move 4,1
	move 1,2
%L95:
	add 4,1
	caie 4,123456
	aoja 1,%L95
	addi 1,123456
	popj 17,

