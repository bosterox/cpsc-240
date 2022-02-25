#include <cstdio>

extern "C" double my_asm_program();

int main()
{
    printf("--------- START ASSEMBLY ---------\n");
    double string_returned = my_asm_program();
    printf("---------- END ASSEMBLY ----------\n");
    
    printf("\nValue returned: %lf\n", string_returned);
    // printf("\nString returned: %s\n", string_returned);

    return 0;
}