/*
Scrieti un program care sa calculeze produsul a doua matrice date
de dimensiuni compatibile unde fiecare element al matricei
rezultate este calculat de catre un thread distinct.
*/

#include <stdio.h>
#include <errno.h>
#include <pthread.h>
#include <unistd.h>
#include <stdlib.h>

int n = 3, i, j;

void* multiply(void* v)
{
    // convertim vectorul pasat ca
    // argument intr-un pointer de int

	int* elem = (int *)v;

    // alocam memorie pentru
    // calculul elementului
    
	int* c = (int *)malloc(sizeof(int));

	for(int i = 0; i < n; i++)
		c[0] += elem[i] * elem[n + i];
        
	return c;
}

// programul va fi compilat astfel: gcc lab6ex2.c -o lab6ex2 -pthread
// programul va fi apelat astfel: ./lab6ex2 hello

int main()
{
    // declararea matricilor si a vectorului de elemente
    int matrix1[n][n], matrix2[n][n], matrix_finale[n][n], v[2*n + 1];

    /* prima matrice va avea forma:
        0 1 2
        1 2 3
        2 3 4 */
	for (i = 0; i < n; i++)
		for (j = 0; j < n; j++)
			matrix1[i][j] = i + j;

    /* a doua matrice va avea forma:
        0 1 2
        1 2 3
        2 3 4 */
	for (i = 0; i < n; i++)
		for (j = 0; j < n; j++)
			matrix2[i][j] = i + j;

	void* result;
	pthread_t thr;

	for (i = 0; i < n; i++)
		for (j = 0; j < n; j++)
        {
			int l, k = 0;

            // punem in vector elementele necesare pentru
            // a calcula elementul cu indicii i si j

			for (l = 0; l < n; l++)
				v[k++] = matrix1[i][l];

			for(l = 0; l < n; l++)
				v[k++] = matrix2[l][j];
			
            // se creeaza un thread nou pentru
            // calculul fiecarei element al matricei

            if(pthread_create(&thr, NULL, multiply, v))
            {
				perror(NULL);
				return errno;
			}
			
            // se asteapta finalizarea threadurilor
            if(pthread_join(thr, &result))
            {
				perror(NULL);
				return errno;
			}
			
            // salvam in noua matrice elementul
            // calculat cu ajutorul unui thread

            matrix_finale[i][j] = *(int *)result;
			
            // eliberam memoria
            free(result);
		}

    // afisarea matricei finale
	for (i = 0; i < n; i++)
    {
		for (j = 0; j < n; j++)
			printf("%d ", matrix_finale[i][j]);
		
        printf("\n");
	}

	return 0;
}
