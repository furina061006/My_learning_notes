#include <stdio.h>
// 举例若有不妥，望多见谅
#define PRINT_VAR1(x) printf(#x "：%s\n",x);
#define PRINT_VAR2(x) printf(#x "：%s\n",x);
#define PRINT_VAR3(x) printf(x "..你们懂吧？\n");
#define PRINT_VAR(x,y) PRINT_VAR##x(y)

char *Others_holiday = "学算法，搞嵌入式";
char *My_holiday = "打游戏，出门旅游";

int main(void) {
    PRINT_VAR(1,Others_holiday);
    PRINT_VAR(2,My_holiday);
    PRINT_VAR(3,"就很");
    return 0;
}