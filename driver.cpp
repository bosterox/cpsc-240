#include <cstdio>

extern "C" char* my_asm_program();

int main()
{
    // printf("Running ASM program...\n");
    char* string_returned = my_asm_program();
    
    printf("\nValue returned: %s\n", &string_returned);
    // printf("\nString returned: %s\n", string_returned);

    return 0;
}