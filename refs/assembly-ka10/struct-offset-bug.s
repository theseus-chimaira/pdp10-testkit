
f1:
	setzm 1(1)
	popj 17,

f2:
	setzm 1(1)
	popj 17,

f3:
	move 1,1(1)
	popj 17,

f4:
	move 1,1(1)
	popj 17,

f5:
	addi 1,1
	popj 17,

f6:
	addi 1,1
	popj 17,

f7:
	move 4,2
	andi 4,1
	add 4,1
	movem 2,1(4)
	popj 17,

f8:
	andi 2,1
	add 1,2
	move 1,1(1)
	popj 17,

store_tail_int_one_const:
	movem 2,1(1)
	popj 17,

store_tail_int_one_index:
	movem 2,1(1)
	popj 17,

load_tail_int_one_const:
	move 1,1(1)
	popj 17,

load_tail_int_one_index:
	move 1,1(1)
	popj 17,

addr_tail_int_one_const:
	addi 1,1
	popj 17,

addr_tail_int_one_index:
	addi 1,1
	popj 17,

diff_tail_int_one:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,addr_tail_int_one_index
	move 10,1
	move 1,11
	pushj 17,addr_tail_int_one_const
	sub 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

use_tail_int_one:
	push 17,10
	move 10,1
	movei 1,g_tail_int_one
	move 2,10
	pushj 17,store_tail_int_one_const
	addi 10,1
	movei 1,g_tail_int_one
	move 2,10
	pushj 17,store_tail_int_one_index
	movei 1,g_tail_int_one
	pushj 17,load_tail_int_one_index
	move 10,1
	movei 1,g_tail_int_one
	pushj 17,addr_tail_int_one_const
	movem 10,(1)
	movei 1,g_tail_int_one
	pushj 17,load_tail_int_one_const
	move 10,1
	movei 1,g_tail_int_one
	pushj 17,addr_tail_int_one_index
	movem 10,(1)
	movei 1,g_tail_int_one
	pushj 17,load_tail_int_one_const
	move 10,1
	movei 1,g_tail_int_one
	pushj 17,load_tail_int_one_index
	add 10,1
	movei 1,g_tail_int_one
	pushj 17,diff_tail_int_one
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

store_tail_uint_one_const:
	movem 2,1(1)
	popj 17,

store_tail_uint_one_index:
	movem 2,1(1)
	popj 17,

load_tail_uint_one_const:
	move 1,1(1)
	popj 17,

load_tail_uint_one_index:
	move 1,1(1)
	popj 17,

addr_tail_uint_one_const:
	addi 1,1
	popj 17,

addr_tail_uint_one_index:
	addi 1,1
	popj 17,

diff_tail_uint_one:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,addr_tail_uint_one_index
	move 10,1
	move 1,11
	pushj 17,addr_tail_uint_one_const
	sub 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

use_tail_uint_one:
	push 17,10
	move 10,1
	movei 1,g_tail_uint_one
	move 2,10
	pushj 17,store_tail_uint_one_const
	addi 10,1
	movei 1,g_tail_uint_one
	move 2,10
	pushj 17,store_tail_uint_one_index
	movei 1,g_tail_uint_one
	pushj 17,load_tail_uint_one_index
	move 10,1
	movei 1,g_tail_uint_one
	pushj 17,addr_tail_uint_one_const
	movem 10,(1)
	movei 1,g_tail_uint_one
	pushj 17,load_tail_uint_one_const
	move 10,1
	movei 1,g_tail_uint_one
	pushj 17,addr_tail_uint_one_index
	movem 10,(1)
	movei 1,g_tail_uint_one
	pushj 17,load_tail_uint_one_const
	move 10,1
	movei 1,g_tail_uint_one
	pushj 17,load_tail_uint_one_index
	add 10,1
	movei 1,g_tail_uint_one
	pushj 17,diff_tail_uint_one
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

store_tail_char_one_const:
	andi 2,777	; zero_extendqisi2
	dpb 2,[POINT 9,(1),17]
	popj 17,

store_tail_char_one_index:
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	dpb 2,4
	popj 17,

load_tail_char_one_const:
	ldb 1,[POINT 9,(1),17]
	popj 17,

load_tail_char_one_index:
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	ldb 1,4
	popj 17,

addr_tail_char_one_const:
	hrrz 1,1
	tlo 1,2200
	popj 17,

addr_tail_char_one_index:
	move 4,1
	movei 1,0
	ash 1,-2	; ashrsi3_pointer
	add 1,4
	hrrz 1,1
	tlo 1,2200
	popj 17,

diff_tail_char_one:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	pushj 17,addr_tail_char_one_index
	move 13,1
	move 1,12
	pushj 17,addr_tail_char_one_const
	move 10,13
	sub 10,1
	muli 10,10
	move 1,11
	ash 1,-1
	add 1,%BADL9(10)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

use_tail_char_one:
	push 17,10
	move 10,1
	andi 10,777	; zero_extendqisi2
	move 1,[POINT 9,g_tail_char_one,8]
	move 2,10
	pushj 17,store_tail_char_one_const
	addi 10,1
	andi 10,777	; zero_extendqisi2
	move 1,[POINT 9,g_tail_char_one,8]
	move 2,10
	pushj 17,store_tail_char_one_index
	move 1,[POINT 9,g_tail_char_one,8]
	pushj 17,load_tail_char_one_index
	move 10,1
	move 1,[POINT 9,g_tail_char_one,8]
	pushj 17,addr_tail_char_one_const
	dpb 10,1
	move 1,[POINT 9,g_tail_char_one,8]
	pushj 17,load_tail_char_one_const
	move 10,1
	move 1,[POINT 9,g_tail_char_one,8]
	pushj 17,addr_tail_char_one_index
	dpb 10,1
	move 1,[POINT 9,g_tail_char_one,8]
	pushj 17,load_tail_char_one_const
	move 10,1
	move 1,[POINT 9,g_tail_char_one,8]
	pushj 17,load_tail_char_one_index
	add 10,1
	move 1,[POINT 9,g_tail_char_one,8]
	pushj 17,diff_tail_char_one
	add 10,1
	andi 10,777	; zero_extendqisi2
	move 1,10
	pop 17,10
	popj 17,

store_tail_uchar_one_const:
	andi 2,777	; zero_extendqisi2
	dpb 2,[POINT 9,(1),17]
	popj 17,

store_tail_uchar_one_index:
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	dpb 2,4
	popj 17,

load_tail_uchar_one_const:
	ldb 1,[POINT 9,(1),17]
	popj 17,

load_tail_uchar_one_index:
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	ldb 1,4
	popj 17,

addr_tail_uchar_one_const:
	hrrz 1,1
	tlo 1,2200
	popj 17,

addr_tail_uchar_one_index:
	move 4,1
	movei 1,0
	ash 1,-2	; ashrsi3_pointer
	add 1,4
	hrrz 1,1
	tlo 1,2200
	popj 17,

diff_tail_uchar_one:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	pushj 17,addr_tail_uchar_one_index
	move 13,1
	move 1,12
	pushj 17,addr_tail_uchar_one_const
	move 10,13
	sub 10,1
	muli 10,10
	move 1,11
	ash 1,-1
	add 1,%BADL9(10)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

use_tail_uchar_one:
	push 17,10
	move 10,1
	andi 10,777	; zero_extendqisi2
	move 1,[POINT 9,g_tail_uchar_one,8]
	move 2,10
	pushj 17,store_tail_uchar_one_const
	addi 10,1
	andi 10,777	; zero_extendqisi2
	move 1,[POINT 9,g_tail_uchar_one,8]
	move 2,10
	pushj 17,store_tail_uchar_one_index
	move 1,[POINT 9,g_tail_uchar_one,8]
	pushj 17,load_tail_uchar_one_index
	move 10,1
	move 1,[POINT 9,g_tail_uchar_one,8]
	pushj 17,addr_tail_uchar_one_const
	dpb 10,1
	move 1,[POINT 9,g_tail_uchar_one,8]
	pushj 17,load_tail_uchar_one_const
	move 10,1
	move 1,[POINT 9,g_tail_uchar_one,8]
	pushj 17,addr_tail_uchar_one_index
	dpb 10,1
	move 1,[POINT 9,g_tail_uchar_one,8]
	pushj 17,load_tail_uchar_one_const
	move 10,1
	move 1,[POINT 9,g_tail_uchar_one,8]
	pushj 17,load_tail_uchar_one_index
	add 10,1
	move 1,[POINT 9,g_tail_uchar_one,8]
	pushj 17,diff_tail_uchar_one
	add 10,1
	andi 10,777	; zero_extendqisi2
	move 1,10
	pop 17,10
	popj 17,

store_tail_qint_one_const:
	andi 2,777	; zero_extendqisi2
	dpb 2,[POINT 9,(1),17]
	popj 17,

store_tail_qint_one_index:
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	dpb 2,4
	popj 17,

load_tail_qint_one_const:
	move 1,(1)
	lsh 1,11
	ash 1,-33
	popj 17,

load_tail_qint_one_index:
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

addr_tail_qint_one_const:
	hrrz 1,1
	tlo 1,2200
	popj 17,

addr_tail_qint_one_index:
	move 4,1
	movei 1,0
	ash 1,-2	; ashrsi3_pointer
	add 1,4
	hrrz 1,1
	tlo 1,2200
	popj 17,

diff_tail_qint_one:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	pushj 17,addr_tail_qint_one_index
	move 13,1
	move 1,12
	pushj 17,addr_tail_qint_one_const
	move 10,13
	sub 10,1
	muli 10,10
	move 1,11
	ash 1,-1
	add 1,%BADL9(10)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

use_tail_qint_one:
	push 17,10
	move 10,1
	andi 10,777	; zero_extendqisi2
	move 2,10
	lsh 2,33
	ash 2,-33
	move 1,[POINT 9,g_tail_qint_one,8]
	pushj 17,store_tail_qint_one_const
	addi 10,1
	lsh 10,33
	ash 10,-33
	move 1,[POINT 9,g_tail_qint_one,8]
	move 2,10
	pushj 17,store_tail_qint_one_index
	move 1,[POINT 9,g_tail_qint_one,8]
	pushj 17,load_tail_qint_one_index
	move 10,1
	move 1,[POINT 9,g_tail_qint_one,8]
	pushj 17,addr_tail_qint_one_const
	dpb 10,1
	move 1,[POINT 9,g_tail_qint_one,8]
	pushj 17,load_tail_qint_one_const
	move 10,1
	move 1,[POINT 9,g_tail_qint_one,8]
	pushj 17,addr_tail_qint_one_index
	dpb 10,1
	move 1,[POINT 9,g_tail_qint_one,8]
	pushj 17,load_tail_qint_one_const
	move 10,1
	move 1,[POINT 9,g_tail_qint_one,8]
	pushj 17,load_tail_qint_one_index
	add 10,1
	move 1,[POINT 9,g_tail_qint_one,8]
	pushj 17,diff_tail_qint_one
	add 10,1
	lsh 10,33
	ash 10,-33
	move 1,10
	pop 17,10
	popj 17,

