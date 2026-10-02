	.data
	.align	2
Qp1:
	.long	Q+301989888
	.align	2
Qp2:
	.long	QA+29142024193
	.align	2
Qp3:
	.long	QA+19478347777
	.align	2
Qp4:
	.long	QA+9814671361
	.align	2
Qp5:
	.long	QA+150994945
	.align	2
UQp1:
	.long	UQ+301989888
	.align	2
UQp2:
	.long	UQA+29142024193
	.align	2
UQp3:
	.long	S+29142024193
	.align	2
UQp4:
	.long	S+19478347777
	.align	2
UQp5:
	.long	S+9814671361
	.align	2
UQp6:
	.long	S+150994945
	.align	2
Hp1:
	.long	H+301989888
	.align	2
Hp2:
	.long	HA+19629342721
	.align	2
Hp3:
	.long	HA+301989889
	.align	2
Hp4:
	.long	S+19629342722
	.align	2
Hp5:
	.long	S+301989890
	.align	2
UHp1:
	.long	UH+301989888
	.align	2
UHp2:
	.long	UHA+19629342721
	.align	2
Cp1:
	.long	C+301989888
	.align	2
Cp2:
	.long	CA+29142024193

ldb1:
	move 1,S+1
	lsh 1,-33
	popj 17,

ldb2:
	ldb 1,[POINT 9,S+1,17]
	popj 17,

ldb3:
	ldb 1,[POINT 9,S+1,26]
	popj 17,

ldb4:
	move 1,S+1
	andi 1,777
	popj 17,

ldb5:
	ldb 1,[POINT 8,S+3,15]
	popj 17,

ldb6:
	ldb 1,[POINT 10,S+3,25]
	popj 17,

ldb7:
	ldb 1,[POINT 8,1,15]
	popj 17,

ldb8:
	ldb 1,[POINT 10,1,25]
	popj 17,

qptr_load_1:
	ldb 1,Qp1
	trne 1,400
	orcmi 1,777
	popj 17,

qptr_load_2:
	ldb 1,Qp2
	trne 1,400
	orcmi 1,777
	popj 17,

qptr_load_3:
	ldb 1,Qp3
	trne 1,400
	orcmi 1,777
	popj 17,

qptr_load_4:
	ldb 1,Qp4
	trne 1,400
	orcmi 1,777
	popj 17,

qptr_load_5:
	ldb 1,Qp5
	trne 1,400
	orcmi 1,777
	popj 17,

uqptr_load_1:
	ldb 1,UQp1
	popj 17,

uqptr_load_2:
	ldb 1,UQp2
	popj 17,

uqptr_load_3:
	ldb 1,UQp3
	popj 17,

uqptr_load_4:
	ldb 1,UQp4
	popj 17,

uqptr_load_5:
	ldb 1,UQp5
	popj 17,

uqptr_load_6:
	ldb 1,UQp6
	popj 17,

hptr_load_1:
	ldb 1,Hp1
	hrre 1,1
	popj 17,

hptr_load_2:
	ldb 1,Hp2
	hrre 1,1
	popj 17,

hptr_load_3:
	ldb 1,Hp3
	hrre 1,1
	popj 17,

hptr_load_4:
	ldb 1,Hp4
	hrre 1,1
	popj 17,

hptr_load_5:
	ldb 1,Hp5
	hrre 1,1
	popj 17,

uhptr_load_1:
	ldb 1,UHp1
	popj 17,

uhptr_load_2:
	ldb 1,UHp2
	popj 17,

cptr_load_1:
	ldb 1,Cp1
	popj 17,

cptr_load_2:
	ldb 1,Cp2
	popj 17,

qptr_store_1:
	dpb 1,Qp1
	popj 17,

qptr_store_2:
	dpb 1,Qp2
	popj 17,

qptr_store_3:
	dpb 1,Qp3
	popj 17,

qptr_store_4:
	dpb 1,Qp4
	popj 17,

qptr_store_5:
	dpb 1,Qp5
	popj 17,

uqptr_store_1:
	dpb 1,UQp1
	popj 17,

uqptr_store_2:
	dpb 1,UQp2
	popj 17,

uqptr_store_3:
	dpb 1,UQp3
	popj 17,

uqptr_store_4:
	dpb 1,UQp4
	popj 17,

uqptr_store_5:
	dpb 1,UQp5
	popj 17,

uqptr_store_6:
	dpb 1,UQp6
	popj 17,

hptr_store_1:
	dpb 1,Hp1	; movhi
	popj 17,

hptr_store_2:
	dpb 1,Hp2	; movhi
	popj 17,

hptr_store_3:
	dpb 1,Hp3	; movhi
	popj 17,

hptr_store_4:
	dpb 1,Hp4	; movhi
	popj 17,

hptr_store_5:
	dpb 1,Hp5	; movhi
	popj 17,

uhptr_store_1:
	dpb 1,UHp1	; movhi
	popj 17,

uhptr_store_2:
	dpb 1,UHp2	; movhi
	popj 17,

cptr_store_1:
	dpb 1,Cp1
	popj 17,

cptr_store_2:
	dpb 1,Cp2
	popj 17,

q_global_load:
	hrre 1,Q
	popj 17,

uq_global_load:
	move 1,UQ
	popj 17,

q_array_load_0:
	move 1,QA
	ash 1,-33
	popj 17,

q_array_load_4:
	move 1,QA+1
	ash 1,-33
	popj 17,

q_array_load_7:
	move 1,QA+1
	lsh 1,33
	ash 1,-33
	popj 17,

