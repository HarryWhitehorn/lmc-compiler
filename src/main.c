#include <stdio.h>

#include "lexer.h"
#include "parser.h"

const char *FILENAME = "c:\\Users\\harry\\Documents\\GitHub\\lmc-compiler\\programs\\demo.txt";

FILE* readFile(const char *filename){
  FILE *f = fopen(filename, "r");
  if (!f) {
    printf("Error opening file %s", filename);
    return NULL;
  }
  return f;
}

int main(int, char**) {
  FILE *f = readFile(FILENAME);

  yyin = f;
  
  yyparse();
  // printIdentifiers();
  printInstructions();

  return 0;
}