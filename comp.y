%{
    #include "comp.h"
    #define YYSTYPE attr
%}

%token TADD TMUL TSUB TDIV TAPAR TFPAR TNUM TFIM TVIR TMAIORIGUAL TMENORIGUAL TMENOR TMAIOR TIGUALIGUAL TIGUAL TAMPER TPIPE TNIGUAL TNOT TVOID TSTRING TINT TIF TWHI TPRINT TREAD TPV TID TCONST TLITERAL TACHAVE TFCHAVE TELSE TRET

%%
Programa: ListaFuncoes { 
			comandos[caudaCom].inst = MAIN;
			caudaCom++;
		}
		BlocoPrincipal
    |{
		comandos[caudaCom].inst = MAIN;
		caudaCom++;
    
    
    }BlocoPrincipal
;
ListaFuncoes: ListaFuncoes Funcao
    | Funcao
;
Funcao: TipoRetorno TID TAPAR DeclParametros TFPAR {
			int j;
			tabelaFun[caudaFun].tipoRetorno = $1.tipo;
			strcpy(tabelaFun[caudaFun].nomeFun, $2.nId);
			printf("%s\n", $2.nId);
			tabelaFun[caudaFun].posVar = caudaSim;
			for(j = 0; j < i; j++)
			{
				strcpy(tabela[caudaSim].nome, $4.vetor[j].nId);
				tabela[caudaSim].tipo = $4.vetor[j].tipo;
				caudaSim++;
			}
			tabelaFun[caudaFun].posInicial = caudaCom;
			comandos[caudaCom].inst = FUNCAO;
			caudaFun++;
			caudaCom++;
		} BlocoPrincipal 
		{
			tabelaFun[caudaFun].posFinal = caudaCom;
			comandos[caudaCom].inst = FUNCAOFINAL;
			caudaCom++;
		}
    |TipoRetorno TID TAPAR TFPAR {
		int j;
		tabelaFun[caudaFun].tipoRetorno = $1.tipo;
		strcpy(tabelaFun[caudaFun].nomeFun, $2.nId);
		printf("%s\n", $2.nId);
		tabelaFun[caudaFun].posVar = caudaSim;
		tabelaFun[caudaFun].posInicial = caudaCom;
		comandos[caudaCom].inst = FUNCAO;
		caudaFun++;
		caudaCom++;
		
		
	} BlocoPrincipal
	{
			tabelaFun[caudaFun].posFinal = caudaCom;
			comandos[caudaCom].inst = FUNCAOFINAL;
			caudaCom++;
	}
;


TipoRetorno : Tipo
    | TVOID {$$.tipo = VOID;}
;
DeclParametros : DeclParametros TVIR Parametro
				{
					int j;
					$1.vetor[i++] = $3;
					for(j = 0; j < i; j++)
						$$.vetor[j] = $1.vetor[j];
				}
				|Parametro
				{
					i = 0;
					$$.vetor = (attr *) malloc(sizeof(attr)*100);
					$$.vetor[i] = $1;
					i++;
				}
;
Parametro : Tipo TID
	{
		$$.tipo = $1.tipo;
		strcpy($$.nId,$2.nId);
	}
;
BlocoPrincipal : TACHAVE Declaracoes ListaCmd TFCHAVE
    | TACHAVE ListaCmd TFCHAVE
;
Declaracoes : Declaracoes Declaracao
    | Declaracao
		
;
Declaracao : Tipo ListaId TPV {
				int j, k;
				Simbolo simb;
				for(j = 0; j < i; j++)
				{
					
					for(k = 0; k < 50; k++)
						simb.nome[k] = $2.vetor[j].nId[k];
					simb.tipo = $1.tipo;
					tabela[caudaSim++] = simb;
				}
			}
;
Tipo : TINT {$$.tipo = INT;}
     | TSTRING {$$.tipo = STRING;}
;
ListaId : ListaId TVIR TID
			{
				int j;
				$1.vetor[i++] = $3;
				for(j = 0; j < i; j++)
					$$.vetor[j] = $1.vetor[j];
				
			}
    | TID
		{
			i = 0;
			$$.vetor = (attr *) malloc(sizeof(attr)*100);
			$$.vetor[i] = $1;
			i++;
		}
;
Bloco : TACHAVE ListaCmd TFCHAVE
;
ListaCmd : ListaCmd Comando
    | Comando
;
Comando : CmdSe
    | CmdEnquanto
    | CmdAtrib
    | CmdEscrita
    | CmdLeitura
    | ChamadaFuncao
    | Retorno
