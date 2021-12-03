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

// functie recursiva pentru testarea ipotezei
// Collatz folosind memoria partajata

void collatz(int n, int written_ch, char* shm_ptr)
{	
	written_ch = sprintf(shm_ptr," %d", n);
    shm_ptr = shm_ptr + written_ch;

	if (n == 1)
	{
	 	written_ch = sprintf(shm_ptr, ".\n");
        shm_ptr = shm_ptr + written_ch;
		return;
	}
	else if (n%2 == 0) n = n/2;
	else n = (3 * n) + 1;
    
	collatz(n, written_ch, shm_ptr);
}

// programul va fi compilat astfel: gcc lab5ex1.c -o lab5ex1 -lrt
// programul va fi apelat astfel: ./lab5ex1 9 16 25 36

int main(int argc, char* argv[])
{
    // se creaza un file descriptor pentru
    // scrierea in memoria partajata
    int shm_fd;

    char* shm_name = "shm_collatz";

    shm_fd = shm_open(shm_name, O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);

    // eroare daca nu se poate creea memoria partajata
    if (shm_fd == -1) 
    {
        perror("Eroare la shm_open\n");
        return errno;
    }

    // fiecare proces copil va avea o zona de memorie
    // de marimea unei pagini unde va putea scrie

    int page_size = getpagesize();
    int total_size = argc * page_size;

    if (ftruncate(shm_fd, total_size) == -1) 
    {
        perror("Eroare la truncate\n");
        return errno;
    }

    printf("Starting parent %d\n", getpid());

    for (int i = 1; i < argc; i++) 
    {
        // se va creea un copil pentru fiecare task

        pid_t child = fork();

        if (child < 0)
        {
            perror("Eroare la crearea procesului copil");
            return -1;
        }
        else if (child == 0)
        {
            // aici ne aflam in procesul copil

            // buffer pentru zona de memoria unde vom scrie
            char* shm_ptr;

            // unui proces copil i se va mapa o portiune de memorie
            // de marimea unei pagini (page_size)
            shm_ptr = mmap(NULL, page_size, PROT_WRITE, MAP_SHARED, shm_fd, (i - 1) * page_size);
            
            // eroare daca nu s-a putut mapa memoria
            if (shm_ptr == MAP_FAILED)
            {
                perror("Eroare la maparea memoriei din procesul copil");
                return errno;
            }

            // transformam argumentul primit in intreg
			// pentru a putea face operatii cu el
            int n = atoi(argv[i]);

            int written_ch;

            // vom pastra intr-o variabila numarul de caractere
            // scrise pentru a deplasa pointerul

            written_ch = sprintf(shm_ptr, "%d:", n);
            shm_ptr = shm_ptr + written_ch;

            // apelam functia recursiva
            collatz(n, written_ch, shm_ptr);

            printf("Done. Parent = %d, Me = %d\n", getppid(), getpid());

            exit(0);
        }
    }
    for (int i = 1; i < argc; i++)
    {
        // procesul parinte va astepta ca toate
		// procesele copil sa fie finalizare
        wait(NULL);
    }
    for (int i = 1; i < argc; i++)
    {
        // incarcam pe rand in memorie fiecare bucata
        // scrisa de procesele copil de mai sus

        char* shm_ptr = mmap(NULL, page_size, PROT_READ, MAP_SHARED, shm_fd, (i-1) * page_size);

        // eroare daca nu s-a putut mapa memoria
        if(shm_ptr == MAP_FAILED)
        {
            perror("Eroare la maparea memoriei din procesul parinte\n");
            return errno;
        }

        // afisam continutul bufferului
        printf("%s", shm_ptr);
    }
    
    printf("Parent done. Parent = %d, Me = %d\n", getppid(), getpid());

    return 0;
}