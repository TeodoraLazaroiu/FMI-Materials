/*
Implementati un program care sa testeze ipoteza Collatz pentru mai multe numere date
folosind memorie partajata. Pornind de la un singur proces parinte, este creat cate 
un copil care se ocupa de un singur numar si scrie seria undeva in memoria partajata.

Parintele va crea obiectul de memorie partajata folosind shmopen(3) si ftruncate(2) si
pe urma va incarca in memorie intreg spatiul pentru citirea rezultatelor cu mmap(2).
*/

#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <unistd.h>
#include <errno.h>
#include <sys/wait.h>
#include <string.h>

void collatz(int n, int written_ch, char* shm_ptr)
{	
	written_ch = sprintf(shm_ptr," %d", n);
    shm_ptr += written_ch;

	if (n == 1)
	{
	 	written_ch = sprintf(shm_ptr, ".\n");
        shm_ptr += written_ch;
		return;
	}
	else if(n%2 == 0) n = n/2;
	else n = 3*n + 1;
    
	collatz(n, written_ch, shm_ptr);
}

int main(int argc, char* argv[])
{
    int shm_fd;
    char* shm_name = "shm_fibo";
    shm_fd = shm_open(shm_name, O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);

    if (shm_fd == -1) 
    {
        perror("Eroare la shm_open\n");
        return errno;
    }

    int page_size = getpagesize();
    int total_size = argc * page_size; // ii alocam un spatiu de page_size fiecaruit proces

    if (ftruncate(shm_fd, total_size) == -1) 
    {
        perror("Eroare la truncate\n");
        return errno;
    }

    printf("Starting parent %d\n", getpid());

    for (int i = 1; i < argc; i++) 
    {
        pid_t child = fork(); // un copil pt fiecare task
        
        if (child < 0)
        {
            perror("Eroare la fork");
            return -1;
        }
        else if (child == 0)
        {
            char* shm_ptr;
            shm_ptr = mmap(NULL, page_size, PROT_WRITE, MAP_SHARED, shm_fd, (i - 1) * page_size);
            // copilului i i se va mapa o bucata de lungime egala cu page_size
            // mai exact, de la (i-1)*page_size la i*page_size
            
            if (shm_ptr == MAP_FAILED)
            {
                perror("Eroare la mmap, din procesul copil");
                return errno;
            }

            int n = atoi(argv[i]);

            int written_ch;

            written_ch = sprintf(shm_ptr, "%d:", n);
            shm_ptr += written_ch; // deplasam pointerul cu nr de caractere scrise

            collatz(n, written_ch, shm_ptr);

            printf("Done. Parent = %d, Me = %d\n", getppid(), getpid());

            exit(0); //normal process termination
        }

    }
    for (int i = 1; i < argc; i++)
    {
        wait(NULL);
    }
    for (int i = 1; i < argc; i++)
    {
        // incarcam pe rand in memorie "bucatica" fiecarui proces copil
        char* shm_ptr = mmap(NULL, page_size, PROT_READ, MAP_SHARED, shm_fd, (i-1)*page_size);
        if(shm_ptr == MAP_FAILED)
        {
            perror("Eroare la mmap din parinte\n");
            return errno;
        }
        printf("%s", shm_ptr);
    }
    
    printf("Parent done. Parent = %d, Me = %d\n", getppid(), getpid());
    return 0;
}