;
Retorno : TRET ExpressaoAritmetica TPV
;
CmdSe : TIF TAPAR ExpressaoLogica TFPAR L Bloco
		{
			corrigir($3.listav, $3.caudav, $5.label);
			corrigir($3.listaf, $3.caudaf, novoLabel());
		}
       |TIF TAPAR ExpressaoLogica TFPAR L Bloco N TELSE L Bloco
       {
			corrigir($3.listav, $3.caudav, $5.label);
			corrigir($3.listaf, $3.caudaf, $9.label);
			corrigir($7.listav, $7.caudav, novoLabel());
		}
;
N: {
		$$.caudav = 0;
		$$.listav[$$.caudav] = caudaCom;
		$$.caudav = $$.caudav +1;
		comandos[caudaCom++].inst = GOTO;
	}
  ;

CmdEnquanto : TWHI TAPAR L ExpressaoLogica TFPAR L Bloco
			  {
					corrigir($4.listav, $4.caudav, $6.label);
					comandos[caudaCom].inst = GOTO;
					comandos[caudaCom++].p1 = $3.label;
					corrigir($4.listaf, $4.caudaf, novoLabel());
			  }
;
CmdAtrib : TID TIGUAL ExpressaoAritmetica TPV 
			{
				int var = posicao($1.nId);
				if(tabela[var].tipo == INT)
				{
					comandos[caudaCom].inst = ISTORE;
					comandos[caudaCom].p1 = posicao($1.nId);
					caudaCom++;
				}
				else
					yyerror("Tipo incorreto",$1.nId);
			}
    | TID TIGUAL Literal TPV
    {
		int var = posicao($1.nId);
		if(tabela[var].tipo == STRING)
		{
			comandos[caudaCom].inst = ASTORE;
			comandos[caudaCom].p1 = posicao($1.nId);
			caudaCom++;
		}
		else
			yyerror("Tipo incorreto",$$.nId);
    
    }
;
CmdEscrita: TPRINT M TAPAR ExpressaoAritmetica TFPAR TPV {
		int tipo=qualtipo($4.nId);
		if (tipo==INT)
			comandos[caudaCom++].inst = PRINTINT;
		else if(tipo==STRING)
			comandos[caudaCom++].inst = PRINTLIT;
		}
    | TPRINT M TAPAR Literal TFPAR TPV {comandos[caudaCom++].inst = PRINTLIT;}
;
M: {comandos[caudaCom++].inst = GETSTATIC;} 
 ;
Literal: TLITERAL 
		{
			comandos[caudaCom].inst = LDC; 
			strcpy(comandos[caudaCom++].p3, $1.val);
		}
	;
CmdLeitura: TREAD TAPAR TID TFPAR TPV
;
ChamadaFuncao: TID TAPAR ListaParametros TFPAR TPV
    | TID TAPAR TFPAR TPV
;
ListaParametros: ListaParametros TVIR ExpressaoAritmetica
    | ExpressaoAritmetica
;
ExpressaoAritmetica: ExpressaoAritmetica TADD Termo { comandos[caudaCom++].inst = IADD; }
                     |ExpressaoAritmetica TSUB Termo {comandos[caudaCom++].inst = ISUB;}
                     |Termo
;
Termo: Termo TMUL Fator{comandos[caudaCom++].inst = IMUL;}
       |Termo TDIV Fator{comandos[caudaCom++].inst = IDIV;}
       |Fator
;
Fator: TID 
		{
			int tipo = qualtipo($1.nId);
			if(tipo == INT)
			{
				
				comandos[caudaCom].inst = ILOAD;
				comandos[caudaCom].p1 = posicao($1.nId);
				caudaCom++;
			}else if(tipo == STRING){
				comandos[caudaCom].inst = ALOAD;
				comandos[caudaCom].p1 = posicao($1.nId);
				caudaCom++;
			}else if(tipo==-1){
				yyerror("Variavel %s não declarada\n",$1.nId);
			}
			
		}
    |TCONST {
    switch ($1.valor){
		case 0:
			comandos[caudaCom++].inst=ICONST0;
			break;
		case 1:
			comandos[caudaCom++].inst=ICONST1;
			break;
		case 2:
			comandos[caudaCom++].inst=ICONST2;
			break;
		case 3:
			comandos[caudaCom++].inst=ICONST3;
			break;
		case 4:
			comandos[caudaCom++].inst=ICONST4;
			break;
		case 5:
			comandos[caudaCom++].inst=ICONST5;
			break;
		default:
			comandos[caudaCom].inst = BIPUSH;
			comandos[caudaCom++].p1 = $1.valor;
		}
    }
    |TAPAR ExpressaoAritmetica TFPAR
    |TSUB Fator
