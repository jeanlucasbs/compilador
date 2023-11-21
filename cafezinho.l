%option yylineno

LETRA		     [A-Za-z]
DIGITO               [0-9]
ID                   [a-zA-Z_][a-zA-Z0-9_]*
COMENTARIO 	     "/*"([^*]|"*"+[^*/])*"*"+"/"
QUEBRA_TEXTO         [\n]
TAB                  [\t]
CARACTERE_INVALIDO   .
ESPACO_BRANCO        [ ]+
CadeiaDeCaracteres   '"' ID* '"'

%{

int linha = 0;
#include "cafezinho.tab.h" 

%}

%option yylineno
%x COMMENT

%%

"/*" { linha=yylineno; BEGIN(COMMENT); }
<COMMENT>"*/" { BEGIN(INITIAL); }
<COMMENT>(.|\n);
<COMMENT><<EOF>> {printf("(ERRO: COMENTÁRIO NÂO TERMINA NA LINHA %d,\"/*\")\n",linha); return (0);}

"int"	    	 	 { return(INT); }
"car"    	 	 { return(CAR); }
"programa"  		 { printf("Palavra reservada: %s\n", yytext);return(programa); }
"retorne"   		 { printf("Palavra reservada: %s\n", yytext);return(retorne); }
"leia"      		 { printf("Palavra reservada: %s\n", yytext);return(leia); }
"escreva"   		 { printf("Palavra reservada: %s\n", yytext);return(escreva); }
"novalinha" 		 { printf("Palavra reservada: %s\n", yytext);return(novalinha); }
"se"        		 { printf("Palavra reservada: %s\n", yytext);return(se); }
"entao"     		 { printf("Palavra reservada: %s\n", yytext);return(entao); }
"senao"     		 { printf("Palavra reservada: %s\n", yytext);return(senao); }
"enquanto"  		 { printf("Palavra reservada: %s\n", yytext);return(enquanto); }
"execute"   		 { printf("Palavra reservada: %s\n", yytext);return(execute); }
"++"        		 { printf("Operador Lógico: %s\n", yytext);return(INCREMENTO); }
"--"        		 { printf("Operador Lógico: %s\n", yytext);return(DECREMENTO); }
"&"         		 { printf("Operador Lógico: %s\n", yytext);return(E_BITWISE); }
"|"         		 { printf("Operador Lógico: %s\n", yytext);return(OU_BITWISE); }
"~"         		 { printf("Operador Lógico: %s\n", yytext);return(NAO_BITWISE); }
"^"        		 { printf("Operador Lógico: %s\n", yytext);return(XOR_BITWISE); }
"!"         		 { printf("Operador Lógico: %s\n", yytext);return(NAO_LOGICO); }
"&&"       		 { printf("Operador Lógico: %s\n", yytext);return(E_LOGICO); }
"||"       		 { printf("Operador Lógico: %s\n", yytext);return(OU_LOGICO); }
"=="       		 { printf("Operador Lógico: %s\n", yytext);return(IGUALDADE); }
"+"         		 { printf("Operador Matemático: %s\n", yytext);return(ADICAO); }
"-"         		 { printf("Operador Matemático: %s\n", yytext);return(SUBTRACAO); }
"*"         		 { printf("Operador Matemático: %s\n", yytext);return(MULTIPLICACAO); }
"/"         		 { printf("Operador Matemático: %s\n", yytext);return(DIVISAO); }
"%"         		 { printf("Operador Matemático: %s\n", yytext);return(RESTO); }
"!="       		 { printf("Operador Matemático: %s\n", yytext);return(DIFERENCA); }
"<"        		 { printf("Operador Matemático: %s\n", yytext);return(MENOR); }
">"        		 { printf("Operador Matemático: %s\n", yytext);return(MAIOR); }
"<="       		 { printf("Operador Matemático: %s\n", yytext);return(MENOR_IGUAL); }
">="         	 	 { printf("Operador Matemático: %s\n", yytext);return(MAIOR_IGUAL); }
">>"        	 	 { printf("Operador Matemático: %s\n", yytext);return(SHIFT_DIREITA); }
"<<"       		 { printf("Operador Matemático: %s\n", yytext);return(SHIFT_ESQUERDA); }
"="        		 { printf("Operador Matemático: %s\n", yytext);return(ATRIBUICAO); }
"+="        		 { printf("Operador Matemático: %s\n", yytext);return(ADICAO_ATRIBUICAO); }
"-="       		 { printf("Operador Matemático: %s\n", yytext);return(SUBTRACAO_ATRIBUICAO); }
"\""		         { printf("Operador Matemático: %s\n", yytext);return(ASPAS); }		
";"         		 { printf("Simbolo: %s\n", yytext);return(PONTO_E_VIRGULA); }
","         		 { printf("Simbolo: %s\n", yytext);return(VIRGULA); }
":"         		 { printf("Simbolo: %s\n", yytext);return(DOIS_PONTOS); }
"("         		 { printf("Simbolo: %s\n", yytext);return(ABRE_PARENTESES); }
")"         		 { printf("Simbolo: %s\n", yytext);return(FECHA_PARENTESES); }
"{"         		 { printf("Simbolo: %s\n", yytext);return(ABRE_CHAVES); }
"}"         		 { printf("Simbolo: %s\n", yytext);return(FECHA_CHAVES); }
"["         		 { printf("Simbolo: %s\n", yytext);return(ABRE_COLCHETES); }
"]"        		 { printf("Simbolo: %s\n", yytext);return(FECHA_COLCHETES); }
"?"         		 { printf("Simbolo: %s\n", yytext);return(INTERROGACAO); }
"#"         		 { printf("Simbolo: %s\n", yytext);return(SUSTENIDO); }

{DIGITO}+ 		 { printf("Inteiro: %s\n", yytext);return INTCONST;}
{LETRA}                  { printf("Caractere: %s\n", yytext);return CARCONST; }
{ID}+       		 { printf("Identificador: %s\n", yytext);return (ID);}

{CARACTERE_INVALIDO}     { return (CARACTERE_INVALIDO);}
{ESPACO_BRANCO}          { return (ESPACO_BRANCO);}
{QUEBRA_TEXTO}	         { return (QUEBRA_TEXTO);}
{TAB}	     	         { return (TAB);}


{CadeiaDeCaracteres}+ {
   printf("Cadeia de caracteres: %s\n", yytext);
   if (yytext[strlen(yytext) - 2] != '"' || yytext[strlen(yytext) - 1] != '\n') {
     printf("ERRO: CADEIA DE CARACTERES OCUPA MAIS DE UMA LINHA NA LINHA %d\n", yylineno);
     return(-1);
   }  
   return(CadeiaDeCaracteres);

}

{COMENTARIO} { /*Ignorar comentarios na hora de ler*/
    int comment_lines = 0;
    int i;
    for (i = 0; i < strlen(yytext); i++) {
        if (yytext[i] == '\n') {
            comment_lines++;
        }
    }
    linha += comment_lines;
}  


%%

int yywrap();

int yywrap(){
    return 1;
}
