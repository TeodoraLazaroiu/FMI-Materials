/*
Implementati o functie care numara aparitiile
unui cuvant intr-un text dat
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int count_occurrences(char* text, char* word)
{
    // despartim textul in cuvinte
    // si numaram aparitiile cuvantului dorit
    
    char *p;
    p = strtok(text, ", ");

    int number = 0;

    while (p != NULL)
    {
        if (strcmp(p, word) == 0) number++;
        p = strtok(NULL, ", ");
    }

    return number;
}

// programul va fi compilat astfel: gcc labCex2.c -o labCex2
// programul va fi apelat astfel: ./labCex2

int main()
{
    char text[50] = "mere, pere, mere, mere, capsuni, ananas";
    char word[10] = "mere";

    printf("Cuvantul \"%s\" apare de %d ori\n", word, count_occurrences(text, word));
}