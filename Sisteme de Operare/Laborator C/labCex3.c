/*
Implementati o alta functie ce citeste doua cuvinte si
inlocuieste intr-un text introdus de la tastatura toate
aparitiile primului cuvant prin cel de-al doilea.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int count_occurrences(char* text, char* word)
{
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

void find_and_replace(char* text, char* find, char* replace)
{
    char *p;
    p = strtok(text, ", ");

    char new_text[50];

    while (p != NULL)
    {
        if (strcmp(p, find) == 0)
        {
            strcat(new_text, replace);
            strcat(new_text, ", ");
        }
        else
        {
            strcat(new_text, p);
            strcat(new_text, ", ");
        }
        
        p = strtok(NULL, ", ");
    }

    new_text[strlen(new_text) - 2] = '\0';

    strcpy(text, new_text);
}

// programul va fi compilat astfel: gcc labCex3.c -o labCex3
// programul va fi apelat astfel: ./labCex3

int main()
{
    char text[50] = "mere, pere, mere, mere, capsuni, ananas";
    char find[10] = "mere";
    char replace[10] = "cirese";

    printf("Textul initial este: %s\n", text);

    find_and_replace(text, find, replace);

    printf("Textul modificat este: %s\n", text);
}