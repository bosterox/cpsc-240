#include <cstdio>
#include <ctime>
#include <iostream>
#include <format>

using namespace std;

// change type as needed for assignment
extern "C" double my_asm_program();

int main()
{
    time_t ttime = time(0);
    tm* localTimeStruct = localtime(&ttime);

    string timeStr = "";
    cout << curTime << endl;

    printf("--------- START ASSEMBLY ---------\n");
    double string_returned = my_asm_program();
    printf("---------- END ASSEMBLY ----------\n");
    
    // change format-specifier as needed for assignment
    printf("\nValue returned: %d\n", &string_returned);

    return 0;
}