# 01.IO_flush

## Commands:
- w - write to file (output.txt)
- n - add /n to the end of lines
- f - deleting fflush'es

## Scenaries and results 
1. Running unchanged code outputs:
`STDOUTSTDERR%`
2. Adding \n to the end of lines:
```
STDOUT
STDERR
```
3. Deleting fflush'es:
`STDOUTSTDERR%`
4. Adding \n and Deleting fflush'es:
````
STDOUT
STDERR
````
5. Results in file of unchanged code outputs:
`STDERR`
6. Results in file with \n:
`STDERR`
7. Results in file without flush'es:
`STDERR`
8. Results in file with \n and without flush'es:
`STDERR`
