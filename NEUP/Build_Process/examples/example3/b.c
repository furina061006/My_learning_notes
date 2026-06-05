#include <stdio.h>

struct Test {
    int y;
};

struct Test2 {
    int x;
};

struct Test abc;
struct Test2 efg;

void Print(void) {
    printf("%lf\n",abc.y); 
    printf("%d\n",sizeof(abc.y));
}