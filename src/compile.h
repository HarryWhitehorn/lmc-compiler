#pragma once
#ifndef COMPILE_H
#define COMPILE_H

#include <stdio.h>

#include "lexer.h"
#include "parser.h"

FILE *openFile(const char *filename, const char *mode);

void freeParser(); // Frees the current loaded instructions from memory 

void compileFromFile(const char *inputPath); // Reads a files contents

void compileFromString(char *String); // Reads from a null-terminated string

void instructionsToFile(const char *outputPath); // Writes to file

void instructionsToCharBuffer(char *Buffer); // Writes instructions as strings to buffer

void instructionsToIntBuffer(int *Buffer); // Writes instructions as ints to buffer

void instructionsToStdout(); // Prints to stdout

#endif