;
ExpressaoLogica:TermoLogico
                {
					int i;
					$$.caudav = $1.caudav;
					$$.caudaf = $1.caudaf;
					for(i = 0; i < $$.caudav; i++)
						$$.listav[i] = $1.listav[i];
					for(i = 0; i < $$.caudaf; i++)
						$$.listaf[i] = $1.listaf[i];
				}
				|ExpressaoLogica TPIPE L TermoLogico
				 {
					int i;
					corrigir($1.listaf, $1.caudaf, $3.label);
					$$.caudav = merge($$.listav, $1.listav, $1.caudav, $4.listav, $4.caudav); 
					$$.caudaf = $4.caudaf;
					for(i = 0; i < $$.caudaf; i++)
						$$.listaf[i] = $4.listaf[i];
				 }
                 |ExpressaoLogica TAMPER L TermoLogico
                 {
					corrigir($1.listav, $1.caudav, $3.label);
					$$.caudaf = merge($$.listaf, $1.listaf, $1.caudaf, $4.listaf, $4.caudaf);  
					$$.caudav = $4.caudav;
					for(i = 0; i < $$.caudav; i++)
						$$.listav[i] = $4.listav[i];
                 }
                 
                ;
L: {$$.label = novoLabel();}
 ;
TermoLogico: ExpressaoRelacional
            |TNOT TermoLogico
            {
				int aux, i, maior;
				if($$.caudaf > $$.caudav)
					maior = $$.caudaf;
				else
					maior = $$.caudav;
				for(i = 0; i < maior; i++)
				{
					aux = $$.listaf[i];
					$$.listaf[i] = $$.listav[i];
					$$.listav[i] = aux;  
				}
            }
            |TAPAR ExpressaoLogica TFPAR
			{
				int i;
				$$.caudav = $2.caudav;
				$$.caudaf = $2.caudaf;
				for(i = 0; i < $$.caudav; i++)
					$$.listav[i] = $2.listav[i];
				for(i = 0; i < $$.caudaf; i++)
					$$.listaf[i] = $2.listaf[i];
				
			}
            ;
ExpressaoRelacional: ExpressaoAritmetica TMENOR ExpressaoAritmetica
					{
						$$.caudav = 0;
						$$.listav[$$.caudav] = caudaCom;
						$$.caudav = $$.caudav +1;
						$$.caudaf = 0;
						$$.listaf[$$.caudaf] = caudaCom + 1;
						$$.caudaf = $$.caudaf +1;
						comandos[caudaCom++].inst = LT;
						comandos[caudaCom++].inst = GOTO;
					}
                    |ExpressaoAritmetica TMENORIGUAL ExpressaoAritmetica
                    {
						$$.caudav = 0;
						$$.listav[$$.caudav] = caudaCom;
						$$.caudav = $$.caudav +1;
						$$.caudaf = 0;
						$$.listaf[$$.caudaf] = caudaCom + 1;
						$$.caudaf = $$.caudaf +1;
						comandos[caudaCom++].inst = LE;
						comandos[caudaCom++].inst = GOTO;
					}
                    |ExpressaoAritmetica TMAIOR ExpressaoAritmetica
                    {
						$$.caudav = 0;
						$$.listav[$$.caudav] = caudaCom;
						$$.caudav = $$.caudav +1;
						$$.caudaf = 0;
						$$.listaf[$$.caudaf] = caudaCom + 1;
						$$.caudaf = $$.caudaf +1;
						comandos[caudaCom++].inst = GT;
						comandos[caudaCom++].inst = GOTO;
					}
                    |ExpressaoAritmetica TMAIORIGUAL ExpressaoAritmetica
                    {
						$$.caudav = 0;
						$$.listav[$$.caudav] = caudaCom;
						$$.caudav = $$.caudav +1;
						$$.caudaf = 0;
						$$.listaf[$$.caudaf] = caudaCom + 1;
						$$.caudaf = $$.caudaf +1;
						comandos[caudaCom++].inst = GE;
						comandos[caudaCom++].inst = GOTO;
					}
                    |ExpressaoAritmetica TIGUALIGUAL ExpressaoAritmetica
                    {
						$$.caudav = 0;
						$$.listav[$$.caudav] = caudaCom;
						$$.caudav = $$.caudav +1;
						$$.caudaf = 0;
						$$.listaf[$$.caudaf] = caudaCom + 1;
						$$.caudaf = $$.caudaf +1;
						comandos[caudaCom++].inst = EQ;
						comandos[caudaCom++].inst = GOTO;
					}
                    |ExpressaoAritmetica TNIGUAL ExpressaoAritmetica
                    {
						$$.caudav = 0;
						$$.listav[$$.caudav] = caudaCom;
						$$.caudav = $$.caudav +1;
						$$.caudaf = 0;
						$$.listaf[$$.caudaf] = caudaCom + 1;
						$$.caudaf = $$.caudaf +1;
						comandos[caudaCom++].inst = NE;
						comandos[caudaCom++].inst = GOTO;
					}
                    ;
%%
#include "lex.yy.c"

int yyerror (char *str)
{
    printf("%s - antes %s\n", str, yytext);
} 

int yywrap()
{
    return 1;
}
