%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int yylex(void);
int yyerror(const char *s) { fprintf(stderr, "Error: %s\n", s); return 0; }

#define MAX_FUN 100
typedef struct {
  char *id;
  int aridad;
} Func;

Func funcs[MAX_FUN];
int nfunc = 0;

void declarar(char *id, int a) {
  funcs[nfunc++] = (Func){ strdup(id), a };
}

int aridad(const char *id) {
  for (int i = 0; i < nfunc; i++)
    if (strcmp(funcs[i].id, id) == 0)
      return funcs[i].aridad;
  return -1;
}
%}
%union {
  char *str;
  int   num;
}

%token <str> ID
%token       FUNC PARIZQ PARDER COMA PUNTOYCOMA

%type  <num> parametros lista_param argumentos lista_arg

%%

programa:
    declaraciones
  ;

declaraciones:
    declaracion
  | declaraciones declaracion
  ;

declaracion:
    FUNC ID PARIZQ parametros PARDER PUNTOYCOMA
      {
        declarar($2, $4);
      }
  |
    ID PARIZQ argumentos PARDER PUNTOYCOMA
      {
        int esp = aridad($1);
        if (esp < 0)
          printf("Error: función '%s' no declarada\n", $1);
        else if (esp != $3)
          printf("Error: función '%s' espera %d argumentos\n", $1, esp);
      }
  ;

parametros:
    { $$ = 0; }
  | lista_param
    { $$ = $1; }
  ;

lista_param:
    ID
      { $$ = 1; }
  | lista_param COMA ID
      { $$ = $1 + 1; }
  ;

argumentos:
    { $$ = 0; }
  | lista_arg
    { $$ = $1; }
  ;

lista_arg:
    ID
      { $$ = 1; }
  | lista_arg COMA ID
      { $$ = $1 + 1; }
  ;
%%

int main(void) {
  return yyparse();
}