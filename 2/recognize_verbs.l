%{
#include <stdio.h>
%}

%%
[\t]+
is |
am |
are |
were |
was |
be |
being |
been |
doing |
does |
did |
will |
would |
should |
can |
could |
has |
have |
had |
go { printf("%s ", yytext);}
.|\n
%%
int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Input file missing\n");
        return 1;
    }
    printf("Verbs found:\n\n");
    yyin= fopen(argv[1], "r");
    yylex();
    puts("");
    return 0;
}

int yywrap() { return(1); }
