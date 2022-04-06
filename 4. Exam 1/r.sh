# Name: Alex Tran (887519064)
# Section: CPSC 240-07
# E-mail: altran@csu.fullerton.edu

#!/bin/bash

rm *.o
rm *.out

echo "Compiling files..."

nasm -f elf64 -o roots.o roots.asm

g++ -g -c -m64 -std=c++17 -fno-pie -no-pie -o quad.o quad.cpp

g++ -g -m64 -std=c++17 -fno-pie -no-pie -o quad.out roots.o quad.o

if test -f "quad.out"; then
    echo "Compilation successful. Running program."
    ./quad.out
else
    echo "Can't find compiled program. Build failed?"
fi