%{
#include <stdio.h>

extern FILE *yyin;
%}

%start program

%token INTEGER
%token PLUS
%token MINUS
%token LPAREN
%token RPAREN

%left '+' '-'

%%

program     : expression { printf("%d\n", $1); } ;
expression  : term { $$ = $1; }
            | expression PLUS expression { $$ = $1 + $3; }
            | expression MINUS expression { $$ = $1 - $3; }
            | LPAREN expression RPAREN { $$ = $2; }
            ;
term        : PLUS INTEGER { $$ = $2; }
            | MINUS INTEGER { $$ = -$2; }
            | INTEGER { $$ = $1; }
            ;
%%


void yyerror(char *s) { fprintf(stderr, "%s\n", s); }

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Missing input file\n");
        return 1;
    }
    yyin = fopen(argv[1], "r");
    yyparse();
    return 0;
}
