%{
#include <stdio.h>
%}

wb [^a-zA-Z0-9]+

%%
{wb}is{wb} |
{wb}am{wb} |
{wb}are{wb} |
{wb}were{wb} |
{wb}was{wb} |
{wb}be{wb} |
{wb}being{wb} |
{wb}been{wb} |
{wb}doing{wb} |
{wb}does{wb} |
{wb}did{wb} |
{wb}will{wb} |
{wb}would{wb} |
{wb}should{wb} |
{wb}can{wb} |
{wb}could{wb} |
{wb}has{wb} |
{wb}have{wb} |
{wb}had{wb} |
{wb}go{wb} { printf("%s ", yytext);}
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
