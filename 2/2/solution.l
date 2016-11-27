%{
#include <stdio.h>
#include <string.h>

int num = 0;

%}

word [a-zA-Z0-9]+

%%
(a)+b {
    // 'yytext' includes the trailing 'b',
    // thus the 'minus one' accommodates for that
    num = (int) strlen(yytext) - 1;
}
.|\n

%%
int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Missing input file\n");
        return 1;
    }
    yyin = fopen(argv[1], "r");
    yylex();
    printf("%d\n", num);
    return 0;
}
int yywrap() { return(1); }
