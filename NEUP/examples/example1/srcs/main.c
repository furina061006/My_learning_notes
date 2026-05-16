#include <stdio.h>
#include "a.h"

int main(void) {
    char expression[6];
    printf("补全颜文字：______~(∠・ω< )⌒☆\n");
    scanf("%s",expression);
    if (strcmp(expression,answer) == 0) {
        char *target = NULL;
        SendPassword(&target);
        printf("YEAH,bro!\n%s!",target);
    } else {
        printf("what's a pity!\nyour answer is fault.");
    }
    return 0;
}
