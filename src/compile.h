#pragma once
#ifndef COMPILE_H
#define COMPILE_H

#include <stdio.h>

#include "lexer.h"
#include "parser.h"

FILE *openFile(const char *filename, const char *mode);

void compileFromFile(const char *inputPath);

void compileFromString(char *String);

void instructionsToFile(const char *outputPath);

void instructionsToCharBuffer(char *Buffer);

void instructionsToIntBuffer(int *Buffer);

void instructionsToStdout();

#endif