/*
 * A simple calculator, using recursive descendent strategy and
 * mutually recursive routines, that performs integer arithmetic
 * involving '+' and '*'.
 *
 * The grammar:
 *
 *  program     : expression
 *  expression  : number operator number
 *              | '(' expression ')'
 *              | number
 *  operator    : '+' | '*'
 *  number      : [0-9]+
 */


#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>


#define true    1
#define false   0

typedef enum {
    EXPRESSION,
    LPAREN,
    RPAREN,
    OPERATOR,
    PLUS,
    MULTIPLY,
    NUMBER,
} Symbol;
Symbol sym;
int sym_val_int;
FILE *input;

int program(void);
int expression(void);
int operator(void);
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
        sym = OPERATOR;
        sym_val_int = PLUS;
        return;
    case '*':
        sym = OPERATOR;
        sym_val_int = MULTIPLY;
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


int operator(void) {
    if (OPERATOR != sym) {
        error("operator: Not an operator");
    }
    int value = sym_val_int;
    next_sym();
    return value;
}

int number(void) {
    if (NUMBER != sym) {
        error("number: Not a number");
    }
    int value = sym_val_int;
    next_sym();
    return value;
}

int expression(void) {
    int value;

    if (accept_sym(LPAREN)) {
        value = expression();
        expect_sym(RPAREN);
    } else if (NUMBER == sym) {
        value = sym_val_int;
        next_sym();
        if (OPERATOR == sym) {
            int value_1 = value;
            int op = operator();
            int value_2 = number();
            if (PLUS == op) {
                value = value_1 + value_2;
            } else {
                value = value_1 * value_2;
            }
        }
    }

    return value;
}


int program(void) {
    next_sym();
    return expression();
}


int main(int argc, char **argv) {
    if (argc < 1) {
        error("Missing input file");
    }
    input = fopen(argv[1], "r");
    printf("%d\n", program());
    return 0;
}
