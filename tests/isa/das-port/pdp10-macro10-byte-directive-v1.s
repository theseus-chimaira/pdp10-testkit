; Genuine MACRO-10 KL10 machine directive and parenthesized byte sizes.
; Both 9-bit values must occupy one PDP-10 36-bit data word.
	.DIRECTIVE KL10
	.TEXT
	ENTRY main
main:
	MOVEI 1,0
	POPJ 17,
	.DATA
bytes_v1:
	BYTE (9)0,(9)1
