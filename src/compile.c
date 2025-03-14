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

void freeParser()
{
    flushParser();
}

void compileFromFile(const char *inputPath)
{
    freeParser();
    FILE *inFptr = openFile(inputPath, "r");
    if (inFptr)
    {
        yyin = inFptr;
        yyparse();
        fclose(inFptr);
    }
}

void compileFromString(char *String)
{
    freeParser();
    YY_BUFFER_STATE bufferState = yy_scan_string(String); // Must be null-terminated
    if (bufferState) {} // TODO Raise Error / Error Handling; check `bufferState` validity
    yyparse();
    yy_delete_buffer(bufferState);
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

void instructionsToCharBuffer(char *Buffer)
{
    sprintInstructions(Buffer);
}

void instructionsToIntBuffer(int *Buffer)
{
    bufferInstructions(Buffer);
}

void instructionsToStdout()
{
    printInstructions();
}