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
base : add		 {sprintf ($$.str,"assign %s to %dt",$1.str,temp++);}	

add : add '+' mul	 {sprintf ($$.str,"%s plu %s",$1.str,$3.str);}
add : add '-' mul	 {sprintf ($$.str,"%s min %s",$1.str,$3.str);}
add : mul		 {sprintf ($$.str,"%s",$1.str);}

mul : mul '*' fac	 {sprintf ($$.str,"%s mul %s",$1.str,$3.str);}
mul : mul '/' fac	 {sprintf ($$.str,"%s div %s",$1.str,$3.str);}
mul : fac	  	 {sprintf ($$.str,"%s",$1.str);}

fac : '(' base ')'	 {sprintf ($$.str,"%s",$2.str);}
fac : number		 {sprintf ($$.str,"%s",$1.str);}

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
