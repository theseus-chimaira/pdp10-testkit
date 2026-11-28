/* Width must fit the declared type, including the 71-bit arithmetic limit. */
struct invalid {
    unsigned short a:19;
    unsigned char b:10;
    _Bool c:2;
    float d:3;
    unsigned long long e:72;
};
