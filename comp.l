delim	[ \t\n]
ws	{delim}+
digito	[0-9]
const	{digito}+
letra	[A-z]
id	{letra}({digito}|{letra})*
literal \".*\"

%%
{ws} {}
"+" {return TADD;}
"-" {return TSUB;}
"*" {return TMUL;}
"/" {return TDIV;}
"(" {return TAPAR;}
")" {return TFPAR;}
"{" {return TACHAVE;}
"}" {return TFCHAVE;}
"," {return TVIR;}
"<=" {return TMENORIGUAL;}
">=" {return TMAIORIGUAL;}
"<" {return TMENOR;}
">" {return TMAIOR;}
"==" {return TIGUALIGUAL;}
"=" {return TIGUAL;}
"&&" {return TAMPER;}
"||" {return TPIPE;}
"!=" {return TNIGUAL;}
"!" {return TNOT;}
"void" {return TVOID;}
"String" {return TSTRING;}
"int" {return TINT;}
"if" {return TIF;}
"return" {return TRET;}
"while" {return TWHI;}
"print" {return TPRINT;}
"read" {return TREAD;}
";" {return TPV;}
"else" {return TELSE;}
{const} {yylval.valor=atoi(yytext);yylval.tipo=TINT; return TCONST;} 
{literal} {yylval.tipo=TSTRING; strcpy(yylval.val, yytext); return TLITERAL;}
{id} {strcpy(yylval.nId,yytext);return TID;}
