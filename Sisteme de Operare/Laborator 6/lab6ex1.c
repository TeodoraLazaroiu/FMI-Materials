/*
Scrieti un program care primeste un sir de caractere la intrare ale carui caractere 
le copiaza in ordine inversa si le salveaza intr-un sir separat. Operatie de inversare
va avea loc intr-un thread separat.Rezultatul va fi obtinut cu ajutorul functiei pthread_join
*/

#include <pthread.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void* reverse(void* arg)
{
    int len = strlen(arg);

    char *new_string = (char *)malloc(len);

    // inversam sirul printr-o parcurgere
    
    for(int i = 0; i < len; ++i)
        new_string[i] = ((char*)arg)[len - i - 1];

    return new_string;
}

// programul va fi compilat astfel: gcc lab6ex1.c -o lab6ex1 -pthread
// programul va fi apelat astfel: ./lab6ex1 hello

int main(int argc, char** argv)
{
    if (argc < 2)
    {
        printf("Trebuie sa avem exact 2 argumente\n");
    }

    // se creeaza un nou thread
    pthread_t thr;

    // functia pthread_create va returna 1 daca
    // nu se va putea crea un thread

    if (pthread_create(&thr, NULL, reverse, argv[1]))
    {
        perror(NULL);
        return errno;
    }

    // cu functia pthread_join se asteapta
    // finalizarea thread-ului specificat
    // si returneaza rezultatul

    void *result;

    if (pthread_join(thr, &result))
    {
        perror(NULL);
        return errno;
    }

    // afisam rezultatul dupa terminarea threadului

    printf("%s\n", (char *)result);

    free(result);

    return 0;                       
}