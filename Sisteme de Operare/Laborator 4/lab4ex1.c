/*
Creati un proces nou folosind fork(2) si afisati fisierele
din directorul curent cu ajutorul execve(2). Din procesul
initial afisati pid-ul propriu si pid-ul copilului.
*/

#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>

// programul va fi compilat astfel: gcc lab4ex1.c -o lab4ex1
// programul va fi apelat astfel: ./lab4ex1

int main(int argc, char* argv[])
{
	// se creaza un nou proces copil
	pid_t pid = fork();
	
	if (pid < 0) return errno;
	else if (pid == 0)
	{	
		// aici ne aflam in procesul copil
		char *argv_aux[] = {"ls", NULL};
		execve("/bin/ls", argv_aux, NULL);
	}
	else
	{
		// aici ne aflam in procesul parinte
		printf("Parent PID = %d, Child PID = %d \n", getpid(), pid);

		// procesul parinte asteapta finalizarea copilului
		wait(NULL);
		printf("Child %d finished\n", pid);
	}
	return 0;
}
