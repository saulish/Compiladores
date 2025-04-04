%{
#include <stdio.h>
#include <string.h>

/* Contadores para cada categoría */
int count_keywords = 0;
int count_identifiers = 0;
int count_numbers = 0;
int count_operators = 0;
int count_delimiters = 0;

/* Función para imprimir resultados */
void imprimir_resultados() {
    printf("\nResumen de tokens:\n");
    printf("Palabras clave: %d\n", count_keywords);
    printf("Identificadores: %d\n", count_identifiers);
    printf("Números: %d\n", count_numbers);
    printf("Operadores: %d\n", count_operators);
    printf("Delimitadores: %d\n", count_delimiters);
}
%}

%%

"int"                   { printf("Palabra clave: int\n"); count_keywords++; }
"return"                { printf("Palabra clave: return\n"); count_keywords++; }
\+|\-|\*|\/|=|==       { printf("Operador: %s\n", yytext); count_operators++; }
[(){};,]               { printf("Delimitador: %s\n", yytext); count_delimiters++; }
[a-zA-Z_][a-zA-Z0-9_]*  { printf("Identificador: %s\n", yytext); count_identifiers++; }
[0-9]+                 { printf("Número: %s\n", yytext); count_numbers++; }
"//".*                { /* Ignorar comentarios de una línea */ }
"/*"([^*]|\*+[^*/])*\*+\/  { /* Ignorar comentarios multilínea */ }
\"([^\\\"]|\\.)*\"     { printf("Cadena: %s\n", yytext); }  /* No se cuenta en este ejemplo */
[ \t\n]+               { /* Ignorar espacios en blanco */ }
.                      { /* Otros caracteres */ }
%%

int main() {
    yylex();
    imprimir_resultados();
    printf("Fin del test avanzado\n");
    return 0;
}
