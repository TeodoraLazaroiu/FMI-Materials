/*
Se citesc de la tastură un număr natural n ce reprezintă dimensiunea unei
matrice pătratice ṣi elementele unei matrice pătratice. Folosind pointeri,
să se afiṣeze elementele matricei, elementul de la intersecţia diagonalelor
(pentru n impar), iar apoi elementele de pe cele două diagonale.
*/

#include <stdio.h>
#include <stdlib.h>

// programul va fi compilat astfel: gcc labCex1.c -o labCex1
// programul va fi apelat astfel: ./labCex1

int main()
{
    int **a;
    int i, j, n;

    printf("Numarul de linii si coloane: ");
    scanf("%d", &n);

    // alocarea matricei

    a = malloc(n * sizeof(int *));

    for (i = 0; i < n; i++)
    {
        a[i] = malloc(n * sizeof(int));
    }

    // citirea elementelor din matrice

    printf("Elementele matricei sunt: ");

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

    if (n % 2 == 1) printf("Intersectia diagonalelor: %d", a[n/2][n/2]);

    // afisarea diagonalei principale

    printf("\nDiagonala principala: ");
    for (i = 0; i < n; i++)
        for (j = 0; j < n; j++)
        {
            if (i == j) printf("%d ", a[i][j]);
        }

    // afisarea diagonalei secundare

    printf("\nDiagonala secundara: ");
    for (i = 0; i < n; i++)
        for (j = 0; j < n; j++)
        {
            if (i + j == n - 1) printf("%d ", a[i][j]);
        }

    printf("\n");
}