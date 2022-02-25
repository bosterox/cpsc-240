#include <cstdio>

// change type as needed for assignment
extern "C" int my_asm_program();

int main()
{
    printf("--------- START ASSEMBLY ---------\n");
    int string_returned = my_asm_program();
    printf("---------- END ASSEMBLY ----------\n");
    
    // change format-specifier as needed for assignment
    printf("\nValue returned: %d\n", &string_returned);

    return 0;
}