DIGITO               [0-9]
LETRA                [a-zA-Z]    
ID                   [a-zA-Z_][a-zA-Z0-9_]*
CONST_STRING         '"' ID* '"'
COMENTARIO 	     "/*"([^*]|"*"+[^*/])*"*"+"/"
QUEBRA_TEXTO         [\n]
TAB                  [\t]
CARACTERE_INVALIDO   .
ESPACO_BRANCO        [ ]+

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

"programa"  { return(programa); }
"car"       { return(car); }
"int"       { return(INT); }
"retorne"   { return(retorne); }
"leia"      { return(leia); }
"escreva"   { return(escreva); }
"novalinha" { return(novalinha); }
"se"        { return(se); }
"entao"     { return(entao); }
"senao"     { return(senao); }
"enquanto"  { return(enquanto); }
"execute"   { return(execute); }
"+"         { return(ADICAO); }
"-"         { return(SUBTRACAO); }
"*"         { return(MULTIPLICACAO); }
"/"         { return(DIVISAO); }
"%"         { return(RESTO); }
"++"        { return(INCREMENTO); }
"--"        { return(DECREMENTO); }
"&"         { return(E_BITWISE); }
"|"         { return(OU_BITWISE); }
"~"         { return(NAO_BITWISE); }
"^"         { return(XOR_BITWISE); }
"!"         { return(NAO_LOGICO); }
"&&"        { return(E_LOGICO); }
"||"        { return(OU_LOGICO); }
"=="        { return(IGUALDADE); }
"!="        { return(DIFERENCA); }
"<"         { return(MENOR); }
">"         { return(MAIOR); }
"<="        { return(MENOR_IGUAL); }
">="        { return(MAIOR_IGUAL); }
">>"        { return(SHIFT_DIREITA); }
"<<"        { return(SHIFT_ESQUERDA); }
"="         { return(ATRIBUICAO); }
"+="        { return(ADICAO_ATRIBUICAO); }
"-="        { return(SUBTRACAO_ATRIBUICAO); }
";"         { return(PONTO_E_VIRGULA); }
","         { return(VIRGULA); }
":"         { return(DOIS_PONTOS); }
"("         { return(ABRE_PARENTESES); }
")"         { return(FECHA_PARENTESES); }
"{"         { return(ABRE_CHAVES); }
"}"         { return(FECHA_CHAVES); }
"["         { return(ABRE_COLCHETES); }
"]"         { return(FECHA_COLCHETES); }
"?"         { return(INTERROGACAO); }
"#"         { return(SUSTENIDO); }

{ID}+ {return (ID);}
{DIGITO}+ {return (DIGITO);}

{CARACTERE_INVALIDO} {return (CARACTERE_INVALIDO);}

{CONST_STRING}+ {
   printf("Linha: %d, Cadeia de caracteres: %s\n", yylineno, yytext);
   if (yytext[strlen(yytext) - 2] != '"' || yytext[strlen(yytext) - 1] != '\n') {
     printf("ERRO: CADEIA DE CARACTERES OCUPA MAIS DE UMA LINHA NA LINHA %d\n", yylineno);
    }  
}

{ESPACO_BRANCO} {return (ESPACO_BRANCO);}
{QUEBRA_TEXTO}	{return (QUEBRA_TEXTO);}

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