uq_array_load_0:
	move 1,UQA
	lsh 1,-33
	popj 17,

uq_array_load_4:
	move 1,UQA+1
	lsh 1,-33
	popj 17,

uq_array_load_7:
	move 1,UQA+1
	andi 1,777
	popj 17,

h_global_load:
	hrre 1,H
	popj 17,

uh_global_load:
	move 1,UH
	popj 17,

h_array_load_0:
	hlre 1,HA
	popj 17,

h_array_load_2:
	hlre 1,HA+1
	popj 17,

h_array_load_3:
	hrre 1,HA+1
	popj 17,

uh_array_load_0:
	hlrz 1,UHA
	popj 17,

uh_array_load_2:
	hlrz 1,UHA+1
	popj 17,

q_global_store:
	movem 1,Q
	popj 17,

uq_global_store:
	movem 1,UQ
	popj 17,

q_array_store_0:
	dpb 1,[POINT 9,QA,8]
	popj 17,

q_array_store_4:
	dpb 1,[POINT 9,QA+1,8]
	popj 17,

q_array_store_7:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,QA+1,35]
	popj 17,

uq_array_store_0:
	dpb 1,[POINT 9,UQA,8]
	popj 17,

uq_array_store_4:
	dpb 1,[POINT 9,UQA+1,8]
	popj 17,

uq_array_store_7:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,UQA+1,35]
	popj 17,

h_global_store:
	movem 1,H
	popj 17,

uh_global_store:
	movem 1,UH
	popj 17,

h_array_store_0:
	hrlm 1,HA
	popj 17,

h_array_store_2:
	hrlm 1,HA+1
	popj 17,

h_array_store_3:
	hrrm 1,HA+1
	popj 17,

uh_array_store_0:
	hrlm 1,UHA
	popj 17,

uh_array_store_2:
	hrlm 1,UHA+1
	popj 17,

q_store_return:
	movem 1,Q
	lsh 1,33
	ash 1,-33
	popj 17,

uq_store_return:
	movem 1,UQ
	popj 17,

h_store_return:
	movem 1,H
	hrre 1,1
	popj 17,

uh_store_return:
	movem 1,UH
	popj 17,

q_array_store_return:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	andi 1,7
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,QA,8]
	jumpe 4,%L99
%L98:
	ibp 1
	sojn 4,%L98	; decrement_and_branch_until_zero
%L99:
	dpb 2,1
	move 1,2
	lsh 1,33
	ash 1,-33
	popj 17,

uq_array_store_return:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	andi 1,7
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,UQA,8]
	jumpe 4,%L102
%L101:
	ibp 1
	sojn 4,%L101	; decrement_and_branch_until_zero
%L102:
	dpb 2,1
	move 1,2
	popj 17,

h_array_store_return:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	andi 1,3
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,HA,17]
	jumpe 4,%L105
%L104:
	ibp 1
	sojn 4,%L104	; decrement_and_branch_until_zero
%L105:
	dpb 2,1	; movhi
	hrre 1,2
	popj 17,

uh_array_store_return:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	andi 1,3
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,UHA,17]
	jumpe 4,%L108
%L107:
	ibp 1
	sojn 4,%L107	; decrement_and_branch_until_zero
%L108:
	dpb 2,1	; movhi
	move 1,2
	popj 17,

q_load_index:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L112
%L111:
	ibp 1
	sojn 4,%L111	; decrement_and_branch_until_zero
%L112:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

uq_load_index:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L116
%L115:
	ibp 1
	sojn 4,%L115	; decrement_and_branch_until_zero
%L116:
	ldb 1,1
	popj 17,

h_load_index:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L120
%L119:
	ibp 1
	sojn 4,%L119	; decrement_and_branch_until_zero
%L120:
	ldb 1,1
	hrre 1,1
	popj 17,

uh_load_index:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L124
%L123:
	ibp 1
	sojn 4,%L123	; decrement_and_branch_until_zero
%L124:
	ldb 1,1
	popj 17,

c_load_index:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L128
%L127:
	ibp 1
	sojn 4,%L127	; decrement_and_branch_until_zero
%L128:
	ldb 1,1
	popj 17,

q_store_index:
	andi 3,777	; zero_extendqisi2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L132
%L131:
	ibp 1
	sojn 4,%L131	; decrement_and_branch_until_zero
%L132:
	dpb 3,1
	popj 17,

uq_store_index:
	andi 3,777	; zero_extendqisi2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L136
%L135:
	ibp 1
	sojn 4,%L135	; decrement_and_branch_until_zero
%L136:
	dpb 3,1
	popj 17,

h_store_index:
	hrrzi 3,(3)	; zero_extendhisi2
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L140
%L139:
	ibp 1
	sojn 4,%L139	; decrement_and_branch_until_zero
%L140:
	dpb 3,1	; movhi
	popj 17,

uh_store_index:
	hrrzi 3,(3)	; zero_extendhisi2
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L144
%L143:
	ibp 1
	sojn 4,%L143	; decrement_and_branch_until_zero
%L144:
	dpb 3,1	; movhi
	popj 17,

c_store_index:
	andi 3,777	; zero_extendqisi2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L148
%L147:
	ibp 1
	sojn 4,%L147	; decrement_and_branch_until_zero
%L148:
	dpb 3,1
	popj 17,

q_load_masked:
	move 4,1
	andi 4,3
	andi 1,7
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,QA,8]
	jumpe 4,%L151
%L150:
	ibp 1
	sojn 4,%L150	; decrement_and_branch_until_zero
%L151:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

uq_load_masked:
	move 4,1
	andi 4,3
	andi 1,7
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,UQA,8]
	jumpe 4,%L154
