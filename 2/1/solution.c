/*
 * A simple calculator, using recursive descendent strategy and
 * mutually recursive routines, that performs integer arithmetic
 * involving '+' and '*'.
 *
 * The grammar:
 *
 *  program     : expression
 *  expression  : term plus term
 *              | term
 *  term        : factor mult factor
 *              | factor
 *  factor      : '(' expression ')'
 *              | number
 *  plus        : '+'
 *  mult        : '*'
 *  number      : [0-9]+
 */


#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>


#define true    1
#define false   0

typedef enum {
    LPAREN,
    RPAREN,
    PLUS,
    MULTIPLY,
    NUMBER,
    EOL,
} Symbol;
Symbol sym;
int sym_val_int;
FILE *input;

int program(void);
int expression(int *left);
int term(void);
int factor(void);
int number(void);


void error(const char *msg) {
    fprintf(stderr, "[ERROR] %s\n", msg);
    exit(EXIT_FAILURE);
}


void next_sym(void) {
    int character = fgetc(input);

    sym = -1;
    sym_val_int = 0;

    switch (character) {
    case EOF:
        sym = EOF;
        return;
    case '\n':
        sym = EOL;
        return;
    case ' ':
        return next_sym();
    case '(':
        sym = LPAREN;
        return;
    case ')':
        sym = RPAREN;
        return;
    case '+':
        sym = PLUS;
        return;
    case '*':
        sym = MULTIPLY;
        return;
    }

    while (isdigit(character)) {
        sym = NUMBER;
        sym_val_int = (sym_val_int * 10) + (character - '0');
        character = fgetc(input);
    }
    if (NUMBER == sym) {
        ungetc(character, input); // check return code!
        return;
    }

    error("next_sym: Unrecognized symbol");
}


int accept_sym(Symbol s) {
    if (s == sym) {
        next_sym();
        return true;
    }
    return false;
}


int expect_sym(Symbol s) {
    if (accept_sym(s)) return true;
    error("expect_sym: Unexpected symbol");
    return false;
}


int number(void) {
    if (NUMBER != sym) {
        error("number: Not a number");
    }
    int value = sym_val_int;
    next_sym();
    return value;
}


int factor(void) {
    int value;

    if (accept_sym(LPAREN)) {
        value = expression(NULL);
        expect_sym(RPAREN);
    } else {
        value = number();
    }

    return value;
}


int term(void) {
    int value = factor();

    if (MULTIPLY == sym) {
        next_sym();
        value = value * factor();
    }

    return value;
}


int expression(int *left) {
    int value;

    if (left != NULL) {
        value = *left;
    } else {
        value = term();
    }

    if (PLUS == sym) {
        next_sym();
        value = value + term();
    }

    return value;
}


int program(void) {
    int value;
    int *left = NULL;

    next_sym();
    while (EOL != sym) {
        value = expression(left);
        left = &value;
    }

    return value;
}


int main(int argc, char **argv) {
    int do_help = false;
    int do_script = false;

    if (argc > 1) {
        do_help = NULL != strstr(argv[1], "--help");
        do_script = !do_help;
    }

    if (do_help) {
        printf("usage:\n");
        printf("\t%s              Enter interpreter mode\n", argv[0]);
        printf("\t%s <path>       Use input file at <path>\n", argv[0]);
        printf("\t%s --help       Show help information\n", argv[0]);
        return 0;
    }

    if (do_script) {
        input = fopen(argv[1], "r");
        if (NULL == input) {
            perror("main");
            const char *msg =
                "main: Could not open input file. "
                "Please ensure that the file exists "
                "and that you have provided the correct path to it.";
            error(msg);
        }

        printf("%d\n", program());
        return 0;
    }

    puts("Entering interpreter mode. Use Ctrl+C to quit.");
    input = stdin;
    while (EOF != sym) {
        printf("> ");
        printf("%d\n", program());
    }

    return 0;
}
