%{
/**
* Facultad de Ingenieria UNAM
*
* Titulo:       Analizador lexico
* Hecho por:    Silva Sebastian, Mejia Ortiz Aaron
* Compiladores  Grupo 2
* 
*
* Objetivo: 	Analizador lexico en flex y ANSI 
* 				C que reconozca componentes lexicos 
*				pertenecientes al un lenguaje definido.
*/        
#include <stdlib.h>
#include <string.h>

/* ----------------------------  Cola con enteros --------------------------- */
	typedef struct intNode{  
		int class;
		int value;
		
		struct intNode * prev;
		struct intNode * next;
	}intNode;

	typedef struct intQueue {   
		struct intNode * head; 
		struct intNode * tail;
		int size;
	}intQueue;

int findIndex(char **table, char *text, int size);


	// Mete a la cola, al final de la cola
	void enqueueInt(intQueue * q, int class, int value) {
		intNode * new = (intNode*)malloc(sizeof(intNode));
		new->class = class;
        new->value = value;
		if (q->head == NULL) { // si la cola está vacía
			new->next  = NULL;
			new->prev = NULL;
			q->head = new;
			q->tail = new;
			q->size += 1;
			return;
		}
		// si no está vacia manda al final
		new->next  = NULL;
		new->prev = q->tail;

		q->tail->next = new;
		q->tail = new;
		q->size += 1;
		return;
	}


	// Regresa el proceso al inicio de la cola
	intNode * dequeueInt(intQueue * q) {
		intNode * p = (intNode*)malloc(sizeof(intNode));

		if (q->head == NULL) { // si está vacia
			q->size -= 1;
			return NULL;
		}

		if (q->head == q->tail) { // si es el ultimo elemento de la cola
			p = q->head;
			q->head = NULL;
			q->tail = NULL;
			q->size -= 1;
			return p;
		}

		 p = q->head;
		 q->head->next->prev = NULL;
		 q->head = q->head->next;
		 q->size -= 1;
		 return p ;
	}


	void printIntQueue(intQueue * q) {
		printf("\n -- TOKENS: -- \n");
		printf("\n Clase\t Valor\n");
		intNode * cursor = (intNode*)malloc(sizeof(intNode));

		cursor = q->head;
		while(cursor != NULL) {
			printf("\n %d\t%d", cursor->class, cursor->value);
			cursor = cursor->next;
		}

		printf("\n -- ----- -- \n");
		return;
	}


	int searchIntQueue(intQueue * q, int value) {
		intNode * cursor = (intNode*) malloc(sizeof(intNode));
		cursor = q->head;
		while( cursor != NULL) {
			if (cursor->value == value)
				return cursor->class;
			cursor = cursor->next;
		}
		return -1;
	}

	void initIntQueue(intQueue * q) {
		q->head = NULL;
		q->tail = NULL;
		return;
	}


	void pushInt(intQueue * q, int class, int  value){
		enqueueInt(q, class, value);
	}


/* ----------------------------  Cola de strings ---------------------------- */

    typedef struct strNode{  
        int index;
        char * value;
        
        struct strNode * prev;
        struct strNode * next;
    }strNode;


    typedef struct strQueue {   
        struct strNode * head; 
        struct strNode * tail;

        int size;
    }strQueue;


	// Mete a la cola, al final de la cola
	void enqueueStr(strQueue * q, int index, char *  value) {
		strNode * new = (strNode*)malloc(sizeof(strNode));
		
		new->index = index;
        new->value = (char*) malloc(sizeof(char)*strlen(value));
        strcpy(new->value, value);

		if (q->head == NULL) { // si la cola está vacía

			new->next  = NULL;
			new->prev = NULL;

			q->head = new;
			q->tail = new;

			q->size += 1;
			return;
		}
		// si no está vacia manda al final
		new->next  = NULL;
		new->prev = q->tail;

		q->tail->next = new;
		q->tail = new;
		q->size += 1;

		return;
	}


	// Regresa el proceso al inicio de la cola
	strNode * dequeueStr(strQueue * q) {
		strNode * p = (strNode*)malloc(sizeof(strNode));

		if (q->head == NULL) { // si está vacia
			q->size -= 1;
			return NULL;
		}

		if (q->head == q->tail) { // si es el ultimo elemento de la cola
			p = q->head;
			q->head = NULL;
			q->tail = NULL;
			q->size -= 1;
			return p;
		}

		 p = q->head;

		 q->head->next->prev = NULL;
		 q->head = q->head->next;
		 q->size -= 1;
		 return p ;
	}


	void printStrQueue(strQueue * q, char * title) {
		printf("\n -- %s -- \n", title);
		printf("\n index\tvalue\n");
		strNode * cursor = (strNode*)malloc(sizeof(strNode));

		cursor = q->head;
		while(cursor != NULL) {
			printf("\n %d\t%s", cursor->index, cursor->value);
			cursor = cursor->next;
		}

		printf("\n -- ----- -- \n");
		return;
	}


	int searchStrQueue(strQueue * q, char * value) {
		strNode * cursor = (strNode*) malloc(sizeof(strNode));
		cursor = q->head;
		while( cursor != NULL) {
			if (!strcmp(cursor->value, value))
				return cursor->index;
			cursor = cursor->next;
		}

		return -1;
	}


	void initStrQueue(strQueue * q) {
		q->head = NULL;
		q->tail = NULL;
		return;
	}


    //funcion push interfaz con la cola
    int pushStr(strQueue * q, int flag, char * value){
        //la bandera viene = 1 si: es identificador, entero o real / = 0 si es cadena
        int index;
        
        if (flag == 1 ){ //si tiene flag = 1 busca coincidencia antes de insertar
            index = searchStrQueue(q, value); //sac el index del elemento si existe
        
            if (index != -1) //si se encuentra un valor regresa el index
                return index;
        
        } //si no tiene la bandera o si no se encontró, lo inserta

        enqueueStr(q, q->size, value);
        return q->size-1;
    }
/*--------------------------------------------------------------------------- */

FILE *archSal;
void regexMatched(int class, char *text, int ix);
int findInStaticTable(int class, char *text);
int line = 1;


// Declaracion de tablas estaticas
char *RESERVADAS[] = {
    "Bul", "Cadena", "Cierto", 
    "Entero", "Falso", "Haz", 
    "Mientras", "Para", "Real",
    "Si","Sino"
    };

char *ESPECIALES[] = {"(", ")", ",", ";", "[", "]"};

char *ASIGNACION[] = {":="};

char *RELACIONALES[] = {
    ".DIF.",".IGL.",
    ".MN.", ".MNI.",
    ".MY.", ".MYI."
    };  
    
char *ARITMETICOS[] = {"+","-","*","/","%"} ;

// Declaracion de listas
strQueue * i;
strQueue * c;
strQueue * e;
strQueue * r;

intQueue * tokens;
%}