%L153:
	ibp 1
	sojn 4,%L153	; decrement_and_branch_until_zero
%L154:
	ldb 1,1
	popj 17,

h_load_masked:
	move 4,1
	andi 4,1
	andi 1,3
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,HA,17]
	jumpe 4,%L157
%L156:
	ibp 1
	sojn 4,%L156	; decrement_and_branch_until_zero
%L157:
	ldb 1,1
	hrre 1,1
	popj 17,

uh_load_masked:
	move 4,1
	andi 4,1
	andi 1,3
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,UHA,17]
	jumpe 4,%L160
%L159:
	ibp 1
	sojn 4,%L159	; decrement_and_branch_until_zero
%L160:
	ldb 1,1
	popj 17,

q_store_masked:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	andi 1,7
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,QA,8]
	jumpe 4,%L163
%L162:
	ibp 1
	sojn 4,%L162	; decrement_and_branch_until_zero
%L163:
	dpb 2,1
	popj 17,

uq_store_masked:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	andi 1,7
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,UQA,8]
	jumpe 4,%L166
%L165:
	ibp 1
	sojn 4,%L165	; decrement_and_branch_until_zero
%L166:
	dpb 2,1
	popj 17,

h_store_masked:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	andi 1,3
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,HA,17]
	jumpe 4,%L169
%L168:
	ibp 1
	sojn 4,%L168	; decrement_and_branch_until_zero
%L169:
	dpb 2,1	; movhi
	popj 17,

uh_store_masked:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	andi 1,3
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,UHA,17]
	jumpe 4,%L172
%L171:
	ibp 1
	sojn 4,%L171	; decrement_and_branch_until_zero
%L172:
	dpb 2,1	; movhi
	popj 17,

addr_Q:
	move 1,[POINT 18,Q,35]
	popj 17,

addr_QA0:
	move 1,[POINT 9,QA,8]
	popj 17,

addr_QA4:
	move 1,[POINT 9,QA+1,8]
	popj 17,

addr_QA7:
	move 1,[POINT 9,QA+1,35]
	popj 17,

addr_UQ:
	move 1,[POINT 18,UQ,35]
	popj 17,

addr_UQA4:
	move 1,[POINT 9,UQA+1,8]
	popj 17,

addr_S_Q1:
	move 1,[POINT 9,S+1,8]
	popj 17,

addr_S_Q2:
	move 1,[POINT 9,S+1,17]
	popj 17,

addr_S_Q3:
	move 1,[POINT 9,S+1,26]
	popj 17,

addr_S_Q4:
	move 1,[POINT 9,S+1,35]
	popj 17,

addr_H:
	move 1,[POINT 18,H,35]
	popj 17,

addr_HA2:
	move 1,[POINT 18,HA+1,17]
	popj 17,

addr_HA3:
	move 1,[POINT 18,HA+1,35]
	popj 17,

addr_S_H1:
	move 1,[POINT 18,S+2,17]
	popj 17,

addr_S_H2:
	move 1,[POINT 18,S+2,35]
	popj 17,

s_q1:
	move 1,S+1
	lsh 1,-33
	popj 17,

s_q2:
	ldb 1,[POINT 9,S+1,17]
	popj 17,

s_q3:
	ldb 1,[POINT 9,S+1,26]
	popj 17,

s_q4:
	move 1,S+1
	andi 1,777
	popj 17,

s_h1:
	hlre 1,S+2
	popj 17,

s_h2:
	hrre 1,S+2
	popj 17,

mb_q1:
	move 1,MB+1
	ash 1,-33
	popj 17,

mb_q2:
	move 1,MB+1
	lsh 1,11
	ash 1,-33
	popj 17,

mb_uq1:
	ldb 1,[POINT 9,MB+1,26]
	popj 17,

mb_uq2:
	move 1,MB+1
	andi 1,777
	popj 17,

mb_h1:
	hlre 1,MB+2
	popj 17,

mb_h2:
	hrre 1,MB+2
	popj 17,

mb_uh1:
	hlrz 1,MB+3
	popj 17,

mb_uh2:
	hrrz 1,MB+3
	popj 17,

mb_c1:
	move 1,MB+4
	lsh 1,-33
	popj 17,

mb_c2:
	ldb 1,[POINT 9,MB+4,17]
	popj 17,

s_q1_store:
	dpb 1,[POINT 9,S+1,8]
	popj 17,

s_q2_store:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,S+1,17]
	popj 17,

s_q3_store:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,S+1,26]
	popj 17,

s_q4_store:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,S+1,35]
	popj 17,

s_h1_store:
	hrlm 1,S+2
	popj 17,

s_h2_store:
	hrrm 1,S+2
	popj 17,

mb_q1_store:
	dpb 1,[POINT 9,MB+1,8]
	popj 17,

mb_q2_store:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,MB+1,17]
	popj 17,

mb_uq1_store:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,MB+1,26]
	popj 17,

mb_uq2_store:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,MB+1,35]
	popj 17,

mb_h1_store:
	hrlm 1,MB+2
	popj 17,

mb_h2_store:
	hrrm 1,MB+2
	popj 17,

mb_uh1_store:
	hrlm 1,MB+3
	popj 17,

mb_uh2_store:
	hrrm 1,MB+3
	popj 17,

mb_c1_store:
	dpb 1,[POINT 9,MB+4,8]
	popj 17,

mb_c2_store:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,MB+4,17]
	popj 17,

mba_q1:
	andi 1,7
	imuli 1,31
	move 1,MBA+1(1)
	ash 1,-33
	popj 17,

