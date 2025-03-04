%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define YYDEBUG 1
#define YYERROR_VERBOSE 1

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

typedef struct Identifier
{
  char *name;
  int addr;
  struct Identifier *next;
} Identifier;

Identifier *identifiers = NULL;

Identifier *lookupIdentifier(const char *name)
{
  // returns pointer to Identifier if exists else NULL
  Identifier *id = identifiers;
  while (id)
  {
    if (strcmp(id->name, name) == 0)
    {
      return id;
    }
    id = id->next;
  }
  return NULL;
}

Identifier *addIdentifier(char *name)
{
  Identifier *lookup = lookupIdentifier(name);
  if (lookup)
  {
    lookup->addr = line_num - 1;
    return lookup;
  }
  else
  {
    Identifier *id = (Identifier *)malloc(sizeof(Identifier));
    id->name = name;
    id->addr = line_num - 1;
    id->next = identifiers;
    identifiers = id;
    return id;
  }
}

Identifier *registerIdentifier(char *name)
{
  Identifier *lookup = lookupIdentifier(name);
  if (lookup)
  {
    return lookup;
  }
  else
  {
    Identifier *id = (Identifier *)malloc(sizeof(Identifier));
    id->name = name;
    id->next = identifiers;
    identifiers = id;
    return id;
  }
}

void printIdentifiers()
{
  Identifier *id = identifiers;
  while (id != NULL)
  {
    printf("DAT %s: %d\n", id->name, id->addr);
    id = id->next;
  }
}

void deleteIdentifier(Identifier *id)
{
  if (id->name != NULL)
  {
    free(id->name);
  }
  free(id);
}

void deleteIdentifiers()
{
  if (identifiers != NULL)
  {
    Identifier *id = identifiers;
    Identifier *next;
    while (id != NULL)
    {
      next = id->next;
      deleteIdentifier(id);
      id = next;
    }
    identifiers = NULL;
  }
}

// INSTRUCTIONS

enum OppType
{
  OT_NONE, // No opp
  OT_LITERAL, // Literal int opp
  OT_IDENT, // Opp value from Identifier
};

typedef struct Instruction
{
  int opcode;
  int oppType;
  int literalOperand;
  int *identOperand;
  struct Instruction *next;
} Instruction;

Instruction *instructionsHead = NULL;
Instruction *instructionTail = NULL;

void addInstruction(int opcode)
{
  Instruction *newInstruction = (Instruction *)malloc(sizeof(Instruction));
  newInstruction->opcode = opcode;
  newInstruction->oppType = OT_NONE;
  newInstruction->next = NULL;
  if (!instructionsHead)
  {
    instructionsHead = newInstruction;
  }
  else
  {
    instructionTail->next = newInstruction;
  }
  instructionTail = newInstruction;
}

void addInstructionValue(int operand)
{
  instructionTail->literalOperand = operand;
  instructionTail->oppType = OT_LITERAL;
}

void addInstructionIdentifier(char *name)
{
  Identifier *id = registerIdentifier(name);
  instructionTail->identOperand = &id->addr;
  instructionTail->oppType = OT_IDENT;
}

void fprintInstructions(FILE *fptr)
{
  Instruction *inst = instructionsHead;
  while (inst != NULL)
  {
    switch (inst->oppType)
    {
    case OT_NONE:
      fprintf(fptr, "%03d\n", inst->opcode);
      break;
    case OT_LITERAL:
      fprintf(fptr, "%d%02d\n", inst->opcode, inst->literalOperand);
      break;
    case OT_IDENT:
      fprintf(fptr, "%d%02d\n", inst->opcode, *inst->identOperand);
    default:
      // TODO Raise Error / Error Handling
      break;
    }
    inst = inst->next;
  }
}

void printInstructions()
{
  fprintInstructions(stdout);
}

void sprintInstructions(char *str)
{
  // TODO? use snprintf for safety?
  Instruction *inst = instructionsHead;
  int length = 0;
  while (inst != NULL)
  {
    switch (inst->oppType)
    {
    case OT_NONE:
      length += sprintf(str + length, "%03d\n", inst->opcode);
      break;
    case OT_LITERAL:
      length += sprintf(str + length, "%d%02d\n", inst->opcode, inst->literalOperand);
      break;
    case OT_IDENT:
      length += sprintf(str + length, "%d%02d\n", inst->opcode, *inst->identOperand);
    default:
      // TODO Raise Error / Error Handling
      break;
    }
    inst = inst->next;
  }
}

void bufferInstructions(int *buffer)
{
  Instruction *inst = instructionsHead;
  int index = 0;
  while (inst != NULL)
  {
    switch (inst->oppType)
    {
    case OT_NONE:
      buffer[index++] = inst->opcode;
      break;
    case OT_LITERAL:
      buffer[index++] = inst->opcode * 100 + inst->literalOperand;
      break;
    case OT_IDENT:
      buffer[index++] = inst->opcode * 100 + *inst->identOperand;
      break;
    default:
      // TODO Raise Error / Error Handling
      break;
    }
    inst = inst->next;
  }
  buffer[index++] = NULL;
}


void deleteInstruction(Instruction *inst)
{
  free(inst);
}

void deleteInstructions()
{
  if (instructionsHead != NULL)
  {
    Instruction *inst = instructionsHead;
    Instruction *next;
    while (inst != NULL)
    {
      next = inst->next;
      deleteInstruction(inst);
      inst = next;
    }
    instructionsHead = NULL;
    instructionTail = NULL;
  }
}

void flushParser()
{
  line_num = 0;
  deleteIdentifiers();
  deleteInstructions();
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
    program instruction_1 ENDLS;
    | instruction_1 ENDLS;
    | ENDLS;
    ;
instruction_1:
    | IDENTIFIER { addIdentifier($1); } instruction;
    | instruction;
    ;
instruction:
    ADD { addInstruction(OP_ADD); } value
    | SUB { addInstruction(OP_SUB); } value
    | STA { addInstruction(OP_STA); } value
    | LDA { addInstruction(OP_LDA); } value
    | BRA { addInstruction(OP_BRA); } value
    | BRZ { addInstruction(OP_BRZ); } value
    | BRP { addInstruction(OP_BRP); } value
    | INP { addInstruction(OP_INP); }
    | OUT { addInstruction(OP_OUT); }
    | OTC { addInstruction(OP_OTC); }
    | HLT { addInstruction(OP_HLT); }
    | IDENTIFIER DAT NUMBER { addIdentifier($1); addInstruction($3); }
    | IDENTIFIER DAT { addIdentifier($1); addInstruction(0); }
    | COMMENT { ; } //TODO optional comment adding (such that inline remains inline and rest at end)
    ;
value:
    NUMBER { addInstructionValue($1); }
    | IDENTIFIER { addInstructionIdentifier($1); }
    ;
ENDLS:
    ENDL ENDLS
    | ENDL
    ;
%%

void yyerror(const char *s)
{
  fprintf(stderr, "Line %d: Error: %s\n", line_num, s);
}