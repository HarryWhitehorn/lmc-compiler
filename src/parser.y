%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define YYDEBUG 1

void yyerror(const char *s);
int yylex();
extern FILE *yyin;
extern int line_num;

enum Opcode
{
  OP_ADD = 1,   // Add
  OP_SUB = 2,   // Subtract
  OP_STA = 3,   // Store
  OP_LDA = 5,   // Load
  OP_BRA = 6,   // Branch Always
  OP_BRZ = 7,   // Branch if Zero
  OP_BRP = 8,   // Branch if positive
  OP_IO = 9,    // Input / Output
  OP_INP = 901, // Input
  OP_OUT = 902, // Output
  OP_OTC = 922, // Output Character
  OP_HLT = 0,   // Halt
};

// IDENTIFIERS

typedef struct Identifier {
  char *name;
  int addr;
  struct Identifier *next;
} Identifier;

Identifier *identifiers = NULL;

Identifier* lookupIdentifier(const char *name) {
  // returns pointer to Identifier if exists else NULL
  Identifier *id = identifiers;
  while (id){
    if (strcmp(id->name, name) == 0) {
      return id;
    }
    id = id->next;
  }
  return NULL;
}

Identifier* addIdentifier(char *name) {
  Identifier *lookup = lookupIdentifier(name);
  if (lookup) {
    lookup->addr = line_num;
    return lookup;
  }
  else {
    Identifier *id = (Identifier *)malloc(sizeof(Identifier));
    id->name = name;
    id->addr = line_num;
    id->next = identifiers;
    identifiers = id;
    return id;
  }
}

Identifier* registerIdentifier(char *name) {
  Identifier *lookup = lookupIdentifier(name);
  if (lookup) {
    return lookup;
  }
  else {
    Identifier *id = (Identifier *)malloc(sizeof(Identifier));
    id->name = name;
    id->next = identifiers;
    identifiers = id;
    return id;
  }
}

void printIdentifiers() {
  Identifier *id = identifiers;
  while (id != NULL) {
    printf("DAT %s: %d\n", id->name, id->addr);
    id = id->next;
  }
}

// INSTRUCTIONS

enum OppType {
  OT_NONE,
  OT_LITERAL,
  OT_IDENT,
};

typedef struct Instruction {
  int opcode;
  int oppType;
  int literalOperand;
  int *identOperand;
  struct Instruction *next;
} Instruction;

Instruction *instructionsHead = NULL;
Instruction *instructionTail = NULL;

void addInstruction(int opcode) {
  Instruction *newInstruction = (Instruction *)malloc(sizeof(Instruction));
  newInstruction->opcode = opcode;
  newInstruction->oppType = OT_NONE;
  newInstruction->next = NULL;
  if (!instructionsHead) {
    instructionsHead = newInstruction;
  }
  else {
    instructionTail->next = newInstruction;
  }
  instructionTail = newInstruction;
}

void addInstructionValue(int operand) {
  instructionTail->literalOperand = operand;
  instructionTail->oppType = OT_LITERAL;
}

void addInstructionIdentifier(char *name) {
  Identifier *id = registerIdentifier(name);
  instructionTail->identOperand = &id->addr;
  instructionTail->oppType = OT_IDENT;
}

void printInstructions(){
  Instruction *inst = instructionsHead;
  while (inst != NULL) {
    switch (inst->oppType) {
      case OT_NONE:
        printf("%03d\n", inst->opcode);
        break;
      case OT_LITERAL:
        printf("%d%02d\n", inst->opcode, inst->literalOperand);
        break;
      case OT_IDENT:
        printf("%d%02d\n", inst->opcode, *inst->identOperand);
      default:
        // throw error
        break;
    }
    inst = inst->next;
  }
}

void fprintInstructions(FILE *fptr){
  Instruction *inst = instructionsHead;
  while (inst != NULL) {
    switch (inst->oppType) {
      case OT_NONE:
        fprintf(fptr,"%03d\n", inst->opcode);
        break;
      case OT_LITERAL:
        fprintf(fptr,"%d%02d\n", inst->opcode, inst->literalOperand);
        break;
      case OT_IDENT:
        fprintf(fptr,"%d%02d\n", inst->opcode, *inst->identOperand);
      default:
        // throw error
        break;
    }
    inst = inst->next;
  }
}

%}

%union {
  int ival;
  char *sval;
}

%token ADD SUB 
%token STA LDA
%token BRA BRZ BRP
%token INP OUT OTC
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
    ADD { addInstruction(OP_ADD); } value //printf("%d",OP_ADD);
    | SUB { addInstruction(OP_SUB); } value //printf("%d",OP_SUB); 
    | STA { addInstruction(OP_STA); } value //printf("%d",OP_STA); 
    | LDA { addInstruction(OP_LDA); } value //printf("%d",OP_LDA); 
    | BRA { addInstruction(OP_BRA); } value //printf("%d",OP_BRA); 
    | BRZ { addInstruction(OP_BRZ); } value //printf("%d",OP_BRZ); 
    | BRP { addInstruction(OP_BRP); } value //printf("%d",OP_BRP); 
    | INP { addInstruction(OP_INP); } //printf("%d\n", OP_INP);
    | OUT { addInstruction(OP_OUT); } //printf("%d\n", OP_OUT);
    | OTC { addInstruction(OP_OTC); } //printf("%d\n", OP_OTC);
    | HLT { addInstruction(OP_HLT); } //printf("%d\n", OP_HLT);
    | IDENTIFIER DAT NUMBER { addInstruction($3); addIdentifier($1); } //printf("DAT %s: %d\n", $1, $3);
    | IDENTIFIER DAT { addInstruction(0); addIdentifier($1); } //printf("DAT %s\n", $1);
    | COMMENT { ; } //printf("%s\n", $1); } //TODO optional comment adding (such that inline remains inline and rest at end)
    ;
value:
    NUMBER { addInstructionValue($1); } //printf("%d\n", $1);
    | IDENTIFIER { addInstructionIdentifier($1); } //printf(" IDENTIFIER %s\n", $1);  
    ;
ENDLS:
    ENDL ENDLS
    | ENDL
    ;
%%

void yyerror(const char *s) {
    fprintf(stderr, "Line %d: Error: %s\n", line_num, s);
}