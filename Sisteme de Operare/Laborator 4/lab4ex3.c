/*
 Implementati un program care sa testeze ipoteza Collatz pentru mai multe
 numere date. Pornind de la un singur proces parinte, este creat cate un
 copil care se ocupa de un singur numar. Parintele va astepta sa termine
 executia fiecare copil. Se vor folosi getpid() si getppid().
*/

#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <stdlib.h>

// functie recursiva ce testeaza ipoteza Collatz
void collatz(int n)
{	
	printf(" %d",n);

	if (n == 1)
	{
	 	printf(".\n");
		return;
	}
	else if (n%2 == 0) n = n/2;
	else n = (3 * n) + 1;
    
	collatz(n);
}

// programul va fi compilat astfel: gcc lab4ex3.c -o lab4ex3
// programul va fi apelat astfel: ./lab4ex3 9 16 25 36

int main(int argc, char* argv[])
{
	printf("Starting parent %d\n", getpid());

	// programul va testa ipoteza Collatz pentru
	// toate argumentele primite la apel

	for (int i = 1; i < argc; i++)
    {
		// se creaza cate un proces copil pentru fiecare
		// numar primit ca argument

		pid_t pid = fork();

		if (pid < 0) return errno;
		else if (pid == 0)
		{
			// transformam argumentul primit in intreg
			// pentru a putea face operatii cu el
			int n = atoi(argv[i]);
			printf("%d:",n);

			// apelam functia recursiva
			collatz(n);

			printf("Done Parent %d Me %d \n", getppid(), getpid());

			exit(0);
		}
	}
	for (int i = 1; i < argc; i++)
	{
		// procesul parinte va astepta ca toate
		// procesele copil sa fie finalizare
		wait(NULL);
	}

	printf("Done Parent %d Me %d \n", getppid(),getpid());
	return 0;
}
