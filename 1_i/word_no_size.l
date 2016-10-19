%{
#include <stdio.h>
#include <string.h>

int words = 0, total_size = 0;
%}

word [a-zA-Z0-9]+

%%
{word} { words++; total_size += yyleng; ECHO; }

%%
int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Missing input file\n");
        return 1;
    }
    yyin = fopen(argv[1], "r");
    yylex();
    printf("\nwords: %d\n", words);
    printf("total size: %d\n", total_size);
    return 0;
}
int yywrap() { return(1); }
