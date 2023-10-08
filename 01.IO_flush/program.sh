#!/bin/bash

#compile
clang 01.IO_flush.c

# console
./a.out     
./a.out n   
./a.out f   
./a.out n f 

mkdir files

./a.out &> ./files/1s.txt
./a.out n &> ./files/2n.txt
./a.out f &> ./files/3f.txt
./a.out n f &> ./files/4nf.txt