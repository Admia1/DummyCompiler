%token INTEGER VARIABLE
%left '+' '-'
%left '*' '/'

%{
#include <stdlib.h>
#include <stdio.h>
#include "ParserObject.c"
#define YYSTYPE struct ParserObject

void yyerror(char *);
int yylex(void);
int sym[26];
char* numberParts [4] = {"", "Ten", "Hun", "Tou"};
int currentNumberSize = 0;
%}
%%
program:
	program number '\n' { printf("%d %s\n", $2.siz, $2.str); }
	|
	;

number:
INTEGER						{ sprintf($$.str,"%s", $1.str);
										$$.siz = 1;}
|INTEGER number		{ sprintf($$.str,"%s%s%s_%s", "", "", $1.str, $2.str);
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
