; Established DAS field syntax, identical semantics to MACRO-10 BYTE.
	.DIRECTIVE KL10
	.TEXT
	ENTRY main
main:
	MOVEI 1,0
	POPJ 17,
	.DATA
bytes_v1:
	BYTE 9,0,1
