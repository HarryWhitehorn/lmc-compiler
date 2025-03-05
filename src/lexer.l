%{
#include <stdio.h>
#include <string.h>
#include "parser.h"
extern int isatty(int) { return 0; } // Windows compatibility (input is not terminal anyway)
int line_num = 1;
%}
%option nounistd
%option noyywrap
%option caseless
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

[0-9]+      { yylval.ival = atoi(yytext); return NUMBER; } // Number
[A-Za-z][A-Za-z0-9]*  { yylval.sval = strdup(yytext); return IDENTIFIER; } // Identifier
\n          { ++line_num; return ENDL; } // Linebreak
[ \t]+      { /* Ignore spaces and tabs */ } // Whitespace
.           { printf("Unrecognized token: %s\n", yytext); } // Unknown
"//".*      { yylval.sval = strdup(yytext); return COMMENT; } // Comments
%%