mba_q2:
	andi 1,7
	imuli 1,31
	move 1,MBA+1(1)
	lsh 1,11
	ash 1,-33
	popj 17,

mba_uq1:
	andi 1,7
	imuli 1,31
	ldb 1,[POINT 9,MBA+1(1),26]
	popj 17,

mba_uq2:
	andi 1,7
	imuli 1,31
	move 1,MBA+1(1)
	andi 1,777
	popj 17,

mba_h1:
	andi 1,7
	imuli 1,31
	hlre 1,MBA+2(1)
	popj 17,

mba_h2:
	andi 1,7
	imuli 1,31
	hrre 1,MBA+2(1)
	popj 17,

mba_uh1:
	andi 1,7
	imuli 1,31
	hlrz 1,MBA+3(1)
	popj 17,

mba_uh2:
	andi 1,7
	imuli 1,31
	hrrz 1,MBA+3(1)
	popj 17,

mba_q1_store:
	andi 1,7
	imuli 1,31
	xmovei 1,MBA+1(1)
	dpb 2,[POINT 9,(1),8]
	popj 17,

mba_q2_store:
	andi 2,777	; zero_extendqisi2
	andi 1,7
	imuli 1,31
	dpb 2,[POINT 9,MBA+1(1),17]
	popj 17,

mba_uq1_store:
	andi 2,777	; zero_extendqisi2
	andi 1,7
	imuli 1,31
	dpb 2,[POINT 9,MBA+1(1),26]
	popj 17,

mba_uq2_store:
	andi 2,777	; zero_extendqisi2
	andi 1,7
	imuli 1,31
	dpb 2,[POINT 9,MBA+1(1),35]
	popj 17,

mba_h1_store:
	andi 1,7
	imuli 1,31
	xmovei 1,MBA+2(1)
	hrlm 2,(1)
	popj 17,

mba_h2_store:
	andi 1,7
	imuli 1,31
	hrrm 2,MBA+2(1)
	popj 17,

mba_uh1_store:
	andi 1,7
	imuli 1,31
	hrlm 2,MBA+3(1)
	popj 17,

mba_uh2_store:
	andi 1,7
	imuli 1,31
	hrrm 2,MBA+3(1)
	popj 17,

vq_load:
	hrre 1,VQ
	popj 17,

vq_array_load:
	move 4,1
	andi 4,3
	andi 1,7
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,VQA,8]
	jumpe 4,%L248
%L247:
	ibp 1
	sojn 4,%L247	; decrement_and_branch_until_zero
%L248:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

vh_load:
	hrre 1,VH
	popj 17,

vh_array_load:
	move 4,1
	andi 4,1
	andi 1,3
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,VHA,17]
	jumpe 4,%L252
%L251:
	ibp 1
	sojn 4,%L251	; decrement_and_branch_until_zero
%L252:
	ldb 1,1
	hrre 1,1
	popj 17,

vq_store:
	movem 1,VQ
	popj 17,

vq_array_store:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	andi 1,7
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,VQA,8]
	jumpe 4,%L256
%L255:
	ibp 1
	sojn 4,%L255	; decrement_and_branch_until_zero
%L256:
	dpb 2,1
	popj 17,

vh_store:
	movem 1,VH
	popj 17,

vh_array_store:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	andi 1,3
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,VHA,17]
	jumpe 4,%L260
%L259:
	ibp 1
	sojn 4,%L259	; decrement_and_branch_until_zero
%L260:
	dpb 2,1	; movhi
	popj 17,

bf_s_a:
	ldb 1,[POINT 8,S+3,15]
	popj 17,

bf_s_b:
	ldb 1,[POINT 10,S+3,25]
	popj 17,

bf_s_a_plus_b:
	ldb 1,[POINT 8,S+3,15]
	ldb 4,[POINT 10,S+3,25]
	add 1,4
	popj 17,

bf_s_a_shift:
	ldb 1,[POINT 8,S+3,15]
	lsh 1,1
	popj 17,

bf_s_b_mask:
	ldb 1,[POINT 9,S+3,25]
	popj 17,

bf_s_a_eq_zero:
	ldb 1,[POINT 8,S+3,15]
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

bf_s_b_gt_100:
	ldb 1,[POINT 10,S+3,25]
	movei 6,100
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

bf_arg_a:
	ldb 1,[POINT 8,1,15]
	popj 17,

bf_arg_b:
	ldb 1,[POINT 10,1,25]
	popj 17,

bf_arg_sum:
	ldb 4,[POINT 8,1,15]
	ldb 1,[POINT 10,1,25]
	add 4,1
	move 1,4
	popj 17,

bf_arg_a_eq_zero:
	ldb 1,[POINT 8,1,15]
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

bf_arg_b_gt_100:
	ldb 1,[POINT 10,1,25]
	movei 6,100
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

bf_ptr_a:
	ldb 1,[POINT 8,(1),15]
	popj 17,

bf_ptr_b:
	ldb 1,[POINT 10,(1),25]
	popj 17,

bf_ptr_sum:
	move 4,1
	ldb 1,[POINT 8,(1),15]
	ldb 4,[POINT 10,(4),25]
	add 1,4
	popj 17,

bf_array_a:
	andi 1,7
	lsh 1,2
	ldb 1,[POINT 8,TA(1),15]
	popj 17,

bf_array_b:
	andi 1,7
	move 4,1
	lsh 4,1
	add 4,1
	ldb 1,[POINT 10,TA(4),25]
	popj 17,

