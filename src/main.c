#include <stdio.h>

#include "lexer.h"
#include "parser.h"

const char *INPUT_PATH = "c:\\Users\\harry\\Documents\\GitHub\\lmc-compiler\\programs\\demo.txt";
const char *OUTPUT_PATH = "c:\\Users\\harry\\Documents\\GitHub\\lmc-compiler\\programs\\out.lmc";

FILE* readFile(const char *filename){
  FILE *fptr = fopen(filename, "r");
  if (!fptr) {
    printf("Error opening file %s", filename);
    return NULL;
  }
  return fptr;
}

int main(int, char**) {
  FILE *fptr = readFile(INPUT_PATH);

  yyin = fptr;
  
  yyparse();
  // printIdentifiers();
  FILE *outFptr = fopen(OUTPUT_PATH, "w");
  printInstructions();
  fprintInstructions(outFptr);

  // tidy
  fclose(fptr);
  fclose(outFptr);
  return 0;
}