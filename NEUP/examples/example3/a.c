#include <stdio.h>

struct Test {
    double x;
};

void Print(void);
extern struct Test abc;
extern struct Test2 efg;
int main(void) {
    abc.x = 1;
    printf("%lf\n",abc.x); 
    printf("%d\n",sizeof(abc.x));
    Print();

    // efg.x = 1;
    // printf("%d\n",efg.x); 

    return 0;
}