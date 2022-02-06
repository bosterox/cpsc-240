#include <cstdio>

extern "C" int my_asm_program();

int main()
{
    int ret = my_asm_program();
    return ret;
}