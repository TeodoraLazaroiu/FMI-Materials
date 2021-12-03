/*
Implementati un program care foloseste fork(2) si testeaza
ipoteza Collatz generand secventa unui numar dat ın procesul copil
*/

#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
    if (argc < 2)
    {
        printf("Error: Not enough arguments\n");
        return 0;
    }

    int n = atoi(argv[1]);

    pid_t pid = fork();

    if (pid  <0)
        return errno;
    else if (pid != 0 && n > 1)
    {
        n = (n % 2) ? (3*n + 1) : (n/2);
        char strn[10];
        sprintf(strn, "%d", n); 
        char *argv2[] = {"collatz", strn};
        execve("C:/Users/Teodora/Documents/GitHub/FMI-Materials/Sisteme de Operare/Laborator 4/lab4ex2.c", argv2 , NULL);
    }
    else if(pid == 0)
    {
        wait(NULL);
        printf("%d ", n);
        if(n==1)
            printf("\nChild %d finished\n", getpid());
    }
    return 0;
}