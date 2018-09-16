
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

typedef struct node{  
	int class;
	int index;
	  
    struct node * prev;
    struct node * next;
}node;

typedef struct Queue {   
	struct node * head; 
	struct node * tail;

	int size;
}Queue;

/* ---------------------------- Funciones Cola ---------------------------- */
	// Mete a la cola, al final de la cola
	void enqueue(Queue * q, int class, int index) {
		node * new = (node*)malloc(sizeof(node));

		new->class = class;
        new->index = index;

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
	node * dequeue(Queue * q) {
		node * p = (node*)malloc(sizeof(node));

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


	void printQueue(Queue * q) {
		printf("\n ---------- Queue ---------- \n");
		printf("\n Class\tIndex\n");
		node * cursor = (node*)malloc(sizeof(node));

		cursor = q->head;
		while(cursor != NULL) {
			printf("\n %d\t%d", cursor->class, cursor->index);
			cursor = cursor->next;
		}

		printf("\n ---------- ----- ---------- \n");
		return;
	}

	void initQueue(Queue * q) {
		q->head = NULL;
		q->tail = NULL;
		return;
	}


int main(){

    
}