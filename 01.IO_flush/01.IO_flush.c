#include <stdio.h>
#include <string.h>

int main(int argc, char *argv[])
{
    int add_n, del_fflush;
    add_n = 0;
    del_fflush = 0;
    
    fputs("\n", stdout);

    for(int i=1; i < argc; i++){
        if (strcmp(argv[i], "n")==0) add_n = 1;
        if (strcmp(argv[1], "f")==0) del_fflush = 1;
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
    
    fputs("\n", stdout);

    return 0;
}