bf_array_sum:
	andi 1,7
	move 4,1
	lsh 4,2
	ldb 3,[POINT 8,TA(4),15]
	move 4,1
	lsh 4,1
	add 4,1
	ldb 4,[POINT 10,TA(4),25]
	add 3,4
	move 1,3
	popj 17,

bf_s_a_store:
	dpb 1,[POINT 8,S+3,15]
	popj 17,

bf_s_b_store:
	dpb 1,[POINT 10,S+3,25]
	popj 17,

bf_s_a_store_return:
	dpb 1,[POINT 8,S+3,15]
	andi 1,377
	popj 17,

bf_s_b_store_return:
	dpb 1,[POINT 10,S+3,25]
	andi 1,1777
	popj 17,

bf_s_a_inc:
	ldb 4,[POINT 8,S+3,15]
	addi 4,1
	dpb 4,[POINT 8,S+3,15]
	popj 17,

bf_s_b_inc:
	ldb 4,[POINT 10,S+3,25]
	addi 4,1
	dpb 4,[POINT 10,S+3,25]
	popj 17,

bf_s_a_inc_return:
	ldb 1,[POINT 8,S+3,15]
	addi 1,1
	dpb 1,[POINT 8,S+3,15]
	andi 1,377
	popj 17,

bf_s_b_inc_return:
	ldb 1,[POINT 10,S+3,25]
	addi 1,1
	dpb 1,[POINT 10,S+3,25]
	andi 1,1777
	popj 17,

bf_s_a_or:
	ldb 4,[POINT 8,S+3,15]
	ior 4,1
	dpb 4,[POINT 8,S+3,15]
	popj 17,

bf_s_b_xor:
	ldb 4,[POINT 10,S+3,25]
	xor 4,1
	dpb 4,[POINT 10,S+3,25]
	popj 17,

bf_ptr_a_store:
	dpb 2,[POINT 8,(1),15]
	popj 17,

bf_ptr_b_store:
	dpb 2,[POINT 10,(1),25]
	popj 17,

bf_ptr_a_store_return:
	dpb 2,[POINT 8,(1),15]
	andi 2,377
	move 1,2
	popj 17,

bf_ptr_b_store_return:
	dpb 2,[POINT 10,(1),25]
	andi 2,1777
	move 1,2
	popj 17,

bf_array_a_store:
	andi 1,7
	movei 4,TA
	lsh 1,2
	jumple 1,%L296
%L295:
	ibp 4
	sojg 1,%L295	; decrement_and_branch_until_zero
%L296:
	jumpe 1,%L298
%L297:
	subi 4,1
	aojl 1,%L297
%L298:
	dpb 2,[POINT 8,(4),15]
	popj 17,

bf_array_b_store:
	andi 1,7
	move 4,1
	lsh 4,1
	movei 3,TA
	add 4,1
	jumple 4,%L302
%L301:
	ibp 3
	sojg 4,%L301	; decrement_and_branch_until_zero
%L302:
	jumpe 4,%L304
%L303:
	subi 3,1
	aojl 4,%L303
%L304:
	dpb 2,[POINT 10,(3),25]
	popj 17,

bf_array_a_store_return:
	andi 1,7
	movei 4,TA
	lsh 1,2
	jumple 1,%L308
%L307:
	ibp 4
	sojg 1,%L307	; decrement_and_branch_until_zero
%L308:
	jumpe 1,%L310
%L309:
	subi 4,1
	aojl 1,%L309
%L310:
	dpb 2,[POINT 8,(4),15]
	andi 2,377
	move 1,2
	popj 17,

bf_array_b_store_return:
	andi 1,7
	move 4,1
	lsh 4,1
	movei 3,TA
	add 4,1
	jumple 4,%L314
%L313:
	ibp 3
	sojg 4,%L313	; decrement_and_branch_until_zero
%L314:
	jumpe 4,%L316
%L315:
	subi 3,1
	aojl 4,%L315
%L316:
	dpb 2,[POINT 10,(3),25]
	andi 2,1777
	move 1,2
	popj 17,

bf_array_a_inc:
	andi 1,7
	movei 3,TA
	move 4,1
	lsh 4,2
	jumple 4,%L320
%L319:
	ibp 3
	sojg 4,%L319	; decrement_and_branch_until_zero
%L320:
	jumpe 4,%L322
%L321:
	subi 3,1
	aojl 4,%L321
%L322:
	lsh 1,2
	ldb 4,[POINT 8,TA(1),15]
	addi 4,1
	dpb 4,[POINT 8,(3),15]
	popj 17,

bf_array_b_inc:
	andi 1,7
	move 4,1
	lsh 4,1
	movei 3,TA
	add 4,1
	jumple 4,%L326
%L325:
	ibp 3
	sojg 4,%L325	; decrement_and_branch_until_zero
%L326:
	jumpe 4,%L328
%L327:
	subi 3,1
	aojl 4,%L327
%L328:
	move 4,1
	lsh 4,1
	add 4,1
	ldb 4,[POINT 10,TA(4),25]
	addi 4,1
	dpb 4,[POINT 10,(3),25]
	popj 17,

sbf_a:
	move 1,SB
	ash 1,-34
	popj 17,

sbf_b:
	move 1,SB
	lsh 1,10
	ash 1,-32
	popj 17,

sbf_c:
	hrre 1,SB
	popj 17,

sbf_a_plus_b:
	move 1,SB
	ash 1,-34
	move 4,SB
	lsh 4,10
	ash 4,-32
	add 1,4
	popj 17,

sbf_a_lt_zero:
	move 1,SB
	lsh 1,-43
	popj 17,