store_tail_uqint_one_const:
	andi 2,777	; zero_extendqisi2
	dpb 2,[POINT 9,(1),17]
	popj 17,

store_tail_uqint_one_index:
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	dpb 2,4
	popj 17,

load_tail_uqint_one_const:
	ldb 1,[POINT 9,(1),17]
	popj 17,

load_tail_uqint_one_index:
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	ldb 1,4
	popj 17,

addr_tail_uqint_one_const:
	hrrz 1,1
	tlo 1,2200
	popj 17,

addr_tail_uqint_one_index:
	move 4,1
	movei 1,0
	ash 1,-2	; ashrsi3_pointer
	add 1,4
	hrrz 1,1
	tlo 1,2200
	popj 17,

diff_tail_uqint_one:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	pushj 17,addr_tail_uqint_one_index
	move 13,1
	move 1,12
	pushj 17,addr_tail_uqint_one_const
	move 10,13
	sub 10,1
	muli 10,10
	move 1,11
	ash 1,-1
	add 1,%BADL9(10)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

use_tail_uqint_one:
	push 17,10
	move 10,1
	andi 10,777	; zero_extendqisi2
	move 1,[POINT 9,g_tail_uqint_one,8]
	move 2,10
	pushj 17,store_tail_uqint_one_const
	addi 10,1
	andi 10,777	; zero_extendqisi2
	move 1,[POINT 9,g_tail_uqint_one,8]
	move 2,10
	pushj 17,store_tail_uqint_one_index
	move 1,[POINT 9,g_tail_uqint_one,8]
	pushj 17,load_tail_uqint_one_index
	move 10,1
	move 1,[POINT 9,g_tail_uqint_one,8]
	pushj 17,addr_tail_uqint_one_const
	dpb 10,1
	move 1,[POINT 9,g_tail_uqint_one,8]
	pushj 17,load_tail_uqint_one_const
	move 10,1
	move 1,[POINT 9,g_tail_uqint_one,8]
	pushj 17,addr_tail_uqint_one_index
	dpb 10,1
	move 1,[POINT 9,g_tail_uqint_one,8]
	pushj 17,load_tail_uqint_one_const
	move 10,1
	move 1,[POINT 9,g_tail_uqint_one,8]
	pushj 17,load_tail_uqint_one_index
	add 10,1
	move 1,[POINT 9,g_tail_uqint_one,8]
	pushj 17,diff_tail_uqint_one
	add 10,1
	andi 10,777	; zero_extendqisi2
	move 1,10
	pop 17,10
	popj 17,

store_tail_hint_one_const:
	hrrm 2,(1)
	popj 17,

store_tail_hint_one_index:
	movei 4,0
	ash 4,-1	; ashrsi3_pointer
	add 4,1
	dpb 2,4	; movhi
	popj 17,

load_tail_hint_one_const:
	hrre 1,(1)
	popj 17,

load_tail_hint_one_index:
	movei 4,0
	ash 4,-1	; ashrsi3_pointer
	add 4,1
	ldb 1,4
	hrre 1,1
	popj 17,

addr_tail_hint_one_const:
	hrrz 1,1
	tlo 1,2200
	popj 17,

addr_tail_hint_one_index:
	move 4,1
	movei 1,0
	ash 1,-1	; ashrsi3_pointer
	add 1,4
	hrrz 1,1
	tlo 1,2200
	popj 17,

diff_tail_hint_one:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	pushj 17,addr_tail_hint_one_index
	move 13,1
	move 1,12
	pushj 17,addr_tail_hint_one_const
	move 10,13
	sub 10,1
	muli 10,4
	move 1,11
	ash 1,-1
	add 1,%BADLH(10)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

use_tail_hint_one:
	push 17,10
	move 10,1
	hrrzi 10,(10)	; zero_extendhisi2
	hrre 2,10	; extendhisi2
	move 1,[POINT 18,g_tail_hint_one,17]
	pushj 17,store_tail_hint_one_const
	addi 10,1
	hrre 10,10	; extendhisi2
	move 1,[POINT 18,g_tail_hint_one,17]
	move 2,10
	pushj 17,store_tail_hint_one_index
	move 1,[POINT 18,g_tail_hint_one,17]
	pushj 17,load_tail_hint_one_index
	move 10,1
	move 1,[POINT 18,g_tail_hint_one,17]
	pushj 17,addr_tail_hint_one_const
	dpb 10,1	; movhi
	move 1,[POINT 18,g_tail_hint_one,17]
	pushj 17,load_tail_hint_one_const
	move 10,1
	move 1,[POINT 18,g_tail_hint_one,17]
	pushj 17,addr_tail_hint_one_index
	dpb 10,1	; movhi
	move 1,[POINT 18,g_tail_hint_one,17]
	pushj 17,load_tail_hint_one_const
	move 10,1
	move 1,[POINT 18,g_tail_hint_one,17]
	pushj 17,load_tail_hint_one_index
	add 10,1
	move 1,[POINT 18,g_tail_hint_one,17]
	pushj 17,diff_tail_hint_one
	add 10,1
	hrre 10,10	; extendhisi2
	move 1,10
	pop 17,10
	popj 17,

store_tail_uhint_one_const:
	hrrm 2,(1)
	popj 17,

store_tail_uhint_one_index:
	movei 4,0
	ash 4,-1	; ashrsi3_pointer
	add 4,1
	dpb 2,4	; movhi
	popj 17,

load_tail_uhint_one_const:
	hrrz 1,(1)
	popj 17,

load_tail_uhint_one_index:
	movei 4,0
	ash 4,-1	; ashrsi3_pointer
	add 4,1
	ldb 1,4
	popj 17,

addr_tail_uhint_one_const:
	hrrz 1,1
	tlo 1,2200
	popj 17,

addr_tail_uhint_one_index:
	move 4,1
	movei 1,0
	ash 1,-1	; ashrsi3_pointer
	add 1,4
	hrrz 1,1
	tlo 1,2200
	popj 17,

diff_tail_uhint_one:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	pushj 17,addr_tail_uhint_one_index
	move 13,1
	move 1,12
	pushj 17,addr_tail_uhint_one_const
	move 10,13
	sub 10,1
	muli 10,4
	move 1,11
	ash 1,-1
	add 1,%BADLH(10)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

use_tail_uhint_one:
	push 17,10
	move 10,1
	hrrzi 10,(10)	; zero_extendhisi2
	move 1,[POINT 18,g_tail_uhint_one,17]
	move 2,10
	pushj 17,store_tail_uhint_one_const
	movei 10,1(10)
	move 1,[POINT 18,g_tail_uhint_one,17]
	move 2,10
	pushj 17,store_tail_uhint_one_index
	move 1,[POINT 18,g_tail_uhint_one,17]
	pushj 17,load_tail_uhint_one_index
	move 10,1
	move 1,[POINT 18,g_tail_uhint_one,17]
	pushj 17,addr_tail_uhint_one_const
	dpb 10,1	; movhi
	move 1,[POINT 18,g_tail_uhint_one,17]
	pushj 17,load_tail_uhint_one_const
	move 10,1
	move 1,[POINT 18,g_tail_uhint_one,17]
	pushj 17,addr_tail_uhint_one_index
	dpb 10,1	; movhi
	move 1,[POINT 18,g_tail_uhint_one,17]
	pushj 17,load_tail_uhint_one_const
	move 10,1
	move 1,[POINT 18,g_tail_uhint_one,17]
	pushj 17,load_tail_uhint_one_index
	add 10,1
	move 1,[POINT 18,g_tail_uhint_one,17]
	pushj 17,diff_tail_uhint_one
	add 10,1
	hrrzi 10,(10)	; zero_extendhisi2
	move 1,10
	pop 17,10
	popj 17,

store_tail_char6_one_const:
	lsh 2,36
	ash 2,-36
	dpb 2,[POINT 6,(1),14]
	popj 17,

store_tail_char6_one_index:
	lsh 2,36
	ash 2,-36
	dpb 2,1
	popj 17,

load_tail_char6_one_const:
	move 1,(1)
	lsh 1,11
	ash 1,-36
	popj 17,

load_tail_char6_one_index:
	ldb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

addr_tail_char6_one_const:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	add 17,[-1,,-1]
	popj 17,

addr_tail_char6_one_index:
	hrrz 1,1
	tlo 1,2200
	popj 17,

diff_tail_char6_one:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	pushj 17,addr_tail_char6_one_index
	move 13,1
	move 1,12
	pushj 17,addr_tail_char6_one_const
	move 10,13
	sub 10,1
	muli 10,14
	move 1,11
	ash 1,-1
	add 1,%BADL6(10)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

use_tail_char6_one:
	push 17,10
	move 10,1
	lsh 10,36
	ash 10,-36
	move 2,10
	lsh 2,36
	ash 2,-36
	move 1,[POINT 6,g_tail_char6_one,5]
	pushj 17,store_tail_char6_one_const
	addi 10,1
	lsh 10,36
	ash 10,-36
	move 1,[POINT 6,g_tail_char6_one,5]
	move 2,10
	pushj 17,store_tail_char6_one_index
	move 1,[POINT 6,g_tail_char6_one,5]
	pushj 17,load_tail_char6_one_index
	move 10,1
	move 1,[POINT 6,g_tail_char6_one,5]
	pushj 17,addr_tail_char6_one_const
	dpb 10,1
	move 1,[POINT 6,g_tail_char6_one,5]
	pushj 17,load_tail_char6_one_const
	move 10,1
	move 1,[POINT 6,g_tail_char6_one,5]
	pushj 17,addr_tail_char6_one_index
	dpb 10,1
	move 1,[POINT 6,g_tail_char6_one,5]
	pushj 17,load_tail_char6_one_const
	move 10,1
	move 1,[POINT 6,g_tail_char6_one,5]
	pushj 17,load_tail_char6_one_index
	add 10,1
	move 1,[POINT 6,g_tail_char6_one,5]
	pushj 17,diff_tail_char6_one
	add 10,1
	lsh 10,36
	ash 10,-36
	move 1,10
	pop 17,10
	popj 17,

store_tail_uchar6_one_const:
	andi 2,77
	dpb 2,[POINT 6,(1),14]
	popj 17,

