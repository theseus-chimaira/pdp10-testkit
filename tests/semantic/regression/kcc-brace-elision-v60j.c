/* Each implicitly initialized subobject consumes only its own elements. */
struct pair { int a, b; };
struct record { int a[2]; struct pair p; int tail; };
static int matrix[2][3] = { 1, 2, 3, 4, 5, 6 };
static int cube[][2][2] = { 1, 2, 3, 4, 5, 6, 7 };
static struct record rec = { 11, 12, 13, 14, 15 };
static struct record designated = { 21, .tail = 25 };
static int sparse[3][2] = { 31, [2] = { 35, 36 } };
static struct { struct pair p; int tail; } partial = { 41, .tail = 43 };
int main(void)
{
    int local[2][2] = { 51, 52, 53 };
    if (matrix[0][2] != 3 || matrix[1][0] != 4 || matrix[1][2] != 6)
        return 1;
    if (sizeof(cube) != 8 * sizeof(int) || cube[1][0][0] != 5
        || cube[1][1][0] != 7 || cube[1][1][1] != 0)
        return 2;
    if (rec.a[0] != 11 || rec.a[1] != 12 || rec.p.a != 13
        || rec.p.b != 14 || rec.tail != 15)
        return 3;
    if (designated.a[0] != 21 || designated.a[1] || designated.p.a
        || designated.p.b || designated.tail != 25)
        return 4;
    if (sparse[0][0] != 31 || sparse[0][1] || sparse[1][0]
        || sparse[1][1] || sparse[2][0] != 35 || sparse[2][1] != 36)
        return 5;
    if (partial.p.a != 41 || partial.p.b || partial.tail != 43)
        return 6;
    if (local[0][0] != 51 || local[0][1] != 52
        || local[1][0] != 53 || local[1][1] != 0)
        return 7;
    return 0;
}
