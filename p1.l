%{
#include <stdlib.h>
#include "y.tab.h"
#include "ParserObject.c"
char* digitName[10] = {"Zer", "One", "Two", "Thr", "Fou", "Fiv", "Six", "Sev", "Nin"};

void yyerror(char *);
%}

%%
[0-9]	{
	sprintf(yylval.str, "%s", digitName[(*yytext - '0')]);
	yylval.siz = 1;
	return INTEGER;
	}

[-+*/\n] { return *yytext; }

[ \t]	;

.	yyerror("invalid character");

%%
int yywrap(void) {
return 1;
}
