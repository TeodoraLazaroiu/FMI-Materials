/*
Rescrieti programul Hello World de data trecuta
folosind numai functii sistem
*/

#include <stdio.h>
#include <unistd.h>

// programul va fi compilat astfel: gcc lab2ex1.c -o lab2ex1
// programul va fi apelat astfel: ./lab2ex1

int main ()
{
    write(1, "Hello, World!\n", 15);
    return 0;
}