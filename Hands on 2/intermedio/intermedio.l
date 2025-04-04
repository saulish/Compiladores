%{
#include <stdio.h>
%}

%%
"int"                   { printf("Palabra clave: int\n"); }
"return"                { printf("Palabra clave: return\n"); }
"//".*                 { /* Ignorar comentarios de una línea */ }
"/*"([^*]|\*+[^*/])*\*+\/ { /* Ignorar comentarios multilínea */ }
\"([^\\\"]|\\.)*\"      { printf("Cadena: %s\n", yytext); }
[a-zA-Z_][a-zA-Z0-9_]*   { printf("Identificador: %s\n", yytext); }
[0-9]+                  { printf("Número: %s\n", yytext); }
[ \t\n]+                { /* Ignorar espacios en blanco */ }
.                       { printf("Carácter desconocido: %s\n", yytext); }
%%

int main() {
    yylex();
    printf("Fin del test intermedio \n");
    return 0;
}
