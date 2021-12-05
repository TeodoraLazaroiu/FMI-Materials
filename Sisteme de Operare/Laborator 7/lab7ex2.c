/*
Scrieti un program care sa sincronizeze executia a n fire de executie
construind un obiect de tip bariera. Bariera va fii initializata folosind
init(n) si fiecare thread va apela barrierpoint() cand va ajunge
in dreptul barierei.

Cand functia este apelata a n-a oara, aceasta porneste executia
tuturor firelor in asteptare.

Verificati rezultatele dumneavoastra cu ajutorul unui program care porneste
mai multe thread-uri ce se folosesc de bariera pentru a-si sincroniza executia.
*/

#include <pthread.h>
#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <unistd.h>
#include <semaphore.h>

#define NR_THREADS 5

// declaram global mutexul si semaforul
pthread_mutex_t mtx;
sem_t sem;

int count;

int barrier_point()
{
    // zona critica
	pthread_mutex_lock(&mtx);
	count++;
	pthread_mutex_unlock(&mtx);

    // programul va face fiecare thread sa astepte
    // pana cand se va ajunge la ultimul
	if (count < NR_THREADS)
    {
		sem_wait(&sem);
	}

    // cand toate threadurile se afla simultan
    // in asteptare atunci se va continua
	if (count == NR_THREADS)
    {
        // elibereaza thread-ul care asteapta
        // de cel mai mult timp in coada
		sem_post(&sem);
	}

	return 0;
}

void* tfun(void* v)
{
	int* tid = (int*)v;
	
	printf("%d reached the barrier\n", *tid);
	barrier_point();
	printf("%d passed the barrier\n", *tid);

    // eliberam memoria alocata dinamic
	free(tid);
	
    return;
}

// programul va fi compilat astfel: gcc lab7ex2.c -o lab7ex2 -pthread
// programul va fi apelat astfel: ./lab7ex2

int main()
{
	int i, s = 0;
	int* id;

    // declaram un vector de threaduri
	pthread_t thr[NR_THREADS];
	
    // initializam mutexul
    if(pthread_mutex_init(&mtx, NULL))
    {
		perror(NULL);
		return errno;
	}

    // initializam semaforul
	if(sem_init(&sem, 0, s))
    {
		perror(NULL);
		return errno;
	}

	for (i = 0; i < NR_THREADS; i++)
    {
        // fiecare thread va avea un id
        // pornind numaratoarea de la 0

		id = (int *)malloc(sizeof(int));
		*id = i;

        // daca exista eroare la crearea
        // threadului cu indexul i

		if (pthread_create(&thr[i], NULL, tfun, id))
        {
			perror(NULL);
			return errno;
		}
	}

	for (i = 0; i < NR_THREADS; i++)
    {
        // se asteapta terminarea executiei
        // tuturor threadurilor

		if (pthread_join(thr[i], NULL))
        {
			perror(NULL);
			return errno;
		}
	}

    // distrugem semaforul si mutexul
	sem_destroy(&sem);
	pthread_mutex_destroy(&mtx);

	return 0;
}
