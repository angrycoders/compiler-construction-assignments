%{
#include <stdio.h>

extern FILE *yyin;
int num = 0;
%}

%start string

%token A
%token B
%%

string      : A string { num++; }
            | B
            ;
%%


void yyerror(char *s) { fprintf(stderr, "%s\n", s); }

int main(int argc, char **argv) {
    int ret_code = 0;

    if (argc != 2) {
        fprintf(stderr, "Missing input file\n");
        return 1;
    }

    yyin = fopen(argv[1], "r");
    ret_code = yyparse();

    if (0 != ret_code) {
        return ret_code;
    }

    printf("%d\n", num);
    return ret_code;
}
