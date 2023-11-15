/* Secao de declaracao (delcaration section)*/

%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex();
extern FILE *yyin;
void yyerror(char const *);
extern int yylineno;
extern char *yytext;
%}

%token DIGITO 
%token LETRA 
%token ID 
%token NUMERO 
%token CARACTERE_INVALIDO 
%token CONST_STRING 
%token ESPACO_BRANCO 
%token COMENTARIO 
%token QUEBRA_TEXTO 
%token TAB
%token programa 
%token car 
%token INT 
%token retorne 
%token leia 
%token escreva 
%token novalinha 
%token se 
%token entao 
%token senao 
%token enquanto 
%token execute
%left  ADICAO
%left  SUBTRACAO 
%left  MULTIPLICACAO 
%left  DIVISAO  
%token RESTO
%token INCREMENTO DECREMENTO 
%token E_BITWISE 
%token OU_BITWISE 
%token NAO_BITWISE 
%token XOR_BITWISE 
%token NAO_LOGICO 
%token E_LOGICO 
%token OU_LOGICO 
%token IGUALDADE 
%token DIFERENCA 
%token MENOR MAIOR 
%token MENOR_IGUAL 
%token MAIOR_IGUAL 
%token SHIFT_DIREITA 
%token SHIFT_ESQUERDA 
%token ATRIBUICAO 
%token ADICAO_ATRIBUICAO 
%token SUBTRACAO_ATRIBUICAO 
%token PONTO_E_VIRGULA 
%token VIRGULA DOIS_PONTOS 
%token ABRE_PARENTESES 
%token FECHA_PARENTESES 
%token ABRE_CHAVES 
%token FECHA_CHAVES 
%token ABRE_COLCHETES 
%token FECHA_COLCHETES 
%token INTERROGACAO SUSTENIDO
%verbose

%%

Programa: DeclFuncVar DeclProg {printf("SUCCESSFUL COMPILATION."); return 1;}
        ;

DeclFuncVar : Tipo ID DeclVar ';' DeclFuncVar
            | Tipo ID '[' DIGITO ']' DeclVar ';' DeclFuncVar
            | Tipo ID DeclFunc DeclFuncVar
            |
            ;

DeclProg : programa Bloco
         ;

DeclVar : ',' ID DeclVar
        | ',' ID '[' DIGITO ']' DeclVar
        | 
        ;

DeclFunc : '(' ListaParametros ')' Bloco
         ;

ListaParametros : 
                | ListaParametrosCont
                ;

ListaParametrosCont : Tipo ID
                    | Tipo ID '[' ']'
                    | Tipo ID ',' ListaParametrosCont
                    | Tipo ID '[' ']' ',' ListaParametrosCont
                    ;
                    
Bloco: '{' ListaDeclVar ListaComando '}'
      | '{' ListaDeclVar '}'
      ;

ListaDeclVar : 
             | Tipo ID DeclVar ';' ListaDeclVar
             | Tipo ID '[' DIGITO ']' DeclVar ';' ListaDeclVar
             ;

Tipo : INT
     | car
     ;

ListaComando : Comando
             | Comando ListaComando
             ;

Comando : ';'
        | Expr ';'
        | retorne Expr ';'
        | leia LValueExpr ';'
        | leia Expr ';'
        | escreva CONST_STRING ';'
        | novalinha ';'
        | se '(' Expr ')' entao Comando
        | se '(' Expr ')' entao Comando senao Comando
        | enquanto '(' Expr ')' execute Comando
        | Bloco
        ;

Expr : AssignExpr
     ;

AssignExpr : CondExpr
           | LValueExpr '=' AssignExpr
           ;

CondExpr : OrExpr
         | OrExpr '?' Expr ':' CondExpr
         ;

OrExpr : OrExpr '|' 
       | AndExpr
       ;

AndExpr : AndExpr E_LOGICO EqExpr
        | EqExpr
        ;

EqExpr : EqExpr IGUALDADE DesigExpr
       | EqExpr DIFERENCA DesigExpr
       | DesigExpr
       ;

DesigExpr : DesigExpr '<' AddExpr
          | DesigExpr '>' AddExpr
          | DesigExpr MENOR_IGUAL AddExpr
          | DesigExpr MAIOR_IGUAL AddExpr
          | AddExpr
          ;

AddExpr : AddExpr '+' MulExpr
        | AddExpr '-' MulExpr
        | MulExpr
        ;

MulExpr : MulExpr '*' UnExpr
        | MulExpr '/' UnExpr
        | MulExpr '%' UnExpr
        | UnExpr
        ;

UnExpr : '-' PrimExpr
       | '!' PrimExpr
       | PrimExpr
       ;

LValueExpr : ID '[' Expr ']'
           | ID
           ;
           
PrimExpr :  ID '(' ListExpr ')'
	  | ID '(' ')'
	  | ID '[' Expr ']'
	  | ID
	  | LETRA
	  | DIGITO
	  | '(' Expr ')'
	  ;

ListExpr : AssignExpr
         | ListExpr ',' AssignExpr
         ;
         

%% 

void yyerror(char const* msg){
    fprintf(stderr, "ERRO: Linha %d \n", yylineno, msg, yytext);
}


int main(int argc, char**argv){
     if(argc!=2){
          printf("Uso correto: cafezinho arquivo_de_teste\n");
          exit(1);
     }
     yyin=fopen(argv[1],"rt");
     if(yyin)
          return yyparse();
     else 
          yyerror("arquivo não encontrado.");
     return(1);
}
