/*
Scrieti un program mycp care sa primeasca la intrare in primul
argument un fisier sursa pe care sa-l copieze intr-un alt
fisier cu numele primit in al doilea argument
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/stat.h>


// functie pentru deschiderea fisierului sursa
int openFromFile(char* fileName)
{
    // deschidem fisierul pentru citire
    int ff = open(fileName, O_RDONLY, S_IRWXU);
    if(ff < 0)
    {
        printf("Eroare la deschiderea fisierului sursa\n");
        printf("Numarul erorii: %d", errno);
        return -1;
    }
    return ff;
}

// functie pentru deschiderea fisierului de destinatie
int openToFile(char* fileName)
{
    struct stat sb;
    stat(fileName, &sb);

    // tratam cazul in care fisierul deja exista
    if (errno == 0)
    {
        printf("Fisierul este deja existent, doriti sa il rescrieti? (y/n): ");

        char action;
        scanf("%c", &action);

        if (action != 'y' && action != 'Y')
            return -1;
    }
    
    // deschidem fisierul pentru a scrie in el
    int tf = open(fileName, O_CREAT | O_WRONLY, S_IRWXU);
    if (tf < 0)
    {
        printf("Eroare la deschiderea fisierul de destinatie\n");
        printf("Numarul erorii: %d", errno);
        return -1;
    }

    return tf;
}

// functie pentru copierea dintr-un fisier in altul
int copyFile(int from, int to, int fileSize)
{
    char* content = malloc(sizeof(char) * fileSize);
    int readResult, writeResult;

    // read returneaza numarul de bytes cititi deci
    // daca citirea s-a efectuat functia va
    // returna un numar strict pozitiv

    if ((readResult = read(from, content, fileSize)) > 0)
    {
        printf("%s", content);

        writeResult = write(to, content, fileSize);

        if (writeResult < 0)
        {
            printf("Eroare la scrierea in fisier\n");
            printf("Numarul erorii: %d", errno);
            return errno;
        }
    }

    if (readResult < 0)
    {
        printf("Eroare la citirea in fisier\n");
        printf("Numarul erorii: %d", errno);
        return errno;
    }

    return 0;
}

// programul va fi compilat astfel: gcc lab2ex2.c -o lab2ex2
// programul va fi apelat astfel: ./lab2ex2 file1 file2

int main(int argc, char** argv)
{
    if (argc != 3)
    {
        printf("Trebuie sa avem exact 3 argumente\n");
        return 0;
    }

    char* fromFile = argv[1],* toFile = argv[2];

    // deschidem cele doua fisiere si verificam
    // daca au fost deschide corect

    int ff = openFromFile(fromFile);
    if (ff < 0)
        return 0;

    int tf = openToFile(toFile);
    if(tf < 0)
        return 0;

    struct stat sb;
    stat(fromFile, &sb);
    int fileSize = sb.st_size;

    // apelam functia pentru copiere
    if (copyFile(ff, tf, fileSize) < 0)
        return 0;

    printf("\n");

    // inchidem fisierele
    close(ff);
    close(tf);

    return 0;
}