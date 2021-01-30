%token INTEGER VARIABLE
%left '+' '-'
%left '*' '/'

%{
#include <stdlib.h>
#include <stdio.h>
#include "ParserObject.c"
#define YYSTYPE struct ParserObject

int temp=1;
void yyerror(char *);
int yylex(void);
int sym[26];
char* numberParts [6] = {"", "Ten", "Hun", ")Tou", "Ten", "Hun"};
int shiftValue [6] = {0,0,0,0,1,1};

int currentNumberSize = 0;
%}
%%
program:
	program base '\n' { printf("%d %s\n", $2.siz, $2.str); }
	|
	;
base : number 		 {sprintf ($$.str,"assign %s to %dt",$1.str,temp++);}	
number:
INTEGER						{ sprintf($$.str,"%s", $1.str);
										$$.siz = 1;}
|INTEGER number		{ sprintf($$.str,"%s%s%s_%s", ($2.siz>=3?"(":""), $1.str, numberParts[$2.siz%6], $2.str+($2.siz>=4?1:0));
										$$.siz = $2.siz +1;}

%%
void yyerror(char *s) {
printf("ERROR : %s\n", s);
return;
}
int main(void) {
yyparse();
return 0;
}
