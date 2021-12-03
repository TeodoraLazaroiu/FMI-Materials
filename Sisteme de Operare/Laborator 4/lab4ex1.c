/*
Creati un proces nou folosind fork(2) si afisati fisierele
din directorul curent cu ajutorul execve(2). Din procesul
initial afisati pid-ul propriu si pid-ul copilului.
*/

#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>

int main(int argc, char* argv[])
{
	pid_t pid = fork();
	
	if (pid < 0)
		return errno;
	else if (pid == 0)
	{
		char *argv1[] = {"ls", NULL};
		execve("/bin/ls", argv1, NULL);
	}
	else
	{
		printf("Parent PID = %d, Child PID = %d \n", getpid(), pid);
		wait(NULL);
		printf("Child %d finished \n", pid);
	}
	return 0;
}