sbf_b_ge_zero:
	move 1,SB
	lsh 1,10
	ash 1,-32
	skipge 1
	tdza 1,1
	movei 1,1
	popj 17,

sbf_array_a:
	andi 1,7
	lsh 1,2
	move 1,SBA(1)
	ash 1,-34
	popj 17,

sbf_array_b:
	andi 1,7
	move 4,1
	lsh 4,1
	add 4,1
	move 1,SBA(4)
	lsh 1,10
	ash 1,-32
	popj 17,

sbf_array_c:
	andi 1,7
	lsh 1,1
	hrre 1,SBA(1)
	popj 17,

sbf_a_store:
	dpb 1,[POINT 8,SB,7]
	popj 17,

sbf_b_store:
	dpb 1,[POINT 10,SB,17]
	popj 17,

sbf_c_store:
	hrrm 1,SB
	popj 17,

sbf_a_store_return:
	dpb 1,[POINT 8,SB,7]
	lsh 1,34
	ash 1,-34
	popj 17,

sbf_b_store_return:
	dpb 1,[POINT 10,SB,17]
	lsh 1,32
	ash 1,-32
	popj 17,

sbf_c_store_return:
	hrrm 1,SB
	hrre 1,1
	popj 17,

sbf_array_a_store:
	andi 1,7
	movei 4,SBA
	lsh 1,2
	jumple 1,%L347
%L346:
	ibp 4
	sojg 1,%L346	; decrement_and_branch_until_zero
%L347:
	jumpe 1,%L349
%L348:
	subi 4,1
	aojl 1,%L348
%L349:
	dpb 2,[POINT 8,(4),7]
	popj 17,

sbf_array_b_store:
	andi 1,7
	move 4,1
	lsh 4,1
	movei 3,SBA
	add 4,1
	jumple 4,%L353
%L352:
	ibp 3
	sojg 4,%L352	; decrement_and_branch_until_zero
%L353:
	jumpe 4,%L355
%L354:
	subi 3,1
	aojl 4,%L354
%L355:
	dpb 2,[POINT 10,(3),17]
	popj 17,

sbf_array_c_store:
	andi 1,7
	hrrm 2,SBA(1)
	popj 17,

copy_q_to_q:
	ldb 4,[POINT 9,QA+1,8]
	movem 4,Q
	popj 17,

copy_uq_to_uq:
	ldb 4,[POINT 9,UQA+1,8]
	movem 4,UQ
	popj 17,

copy_h_to_h:
	hlrz 4,HA+1
	movem 4,H
	popj 17,

copy_uh_to_uh:
	hlrz 4,UHA+1
	movem 4,UH
	popj 17,

copy_struct_q:
	ldb 4,[POINT 9,S+1,17]
	dpb 4,[POINT 9,S+1,8]
	popj 17,

copy_struct_q_cross:
	ldb 4,[POINT 9,UQA+1,35]
	dpb 4,[POINT 9,S+1,35]
	popj 17,

copy_struct_h:
	hrrz 4,S+2
	hrlm 4,S+2
	popj 17,

copy_q_to_struct:
	ldb 6,[POINT 18,UQ,35]
	dpb 6,[POINT 9,S+1,26]
	popj 17,

copy_h_to_struct:
	hlrz 6,H
	hrrm 6,S+2
	popj 17,

copy_mb_q:
	ldb 4,[POINT 9,MB+1,17]
	dpb 4,[POINT 9,MB+1,8]
	popj 17,

copy_mb_h:
	hrrz 4,MB+2
	hrlm 4,MB+2
	popj 17,

copy_mb_c:
	ldb 4,[POINT 9,MB+4,17]
	dpb 4,[POINT 9,MB+4,8]
	popj 17,

q_load_extend:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

uq_load_extend:
	ldb 1,1
	popj 17,

h_load_extend:
	ldb 1,1
	hrre 1,1
	popj 17,

uh_load_extend:
	ldb 1,1
	popj 17,

q_store_trunc:
	dpb 2,1
	popj 17,

uq_store_trunc:
	dpb 2,1
	popj 17,

h_store_trunc:
	dpb 2,1	; movhi
	popj 17,

uh_store_trunc:
	dpb 2,1	; movhi
	popj 17,

q_postinc_load:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

q_postinc_store:
	dpb 2,1
	popj 17,

uq_postinc_load:
	ldb 1,1
	popj 17,

uq_postinc_store:
	dpb 2,1
	popj 17,

h_postinc_load:
	ldb 1,1
	hrre 1,1
	popj 17,

h_postinc_store:
	dpb 2,1	; movhi
	popj 17,

c_postinc_load:
	ldb 1,1
	popj 17,

c_postinc_store:
	dpb 2,1
	popj 17,

q_sum_loop:
	move 7,1
	setzb 1,6
	caml 1,2
	popj 17,
	subi 2,1
%L396:
	move 4,6
	andi 4,3
	move 3,6
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L392
%L391:
	ibp 3
	sojn 4,%L391	; decrement_and_branch_until_zero
%L392:
	ldb 4,3
	trne 4,400
	orcmi 4,777
	add 1,4
	addi 6,1
	sojge 2,%L396	; doloop_end
	popj 17,

uq_sum_loop:
	move 7,1
	setzb 1,6
	caml 1,2
	popj 17,
	subi 2,1
%L408:
	move 4,6
	andi 4,3
	move 3,6
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L404
%L403:
	ibp 3
	sojn 4,%L403	; decrement_and_branch_until_zero
%L404:
	ldb 3,3
	add 1,3
	addi 6,1
	sojge 2,%L408	; doloop_end
	popj 17,

