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

    pid_t pid = fork();
	
	if (pid < 0)
		return errno;
	else if (pid == 0)
	{
		int n = atoi(argv[1]);

		printf("%d: %d",n, n);

		while(n != 1)
        {
			if (n % 2 == 0)
				n = n/2;
			else n = 3*n + 1;
            
			printf(" %d",n);
		}
		printf(".\n");
	}
	else
	{
		wait(NULL);
		printf("Child %d finished\n", pid);
	}
	return 0;
}