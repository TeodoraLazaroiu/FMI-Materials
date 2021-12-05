/*
Scrieti un program care sa calculeze produsul a doua matrice date
de dimensiuni compatibile unde fiecare element al matricei
rezultate este calculat de catre un thread distinct.
*/

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <pthread.h>

#define rows 3
#define cols 3

int matrix1[rows][cols] =
{
        {1,2,3},
        {4,5,6},
        {7,8,9}
};

int matrix2[rows][cols] =
{
        {1,1,1},
        {2,2,2},
        {3,3,3}
};
int result_matrix[rows][cols];

struct index
{
    int i, j;
};

void* multiply(void* position){
    struct index * index = position;
    int i = index->i;
    int j = index->j;

    free(position);

    result_matrix[j][i] = 0;

    for(int k = 0; k < cols; ++k)
        result_matrix[j][i] += matrix1[j][k] * matrix2[k][i];

    return NULL;
}

int main()
{
    pthread_t threads[rows * cols];

    int thread_id = 0;
    for (int i=0;i<rows;++i)
        for (int j=0;j<cols;++j)
        {
            struct index* index = calloc(1, sizeof(struct index));
            index->i = i;
            index->j = j;

            if(pthread_create(&threads[thread_id++], NULL, multiply, index))
            {
                perror(NULL);
                return errno;
            }
        }

    for (int i = 0; i < thread_id; ++i){
        if(pthread_join(threads[i], NULL))
        {
            perror(NULL);
            return errno;
        }
        printf("Joined thread %d\n", i);
    }
     
    for (int i = 0; i < rows; ++i)
    {
        for(int j = 0; j < cols; ++j)
            printf("%d ", result_matrix[i][j]);
        printf("\n");
    }

    return 0;
}