h_sum_loop:
	move 7,1
	setzb 1,6
	caml 1,2
	popj 17,
	subi 2,1
%L420:
	move 4,6
	andi 4,1
	move 3,6
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L416
%L415:
	ibp 3
	sojn 4,%L415	; decrement_and_branch_until_zero
%L416:
	ldb 4,3
	hrre 4,4
	add 1,4
	addi 6,1
	sojge 2,%L420	; doloop_end
	popj 17,

uh_sum_loop:
	move 7,1
	setzb 1,6
	caml 1,2
	popj 17,
	subi 2,1
%L432:
	move 4,6
	andi 4,1
	move 3,6
	ash 3,-1	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L428
%L427:
	ibp 3
	sojn 4,%L427	; decrement_and_branch_until_zero
%L428:
	ldb 3,3
	add 1,3
	addi 6,1
	sojge 2,%L432	; doloop_end
	popj 17,

q_zero_loop:
	movei 6,0
	caml 6,2
	popj 17,
	movei 7,0
	subi 2,1
%L444:
	move 4,6
	andi 4,3
	move 3,6
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L440
%L439:
	ibp 3
	sojn 4,%L439	; decrement_and_branch_until_zero
%L440:
	dpb 7,3
	addi 6,1
	sojge 2,%L444	; doloop_end
	popj 17,

uq_zero_loop:
	movei 6,0
	caml 6,2
	popj 17,
	movei 7,0
	subi 2,1
%L456:
	move 4,6
	andi 4,3
	move 3,6
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L452
%L451:
	ibp 3
	sojn 4,%L451	; decrement_and_branch_until_zero
%L452:
	dpb 7,3
	addi 6,1
	sojge 2,%L456	; doloop_end
	popj 17,

h_zero_loop:
	movei 6,0
	caml 6,2
	popj 17,
	movei 7,0
	subi 2,1
%L468:
	move 4,6
	andi 4,1
	move 3,6
	ash 3,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L464
%L463:
	ibp 3
	sojn 4,%L463	; decrement_and_branch_until_zero
%L464:
	dpb 7,3	; movhi
	addi 6,1
	sojge 2,%L468	; doloop_end
	popj 17,

uh_zero_loop:
	movei 6,0
	caml 6,2
	popj 17,
	movei 7,0
	subi 2,1
%L480:
	move 4,6
	andi 4,1
	move 3,6
	ash 3,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L476
%L475:
	ibp 3
	sojn 4,%L475	; decrement_and_branch_until_zero
%L476:
	dpb 7,3	; movhi
	addi 6,1
	sojge 2,%L480	; doloop_end
	popj 17,

bf_sum_loop:
	setzb 7,6
	caml 7,1
	jrst %L488
	subi 1,1
%L489:
	move 3,6
	andi 3,7
	move 4,3
	lsh 4,2
	ldb 2,[POINT 8,TA(4),15]
	move 4,3
	lsh 4,1
	add 4,3
	ldb 4,[POINT 10,TA(4),25]
	add 2,4
	add 7,2
	addi 6,1
	sojge 1,%L489	; doloop_end
%L488:
	move 1,7
	popj 17,

bf_zero_loop:
	movei 6,0
	caml 6,1
	popj 17,
	movei 7,0
	subi 1,1
%L508:
	move 2,6
	andi 2,7
	movei 3,TA
	move 4,2
	lsh 4,2
	jumple 4,%L497
%L496:
	ibp 3
	sojg 4,%L496	; decrement_and_branch_until_zero
%L497:
	jumpe 4,%L499
%L498:
	subi 3,1
	aojl 4,%L498
%L499:
	dpb 7,[POINT 8,(3),15]
	move 4,2
	lsh 4,1
	movei 3,TA
	add 4,2
	jumple 4,%L502
%L501:
	ibp 3
	sojg 4,%L501	; decrement_and_branch_until_zero
%L502:
	jumpe 4,%L504
%L503:
	subi 3,1
	aojl 4,%L503
%L504:
	dpb 7,[POINT 10,(3),25]
	addi 6,1
	sojge 1,%L508	; doloop_end
	popj 17,

sbf_sum_loop:
	setzb 7,6
	caml 7,1
	jrst %L516
	subi 1,1
%L517:
	move 4,6
	andi 4,7
	move 3,4
	lsh 3,2
	move 3,SBA(3)
	ash 3,-34
	move 2,4
	lsh 2,1
	add 4,2
	move 4,SBA(4)
	lsh 4,10
	ash 4,-32
	add 3,4
	hrre 4,SBA(2)
	add 3,4
	add 7,3
	addi 6,1
	sojge 1,%L517	; doloop_end
%L516:
	move 1,7
	popj 17,

sbf_zero_loop:
	movei 7,0
	caml 7,1
	popj 17,
	movei 6,0
	subi 1,1
%L536:
	move 2,7
	andi 2,7
	movei 3,SBA
	move 4,2
	lsh 4,2
	jumple 4,%L525
%L524:
	ibp 3
	sojg 4,%L524	; decrement_and_branch_until_zero
%L525:
	jumpe 4,%L527
%L526:
	subi 3,1
	aojl 4,%L526
%L527:
	dpb 6,[POINT 8,(3),7]
	move 4,2
	lsh 4,1
	movei 3,SBA
	add 4,2
	jumple 4,%L530
%L529:
	ibp 3
	sojg 4,%L529	; decrement_and_branch_until_zero
%L530:
	jumpe 4,%L532
%L531:
	subi 3,1
	aojl 4,%L531