store_tail_uchar6_one_index:
	andi 2,77
	dpb 2,1
	popj 17,

load_tail_uchar6_one_const:
	ldb 1,[POINT 6,(1),14]
	popj 17,

load_tail_uchar6_one_index:
	ldb 1,1
	popj 17,

addr_tail_uchar6_one_const:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	add 17,[-1,,-1]
	popj 17,

addr_tail_uchar6_one_index:
	hrrz 1,1
	tlo 1,2200
	popj 17,

diff_tail_uchar6_one:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	pushj 17,addr_tail_uchar6_one_index
	move 13,1
	move 1,12
	pushj 17,addr_tail_uchar6_one_const
	move 10,13
	sub 10,1
	muli 10,14
	move 1,11
	ash 1,-1
	add 1,%BADL6(10)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

use_tail_uchar6_one:
	push 17,10
	move 10,1
	andi 10,77
	move 2,10
	andi 2,77
	move 1,[POINT 6,g_tail_uchar6_one,5]
	pushj 17,store_tail_uchar6_one_const
	addi 10,1
	andi 10,77
	move 1,[POINT 6,g_tail_uchar6_one,5]
	move 2,10
	pushj 17,store_tail_uchar6_one_index
	move 1,[POINT 6,g_tail_uchar6_one,5]
	pushj 17,load_tail_uchar6_one_index
	move 10,1
	move 1,[POINT 6,g_tail_uchar6_one,5]
	pushj 17,addr_tail_uchar6_one_const
	dpb 10,1
	move 1,[POINT 6,g_tail_uchar6_one,5]
	pushj 17,load_tail_uchar6_one_const
	move 10,1
	move 1,[POINT 6,g_tail_uchar6_one,5]
	pushj 17,addr_tail_uchar6_one_index
	dpb 10,1
	move 1,[POINT 6,g_tail_uchar6_one,5]
	pushj 17,load_tail_uchar6_one_const
	move 10,1
	move 1,[POINT 6,g_tail_uchar6_one,5]
	pushj 17,load_tail_uchar6_one_index
	add 10,1
	move 1,[POINT 6,g_tail_uchar6_one,5]
	pushj 17,diff_tail_uchar6_one
	add 10,1
	andi 10,77
	move 1,10
	pop 17,10
	popj 17,

store_tail_char7_one_const:
	lsh 2,35
	ash 2,-35
	dpb 2,[POINT 7,(1),15]
	popj 17,

store_tail_char7_one_index:
	lsh 2,35
	ash 2,-35
	dpb 2,1
	popj 17,

load_tail_char7_one_const:
	move 1,(1)
	lsh 1,11
	ash 1,-35
	popj 17,

load_tail_char7_one_index:
	ldb 1,1
	trne 1,100
	orcmi 1,177
	popj 17,

addr_tail_char7_one_const:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	add 17,[-1,,-1]
	popj 17,

addr_tail_char7_one_index:
	hrrz 1,1
	tlo 1,2200
	popj 17,

diff_tail_char7_one:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	pushj 17,addr_tail_char7_one_index
	move 13,1
	move 1,12
	pushj 17,addr_tail_char7_one_const
	move 10,13
	sub 10,1
	muli 10,12
	move 1,11
	ash 1,-1
	add 1,%BADL7(10)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

use_tail_char7_one:
	push 17,10
	move 10,1
	lsh 10,35
	ash 10,-35
	move 2,10
	lsh 2,35
	ash 2,-35
	move 1,[POINT 7,g_tail_char7_one,6]
	pushj 17,store_tail_char7_one_const
	addi 10,1
	lsh 10,35
	ash 10,-35
	move 1,[POINT 7,g_tail_char7_one,6]
	move 2,10
	pushj 17,store_tail_char7_one_index
	move 1,[POINT 7,g_tail_char7_one,6]
	pushj 17,load_tail_char7_one_index
	move 10,1
	move 1,[POINT 7,g_tail_char7_one,6]
	pushj 17,addr_tail_char7_one_const
	dpb 10,1
	move 1,[POINT 7,g_tail_char7_one,6]
	pushj 17,load_tail_char7_one_const
	move 10,1
	move 1,[POINT 7,g_tail_char7_one,6]
	pushj 17,addr_tail_char7_one_index
	dpb 10,1
	move 1,[POINT 7,g_tail_char7_one,6]
	pushj 17,load_tail_char7_one_const
	move 10,1
	move 1,[POINT 7,g_tail_char7_one,6]
	pushj 17,load_tail_char7_one_index
	add 10,1
	move 1,[POINT 7,g_tail_char7_one,6]
	pushj 17,diff_tail_char7_one
	add 10,1
	lsh 10,35
	ash 10,-35
	move 1,10
	pop 17,10
	popj 17,

store_tail_uchar7_one_const:
	andi 2,177
	dpb 2,[POINT 7,(1),15]
	popj 17,

store_tail_uchar7_one_index:
	andi 2,177
	dpb 2,1
	popj 17,

load_tail_uchar7_one_const:
	ldb 1,[POINT 7,(1),15]
	popj 17,

load_tail_uchar7_one_index:
	ldb 1,1
	popj 17,

addr_tail_uchar7_one_const:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	add 17,[-1,,-1]
	popj 17,

addr_tail_uchar7_one_index:
	hrrz 1,1
	tlo 1,2200
	popj 17,

diff_tail_uchar7_one:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	pushj 17,addr_tail_uchar7_one_index
	move 13,1
	move 1,12
	pushj 17,addr_tail_uchar7_one_const
	move 10,13
	sub 10,1
	muli 10,12
	move 1,11
	ash 1,-1
	add 1,%BADL7(10)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

use_tail_uchar7_one:
	push 17,10
	move 10,1
	andi 10,177
	move 2,10
	andi 2,177
	move 1,[POINT 7,g_tail_uchar7_one,6]
	pushj 17,store_tail_uchar7_one_const
	addi 10,1
	andi 10,177
	move 1,[POINT 7,g_tail_uchar7_one,6]
	move 2,10
	pushj 17,store_tail_uchar7_one_index
	move 1,[POINT 7,g_tail_uchar7_one,6]
	pushj 17,load_tail_uchar7_one_index
	move 10,1
	move 1,[POINT 7,g_tail_uchar7_one,6]
	pushj 17,addr_tail_uchar7_one_const
	dpb 10,1
	move 1,[POINT 7,g_tail_uchar7_one,6]
	pushj 17,load_tail_uchar7_one_const
	move 10,1
	move 1,[POINT 7,g_tail_uchar7_one,6]
	pushj 17,addr_tail_uchar7_one_index
	dpb 10,1
	move 1,[POINT 7,g_tail_uchar7_one,6]
	pushj 17,load_tail_uchar7_one_const
	move 10,1
	move 1,[POINT 7,g_tail_uchar7_one,6]
	pushj 17,load_tail_uchar7_one_index
	add 10,1
	move 1,[POINT 7,g_tail_uchar7_one,6]
	pushj 17,diff_tail_uchar7_one
	add 10,1
	andi 10,177
	move 1,10
	pop 17,10
	popj 17,

store_tail_char8_one_const:
	lsh 2,34
	ash 2,-34
	dpb 2,[POINT 8,(1),16]
	popj 17,

store_tail_char8_one_index:
	lsh 2,34
	ash 2,-34
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	dpb 2,4
	popj 17,

load_tail_char8_one_const:
	move 1,(1)
	lsh 1,11
	ash 1,-34
	popj 17,

load_tail_char8_one_index:
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	ldb 1,4
	trne 1,200
	orcmi 1,377
	popj 17,

addr_tail_char8_one_const:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	add 17,[-1,,-1]
	popj 17,

addr_tail_char8_one_index:
	move 4,1
	movei 1,0
	ash 1,-2	; ashrsi3_pointer
	add 1,4
	hrrz 1,1
	tlo 1,2200
	popj 17,

diff_tail_char8_one:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	pushj 17,addr_tail_char8_one_index
	move 13,1
	move 1,12
	pushj 17,addr_tail_char8_one_const
	move 10,13
	sub 10,1
	muli 10,10
	move 1,11
	ash 1,-1
	add 1,%BADL8(10)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

use_tail_char8_one:
	push 17,10
	move 10,1
	lsh 10,34
	ash 10,-34
	move 2,10
	lsh 2,34
	ash 2,-34
	move 1,[POINT 8,g_tail_char8_one,7]
	pushj 17,store_tail_char8_one_const
	addi 10,1
	lsh 10,34
	ash 10,-34
	move 1,[POINT 8,g_tail_char8_one,7]
	move 2,10
	pushj 17,store_tail_char8_one_index
	move 1,[POINT 8,g_tail_char8_one,7]
	pushj 17,load_tail_char8_one_index
	move 10,1
	move 1,[POINT 8,g_tail_char8_one,7]
	pushj 17,addr_tail_char8_one_const
	dpb 10,1
	move 1,[POINT 8,g_tail_char8_one,7]
	pushj 17,load_tail_char8_one_const
	move 10,1
	move 1,[POINT 8,g_tail_char8_one,7]
	pushj 17,addr_tail_char8_one_index
	dpb 10,1
	move 1,[POINT 8,g_tail_char8_one,7]
	pushj 17,load_tail_char8_one_const
	move 10,1
	move 1,[POINT 8,g_tail_char8_one,7]
	pushj 17,load_tail_char8_one_index
	add 10,1
	move 1,[POINT 8,g_tail_char8_one,7]
	pushj 17,diff_tail_char8_one
	add 10,1
	lsh 10,34
	ash 10,-34
	move 1,10
	pop 17,10
	popj 17,

store_tail_uchar8_one_const:
	andi 2,377
	dpb 2,[POINT 8,(1),16]
	popj 17,

store_tail_uchar8_one_index:
	andi 2,377
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	dpb 2,4
	popj 17,

load_tail_uchar8_one_const:
	ldb 1,[POINT 8,(1),16]
	popj 17,

load_tail_uchar8_one_index:
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	ldb 1,4
	popj 17,

addr_tail_uchar8_one_const:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	add 17,[-1,,-1]
	popj 17,

addr_tail_uchar8_one_index:
	move 4,1
	movei 1,0
	ash 1,-2	; ashrsi3_pointer
	add 1,4
	hrrz 1,1
	tlo 1,2200
	popj 17,

diff_tail_uchar8_one:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	pushj 17,addr_tail_uchar8_one_index
	move 13,1
	move 1,12
	pushj 17,addr_tail_uchar8_one_const
	move 10,13
	sub 10,1
	muli 10,10
	move 1,11
	ash 1,-1
	add 1,%BADL8(10)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

