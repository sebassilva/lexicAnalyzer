%{
/**
* titulo:       Analizador lexico
* hecho por:    Silva Sebastian, Mejia Aaron
* Compiladores  Grupo 2
* Facultad de Ingenieria UNAM
*/        
#include <string.h>

FILE *archSal;
void regexMatched(char *text);
void handleErr(char *err);
int findInStaticTable(char *text, char *table[]);
int line = 0;
%}

charmayus [A-Z]
charminus [a-z]
numeros [0-9]

espacio [ ]
salto [\n]
tab [\t]

reservadas Bul|Cadena|Cierto|Entero|Falso|Haz|Mientras|Para|Real|Si|Sino
identificador {charminus}(({charmayus}|{charminus}){0,7})[^{numeros}{salto}]
especiales \(|\)|\[|\]|,|;
asignacion :=
relacionales \.DIF\.|\.IGL\.|\.MN\.|\.MNI\.|\.MY\.|\.MYI\.
aritmeticos \+|-|\*|\/|%
entero {numeros}+
real ({numeros}+\.|\.{numeros}+){numeros}*
cientifico ({real}|{entero})(e|E)(\+|-)?{entero}
cadena \"[^"](\\.|[^\\"])*\"


%%
{reservadas}    fprintf(archSal, "reservadas ");    regexMatched(0, yytext, -1);
{identificador} fprintf(archSal, "identificador "); regexMatched(1, yytext, i.push(yytext)); //push() buscar, insertar, return ix
{especiales}    fprintf(archSal, "especiales ");    regexMatched(2, yytext, -1);
{asignacion}    fprintf(archSal, "asignacion ");    regexMatched(3, yytext, -1);
{relacionales}  fprintf(archSal, "relacionales");   regexMatched(4, yytext, -1);
{aritmeticos}   fprintf(archSal, "aritmeticos");    regexMatched(5, yytext, -1);
{cadena}        fprintf(archSal, "cadena");         regexMatched(6, yytext, c.push(yytext)); //push() inseta, return ix
{entero}        fprintf(archSal, "entero");         regexMatched(7, yytext, e.push(yytext)); //push() buscar, insertar, return ix
{real}          fprintf(archSal, "real");           regexMatched(8, yytext, r.push(yytext)); //push() buscar, insertar, return ix
{cientifico}    fprintf(archSal, "cientifico");     regexMatched(8, yytext, r.push(yytext)); //push() buscar, insertar, return ixreturn ix 
{espacio}       fprintf(archSal, " "); 
{salto}         fprintf(archSal, "\n"); line++;
{tab}           fprintf(archSal, "\t"); 
.               fprintf(archSal, "error line %d {%s}", line, yytext); handleErr(yytext);


%%





int main(int argc, char *argv[]) {
    yyin = fopen(argv[1],"r");
    archSal = fopen("salida.txt","w");
    yylex();
    fclose(archSal);
    return 0;
}

void regexMatched(int class, char *text, int ix){

    if(ix == -1){
        //Tabla estática
        ix = findInStaticTable(class, text);
        tokens.push(class, staticIx);
    }


    //Verificar a qué tabla debe ir
    if(ix == -1){
        //TABLAS ESTATICAS
        //Buscar ix en tabla estática de la clase a la que 
        ix = c:
    }
        //TABLAS DINAMICAS
        //push en tabla dinamica que regresa ix 
    //entonces push a tabla principal
    
    printf("%s detected", text);
}



int findInStaticTable(int class, char *text){
    char *table[]; //?

    switch(class){
        case 0: 
        table = RESERVADAS;
        break;

        case 2: 
        table = ESPECIALES;
        break;

        case 3: 
        table = ASIGNACION;
        break;

        case 4: 
        table = RELACIONALES;
        break;

        case 5: 
        table = ARITMETICOS;
        break;

    }
    int size =  sizeof(table) / sizeof(table[0]);
    for(int i=0; i<= size; i++){
        if(strcmp(text, table[i]) == 0){
            return i;
        }
    }
    return -1;
}
