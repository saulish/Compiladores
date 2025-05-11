%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int yylex(void);
int yyerror(const char *s) { fprintf(stderr, "Error: %s\n", s); return 0; }

#define MAX 100
typedef struct { char *id; int tipo; } Simbolo;
Simbolo tabla[MAX];
int ntabla = 0;

void agregar(char *id, int tipo) {
  tabla[ntabla++] = (Simbolo){ strdup(id), tipo };
}

int buscar(char *id) {
  for (int i = 0; i < ntabla; i++)
    if (tabla[i].id && strcmp(tabla[i].id, id) == 0)
      return tabla[i].tipo;
  return -1;
}
%}

%union {
  char *str;
  int num;
}
%token <str> ID
%token <num> NUMBER
%token INT IGUAL PUNTOYCOMA
%type  <num> expr

%%

programa:
    declaraciones
  ;

declaraciones:
    declaracion
  | declaraciones declaracion
  ;

declaracion:
    /* 1) Declaración de variable */
    INT ID PUNTOYCOMA
      { agregar($2, 0); /* 0 = int */ }

  | /* 2) Asignación: ID = expr; */
    ID IGUAL expr PUNTOYCOMA
      {
        int t1 = buscar($1);  
        int t2 = $3;        
        if (t1 < 0)
          printf("Error: identificador '%s' no declarado\n", $1);
        else if (t2 < 0)
          printf("Error: identificador no declarado\n");
        else if (t1 != t2)
          printf("Error: tipos incompatibles\n");
      }
  ;

expr:
    ID      { $$ = buscar($1); }
  | NUMBER  { $$ = 0;              }
  ;
%%
int main() { return yyparse(); }
