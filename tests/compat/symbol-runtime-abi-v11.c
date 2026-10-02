typedef long long int71_t;

extern int abi_external_lower_v11(int);
extern int AbiExternalMixedV11(int);
extern int _abi_external_lead_v11(int);
extern int abi_external_symbol_name_longer_than_31_v11(int);

int abi_public_lower_v11(int x)
{
    return x + 1;
}

int AbiPublicMixedV11(int x)
{
    return x + 2;
}

int _abi_public_lead_v11(int x)
{
    return x + 3;
}

int abi_public_symbol_name_longer_than_31_v11(int x)
{
    return x + 4;
}

int abi_call_symbols_v11(int x)
{
    return abi_external_lower_v11(x)
        + AbiExternalMixedV11(x)
        + _abi_external_lead_v11(x)
        + abi_external_symbol_name_longer_than_31_v11(x);
}

int71_t abi_div_int71_v11(int71_t a, int71_t b)
{
    return a / b;
}

int71_t abi_mod_int71_v11(int71_t a, int71_t b)
{
    return a % b;
}
