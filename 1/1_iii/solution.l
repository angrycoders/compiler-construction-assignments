%{
#include <stdio.h>
%}

%%
abc printf("ABC");
%%

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Input file missing\n");
        return 1;
    }
    yyin =fopen(argv[1], "r");
    yylex();
    return 0;
}

int yywrap() { return(1); }
