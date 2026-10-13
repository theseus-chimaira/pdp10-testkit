/* Migrated original KCC instruction assertions. */
/* codegen-require-regex: "(?ims)^div2:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:ash\\s+[0-7]+,-1)" "(?ims)^div8:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:ash\\s+[0-7]+,-3)" "(?ims)^mod8:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:sub\\s+[0-7]+,0?16)" "(?ims)^div3:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:\\bIDIV\\b|%SIDN)" */
/* codegen-forbid-regex: "(?ims)^div1:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:\\bIDIV\\b|%SIDN|%UIDN)" "(?ims)^mod1:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:\\bIDIV\\b|%SIDN|%UIDN)" "(?ims)^div2:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:\\bIDIV\\b|%SIDN|%UIDN)" "(?ims)^div8:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:\\bIDIV\\b|%SIDN|%UIDN)" "(?ims)^mod8:\\s*\\n(?:(?!^[A-Za-z_][A-Za-z0-9_]*:).)*?(?:\\bIDIV\\b|%SIDN|%UIDN)" */
int div1(int x) { return x / 1; }
int mod1(int x) { return x % 1; }
int div2(int x) { return x / 2; }
int div8(int x) { return x / 8; }
int mod8(int x) { return x % 8; }
int div3(int x) { return x / 3; }
