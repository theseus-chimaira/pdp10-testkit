/* Width must fit the declared type, and wide fields remain unsupported. */
struct invalid {
    unsigned short a:19;
    unsigned char b:10;
    _Bool c:2;
    float d:3;
    unsigned long long e:40;
};