use_tail_uchar8_one:
	push 17,10
	move 10,1
	andi 10,377
	move 2,10
	andi 2,377
	move 1,[POINT 8,g_tail_uchar8_one,7]
	pushj 17,store_tail_uchar8_one_const
	addi 10,1
	andi 10,377
	move 1,[POINT 8,g_tail_uchar8_one,7]
	move 2,10
	pushj 17,store_tail_uchar8_one_index
	move 1,[POINT 8,g_tail_uchar8_one,7]
	pushj 17,load_tail_uchar8_one_index
	move 10,1
	move 1,[POINT 8,g_tail_uchar8_one,7]
	pushj 17,addr_tail_uchar8_one_const
	dpb 10,1
	move 1,[POINT 8,g_tail_uchar8_one,7]
	pushj 17,load_tail_uchar8_one_const
	move 10,1
	move 1,[POINT 8,g_tail_uchar8_one,7]
	pushj 17,addr_tail_uchar8_one_index
	dpb 10,1
	move 1,[POINT 8,g_tail_uchar8_one,7]
	pushj 17,load_tail_uchar8_one_const
	move 10,1
	move 1,[POINT 8,g_tail_uchar8_one,7]
	pushj 17,load_tail_uchar8_one_index
	add 10,1
	move 1,[POINT 8,g_tail_uchar8_one,7]
	pushj 17,diff_tail_uchar8_one
	add 10,1
	andi 10,377
	move 1,10
	pop 17,10
	popj 17,

store_tail_char9_one_const:
	andi 2,777	; zero_extendqisi2
	dpb 2,[POINT 9,(1),17]
	popj 17,

store_tail_char9_one_index:
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	dpb 2,4
	popj 17,

load_tail_char9_one_const:
	move 1,(1)
	lsh 1,11
	ash 1,-33
	popj 17,

load_tail_char9_one_index:
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

addr_tail_char9_one_const:
	hrrz 1,1
	tlo 1,2200
	popj 17,

addr_tail_char9_one_index:
	move 4,1
	movei 1,0
	ash 1,-2	; ashrsi3_pointer
	add 1,4
	hrrz 1,1
	tlo 1,2200
	popj 17,

diff_tail_char9_one:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	pushj 17,addr_tail_char9_one_index
	move 13,1
	move 1,12
	pushj 17,addr_tail_char9_one_const
	move 10,13
	sub 10,1
	muli 10,10
	move 1,11
	ash 1,-1
	add 1,%BADL9(10)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

use_tail_char9_one:
	push 17,10
	move 10,1
	andi 10,777	; zero_extendqisi2
	move 2,10
	lsh 2,33
	ash 2,-33
	move 1,[POINT 9,g_tail_char9_one,8]
	pushj 17,store_tail_char9_one_const
	addi 10,1
	lsh 10,33
	ash 10,-33
	move 1,[POINT 9,g_tail_char9_one,8]
	move 2,10
	pushj 17,store_tail_char9_one_index
	move 1,[POINT 9,g_tail_char9_one,8]
	pushj 17,load_tail_char9_one_index
	move 10,1
	move 1,[POINT 9,g_tail_char9_one,8]
	pushj 17,addr_tail_char9_one_const
	dpb 10,1
	move 1,[POINT 9,g_tail_char9_one,8]
	pushj 17,load_tail_char9_one_const
	move 10,1
	move 1,[POINT 9,g_tail_char9_one,8]
	pushj 17,addr_tail_char9_one_index
	dpb 10,1
	move 1,[POINT 9,g_tail_char9_one,8]
	pushj 17,load_tail_char9_one_const
	move 10,1
	move 1,[POINT 9,g_tail_char9_one,8]
	pushj 17,load_tail_char9_one_index
	add 10,1
	move 1,[POINT 9,g_tail_char9_one,8]
	pushj 17,diff_tail_char9_one
	add 10,1
	lsh 10,33
	ash 10,-33
	move 1,10
	pop 17,10
	popj 17,

store_tail_uchar9_one_const:
	andi 2,777	; zero_extendqisi2
	dpb 2,[POINT 9,(1),17]
	popj 17,

store_tail_uchar9_one_index:
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	dpb 2,4
	popj 17,

load_tail_uchar9_one_const:
	ldb 1,[POINT 9,(1),17]
	popj 17,

load_tail_uchar9_one_index:
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	ldb 1,4
	popj 17,

addr_tail_uchar9_one_const:
	hrrz 1,1
	tlo 1,2200
	popj 17,

addr_tail_uchar9_one_index:
	move 4,1
	movei 1,0
	ash 1,-2	; ashrsi3_pointer
	add 1,4
	hrrz 1,1
	tlo 1,2200
	popj 17,

diff_tail_uchar9_one:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	pushj 17,addr_tail_uchar9_one_index
	move 13,1
	move 1,12
	pushj 17,addr_tail_uchar9_one_const
	move 10,13
	sub 10,1
	muli 10,10
	move 1,11
	ash 1,-1
	add 1,%BADL9(10)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

use_tail_uchar9_one:
	push 17,10
	move 10,1
	andi 10,777	; zero_extendqisi2
	move 1,[POINT 9,g_tail_uchar9_one,8]
	move 2,10
	pushj 17,store_tail_uchar9_one_const
	addi 10,1
	andi 10,777	; zero_extendqisi2
	move 1,[POINT 9,g_tail_uchar9_one,8]
	move 2,10
	pushj 17,store_tail_uchar9_one_index
	move 1,[POINT 9,g_tail_uchar9_one,8]
	pushj 17,load_tail_uchar9_one_index
	move 10,1
	move 1,[POINT 9,g_tail_uchar9_one,8]
	pushj 17,addr_tail_uchar9_one_const
	dpb 10,1
	move 1,[POINT 9,g_tail_uchar9_one,8]
	pushj 17,load_tail_uchar9_one_const
	move 10,1
	move 1,[POINT 9,g_tail_uchar9_one,8]
	pushj 17,addr_tail_uchar9_one_index
	dpb 10,1
	move 1,[POINT 9,g_tail_uchar9_one,8]
	pushj 17,load_tail_uchar9_one_const
	move 10,1
	move 1,[POINT 9,g_tail_uchar9_one,8]
	pushj 17,load_tail_uchar9_one_index
	add 10,1
	move 1,[POINT 9,g_tail_uchar9_one,8]
	pushj 17,diff_tail_uchar9_one
	add 10,1
	andi 10,777	; zero_extendqisi2
	move 1,10
	pop 17,10
	popj 17,

store_tail_short16_one_const:
	lsh 2,24
	ash 2,-24
	dpb 2,[POINT 16,(1),31]
	popj 17,

store_tail_short16_one_index:
	lsh 2,24
	ash 2,-24
	movei 4,0
	ash 4,-1	; ashrsi3_pointer
	add 4,1
	dpb 2,4	; movhi
	popj 17,

load_tail_short16_one_const:
	move 1,(1)
	lsh 1,20
	ash 1,-24
	popj 17,

load_tail_short16_one_index:
	movei 4,0
	ash 4,-1	; ashrsi3_pointer
	add 4,1
	move 1,(4)
	lsh 1,20
	ash 1,-24
	popj 17,

addr_tail_short16_one_const:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	add 17,[-1,,-1]
	popj 17,

addr_tail_short16_one_index:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	add 17,[-1,,-1]
	popj 17,

diff_tail_short16_one:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	pushj 17,addr_tail_short16_one_index
	move 13,1
	move 1,12
	pushj 17,addr_tail_short16_one_const
	move 10,13
	sub 10,1
	muli 10,4
	move 1,11
	ash 1,-1
	add 1,%BADLH(10)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

use_tail_short16_one:
	push 17,10
	move 10,1
	lsh 10,24
	ash 10,-24
	move 2,10
	lsh 2,24
	ash 2,-24
	move 1,[POINT 18,g_tail_short16_one,17]
	pushj 17,store_tail_short16_one_const
	addi 10,1
	lsh 10,24
	ash 10,-24
	move 1,[POINT 18,g_tail_short16_one,17]
	move 2,10
	pushj 17,store_tail_short16_one_index
	move 1,[POINT 18,g_tail_short16_one,17]
	pushj 17,load_tail_short16_one_index
	move 10,1
	move 1,[POINT 18,g_tail_short16_one,17]
	pushj 17,addr_tail_short16_one_const
	dpb 10,1	; movhi
	move 1,[POINT 18,g_tail_short16_one,17]
	pushj 17,load_tail_short16_one_const
	move 10,1
	move 1,[POINT 18,g_tail_short16_one,17]
	pushj 17,addr_tail_short16_one_index
	dpb 10,1	; movhi
	move 1,[POINT 18,g_tail_short16_one,17]
	pushj 17,load_tail_short16_one_const
	move 10,1
	move 1,[POINT 18,g_tail_short16_one,17]
	pushj 17,load_tail_short16_one_index
	add 10,1
	move 1,[POINT 18,g_tail_short16_one,17]
	pushj 17,diff_tail_short16_one
	add 10,1
	lsh 10,24
	ash 10,-24
	move 1,10
	pop 17,10
	popj 17,

store_tail_ushort16_one_const:
	andi 2,177777
	dpb 2,[POINT 16,(1),31]
	popj 17,

store_tail_ushort16_one_index:
	andi 2,177777
	movei 4,0
	ash 4,-1	; ashrsi3_pointer
	add 4,1
	dpb 2,4	; movhi
	popj 17,

load_tail_ushort16_one_const:
	move 1,(1)
	lsh 1,-4
	andi 1,177777
	popj 17,

load_tail_ushort16_one_index:
	movei 4,0
	ash 4,-1	; ashrsi3_pointer
	add 4,1
	move 1,(4)
	lsh 1,-4
	andi 1,177777
	popj 17,

addr_tail_ushort16_one_const:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	add 17,[-1,,-1]
	popj 17,

addr_tail_ushort16_one_index:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	add 17,[-1,,-1]
	popj 17,

diff_tail_ushort16_one:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	pushj 17,addr_tail_ushort16_one_index
	move 13,1
	move 1,12
	pushj 17,addr_tail_ushort16_one_const
	move 10,13
	sub 10,1
	muli 10,4
	move 1,11
	ash 1,-1
	add 1,%BADLH(10)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

