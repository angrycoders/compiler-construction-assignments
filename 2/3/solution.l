%{
#include <stdlib.h>
#include "y.tab.h"

void yyerror(char *);
%}

%%
[0-9]   {
    yylval = atoi(yytext);
    return INTEGER;
}
"+"     { return PLUS; }
"-"     { return MINUS; }
"("     { return LPAREN; }
")"     { return RPAREN; }
[ \t]   ;
.       { yyerror("Unexpected character"); }
%%

int yywrap() { return 1; }
