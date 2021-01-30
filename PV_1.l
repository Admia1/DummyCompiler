%option noyywrap
%{
#include <stdlib.h>
#include <stdio.h>

FILE *fp;
%}

%%
[1-9]	{
		yylval = atoi(yytext);
		fprintf(fp, "I read integer with value %d \n",yylval);
		return INTEGER; 
	}
[-()=+*]		{
			yylval = *yytext;
			//printf("I read op with value");
			//printf(yytext);
			fprintf(fp, "I read op with value");
			fprintf(fp, yytext);
			return OP;
			}
%%

int main(int argc, char *argv[]) 
{
	 yyin = fopen("input.txt", "r");
	 fp = fopen("/tmp/test.txt", "w");
	 yylex();
	 fclose(fp);
	 fclose(yyin);
	 return 0;
} 