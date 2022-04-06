#include <cstdio>

// change type as needed for assignment
extern "C" double roots();
extern "C" double noroots();
extern "C" double oneroot(double fraction, double minusB);

int main()
{
    printf("[This is the midterm solution created by Alexander Tran for CPSC 240-07.]\n");

    double val = roots();
    
    // change format-specifier as needed for assignment
    printf("\nValue returned: %lf\n", val);

    return 0;
}

double noroots()
{
    printf("There are no roots.\n");
    return 0;
}

double oneroot(double fraction, double minusB)
{
    double root = fraction + minusB;
    printf("There is one root: %lf\n", root);
    return root;
}