use_tail_ushort16_one:
	push 17,10
	move 10,1
	andi 10,177777
	move 2,10
	andi 2,177777
	move 1,[POINT 18,g_tail_ushort16_one,17]
	pushj 17,store_tail_ushort16_one_const
	addi 10,1
	andi 10,177777
	move 1,[POINT 18,g_tail_ushort16_one,17]
	move 2,10
	pushj 17,store_tail_ushort16_one_index
	move 1,[POINT 18,g_tail_ushort16_one,17]
	pushj 17,load_tail_ushort16_one_index
	move 10,1
	move 1,[POINT 18,g_tail_ushort16_one,17]
	pushj 17,addr_tail_ushort16_one_const
	dpb 10,1	; movhi
	move 1,[POINT 18,g_tail_ushort16_one,17]
	pushj 17,load_tail_ushort16_one_const
	move 10,1
	move 1,[POINT 18,g_tail_ushort16_one,17]
	pushj 17,addr_tail_ushort16_one_index
	dpb 10,1	; movhi
	move 1,[POINT 18,g_tail_ushort16_one,17]
	pushj 17,load_tail_ushort16_one_const
	move 10,1
	move 1,[POINT 18,g_tail_ushort16_one,17]
	pushj 17,load_tail_ushort16_one_index
	add 10,1
	move 1,[POINT 18,g_tail_ushort16_one,17]
	pushj 17,diff_tail_ushort16_one
	add 10,1
	andi 10,177777
	move 1,10
	pop 17,10
	popj 17,

store_tail_short18_one_const:
	hrrm 2,(1)
	popj 17,

store_tail_short18_one_index:
	movei 4,0
	ash 4,-1	; ashrsi3_pointer
	add 4,1
	dpb 2,4	; movhi
	popj 17,

load_tail_short18_one_const:
	hrre 1,(1)
	popj 17,

load_tail_short18_one_index:
	movei 4,0
	ash 4,-1	; ashrsi3_pointer
	add 4,1
	ldb 1,4
	hrre 1,1
	popj 17,

addr_tail_short18_one_const:
	hrrz 1,1
	tlo 1,2200
	popj 17,

addr_tail_short18_one_index:
	move 4,1
	movei 1,0
	ash 1,-1	; ashrsi3_pointer
	add 1,4
	hrrz 1,1
	tlo 1,2200
	popj 17,

diff_tail_short18_one:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	pushj 17,addr_tail_short18_one_index
	move 13,1
	move 1,12
	pushj 17,addr_tail_short18_one_const
	move 10,13
	sub 10,1
	muli 10,4
	move 1,11
	ash 1,-1
	add 1,%BADLH(10)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

use_tail_short18_one:
	push 17,10
	move 10,1
	hrrzi 10,(10)	; zero_extendhisi2
	hrre 2,10	; extendhisi2
	move 1,[POINT 18,g_tail_short18_one,17]
	pushj 17,store_tail_short18_one_const
	addi 10,1
	hrre 10,10	; extendhisi2
	move 1,[POINT 18,g_tail_short18_one,17]
	move 2,10
	pushj 17,store_tail_short18_one_index
	move 1,[POINT 18,g_tail_short18_one,17]
	pushj 17,load_tail_short18_one_index
	move 10,1
	move 1,[POINT 18,g_tail_short18_one,17]
	pushj 17,addr_tail_short18_one_const
	dpb 10,1	; movhi
	move 1,[POINT 18,g_tail_short18_one,17]
	pushj 17,load_tail_short18_one_const
	move 10,1
	move 1,[POINT 18,g_tail_short18_one,17]
	pushj 17,addr_tail_short18_one_index
	dpb 10,1	; movhi
	move 1,[POINT 18,g_tail_short18_one,17]
	pushj 17,load_tail_short18_one_const
	move 10,1
	move 1,[POINT 18,g_tail_short18_one,17]
	pushj 17,load_tail_short18_one_index
	add 10,1
	move 1,[POINT 18,g_tail_short18_one,17]
	pushj 17,diff_tail_short18_one
	add 10,1
	hrre 10,10	; extendhisi2
	move 1,10
	pop 17,10
	popj 17,

store_tail_ushort18_one_const:
	hrrm 2,(1)
	popj 17,

store_tail_ushort18_one_index:
	movei 4,0
	ash 4,-1	; ashrsi3_pointer
	add 4,1
	dpb 2,4	; movhi
	popj 17,

load_tail_ushort18_one_const:
	hrrz 1,(1)
	popj 17,

load_tail_ushort18_one_index:
	movei 4,0
	ash 4,-1	; ashrsi3_pointer
	add 4,1
	ldb 1,4
	popj 17,

addr_tail_ushort18_one_const:
	hrrz 1,1
	tlo 1,2200
	popj 17,

addr_tail_ushort18_one_index:
	move 4,1
	movei 1,0
	ash 1,-1	; ashrsi3_pointer
	add 1,4
	hrrz 1,1
	tlo 1,2200
	popj 17,

diff_tail_ushort18_one:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	pushj 17,addr_tail_ushort18_one_index
	move 13,1
	move 1,12
	pushj 17,addr_tail_ushort18_one_const
	move 10,13
	sub 10,1
	muli 10,4
	move 1,11
	ash 1,-1
	add 1,%BADLH(10)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

use_tail_ushort18_one:
	push 17,10
	move 10,1
	hrrzi 10,(10)	; zero_extendhisi2
	move 1,[POINT 18,g_tail_ushort18_one,17]
	move 2,10
	pushj 17,store_tail_ushort18_one_const
	movei 10,1(10)
	move 1,[POINT 18,g_tail_ushort18_one,17]
	move 2,10
	pushj 17,store_tail_ushort18_one_index
	move 1,[POINT 18,g_tail_ushort18_one,17]
	pushj 17,load_tail_ushort18_one_index
	move 10,1
	move 1,[POINT 18,g_tail_ushort18_one,17]
	pushj 17,addr_tail_ushort18_one_const
	dpb 10,1	; movhi
	move 1,[POINT 18,g_tail_ushort18_one,17]
	pushj 17,load_tail_ushort18_one_const
	move 10,1
	move 1,[POINT 18,g_tail_ushort18_one,17]
	pushj 17,addr_tail_ushort18_one_index
	dpb 10,1	; movhi
	move 1,[POINT 18,g_tail_ushort18_one,17]
	pushj 17,load_tail_ushort18_one_const
	move 10,1
	move 1,[POINT 18,g_tail_ushort18_one,17]
	pushj 17,load_tail_ushort18_one_index
	add 10,1
	move 1,[POINT 18,g_tail_ushort18_one,17]
	pushj 17,diff_tail_ushort18_one
	add 10,1
	hrrzi 10,(10)	; zero_extendhisi2
	move 1,10
	pop 17,10
	popj 17,

store_tail_int32_one_const:
	dpb 2,[POINT 32,1(1),31]
	popj 17,

store_tail_int32_one_index:
	dpb 2,[POINT 32,1(1),31]
	popj 17,

load_tail_int32_one_const:
	move 1,1(1)
	ash 1,-4
	popj 17,

load_tail_int32_one_index:
	move 1,1(1)
	ash 1,-4
	popj 17,

addr_tail_int32_one_const:
	addi 1,1
	popj 17,

addr_tail_int32_one_index:
	addi 1,1
	popj 17,

diff_tail_int32_one:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,addr_tail_int32_one_index
	move 10,1
	move 1,11
	pushj 17,addr_tail_int32_one_const
	sub 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

use_tail_int32_one:
	push 17,10
	move 10,1
	movei 1,g_tail_int32_one
	move 2,10
	pushj 17,store_tail_int32_one_const
	addi 10,1
	movei 1,g_tail_int32_one
	move 2,10
	pushj 17,store_tail_int32_one_index
	movei 1,g_tail_int32_one
	pushj 17,load_tail_int32_one_index
	move 10,1
	movei 1,g_tail_int32_one
	pushj 17,addr_tail_int32_one_const
	movem 10,(1)
	movei 1,g_tail_int32_one
	pushj 17,load_tail_int32_one_const
	move 10,1
	movei 1,g_tail_int32_one
	pushj 17,addr_tail_int32_one_index
	movem 10,(1)
	movei 1,g_tail_int32_one
	pushj 17,load_tail_int32_one_const
	move 10,1
	movei 1,g_tail_int32_one
	pushj 17,load_tail_int32_one_index
	add 10,1
	movei 1,g_tail_int32_one
	pushj 17,diff_tail_int32_one
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

store_tail_uint32_one_const:
	dpb 2,[POINT 32,1(1),31]
	popj 17,

store_tail_uint32_one_index:
	dpb 2,[POINT 32,1(1),31]
	popj 17,

load_tail_uint32_one_const:
	move 1,1(1)
	lsh 1,-4
	popj 17,

load_tail_uint32_one_index:
	move 1,1(1)
	lsh 1,-4
	popj 17,

addr_tail_uint32_one_const:
	addi 1,1
	popj 17,

addr_tail_uint32_one_index:
	addi 1,1
	popj 17,

diff_tail_uint32_one:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,addr_tail_uint32_one_index
	move 10,1
	move 1,11
	pushj 17,addr_tail_uint32_one_const
	sub 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

use_tail_uint32_one:
	push 17,10
	move 10,1
	movei 1,g_tail_uint32_one
	move 2,10
	pushj 17,store_tail_uint32_one_const
	addi 10,1
	movei 1,g_tail_uint32_one
	move 2,10
	pushj 17,store_tail_uint32_one_index
	movei 1,g_tail_uint32_one
	pushj 17,load_tail_uint32_one_index
	move 10,1
	movei 1,g_tail_uint32_one
	pushj 17,addr_tail_uint32_one_const
	movem 10,(1)
	movei 1,g_tail_uint32_one
	pushj 17,load_tail_uint32_one_const
	move 10,1
	movei 1,g_tail_uint32_one
	pushj 17,addr_tail_uint32_one_index
	movem 10,(1)
	movei 1,g_tail_uint32_one
	pushj 17,load_tail_uint32_one_const
	move 10,1
	movei 1,g_tail_uint32_one
	pushj 17,load_tail_uint32_one_index
	add 10,1
	movei 1,g_tail_uint32_one
	pushj 17,diff_tail_uint32_one
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

store_tail_sint_one_const:
	movem 2,1(1)
	popj 17,

store_tail_sint_one_index:
	movem 2,1(1)
	popj 17,

load_tail_sint_one_const:
	move 1,1(1)
	popj 17,

load_tail_sint_one_index:
	move 1,1(1)
	popj 17,

addr_tail_sint_one_const:
	addi 1,1
	popj 17,

addr_tail_sint_one_index:
	addi 1,1
	popj 17,

diff_tail_sint_one:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,addr_tail_sint_one_index
	move 10,1
	move 1,11
	pushj 17,addr_tail_sint_one_const
	sub 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

