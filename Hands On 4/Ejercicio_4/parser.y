%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
int yyparse(void);
int yyerror(char *s) { printf("Error: %s\n", s); return 0; }

#define MAX_SCOPE 10
#define MAX_ID 100
char *ambitos[MAX_SCOPE][MAX_ID] = {{0}};
int niveles[MAX_SCOPE] = {0};
int tope = 0;

void entrar_ambito() {
    if (tope + 1 >= MAX_SCOPE) {
        printf("Error: demasiados ámbitos anidados\n");
        exit(1);
    }
    tope++;
    niveles[tope] = 0;
}

void salir_ambito() {
    for (int j = 0; j < niveles[tope]; j++) {
        free(ambitos[tope][j]);
        ambitos[tope][j] = NULL;
    }
    niveles[tope] = 0;
    tope--;
}

void agregar_local(char *id) {
    if (niveles[tope] >= MAX_ID) {
        printf("Error: demasiadas variables en el ámbito actual\n");
        exit(1);
    }
    ambitos[tope][niveles[tope]++] = strdup(id);
}

int buscar_local(char *id) {
    for (int i = tope; i >= 0; i--) {
        for (int j = 0; j < niveles[i]; j++) {
            if (strcmp(ambitos[i][j], id) == 0) return 1;
        }
    }
    return 0;
}

void liberar_memoria() {
    for (int i = 0; i <= tope; i++) {
        for (int j = 0; j < niveles[i]; j++) {
            free(ambitos[i][j]);
            ambitos[i][j] = NULL;
        }
        niveles[i] = 0;
    }
    tope = 0;
}
%}

%union { char *str; }
%token <str> ID
%token INT LLAVEIZQ LLAVEDER PUNTOYCOMA

%%
programa:
	    
  | instrucciones 
    ;

bloque:
          LLAVEIZQ { entrar_ambito(); } instrucciones LLAVEDER { salir_ambito(); }
    ;

instrucciones:
  | instrucciones instruccion
    ;

instruccion:
	       INT ID PUNTOYCOMA { agregar_local($2); }
  | ID PUNTOYCOMA {
        if (!buscar_local($1))
            printf("Error semántico: '%s' no está declarado\n", $1);
    } // Uso de variable
  | bloque 
    ;
%%

int main() {
    int result = yyparse();
    liberar_memoria();
    return result;
}
