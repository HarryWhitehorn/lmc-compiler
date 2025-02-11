#include "compile.h"

FILE* openFile(const char *filename, const char *mode){
    FILE *fptr = fopen(filename, mode);
    if (!fptr) {
        printf("Error opening file '%s'\n", filename); // TODO: Raise Error / Error Handling
        return NULL;
    }
    return fptr;
}

int compile(const char *inputPath, const char *outputPath) {
    FILE *inFptr = openFile(inputPath, "r");
    if (inFptr){
        yyin = inFptr;
        yyparse();
        fclose(inFptr);
        FILE *outFptr = openFile(outputPath, "w");
        if (outFptr) {
        printInstructions();
        fprintInstructions(outFptr);
        fclose(outFptr);
        return 0;
        }
    }
    return 2;
}