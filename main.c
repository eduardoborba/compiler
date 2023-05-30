#include "comp.h"

extern FILE *yyin;
	
void imprimirTabela();

int caudaCom = 0;
int caudaSim = 0;
Instrucao comandos[200];
Simbolo tabela[50];
int i;
int label = 0;
Funcao tabelaFun[50];
int caudaFun = 0;

int main(int argc, char **argv)
{
	if(argc == 3)
	{
		yyin = fopen(argv[1], "r+");
		yyparse();
		//imprimirTabela();
		imprimirComandos(argv[2]);
	}
	else{
		printf("uso: ./programa fonte saida\n");
	}
	return 0;
}

void imprimirTabela()
{
	int i;
	for(i = 0; i < caudaSim; i++)
	{
		printf("nome: %s pos: %d\n", tabela[i].nome, i);
	}
	
}

void imprimirComandos(char *arquivo)
{
	//printf("CaudaCOM = %d\n", caudaCom);
	int i, k = 0, j;
	FILE *saida;
	char retorno[20], parametros[100];
	saida = fopen(arquivo, "w");
	fprintf(saida, ".class public %s\n.super java/lang/Object\n\n", arquivo);
	fprintf(saida, ".method public <init>()V\n\taload_0\n\tinvokenonvirtual java/lang/Object/<init>()V\n\treturn\n.end method\n\n");
	//fprintf(saida, ".method public static main([Ljava/lang/String;)V\n\t.limit stack %d\n\t.limit locals %d\n", 6, caudaSim + 1);
	for(i = 0; i < caudaCom; i++)
	{
		fprintf(saida, "\t");
		switch(comandos[i].inst)
		{
			case ICONST0:
				fprintf(saida, "iconst_0\n");
				break;
			case ICONST1:
				fprintf(saida,"iconst_1\n");
				break;
			case ICONST2:
				fprintf(saida,"iconst_2\n");
				break;
			case ICONST3:
				fprintf(saida,"iconst_3\n");
				break;
			case ICONST4:
				fprintf(saida,"iconst_4\n");
				break;
			case ICONST5:
				fprintf(saida,"iconst_5\n");
				break;
			case BIPUSH:
				fprintf(saida,"bipush %d\n", comandos[i].p1);
				break;
			case IADD:
				fprintf(saida,"iadd\n");
				break;
			case ISUB:
				fprintf(saida,"isub\n");
				break;
			case IMUL:
				fprintf(saida,"imul\n");
				break;
			case IDIV:
				fprintf(saida,"idiv\n");
				break;
			case ISTORE:
				fprintf(saida,"istore_%d\n", comandos[i].p1+1);
				break;
			case ILOAD:
				fprintf(saida,"iload_%d\n", comandos[i].p1+1);
				break;
			case GETSTATIC:
				fprintf(saida, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
				break;
			case PRINTINT:
				fprintf(saida, "invokevirtual java/io/PrintStream/print(I)V\n");
				break;
			case PRINTLIT:
				fprintf(saida, "invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V\n");
				break;
			case LDC:
				fprintf(saida, "ldc %s\n", comandos[i].p3);
				break;
			case ALOAD:
				fprintf(saida, "aload_%d\n", comandos[i].p1+1);
				break;
			case ASTORE:
				fprintf(saida,"astore_%d\n",comandos[i].p1+1);
				break;
			case LE:
				fprintf(saida,"if_icmple l%d\n", comandos[i].p1);
				break;
			case LT:
				fprintf(saida,"if_icmplt l%d\n", comandos[i].p1);
				break;
			case GE:
				fprintf(saida,"if_icmpge l%d\n", comandos[i].p1);
				break;
			case GT:
				fprintf(saida,"if_icmpgt l%d\n", comandos[i].p1);
				break;
			case EQ:
				fprintf(saida,"if_icmpeq l%d\n", comandos[i].p1);
				break;
			case NE:
				fprintf(saida,"if_icmpne l%d\n", comandos[i].p1);
				break;
			case GOTO:
				fprintf(saida,"goto l%d\n", comandos[i].p1);
				break;
			case LABEL:
				fprintf(saida,"\rl%d:\n",comandos[i].p1);
				break;
			case FUNCAO:
				strcpy(parametros, "");
				for(j = 0; j < tabelaFun[k].nParam; j++)
				{
					//if(tabela[tabelaFun[ḱ].posInicial + j].tipo == INT)
						strcat(parametros, "I");
					//if(tabela[tabelaFun[ḱ].posInicial+j].tipo == STRING)
						//	strcat(parametros, "Ljava/lang/String;");
				}
				if(tabelaFun[k].tipoRetorno == INT)
					strcpy(retorno, "I");
				if(tabelaFun[k].tipoRetorno == VOID)
					strcpy(retorno,"V");
				if(tabelaFun[k].tipoRetorno == STRING)
					strcpy(retorno,"Ljava/lang/String;");
				fprintf(saida, "\r.method public static %s(%s)%s\n\t.limit stack %d\n\t.limit locals %d\n", tabelaFun[k].nomeFun, parametros, retorno, 6, tabelaFun[k].nParam);
				break;
			case FUNCAOFINAL:
				if(tabelaFun[k].tipoRetorno != VOID)
					fprintf(saida, "return");
				fprintf(saida, "\n.end method\n\n");
				k++;
				break;
			case MAIN:
				fprintf(saida, "\r.method public static main([Ljava/lang/String;)V\n\t.limit stack %d\n\t.limit locals %d\n", 6, caudaSim + 1);
				break;
		}
	}
	fprintf(saida, "\treturn\n.end method\n");
	fclose(saida);
}

int posicao(char nome[50])
{
	int n = 0;
	while(n <= caudaSim)
	{
		if(!strcmp(nome, tabela[n].nome))
			return n;
		n++;
	}
	return -1;
}

int qualtipo(char nome[50])
{
	int n = 0;
	while(n <= caudaSim)
	{
		if(!strcmp(nome, tabela[n].nome))
			return tabela[n].tipo;
		n++;
	}
	return -1;
	
}

int novoLabel()
{
	
	label++;
	comandos[caudaCom].inst = LABEL;
	comandos[caudaCom++].p1 = label;	
	return label;
}


int merge(int Bv[100], int B1v[100], int caudaB, int Cv[100], int caudaC)
{
	int i, j, cauda, flag;
	for(cauda=0;cauda<caudaB;cauda++){
		Bv[cauda] = B1v[cauda];
	}
	for(i = 0; i < caudaC; i++)
	{
		flag = 0;
		for(j = 0; j < caudaB; j++)
		{
			if(Cv[i] == B1v[j])
				flag = 1;
		}
		if(flag == 0)
		{
			Bv[cauda] = Cv[i];
			cauda++;
		}
	}
	return cauda;
}

void corrigir(int lista[100], int cauda, int l)
{
	int i;
	for(i = 0; i < cauda; i++)
	{
		comandos[lista[i]].p1 = l;
	}
}
