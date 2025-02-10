%{
#include <stdio.h>
#include <string.h>
#include "parser.h"
extern int isatty(int) { return 0; }
int line_num = 1;
%}
%option nounistd
%option noyywrap
%%
"ADD"       { return ADD; }
"SUB"       { return SUB; }
"STA"       { return STA; }
"LDA"       { return LDA; }
"BRA"       { return BRA; }
"BRZ"       { return BRZ; }
"BRP"       { return BRP; }
"INP"       { return INP; }
"OUT"       { return OUT; }
"OTC"       { return OTC; }
"HLT"       { return HLT; }
"DAT"       { return DAT; }

[0-9]+      { yylval.ival = atoi(yytext); return NUMBER; }
[A-Za-z][A-Za-z0-9]*  { yylval.sval = strdup(yytext); return IDENTIFIER; }
\n          { ++line_num; return ENDL; }
[ \t]+      { /* Ignore spaces and tabs */ }
.           { printf("Unrecognized token: %s\n", yytext); }
"//".*      { yylval.sval = strdup(yytext); return COMMENT; }
%%