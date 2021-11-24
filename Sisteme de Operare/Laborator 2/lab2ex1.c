#include <stdio.h>
#include <unistd.h>

int main ()
{
    write(1, "Hello, World!\n", 15);
    return 0;
}