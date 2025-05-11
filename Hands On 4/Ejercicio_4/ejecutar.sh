rm lex.yy.c
rm parser.tab.c
rm parser.tab.h
rm verificador

echo "Compilando el analizador..."

bison -d parser.y
flex scanner.l
gcc -o verificador parser.tab.c lex.yy.c -lfl
./verificador < entrada.txt