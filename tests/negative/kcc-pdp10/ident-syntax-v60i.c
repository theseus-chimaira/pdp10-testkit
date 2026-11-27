/* Non-string metadata and trailing tokens must be diagnosed. */
#ident 123
#ident "valid string" garbage
#ident L"wide string"
int ordinary;
