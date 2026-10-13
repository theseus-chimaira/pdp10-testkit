volatile int __test_exit;

struct holder {
    char *p;
};

static char storage[4];
static struct holder global_holder;

static char *char_pointer(int i)
{
    return &storage[i];
}

static void *void_pointer(int i)
{
    return &storage[i];
}

int main(void)
{
    static struct holder static_holder;

    storage[0] = 'A';
    storage[1] = 'B';
    storage[2] = 'C';
    storage[3] = 0;

    global_holder.p = char_pointer(1);
    if (*global_holder.p != 'B')
        return 1;

    static_holder.p = void_pointer(2);
    if (*static_holder.p != 'C')
        return 2;

    return 0;
}
