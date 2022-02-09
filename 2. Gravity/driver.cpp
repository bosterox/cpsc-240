#include <cstdio>

extern "C" int my_asm_program();

int main()
{
    // printf("Running ASM program...\n");
    int string_returned = my_asm_program();
    
    printf("\nValue returned: %d\n", &string_returned);
    // printf("\nString returned: %s\n", string_returned);

    return 0;
}