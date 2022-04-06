#!/bin/bash

#Author: Daniel C
#Title: BASH compile for C++
#Modifed by Alex T

rm *.o
rm *.out

echo "Compiling files..."

nasm -f elf64 -o code.o code.asm

g++ -g -c -m64 -std=c++17 -fno-pie -no-pie -o driver.o driver.cpp

g++ -g -m64 -std=c++17 -fno-pie -no-pie -o application.out code.o driver.o

if test -f "application.out"; then
    echo "Compilation successful. Running program."
    ./application.out
else
    echo "Can't find compiled program. Build failed?"
fi