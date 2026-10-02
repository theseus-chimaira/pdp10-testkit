
idivm1:
	setzb 4,5
	move 4,2
	idiv 4,1
	move 1,4
	popj 17,

idivm2:
	setzb 4,5
	move 4,1
	idiv 4,(2)
	movem 4,(2)
	popj 17,

idiv3:
	setzb 4,5
	move 4,1
	idiv 4,3
	move 1,5
	popj 17,

idiv4:
	setzb 4,5
	move 4,1
	idiv 4,(3)
	move 1,5
	popj 17,

