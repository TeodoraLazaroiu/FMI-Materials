#include <stdio.h>
#include <stdlib.h>

int main()
{
    int **a;
    int i, j, n;

    printf("n:");
    scanf("%d", &n);

    // alocarea matricei

    a = malloc(n * sizeof(int *));

    for (i = 0; i < n; i++)
    {
        a[i] = malloc(n * sizeof(int));
    }

    // citirea elementelor din matrice

    printf("elementele matricei:");

    for (i = 0; i < n; i++)
        for(j = 0; j < n; j++)
            scanf("%d", &a[i][j]);

    // afisarea elementelor din matrice

    printf("Matricea este:\n");

    for (i = 0; i < n; i++)
    {
        for (j = 0; j < n; j++)
        {
            printf("%d ", a[i][j]);
        }
        printf("\n");
    }

    // afisarea elementului de la intersectia diagonalelor
    // doar daca n este impar

    if (n % 2 == 1) printf("intersectia diagonalelor: %d", a[n/2][n/2]);

    // afisarea diagonalei principale

    printf("\ndiagonala principala: ");
    for (i = 0; i < n; i++)
        for (j = 0; j < n; j++)
        {
            if (i == j) printf("%d ", a[i][j]);
        }

    // afisarea diagonalei secundare

    printf("\ndiagonala secundara: ");
    for (i = 0; i < n; i++)
        for (j = 0; j < n; j++)
        {
            if (i + j == n - 1) printf("%d ", a[i][j]);
        }
}