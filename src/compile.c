#include "compile.h"

FILE *openFile(const char *filename, const char *mode)
{
    FILE *fptr = fopen(filename, mode);
    if (!fptr)
    {
        printf("Error opening file '%s'\n", filename); // TODO Raise Error / Error Handling
        return NULL;
    }
    return fptr;
}

void compileFromFile(const char *inputPath)
{
    flushParser();
    FILE *inFptr = openFile(inputPath, "r");
    if (inFptr)
    {
        yyin = inFptr;
        yyparse();
        fclose(inFptr);
    }
}

void instructionsToFile(const char *outputPath)
{
    FILE *outFptr = openFile(outputPath, "w");
    if (outFptr)
    {
        fprintInstructions(outFptr);
        fclose(outFptr);
    }
}

void instructionsToBuffer(char *Buffer)
{
    sprintInstructions(Buffer);
}

void instructionsToStdout()
{
    printInstructions();
}