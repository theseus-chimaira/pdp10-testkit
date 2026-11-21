; A real relocation still requires its defined external symbol.
	.TEXT
	EXTERN %ONE,%BADX6,%BADX7,%BADX8,%BADX9,%BADXH
	ENTRY main
main:
	MOVE 1,%ONE
	POPJ 17,
