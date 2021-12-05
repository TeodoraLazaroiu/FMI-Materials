/*
Scrieti un program care gestioneaza accesul la un numar finit de resurse.
Mai multe fire de executie pot cere concomitent o parte din resurse pe
care le vor da inapoi o data ce nu le mai sunt utile.
*/

#include <stdio.h>
#include <pthread.h>
#include <errno.h>
#include <stdlib.h>

#define MAXRESOURCES 5
#define MAXTHREADS 6
int available_resources = MAXRESOURCES;

pthread_mutex_t mtx;
int size = MAXTHREADS;
int count_threads[MAXTHREADS] = {2,-3,2,-2,1,-1};

int decrease_count(int count)
{
    if (pthread_mutex_lock(&mtx))
    {
        printf("Eroare la scaderea numarului de resurse\n");
    }

    // dam resurse doar daca avem de unde
    if (count <= available_resources)
    {
        available_resources -= count;
        printf("Got %d resources, %d remaining\n", count, available_resources);
    }
    return pthread_mutex_unlock(&mtx);
}

int increase_count(int count)
{
    if (pthread_mutex_lock(&mtx))
    {
        printf("Eroare la cresterea numarului de resurse\n");
    }

    // numarul de resurse nu trebuie sa depaseasca numarul maxim
    if (available_resources + count <= MAXRESOURCES)
    {
         available_resources += count;
         printf("Released %d resources, %d remaining\n", count, available_resources);
    }

    return pthread_mutex_unlock(&mtx);
}

void* threads_fun(void* x)
{
    // transformam in pointer la int
    int count = *((int*)x);

    // daca parametrul este negativ inseamna ca se iau resurse
    // iar daca este pozitiv se elibereaza resurse
    if (count < 0)
        decrease_count(-count);
    else
        increase_count(count);

    return NULL;
}

// programul va fi compilat astfel: gcc lab7ex1.c -o lab7ex1 -pthread
// programul va fi apelat astfel: ./lab7ex1

int main()
{
	// initializam mutexul
    if (pthread_mutex_init(&mtx, NULL))
	{
        perror(NULL);
        return errno ;
    }

    // afisam numarul de resurse maxim
    printf("MAXRESOURCES = %d\n", MAXRESOURCES);

    // se creeaza un vector de threaduri
    pthread_t* v = malloc(size * sizeof(pthread_t *));


    for (int i = 0; i < size; i++)
        pthread_create(&v[i], NULL, threads_fun, &count_threads[i]);

    for (int i = 0; i < size; i++)
        pthread_join(v[i], NULL);

	// distrugem mutexul
    pthread_mutex_destroy(&mtx);
    return 0;
}