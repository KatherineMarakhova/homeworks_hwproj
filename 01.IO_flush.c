#include <stdio.h>
#include <string.h>

/*
Компиляция
$ cc 01.IO_flush.c -o 01.IO_flush

Запуск
$ ./01.IO_flush w
$ ./01.IO_flush n w
$ ./01.IO_flush w n f
и тд.
*/


int main(int argc, char *argv[])
{
    int write_to_file, add_n, del_fflush;
    write_to_file = 0;
    add_n = 0;
    del_fflush = 0;

    for(int i=1; i < argc; i++){
        if (strcmp(argv[i], "w")==0) write_to_file = 1;
        if (strcmp(argv[i], "n")==0) add_n = 1;
        if (strcmp(argv[1], "f")==0) del_fflush = 1;
    }

    if (write_to_file){                     
        freopen("output.txt", "w", stdout);
        freopen("output.txt", "w", stderr);
    }

    if (add_n)                     
        fputs("STDOUT\n", stdout);

    else 
        fputs("STDOUT", stdout);

    if (!del_fflush)          
        fflush(stdout);
    
    if (add_n)
        fputs("STDERR\n", stderr);

    else
        fputs("STDERR", stderr);

    if (!del_fflush)
        fflush(stderr);

    return 0;
}