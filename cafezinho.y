/* Secao de declaracao (delcaration section)*/

%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern FILE *yyin;
extern int yylineno;
extern char *yytext;
void yyerror(char const *);

%}

%union {
    int intVal;
    char carVal;
    char* cadeiaVal;
}



%token CARCONST
%token INTCONST
%token CadeiaDeCaracteres 
%token ID 
%token programa
%token <intVal> INT 
%token <carVal> CAR
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
%token INCREMENTO 
%token DECREMENTO 
%token E_BITWISE 
%token OU_BITWISE 
%token NAO_BITWISE 
%token XOR_BITWISE 
%token NAO_LOGICO 
%token E_LOGICO
%token ASPAS 
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
%token CARACTERE_INVALIDO 
%token CONST_STRING 
%token ESPACO_BRANCO
%token TAB 
%token QUEBRA_TEXTO 
%token COMENTARIO
%verbose

%%

Programa: DeclFuncVar DeclProg 
        ;

DeclFuncVar : Tipo ID DeclVar PONTO_E_VIRGULA DeclFuncVar
            | Tipo ID ABRE_COLCHETES INTCONST FECHA_COLCHETES DeclVar PONTO_E_VIRGULA DeclFuncVar
            | Tipo ID DeclFunc DeclFuncVar
            |
            ;

DeclProg : programa {printf("SUCCESSFUL COMPILATION.\n"); return 1;} Bloco
         ;

DeclVar : VIRGULA ID DeclVar
        | VIRGULA ID ABRE_COLCHETES INTCONST FECHA_COLCHETES DeclVar
        | 
        ;

DeclFunc : ABRE_PARENTESES ListaParametros FECHA_PARENTESES Bloco
         ;

ListaParametros : 
                | ListaParametrosCont
                ;

ListaParametrosCont : Tipo ID
                    | Tipo ID ABRE_COLCHETES FECHA_COLCHETES
                    | Tipo ID VIRGULA ListaParametrosCont
                    | Tipo ID ABRE_COLCHETES FECHA_COLCHETES VIRGULA ListaParametrosCont
                    ;
                    
Bloco: ABRE_CHAVES ListaDeclVar ListaComando FECHA_CHAVES
      | ABRE_CHAVES ListaDeclVar FECHA_CHAVES
      ;

ListaDeclVar : 
             | Tipo ID DeclVar PONTO_E_VIRGULA ListaDeclVar
             | Tipo ID ABRE_COLCHETES INTCONST FECHA_COLCHETES DeclVar PONTO_E_VIRGULA ListaDeclVar
             ;

Tipo : INT
     | CAR	
     ;

ListaComando : Comando
             | Comando ListaComando
             ;

Comando : PONTO_E_VIRGULA
        | Expr PONTO_E_VIRGULA
        | retorne Expr PONTO_E_VIRGULA 
        | leia LValueExpr PONTO_E_VIRGULA
        | escreva Expr PONTO_E_VIRGULA
        | escreva CadeiaDeCaracteres PONTO_E_VIRGULA
        | novalinha PONTO_E_VIRGULA
        | se ABRE_PARENTESES Expr FECHA_PARENTESES entao Comando
        | se ABRE_PARENTESES Expr FECHA_PARENTESES entao Comando senao Comando
        | enquanto ABRE_PARENTESES Expr FECHA_PARENTESES execute Comando
        | Bloco
        ;

Expr : AssignExpr
     ;

AssignExpr : CondExpr
           | LValueExpr ATRIBUICAO AssignExpr
           ;

CondExpr : OrExpr
         | OrExpr INTERROGACAO Expr DOIS_PONTOS CondExpr
         ;

OrExpr : OrExpr OU_BITWISE AndExpr
       | AndExpr
       ;

AndExpr : AndExpr E_LOGICO EqExpr
        | EqExpr
        ;

EqExpr : EqExpr IGUALDADE DesigExpr
       | EqExpr DIFERENCA DesigExpr
       | DesigExpr
       ;

DesigExpr : DesigExpr MENOR AddExpr
          | DesigExpr MAIOR AddExpr
          | DesigExpr MENOR_IGUAL AddExpr
          | DesigExpr MAIOR_IGUAL AddExpr
          | AddExpr
          ;

AddExpr : AddExpr ADICAO MulExpr
        | AddExpr SUBTRACAO MulExpr
        | MulExpr
        ;

MulExpr : MulExpr MULTIPLICACAO UnExpr
        | MulExpr DIVISAO UnExpr
        | MulExpr RESTO UnExpr
        | UnExpr
        ;

UnExpr : SUBTRACAO PrimExpr
       | NAO_LOGICO PrimExpr
       | PrimExpr
       ;

LValueExpr : ID ABRE_COLCHETES Expr FECHA_COLCHETES
           | ID
           ;
           
PrimExpr :  ID ABRE_PARENTESES ListExpr FECHA_PARENTESES
	  | ID ABRE_PARENTESES FECHA_PARENTESES
	  | ID ABRE_COLCHETES Expr FECHA_COLCHETES
	  | ID
	  | CARCONST
	  | INTCONST
	  | ABRE_PARENTESES Expr FECHA_PARENTESES
	  ;

ListExpr : AssignExpr
         | ListExpr VIRGULA AssignExpr
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
