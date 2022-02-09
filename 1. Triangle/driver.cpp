#include <cstdio>

extern "C" double my_asm_program();

int main()
{
    double ret = my_asm_program();
    printf("\nASM returned double value: %lf\n", ret);
    return 0;
}