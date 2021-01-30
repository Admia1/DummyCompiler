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
	program base '\n' {printf("print %s \n",$2.str);}
	|
	;
base : add		 {sprintf ($$.str,"%s",$1.str);}	

add : add '+' mul	 {printf ("assign %s plu %s to t%d \n",$1.str,$3.str,temp);sprintf ($$.str,"t%d",temp++);}
add : add '-' mul	 {printf ("assign %s min %s to t%d \n",$1.str,$3.str,temp);sprintf ($$.str,"t%d",temp++);}
add : mul		 {sprintf ($$.str,"%s",$1.str);}

mul : mul '*' fac	 {printf ("assign %s mul %s to t%d \n",$1.str,$3.str,temp);sprintf ($$.str,"t%d",temp++);}
mul : mul '/' fac	 {printf ("assign %s div %s to t%d \n",$1.str,$3.str,temp);sprintf ($$.str,"t%d",temp++);}
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
