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


#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>


#define true    1
#define false   0

typedef enum {
    LPAREN,
    RPAREN,
    PLUS,
    MULTIPLY,
    NUMBER,
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
    case ' ':
    case '\n':
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
    while (EOF != sym) {
        value = expression(left);
        left = &value;
    }

    return value;
}


int main(int argc, char **argv) {
    if (argc < 1) {
        error("Missing input file");
    }
    input = fopen(argv[1], "r");
    printf("%d\n", program());
    return 0;
}
