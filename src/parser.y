%code top{
#include <stdio.h>
#include <stdlib.h>
#define YYDEBUG 1

void yyerror(const char *s);
int yylex();
extern FILE *yyin;
extern int line_num;
}

%union {
  int ival;
  float fval;
  char *sval;
}

%token ADD SUB 
%token STA LDA
%token BRA BRZ BRP
%token INP OUT 
%token HLT
%token DAT
%token ENDL

%token <ival> NUMBER
%token <sval> IDENTIFIER
%token <sval> COMMENT

%%
program:
    program instruction ENDLS;
    | instruction ENDLS;
    | ENDLS;
    ;
instruction:
    ADD { printf("ADD "); } value 
    | SUB { printf("SUB "); } value 
    | STA { printf("STA "); } value 
    | LDA { printf("LDA "); } value 
    | BRA { printf("BRA "); } value 
    | BRZ { printf("BRZ "); } value 
    | BRP { printf("BRP "); } value 
    | INP { printf("INP\n"); }
    | OUT { printf("OUT\n"); }
    | HLT { printf("HLT\n"); }
    | IDENTIFIER DAT { printf("DAT %s\n", $1); }
    | COMMENT { ; } //TODO optional comment adding 
    ;
value:
    NUMBER { printf("NUMBER %d\n", $1); }
    | IDENTIFIER { printf("IDENTIFIER %s\n", $1); }
    ;
ENDLS:
    ENDL ENDLS
    | ENDL
    ;
%%

const char *filename = "c:\\Users\\harry\\Documents\\GitHub\\lmc-compiler\\programs\\demo.txt";

int main(int, char**) {
  // Open a file handle to a particular file:
  FILE *myfile = fopen(filename, "r");
  // Make sure it is valid:
  if (!myfile) {
    printf("I can't open file!");
    return -1;
  }
  // Set Flex to read from it instead of defaulting to STDIN:
  yyin = myfile;
  
  // Parse through the input:
  yyparse();
  
}

void yyerror(const char *s) {
    fprintf(stderr, "Line %d: Error: %s\n", line_num, s);
}
