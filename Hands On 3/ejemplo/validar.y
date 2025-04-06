%{
#include <stdio.h>
#include <stdlib.h>

/* Prototipos para evitar warnings */
int yylex(void);
int yyerror(char *s);
int yywrap(void);
%}

%token NUMBER
%left '+' '-'
%left '*' '/'
%right UMINUS

%%
input:  expr '\n' { printf("Expresión válida\n"); }
      | error '\n' { yyerror("Expresión inválida"); yyerrok; }
      ;

expr: expr '+' expr
    | expr '-' expr
    | expr '*' expr
    | expr '/' expr
    | '-' expr %prec UMINUS
    | '(' expr ')'
    | NUMBER
    ;
%%

int yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
    return 0;
}

/* Evita el undefined reference de flex */
int yywrap(void) {
    return 1;
}

/* Punto de entrada */
int main(void) {
    return yyparse();
}