charmayus [A-Z]
charminus [a-z]
numeros [0-9]

espacio [ ]
salto [\n]
tab [\t]
comentario ($$(.*))

reservadas Bul|Cadena|Cierto|Entero|Falso|Haz|Mientras|Para|Real|Si|Sino
identificador ({charminus}(({charmayus}|{charminus}){0,7}))
especiales \(|\)|\[|\]|,|;
asignacion :=
relacionales \.DIF\.|\.IGL\.|\.MN\.|\.MNI\.|\.MY\.|\.MYI\.
aritmeticos \+|-|\*|\/|%
entero {numeros}+
real ({numeros}+\.|\.{numeros}+){numeros}*
cientifico ({real}|{entero})(e|E)(\+|-)?{entero}
cadena \"[^"](\\.|[^\\"])*\"


%%
{comentario}	{/* ignora */}
{reservadas}    {pushInt(tokens, 0, findIndex(RESERVADAS, 	yytext, sizeof(RESERVADAS)));}
{especiales}    {pushInt(tokens, 1, findIndex(ESPECIALES, 	yytext, sizeof(ESPECIALES)));}
{identificador} {pushInt(tokens, 2, pushStr(i, 1, yytext));}
{asignacion}    {pushInt(tokens, 3, findIndex(ASIGNACION, 	yytext, sizeof(ASIGNACION)));}
{relacionales}  {pushInt(tokens, 4, findIndex(RELACIONALES, yytext, sizeof(RELACIONALES)));}
{aritmeticos}   {pushInt(tokens, 5, findIndex(ARITMETICOS, 	yytext, sizeof(ARITMETICOS)));}
{cadena}        {pushInt(tokens, 6, pushStr(c, 1, yytext));}
{entero}        {pushInt(tokens, 7, pushStr(e, 1, yytext));} 
{real}          {pushInt(tokens, 8, pushStr(r, 1, yytext));}
{cientifico}    {pushInt(tokens, 8, pushStr(r, 1, yytext));}
{espacio}       {/* ignore*/}
{salto}         {line++;}
{tab}           {fprintf(archSal, "\t"); }
.               {fprintf(archSal, "\nError in line %d: {%s}", line, yytext); printf("\nError in line %d: {%s}", line, yytext);}

%%

int main(int argc, char *argv[]) {
	//inizialicacion de listas
    i = (strQueue*) malloc(sizeof(strQueue));
    c = (strQueue*) malloc(sizeof(strQueue));
    e = (strQueue*) malloc(sizeof(strQueue));
    r = (strQueue*) malloc(sizeof(strQueue));
    tokens = (intQueue*) malloc(sizeof(intQueue));

    initIntQueue(tokens);
    initStrQueue(i);
    initStrQueue(c);
    initStrQueue(e);
    initStrQueue(r);

    //abre archivos de entrada y salida
    yyin = fopen(argv[1],"r");
    archSal = fopen("lexic.txt","w");

    yylex();
    fclose(archSal);

	// muestra estado de las listas al finalizar
    printIntQueue(tokens);
    printStrQueue(i, "Enteros");
    printStrQueue(c, "Cadenas");
    printStrQueue(e, "Reales");
    printStrQueue(r, "Reales");
    
    return 0;
}

int findIndex(char **table, char *text, int size){
    for(int i=0; i<= size; i++){
        
        if(strcmp(text, table[i]) == 0){
            return i;
        }
    }
    return -1;
}