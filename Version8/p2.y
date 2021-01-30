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
	program base '\n' {
				$$.siz = $2.siz;
				 if($$.siz>1)
					printf("print %s \n",$2.str);
				 else
					printf("assign %s to t%d \n",$2.str,temp++);
			  }
	|
	;
base : add		 {sprintf ($$.str,"%s",$1.str);$$.siz = $1.siz;}	

add : add '+' mul	 {printf ("assign %s plu %s to t%d \n",$1.str,$3.str,temp);sprintf ($$.str,"t%d",temp++);$$.siz = $1.siz+ $3.siz;}
add : add '-' mul	 {printf ("assign %s min %s to t%d \n",$1.str,$3.str,temp);sprintf ($$.str,"t%d",temp++);$$.siz = $1.siz+ $3.siz;}
add : mul		 {sprintf ($$.str,"%s",$1.str);$$.siz = $1.siz;}

mul : mul '*' fac	 {printf ("assign %s mul %s to t%d \n",$1.str,$3.str,temp);sprintf ($$.str,"t%d",temp++);$$.siz = $1.siz+ $3.siz;}
mul : mul '/' fac	 {printf ("assign %s div %s to t%d \n",$1.str,$3.str,temp);sprintf ($$.str,"t%d",temp++);$$.siz = $1.siz+ $3.siz;}
mul : fac	  	 {sprintf ($$.str,"%s",$1.str);$$.siz = $1.siz;}

fac : '(' base ')'	 {sprintf ($$.str,"%s",$2.str);$$.siz = $2.siz;}
fac : number		 {sprintf ($$.str,"%s",$1.str);$$.siz = 1;}

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