use_tail_sint_one:
	push 17,10
	move 10,1
	movei 1,g_tail_sint_one
	move 2,10
	pushj 17,store_tail_sint_one_const
	addi 10,1
	movei 1,g_tail_sint_one
	move 2,10
	pushj 17,store_tail_sint_one_index
	movei 1,g_tail_sint_one
	pushj 17,load_tail_sint_one_index
	move 10,1
	movei 1,g_tail_sint_one
	pushj 17,addr_tail_sint_one_const
	movem 10,(1)
	movei 1,g_tail_sint_one
	pushj 17,load_tail_sint_one_const
	move 10,1
	movei 1,g_tail_sint_one
	pushj 17,addr_tail_sint_one_index
	movem 10,(1)
	movei 1,g_tail_sint_one
	pushj 17,load_tail_sint_one_const
	move 10,1
	movei 1,g_tail_sint_one
	pushj 17,load_tail_sint_one_index
	add 10,1
	movei 1,g_tail_sint_one
	pushj 17,diff_tail_sint_one
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

store_tail_usint_one_const:
	movem 2,1(1)
	popj 17,

store_tail_usint_one_index:
	movem 2,1(1)
	popj 17,

load_tail_usint_one_const:
	move 1,1(1)
	popj 17,

load_tail_usint_one_index:
	move 1,1(1)
	popj 17,

addr_tail_usint_one_const:
	addi 1,1
	popj 17,

addr_tail_usint_one_index:
	addi 1,1
	popj 17,

diff_tail_usint_one:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,addr_tail_usint_one_index
	move 10,1
	move 1,11
	pushj 17,addr_tail_usint_one_const
	sub 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

use_tail_usint_one:
	push 17,10
	move 10,1
	movei 1,g_tail_usint_one
	move 2,10
	pushj 17,store_tail_usint_one_const
	addi 10,1
	movei 1,g_tail_usint_one
	move 2,10
	pushj 17,store_tail_usint_one_index
	movei 1,g_tail_usint_one
	pushj 17,load_tail_usint_one_index
	move 10,1
	movei 1,g_tail_usint_one
	pushj 17,addr_tail_usint_one_const
	movem 10,(1)
	movei 1,g_tail_usint_one
	pushj 17,load_tail_usint_one_const
	move 10,1
	movei 1,g_tail_usint_one
	pushj 17,addr_tail_usint_one_index
	movem 10,(1)
	movei 1,g_tail_usint_one
	pushj 17,load_tail_usint_one_const
	move 10,1
	movei 1,g_tail_usint_one
	pushj 17,load_tail_usint_one_index
	add 10,1
	movei 1,g_tail_usint_one
	pushj 17,diff_tail_usint_one
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

store_tail_dint_one_const:
	movem 2,2(1)
	movem 3,3(1)
	popj 17,

store_tail_dint_one_index:
	movem 2,2(1)
	movem 3,3(1)
	popj 17,

load_tail_dint_one_const:
	move 4,2(1)
	move 5,3(1)
	move 1,4
	move 2,5
	popj 17,

load_tail_dint_one_index:
	move 4,2(1)
	move 5,3(1)
	move 1,4
	move 2,5
	popj 17,

addr_tail_dint_one_const:
	addi 1,2
	popj 17,

addr_tail_dint_one_index:
	addi 1,2
	popj 17,

diff_tail_dint_one:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,addr_tail_dint_one_index
	move 10,1
	move 1,11
	pushj 17,addr_tail_dint_one_const
	sub 10,1
	ash 10,-1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

use_tail_dint_one:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 10,1
	move 11,2
	movei 1,g_tail_dint_one
	move 2,10
	move 3,11
	pushj 17,store_tail_dint_one_const
	move 3,11
	aos 4,3
	tlc 4,400000
	move 1,11
	tlc 1,400000
	caml 4,1
	tdza 4,4
	movei 4,1
	move 2,10
	add 2,4
	movei 1,g_tail_dint_one
	pushj 17,store_tail_dint_one_index
	movei 1,g_tail_dint_one
	pushj 17,load_tail_dint_one_index
	move 10,1
	move 11,2
	movei 1,g_tail_dint_one
	pushj 17,addr_tail_dint_one_const
	movem 10,(1)
	movem 11,1(1)
	movei 1,g_tail_dint_one
	pushj 17,load_tail_dint_one_const
	move 10,1
	move 11,2
	movei 1,g_tail_dint_one
	pushj 17,addr_tail_dint_one_index
	movem 10,(1)
	movem 11,1(1)
	movei 1,g_tail_dint_one
	pushj 17,load_tail_dint_one_const
	move 12,1
	move 13,2
	movei 1,g_tail_dint_one
	pushj 17,load_tail_dint_one_index
	move 11,13
	add 11,2
	move 4,11
	tlc 4,400000
	move 3,13
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 10,12
	add 10,1
	add 10,4
	movei 1,g_tail_dint_one
	pushj 17,diff_tail_dint_one
	move 5,1
	ash 1,-43
	move 4,1
	move 2,11
	add 2,5
	move 3,2
	tlc 3,400000
	move 6,11
	tlc 6,400000
	caml 3,6
	tdza 3,3
	movei 3,1
	move 1,10
	add 1,4
	add 1,3
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

store_tail_udint_one_const:
	movem 2,2(1)
	movem 3,3(1)
	popj 17,

store_tail_udint_one_index:
	movem 2,2(1)
	movem 3,3(1)
	popj 17,

load_tail_udint_one_const:
	move 4,2(1)
	move 5,3(1)
	move 1,4
	move 2,5
	popj 17,

load_tail_udint_one_index:
	move 4,2(1)
	move 5,3(1)
	move 1,4
	move 2,5
	popj 17,

addr_tail_udint_one_const:
	addi 1,2
	popj 17,

addr_tail_udint_one_index:
	addi 1,2
	popj 17,

diff_tail_udint_one:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,addr_tail_udint_one_index
	move 10,1
	move 1,11
	pushj 17,addr_tail_udint_one_const
	sub 10,1
	ash 10,-1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

use_tail_udint_one:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 10,1
	move 11,2
	movei 1,g_tail_udint_one
	move 2,10
	move 3,11
	pushj 17,store_tail_udint_one_const
	move 3,11
	aos 4,3
	tlc 4,400000
	move 1,11
	tlc 1,400000
	caml 4,1
	tdza 4,4
	movei 4,1
	move 2,10
	add 2,4
	movei 1,g_tail_udint_one
	pushj 17,store_tail_udint_one_index
	movei 1,g_tail_udint_one
	pushj 17,load_tail_udint_one_index
	move 10,1
	move 11,2
	movei 1,g_tail_udint_one
	pushj 17,addr_tail_udint_one_const
	movem 10,(1)
	movem 11,1(1)
	movei 1,g_tail_udint_one
	pushj 17,load_tail_udint_one_const
	move 10,1
	move 11,2
	movei 1,g_tail_udint_one
	pushj 17,addr_tail_udint_one_index
	movem 10,(1)
	movem 11,1(1)
	movei 1,g_tail_udint_one
	pushj 17,load_tail_udint_one_const
	move 12,1
	move 13,2
	movei 1,g_tail_udint_one
	pushj 17,load_tail_udint_one_index
	move 11,13
	add 11,2
	move 4,11
	tlc 4,400000
	move 3,13
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 10,12
	add 10,1
	add 10,4
	movei 1,g_tail_udint_one
	pushj 17,diff_tail_udint_one
	move 5,1
	ash 1,-43
	move 4,1
	move 2,11
	add 2,5
	move 3,2
	tlc 3,400000
	move 6,11
	tlc 6,400000
	caml 3,6
	tdza 3,3
	movei 3,1
	move 1,10
	add 1,4
	add 1,3
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

store_tail_int_two_dyn:
	andi 2,1
	add 1,2
	movem 3,1(1)
	popj 17,

load_tail_int_two_dyn:
	andi 2,1
	add 1,2
	move 1,1(1)
	popj 17,

addr_tail_int_two_dyn:
	addi 1,1
	andi 2,1
	add 1,2
	popj 17,

diff_tail_int_two_dyn:
	push 17,10
	move 10,1
	pushj 17,addr_tail_int_two_dyn
	sub 1,10
	ash 1,2	; ashlsi3_pointer
	subi 1,1
	ash 1,-2
	pop 17,10
	popj 17,

use_tail_int_two:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 11,2
	movei 1,g_tail_int_two
	move 3,10
	pushj 17,store_tail_int_two_dyn
	move 12,11
	addi 12,1
	movei 1,g_tail_int_two
	move 2,12
	pushj 17,addr_tail_int_two_dyn
	addi 10,1
	movem 10,(1)
	movei 1,g_tail_int_two
	move 2,11
	pushj 17,load_tail_int_two_dyn
	move 10,1
	movei 1,g_tail_int_two
	move 2,12
	pushj 17,load_tail_int_two_dyn
	add 10,1
	movei 1,g_tail_int_two
	move 2,11
	pushj 17,diff_tail_int_two_dyn
	add 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

store_tail_qint_two_dyn:
	andi 3,777	; zero_extendqisi2
	andi 2,1
	move 4,2
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 2,%L1012
%L1011:
	ibp 1
	sojn 2,%L1011	; decrement_and_branch_until_zero
%L1012:
	dpb 3,1
	popj 17,

load_tail_qint_two_dyn:
	andi 2,1
	move 4,2
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 2,%L1015
%L1014:
	ibp 1
	sojn 2,%L1014	; decrement_and_branch_until_zero
%L1015:
	move 1,(1)
	ash 1,-33
	popj 17,

addr_tail_qint_two_dyn:
	andi 2,1
	move 4,2
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 2,%L1019
%L1018:
	ibp 1
	sojn 2,%L1018	; decrement_and_branch_until_zero
%L1019:
	hrrz 1,1
	tlo 1,2200
	popj 17,

diff_tail_qint_two_dyn:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	pushj 17,addr_tail_qint_two_dyn
	hrrz 12,12
	tlo 12,2200
	move 10,1
	sub 10,12
	muli 10,10
	move 1,11
	ash 1,-1
	add 1,%BADL9(10)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

use_tail_qint_two:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 11,2
	andi 10,777	; zero_extendqisi2
	move 3,10
	lsh 3,33
	ash 3,-33
	move 1,[POINT 9,g_tail_qint_two,8]
	pushj 17,store_tail_qint_two_dyn
	move 12,11
	addi 12,1
	move 1,[POINT 9,g_tail_qint_two,8]
	move 2,12
	pushj 17,addr_tail_qint_two_dyn
	addi 10,1
	dpb 10,1
	move 1,[POINT 9,g_tail_qint_two,8]
	move 2,11
	pushj 17,load_tail_qint_two_dyn
	move 10,1
	move 1,[POINT 9,g_tail_qint_two,8]
	move 2,12
	pushj 17,load_tail_qint_two_dyn
	add 10,1
	move 1,[POINT 9,g_tail_qint_two,8]
	move 2,11
	pushj 17,diff_tail_qint_two_dyn
	add 10,1
	lsh 10,33
	ash 10,-33
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

