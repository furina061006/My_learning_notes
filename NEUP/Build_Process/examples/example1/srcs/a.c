#include <stdlib.h>
#include <stdio.h>
#include "a.h" 

static char password[] = "0d000721";
const char* answer = "Ciallo";

struct example{
    char b;
    int a;
}example1;

void SendPassword(char **ptarget) {
    example1.a = 1;
    int length = strlen(password);
    *ptarget = (char *)malloc((length + 1) * sizeof(char));
    int i = 0;
    for (; password[i] != '\0'; i++) {
        (*ptarget)[i] = password[i];
    }
    (*ptarget)[i] = '\0';
}  