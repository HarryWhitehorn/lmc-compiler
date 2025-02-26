#pragma once
#ifndef COMPILE_H
#define COMPILE_H

#include <stdio.h>

#include "lexer.h"
#include "parser.h"

FILE *openFile(const char *filename, const char *mode);

void compileFromFile(const char *inputPath);

void instructionsToFile(const char *outputPath);

void instructionsToBuffer(char *Buffer);

void instructionsToStdout();

#endif