%L532:
	dpb 6,[POINT 10,(3),17]
	hrrm 6,SBA(2)
	addi 7,1
	sojge 1,%L536	; doloop_end
	popj 17,

q_load_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	ldb 1,10
	trne 1,400
	orcmi 1,777
	pop 17,10
	popj 17,

q_store_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	andi 10,777	; zero_extendqisi2
	pushj 17,clobber
	dpb 10,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

h_load_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	ldb 1,10
	hrre 1,1
	pop 17,10
	popj 17,

h_store_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	hrrzi 10,(10)	; zero_extendhisi2
	pushj 17,clobber
	dpb 10,11	; movhi
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

bf_load_after_call:
	pushj 17,clobber
	ldb 1,[POINT 8,S+3,15]
	ldb 4,[POINT 10,S+3,25]
	add 1,4
	popj 17,

bf_store_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	pushj 17,clobber
	dpb 10,[POINT 8,S+3,15]
	dpb 11,[POINT 10,S+3,25]
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

sbf_load_after_call:
	pushj 17,clobber
	move 1,SB
	ash 1,-34
	move 4,SB
	lsh 4,10
	ash 4,-32
	add 1,4
	hrre 4,SB
	add 1,4
	popj 17,

sbf_store_after_call:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 11,2
	move 12,3
	pushj 17,clobber
	dpb 10,[POINT 8,SB,7]
	dpb 11,[POINT 10,SB,17]
	hrrm 12,SB
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

q_if_negative:
	ldb 4,1
	trne 4,400
	orcmi 4,777
	seto 1,
	jumpl 4,%L545
	movei 1,1
%L545:
	popj 17,

h_if_negative:
	ldb 4,1
	hrre 4,4
	seto 1,
	jumpl 4,%L547
	movei 1,1
%L547:
	popj 17,

uq_if_gt_0177:
	ldb 1,1
	tlo 1,400000
	move 6,[-377777777601]
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

uh_if_gt_077777:
	ldb 1,1
	tlo 1,400000
	move 6,[-377777700001]
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

bf_if_a_zero:
	ldb 1,[POINT 8,S+3,15]
	skipe 1
	movei 1,1
	popj 17,

bf_if_b_big:
	ldb 4,[POINT 10,S+3,25]
	movei 1,1
	caig 4,100
	seto 1,
	popj 17,

sbf_if_a_negative:
	seto 1,
	skipl SB
	movei 1,1
	popj 17,

q_h_mix:
	hrre 1,Q
	hrre 4,H
	add 1,4
	move 4,S+1
	lsh 4,-33
	add 1,4
	hlre 4,S+2
	add 1,4
	popj 17,

uq_bf_mix:
	ldb 1,[POINT 9,S+1,17]
	ldb 6,[POINT 18,UQ,35]
	add 1,6
	ldb 4,[POINT 8,S+3,15]
	add 1,4
	ldb 4,[POINT 10,S+3,25]
	add 1,4
	popj 17,

mb_mix:
	move 1,MB+1
	ash 1,-33
	move 4,MB+1
	lsh 4,11
	ash 4,-33
	add 1,4
	hlre 4,MB+2
	add 1,4
	hrre 4,MB+2
	add 1,4
	move 4,MB+4
	lsh 4,-33
	add 1,4
	ldb 4,[POINT 9,MB+4,17]
	add 1,4
	popj 17,

q_h_array_mix:
	move 7,1
	move 3,1
	andi 3,7
	move 6,1
	andi 6,3
	move 4,6
	move 1,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,QA,8]
	jumpe 6,%L564
%L563:
	ibp 1
	sojn 4,%L563	; decrement_and_branch_until_zero
%L564:
	ldb 2,1
	trne 2,400
	orcmi 2,777
	move 1,7
	andi 1,1
	move 4,6
	ash 4,-1	; ashrsi3_pointer
	add 4,[POINT 18,HA,17]
	jumpe 1,%L566
%L565:
	ibp 4
	sojn 1,%L565	; decrement_and_branch_until_zero
%L566:
	ldb 4,4
	hrre 4,4
	add 2,4
	imuli 3,31
	xmovei 3,MBA(3)
	move 4,1(3)
	ash 4,-33
	add 2,4
	hlre 4,2(3)
	add 2,4
	move 1,2
	popj 17,

q_h_array_store_mix:
	move 7,1
	andi 7,7
	move 6,1
	andi 6,3
	move 4,6
	move 3,7
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,QA,8]
	jumpe 6,%L569
%L568:
	ibp 3
	sojn 4,%L568	; decrement_and_branch_until_zero
%L569:
	dpb 2,3
	andi 1,1
	move 3,6
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,HA,17]
	jumpe 1,%L571
%L570:
	ibp 3
	sojn 1,%L570	; decrement_and_branch_until_zero
%L571:
	move 4,2
	ash 4,-1
	dpb 4,3	; movhi
	imuli 7,31
	xmovei 4,MBA(7)
	addi 2,1
	idpb 2,[POINT 9,(4),8]
	addi 2,1
	addi 4,1
	hrlm 2,(4)
	popj 17,

	.bss
Q:
	.space	4
QA:
	.space	8
UQ:
	.space	4
UQA:
	.space	8
H:
	.space	4
HA:
	.space	8
UH:
	.space	4
UHA:
	.space	8
C:
	.space	4
CA:
	.space	8
S:
	.space	16
TA:
	.space	32
SB:
	.space	4
SBA:
	.space	32
MB:
	.space	20
MBA:
	.space	160
VQ:
	.space	4
VQA:
	.space	8
VH:
	.space	4
VHA:
	.space	8
