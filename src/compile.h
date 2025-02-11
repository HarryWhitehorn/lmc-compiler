#pragma once
#ifndef COMPILE_H
#define COMPILE_H

#include <stdio.h>

#include "lexer.h"
#include "parser.h"

FILE* openFile(const char *filename, const char *mode);

int compile(const char *inputPath, const char *outputPath);

#endif