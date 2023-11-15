#Substitua o valor de CC com o nome do compilador que voce usa: gcc ou g++
CC = gcc
CFLAGS =   -g  -Wall -ansi
LFLAGS = -lm

cafezinho:    main.o lexico.o
	$(CC) $(CFLAGS) $(LFLAGS) lexico.o main.o -o  cafezinho
                
main.o: cafezinho.tab.c
	$(CC) $(CFLAGS) -c cafezinho.tab.c -o main.o

lex.yy.c: cafezinho.l
	flex  --yylineno cafezinho.l

lexico.o: lex.yy.c  
	$(CC) $(CFLAGS) -c lex.yy.c   -o lexico.o


cafezinho.tab.c: cafezinho.y
	bison -d cafezinho.y

clean:
	rm -f   cafezinho.tab.c cafezinho.tab.h lex.yy.c *.o cafezinho cafezinho.output 

cleanObj:
	rm -f   *.o  
# Quando seu trabalho estiver pronto. No diretorio onde estão fontes digite na linha de comando: make tgz
# este comando ira criar um arquivo do tipo tar zipado com extensao .tgz contendo os fontes do seu programa e o Makefile.
# envie um mail com este arquivo para o professor.
tgz: 
	rm -f *.o rm cafezinho *.tgz 
	tar -zcvf cafezinho.tgz *
	echo "O arquivo cafezinho.tgz com os fontes e Makefile foi gerado. Pode ser enviado."	

