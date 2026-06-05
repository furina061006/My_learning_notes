#include <stdio.h>

struct Test {
    double x;
}; 

void Print(void);

extern struct Test abc;
int main(void) {
    abc.x = 1;
    printf("%lf\n",abc.x); 
    printf("%d\n",sizeof(abc.x));
    Print();

    return 0;
}