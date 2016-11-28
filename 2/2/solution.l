%{
#include <stdlib.h>
#include "y.tab.h"

void yyerror(char *);
%}

%%
"a"     { return A; }
"b"     { return B; }
[ \t]   ;
.       { yyerror("Unexpected character"); }
%%

int yywrap() { return 1; }
