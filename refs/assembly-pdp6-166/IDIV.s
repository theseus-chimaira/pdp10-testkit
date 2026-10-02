
idivm1:
	idivm 2,1
	popj 17,

idivm2:
	idivm 1,(2)
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