store_tail_hint_two_dyn:
	hrrzi 3,(3)	; zero_extendhisi2
	andi 2,1
	move 4,2
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 2,%L1038
%L1037:
	ibp 1
	sojn 2,%L1037	; decrement_and_branch_until_zero
%L1038:
	dpb 3,1	; movhi
	popj 17,

load_tail_hint_two_dyn:
	andi 2,1
	move 4,2
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 2,%L1041
%L1040:
	ibp 1
	sojn 2,%L1040	; decrement_and_branch_until_zero
%L1041:
	ldb 1,1
	hrre 1,1
	popj 17,

addr_tail_hint_two_dyn:
	andi 2,1
	move 4,2
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 2,%L1045
%L1044:
	ibp 1
	sojn 2,%L1044	; decrement_and_branch_until_zero
%L1045:
	hrrz 1,1
	tlo 1,2200
	popj 17,

diff_tail_hint_two_dyn:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	pushj 17,addr_tail_hint_two_dyn
	hrrz 12,12
	tlo 12,2200
	move 10,1
	sub 10,12
	muli 10,4
	move 1,11
	ash 1,-1
	add 1,%BADLH(10)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

use_tail_hint_two:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 11,2
	hrrzi 10,(10)	; zero_extendhisi2
	hrre 3,10	; extendhisi2
	move 1,[POINT 18,g_tail_hint_two,17]
	pushj 17,store_tail_hint_two_dyn
	move 12,11
	addi 12,1
	move 1,[POINT 18,g_tail_hint_two,17]
	move 2,12
	pushj 17,addr_tail_hint_two_dyn
	addi 10,1
	dpb 10,1	; movhi
	move 1,[POINT 18,g_tail_hint_two,17]
	move 2,11
	pushj 17,load_tail_hint_two_dyn
	move 10,1
	move 1,[POINT 18,g_tail_hint_two,17]
	move 2,12
	pushj 17,load_tail_hint_two_dyn
	add 10,1
	move 1,[POINT 18,g_tail_hint_two,17]
	move 2,11
	pushj 17,diff_tail_hint_two_dyn
	add 10,1
	hrre 10,10	; extendhisi2
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

store_tail_char8_two_dyn:
	lsh 3,34
	ash 3,-34
	andi 2,1
	move 4,2
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 2,%L1064
%L1063:
	ibp 1
	sojn 2,%L1063	; decrement_and_branch_until_zero
%L1064:
	dpb 3,1
	popj 17,

load_tail_char8_two_dyn:
	andi 2,1
	move 4,2
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 2,%L1067
%L1066:
	ibp 1
	sojn 2,%L1066	; decrement_and_branch_until_zero
%L1067:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

addr_tail_char8_two_dyn:
	andi 2,1
	move 4,2
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 2,%L1071
%L1070:
	ibp 1
	sojn 2,%L1070	; decrement_and_branch_until_zero
%L1071:
	hrrz 1,1
	tlo 1,2200
	popj 17,

diff_tail_char8_two_dyn:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	pushj 17,addr_tail_char8_two_dyn
	movei 4,(17)
	tlo 4,2200
	move 10,1
	sub 10,4
	muli 10,10
	move 1,11
	ash 1,-1
	add 1,%BADL8(10)
	move 10,-2(17)
	move 11,-1(17)
	add 17,[-3,,-3]
	popj 17,

use_tail_char8_two:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 11,2
	lsh 10,34
	ash 10,-34
	move 3,10
	lsh 3,34
	ash 3,-34
	move 1,[POINT 8,g_tail_char8_two,7]
	pushj 17,store_tail_char8_two_dyn
	move 12,11
	addi 12,1
	move 1,[POINT 8,g_tail_char8_two,7]
	move 2,12
	pushj 17,addr_tail_char8_two_dyn
	addi 10,1
	dpb 10,1
	move 1,[POINT 8,g_tail_char8_two,7]
	move 2,11
	pushj 17,load_tail_char8_two_dyn
	move 10,1
	move 1,[POINT 8,g_tail_char8_two,7]
	move 2,12
	pushj 17,load_tail_char8_two_dyn
	add 10,1
	move 1,[POINT 8,g_tail_char8_two,7]
	move 2,11
	pushj 17,diff_tail_char8_two_dyn
	add 10,1
	lsh 10,34
	ash 10,-34
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

store_tail_char9_two_dyn:
	andi 3,777	; zero_extendqisi2
	andi 2,1
	move 4,2
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 2,%L1090
%L1089:
	ibp 1
	sojn 2,%L1089	; decrement_and_branch_until_zero
%L1090:
	dpb 3,1
	popj 17,

load_tail_char9_two_dyn:
	andi 2,1
	move 4,2
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 2,%L1093
%L1092:
	ibp 1
	sojn 2,%L1092	; decrement_and_branch_until_zero
%L1093:
	move 1,(1)
	ash 1,-33
	popj 17,

addr_tail_char9_two_dyn:
	andi 2,1
	move 4,2
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 2,%L1097
%L1096:
	ibp 1
	sojn 2,%L1096	; decrement_and_branch_until_zero
%L1097:
	hrrz 1,1
	tlo 1,2200
	popj 17,

diff_tail_char9_two_dyn:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	pushj 17,addr_tail_char9_two_dyn
	hrrz 12,12
	tlo 12,2200
	move 10,1
	sub 10,12
	muli 10,10
	move 1,11
	ash 1,-1
	add 1,%BADL9(10)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

use_tail_char9_two:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 11,2
	andi 10,777	; zero_extendqisi2
	move 3,10
	lsh 3,33
	ash 3,-33
	move 1,[POINT 9,g_tail_char9_two,8]
	pushj 17,store_tail_char9_two_dyn
	move 12,11
	addi 12,1
	move 1,[POINT 9,g_tail_char9_two,8]
	move 2,12
	pushj 17,addr_tail_char9_two_dyn
	addi 10,1
	dpb 10,1
	move 1,[POINT 9,g_tail_char9_two,8]
	move 2,11
	pushj 17,load_tail_char9_two_dyn
	move 10,1
	move 1,[POINT 9,g_tail_char9_two,8]
	move 2,12
	pushj 17,load_tail_char9_two_dyn
	add 10,1
	move 1,[POINT 9,g_tail_char9_two,8]
	move 2,11
	pushj 17,diff_tail_char9_two_dyn
	add 10,1
	lsh 10,33
	ash 10,-33
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

store_tail_short18_two_dyn:
	hrrzi 3,(3)	; zero_extendhisi2
	andi 2,1
	move 4,2
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 2,%L1116
%L1115:
	ibp 1
	sojn 2,%L1115	; decrement_and_branch_until_zero
%L1116:
	dpb 3,1	; movhi
	popj 17,

load_tail_short18_two_dyn:
	andi 2,1
	move 4,2
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 2,%L1119
%L1118:
	ibp 1
	sojn 2,%L1118	; decrement_and_branch_until_zero
%L1119:
	ldb 1,1
	hrre 1,1
	popj 17,

addr_tail_short18_two_dyn:
	andi 2,1
	move 4,2
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 2,%L1123
%L1122:
	ibp 1
	sojn 2,%L1122	; decrement_and_branch_until_zero
%L1123:
	hrrz 1,1
	tlo 1,2200
	popj 17,

diff_tail_short18_two_dyn:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	pushj 17,addr_tail_short18_two_dyn
	hrrz 12,12
	tlo 12,2200
	move 10,1
	sub 10,12
	muli 10,4
	move 1,11
	ash 1,-1
	add 1,%BADLH(10)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

use_tail_short18_two:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 11,2
	hrrzi 10,(10)	; zero_extendhisi2
	hrre 3,10	; extendhisi2
	move 1,[POINT 18,g_tail_short18_two,17]
	pushj 17,store_tail_short18_two_dyn
	move 12,11
	addi 12,1
	move 1,[POINT 18,g_tail_short18_two,17]
	move 2,12
	pushj 17,addr_tail_short18_two_dyn
	addi 10,1
	dpb 10,1	; movhi
	move 1,[POINT 18,g_tail_short18_two,17]
	move 2,11
	pushj 17,load_tail_short18_two_dyn
	move 10,1
	move 1,[POINT 18,g_tail_short18_two,17]
	move 2,12
	pushj 17,load_tail_short18_two_dyn
	add 10,1
	move 1,[POINT 18,g_tail_short18_two,17]
	move 2,11
	pushj 17,diff_tail_short18_two_dyn
	add 10,1
	hrre 10,10	; extendhisi2
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

store_tail_sint_two_dyn:
	andi 2,1
	add 1,2
	movem 3,1(1)
	popj 17,

load_tail_sint_two_dyn:
	andi 2,1
	add 1,2
	move 1,1(1)
	popj 17,

addr_tail_sint_two_dyn:
	addi 1,1
	andi 2,1
	add 1,2
	popj 17,

diff_tail_sint_two_dyn:
	push 17,10
	move 10,1
	pushj 17,addr_tail_sint_two_dyn
	sub 1,10
	ash 1,2	; ashlsi3_pointer
	subi 1,1
	ash 1,-2
	pop 17,10
	popj 17,

use_tail_sint_two:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 11,2
	movei 1,g_tail_sint_two
	move 3,10
	pushj 17,store_tail_sint_two_dyn
	move 12,11
	addi 12,1
	movei 1,g_tail_sint_two
	move 2,12
	pushj 17,addr_tail_sint_two_dyn
	addi 10,1
	movem 10,(1)
	movei 1,g_tail_sint_two
	move 2,11
	pushj 17,load_tail_sint_two_dyn
	move 10,1
	movei 1,g_tail_sint_two
	move 2,12
	pushj 17,load_tail_sint_two_dyn
	add 10,1
	movei 1,g_tail_sint_two
	move 2,11
	pushj 17,diff_tail_sint_two_dyn
	add 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

store_tail_dint_two_dyn:
	andi 2,1
	lsh 2,1
	add 2,1
	movem 3,2(2)
	movem 4,3(2)
	popj 17,

load_tail_dint_two_dyn:
	andi 2,1
	lsh 2,1
	add 2,1
	move 4,2(2)
	move 5,3(2)
	move 1,4
	move 2,5
	popj 17,

addr_tail_dint_two_dyn:
	addi 1,2
	andi 2,1
	lsh 2,1
	add 1,2
	popj 17,

