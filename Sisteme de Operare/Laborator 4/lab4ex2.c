/*
Implementati un program care foloseste fork(2) si testeaza
ipoteza Collatz generand secventa unui numar dat in procesul copil
*/

#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <stdlib.h>

// programul va fi compilat astfel: gcc lab4ex2.c -o lab4ex2
// programul va fi apelat astfel: ./lab4ex2 24

int main(int argc, char **argv)
{
    if (argc < 2)
    {
        printf("Trebuie sa avem exact 2 argumente\n");
        return 0;
    }

	// se creeaza un nou proces copil
    pid_t pid = fork();
	
	if (pid < 0) return errno;
	else if (pid == 0)
	{
		// aici ne aflam in procesul copil

		// transformam argumentul primit in intreg
		// pentru a putea face operatii cu el
		int n = atoi(argv[1]);

		printf("%d: %d", n, n);

		// programul va rula pana cand n va ajunge la 1
		while (n != 1)
        {
			if (n % 2 == 0) n = n/2;
			else n = (3 * n) + 1;
            
			printf(" %d",n);
		}

		printf(".\n");
	}
	else
	{
		//aici ne aflam in procesul parinte

		// parintele va astepta finalizarea copilului
		wait(NULL);
		printf("Child %d finished\n", pid);
	}
	return 0;
}