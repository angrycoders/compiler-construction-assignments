%{
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int words = 0;
// we are storing the 'different' words in a 'cache' variable.
// words from the input will be searched in this variable
char *cache = NULL;
%}

letter [a-zA-Z0-9]
digit [0-9]
word ({letter}|{digit})+

%%
{word} {
            int ret_code = 0;
            char *target = NULL;
            char *found = NULL;
            // we add a 'space' after the word to ensure that the
            // entire word is found. The space serves as the word
            // boundary.
            ret_code = asprintf(&target, " %s ", yytext);
            if (ret_code < 0) {
                perror("finding word failed");
                exit(1);
            }
            // remember that our cache starts empty. We must ensure
            // not to cause a segfault by searching using a null pointer
            if (NULL != cache) {
                found = strstr(cache, target);
            }
            // if the word has NOT been found
            if (NULL == found) {
                words++;
                // store this new different word into the cache
                ret_code = asprintf(&cache, "%s%s", cache, target);
                if (ret_code < 0) {
                    perror("caching word failed");
                    exit(1);
                }
                ECHO;
            }
       }
. |\n
%%

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Input file missing\n");
        return 1;
    }
    yyin = fopen(argv[1], "r");
    yylex();
    printf("\nwords: %d\n", words);
    return 0;
}
int yywrap() { return(1); }