diff_tail_dint_two_dyn:
	push 17,10
	move 10,1
	pushj 17,addr_tail_dint_two_dyn
	sub 1,10
	ash 1,2	; ashlsi3_pointer
	subi 1,2
	ash 1,-3
	pop 17,10
	popj 17,

use_tail_dint_two:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 10,1
	move 11,2
	move 14,3
	movei 1,g_tail_dint_two
	move 2,3
	move 3,10
	move 4,11
	pushj 17,store_tail_dint_two_dyn
	move 15,14
	addi 15,1
	movei 1,g_tail_dint_two
	move 2,15
	pushj 17,addr_tail_dint_two_dyn
	move 5,11
	aos 3,5
	tlc 3,400000
	move 2,11
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	add 3,10
	movem 3,(1)
	movem 5,1(1)
	movei 1,g_tail_dint_two
	move 2,14
	pushj 17,load_tail_dint_two_dyn
	move 12,1
	move 13,2
	movei 1,g_tail_dint_two
	move 2,15
	pushj 17,load_tail_dint_two_dyn
	move 11,13
	add 11,2
	move 4,11
	tlc 4,400000
	move 3,13
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 10,12
	add 10,1
	add 10,4
	movei 1,g_tail_dint_two
	move 2,14
	pushj 17,diff_tail_dint_two_dyn
	move 5,1
	ash 1,-43
	move 4,1
	move 2,11
	add 2,5
	move 3,2
	tlc 3,400000
	move 6,11
	tlc 6,400000
	caml 3,6
	tdza 3,3
	movei 3,1
	move 1,10
	add 1,4
	add 1,3
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

store_nested_const:
	movem 2,2(1)
	popj 17,

store_nested_index:
	movem 2,2(1)
	popj 17,

load_nested_mix:
	move 4,1
	move 1,2(1)
	lsh 1,1
	add 1,3(4)
	popj 17,

store_packed_const:
	lsh 2,34
	ash 2,-34
	dpb 2,[POINT 8,(1),16]
	popj 17,

store_packed_index:
	lsh 2,34
	ash 2,-34
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	dpb 2,4
	popj 17,

load_packed_mix:
	move 3,1
	move 1,(1)
	lsh 1,11
	ash 1,-34
	movei 4,0
	ash 4,-2	; ashrsi3_pointer
	add 4,3
	ldb 4,4
	add 1,4
	lsh 1,34
	ash 1,-34
	popj 17,

volatile_struct_offset:
	andi 1,1
	movem 2,gv_scalar_two+1(1)
	move 1,gv_scalar_two+1
	move 4,gv_scalar_two+2
	add 1,4
	popj 17,

stack_struct_offset:
	add 17,[6,,6]
	movem 1,-1(17)
	movei 3,-1(17)
	move 6,1
	addi 6,1
	movem 6,1(3)
	addi 1,2
	movem 1,-5(17)
	move 6,1(3)
	movem 6,-4(17)
	move 4,6
	add 4,(3)
	movem 4,-3(17)
	move 2,4
	addi 2,1
	movem 2,-2(17)
	move 1,1(3)
	add 1,-4(17)
	add 1,4
	add 1,2
	add 17,[-6,,-6]
	popj 17,

	.globl	use_struct_offset_bug
use_struct_offset_bug:
	add 17,[16,,16]
	movem 16,-15(17)
	movei 0,-14(17)
	hrli 0,10
	blt 0,-7(17)
	move 12,1
	movei 1,g_scalar_one
	pushj 17,f1
	movei 1,g_scalar_one
	pushj 17,f2
	movem 12,g_scalar_one+1
	movei 1,g_scalar_two
	move 2,12
	pushj 17,f7
	move 4,12
	ash 4,-43
	move 14,12
	move 13,4
	move 1,13
	move 2,14
	pushj 17,use_tail_dint_one
	movem 1,-6(17)
	movem 2,-5(17)
	move 1,13
	move 2,14
	pushj 17,use_tail_udint_one
	movem 1,-4(17)
	movem 2,-3(17)
	movei 1,g_nested
	move 2,12
	pushj 17,store_nested_const
	move 10,12
	addi 10,1
	movei 1,g_nested
	move 2,10
	pushj 17,store_nested_index
	move 11,12
	move 6,12
	lsh 6,34
	ash 6,-34
	movem 6,-2(17)
	move 1,[POINT 18,g_packed,17]
	move 2,6
	pushj 17,store_packed_const
	lsh 10,34
	ash 10,-34
	move 1,[POINT 18,g_packed,17]
	move 2,10
	pushj 17,store_packed_index
	movei 1,g_scalar_one
	pushj 17,f3
	move 10,1
	movei 1,g_scalar_one
	pushj 17,f4
	add 10,1
	movei 1,g_scalar_one
	pushj 17,f5
	add 10,(1)
	movei 1,g_scalar_one
	pushj 17,f6
	add 10,(1)
	movei 1,g_scalar_two
	move 2,12
	pushj 17,f8
	add 10,1
	move 1,12
	pushj 17,use_tail_int_one
	add 10,1
	move 1,12
	pushj 17,use_tail_uint_one
	add 10,1
	move 15,12
	andi 15,777	; zero_extendqisi2
	move 1,15
	pushj 17,use_tail_char_one
	add 10,1
	move 1,15
	pushj 17,use_tail_uchar_one
	add 10,1
	move 6,12
	lsh 6,33
	ash 6,-33
	movem 6,-1(17)
	move 1,6
	pushj 17,use_tail_qint_one
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,15
	pushj 17,use_tail_uqint_one
	add 10,1
	hrre 16,12	; extendhisi2
	move 1,16
	pushj 17,use_tail_hint_one
	hrre 1,1	; extendhisi2
	add 10,1
	move 6,12
	hrrzi 6,(6)	; zero_extendhisi2
	movem 6,(17)
	move 1,6
	pushj 17,use_tail_uhint_one
	add 10,1
	move 1,12
	lsh 1,36
	ash 1,-36
	pushj 17,use_tail_char6_one
	lsh 1,36
	ash 1,-36
	add 10,1
	move 1,12
	andi 1,77
	pushj 17,use_tail_uchar6_one
	andi 1,77
	add 10,1
	move 1,12
	lsh 1,35
	ash 1,-35
	pushj 17,use_tail_char7_one
	lsh 1,35
	ash 1,-35
	add 10,1
	move 1,12
	andi 1,177
	pushj 17,use_tail_uchar7_one
	andi 1,177
	add 10,1
	move 1,-2(17)
	pushj 17,use_tail_char8_one
	lsh 1,34
	ash 1,-34
	add 10,1
	andi 11,377
	move 1,11
	pushj 17,use_tail_uchar8_one
	andi 1,377
	add 10,1
	move 1,-1(17)
	pushj 17,use_tail_char9_one
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,15
	pushj 17,use_tail_uchar9_one
	add 10,1
	move 11,12
	move 1,12
	lsh 1,24
	ash 1,-24
	pushj 17,use_tail_short16_one
	lsh 1,24
	ash 1,-24
	add 10,1
	andi 11,177777
	move 1,11
	pushj 17,use_tail_ushort16_one
	andi 1,177777
	add 10,1
	move 1,16
	pushj 17,use_tail_short18_one
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,(17)
	pushj 17,use_tail_ushort18_one
	add 10,1
	move 1,12
	pushj 17,use_tail_int32_one
	add 10,1
	move 1,12
	pushj 17,use_tail_uint32_one
	add 10,1
	move 1,12
	pushj 17,use_tail_sint_one
	add 10,1
	move 1,12
	pushj 17,use_tail_usint_one
	add 10,1
	move 6,-5(17)
	add 10,6
	move 6,-3(17)
	add 10,6
	move 1,12
	move 2,12
	pushj 17,use_tail_int_two
	add 10,1
	move 1,-1(17)
	move 2,12
	pushj 17,use_tail_qint_two
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,16
	move 2,12
	pushj 17,use_tail_hint_two
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,-2(17)
	move 2,12
	pushj 17,use_tail_char8_two
	lsh 1,34
	ash 1,-34
	add 10,1
	move 1,-1(17)
	move 2,12
	pushj 17,use_tail_char9_two
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,16
	move 2,12
	pushj 17,use_tail_short18_two
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,12
	move 2,12
	pushj 17,use_tail_sint_two
	add 10,1
	move 1,13
	move 2,14
	move 3,12
	pushj 17,use_tail_dint_two
	add 10,2
	movei 1,g_nested
	pushj 17,load_nested_mix
	add 10,1
	move 1,[POINT 18,g_packed,17]
	pushj 17,load_packed_mix
	lsh 1,34
	ash 1,-34
	add 10,1
	move 2,12
	addi 2,3
	move 1,12
	pushj 17,volatile_struct_offset
	add 10,1
	move 1,12
	pushj 17,stack_struct_offset
	add 10,1
	move 1,10
	move 16,-15(17)
	movei 0,10
	hrli 0,-14(17)
	blt 0,15
	add 17,[-16,,-16]
	popj 17,

	.bss
g_scalar_one:
	.space	8
g_scalar_two:
	.space	16
g_tail_int_one:
	.space	8
g_tail_uint_one:
	.space	8
g_tail_char_one:
	.space	4
g_tail_uchar_one:
	.space	4
g_tail_qint_one:
	.space	4
g_tail_uqint_one:
	.space	4
g_tail_hint_one:
	.space	4
g_tail_uhint_one:
	.space	4
g_tail_char6_one:
	.space	4
g_tail_uchar6_one:
	.space	4
g_tail_char7_one:
	.space	4
g_tail_uchar7_one:
	.space	4
g_tail_char8_one:
	.space	4
g_tail_uchar8_one:
	.space	4
g_tail_char9_one:
	.space	4
g_tail_uchar9_one:
	.space	4
g_tail_short16_one:
	.space	4
g_tail_ushort16_one:
	.space	4
g_tail_short18_one:
	.space	4
g_tail_ushort18_one:
	.space	4
g_tail_int32_one:
	.space	8
g_tail_uint32_one:
	.space	8
g_tail_sint_one:
	.space	8
g_tail_usint_one:
	.space	8
g_tail_dint_one:
	.space	16
g_tail_udint_one:
	.space	16
g_tail_int_two:
	.space	16
g_tail_qint_two:
	.space	4
g_tail_hint_two:
	.space	8
g_tail_char8_two:
	.space	8
g_tail_char9_two:
	.space	4
g_tail_short18_two:
	.space	8
g_tail_sint_two:
	.space	16
g_tail_dint_two:
	.space	32
g_nested:
	.space	16
g_packed:
	.space	4
gv_scalar_two:
	.space	16
