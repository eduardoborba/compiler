#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define ICONST0 1
#define ICONST1 2
#define ICONST2 3
#define ICONST3 4
#define ICONST4 5
#define ICONST5 6
#define BIPUSH 7
#define IADD 8
#define INT 9
#define STRING 10
#define ISUB 11
#define IMUL 12
#define IDIV 13
#define ISTORE 14
#define ILOAD 15
#define GETSTATIC 16
#define PRINTLIT 17
#define PRINTINT 18
#define LDC 19
#define ALOAD 20
#define ASTORE 21
#define LT 22
#define LE 23
#define GT 24
#define GE 25
#define EQ 26
#define NE 27
#define GOTO 28
#define LABEL 29
#define VOID 30
#define FUNCAO 31
#define FUNCAOFINAL 32
#define MAIN 33




typedef struct Atributo
{
    char nId[50];
    char val[100];
    int valor;
    int tipo;
    struct Atributo *vetor;
    int listav[100];
    int caudav;
    int listaf[100];
    int caudaf;
    int label;
}attr;

typedef struct 
{
    int inst;
    int p1, p2;
    char p3[100];
}Instrucao;

typedef struct 
{
    char nome[50];
    int tipo;
}Simbolo;

typedef struct
{
	char nomeFun[50];
	int posInicial;
	int posFinal;
	int tipoRetorno;
	int nParam;
	int posVar;
	struct Atributo *vetor;
}Funcao;

extern Instrucao comandos[200];
extern int caudaCom;
extern Simbolo tabela[50];
extern int caudaSim;
extern int i;
extern int label;
extern Funcao tabelaFun[50];
extern int caudaFun;

void imprimirComandos(char *arquivo);
void imprimirTabela();
int posicao(char nome[50]);
int qualtipo(char nome[50]);
int novoLabel();
int merge(int Bv[100], int B1v[100], int caudaB, int Cv[100], int caudaC);
void corrigir(int lista[100], int cauda, int l);
