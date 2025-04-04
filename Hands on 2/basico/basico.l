%{
#include <stdio.h>
%}

%%
"int"           { printf("Palabra clave: int\n"); }
"return"        { printf("Palabra clave: return\n"); }
[a-zA-Z_][a-zA-Z0-9_]* { printf("Identificador: %s\n", yytext); }
[0-9]+          { printf("Número: %s\n", yytext); }
[ \t\n]+        { /* Ignorar espacios en blanco */ }
.               { printf("Carácter desconocido: %s\n", yytext); }
%%

int main() {
    yylex();
    printf("Fin del test basico\n");
    return 0;
}
