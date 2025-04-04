%{
/* Declaration Section */
#include <stdio.h>
#include "tokens.hpp"
%}

%option yylineno
%option noyywrap

whitespace      ([\r\n\t ])
digit           ([0-9])
letter          ([a-zA-Z])
digitletter     ([0-9a-zA-Z])
string          ([ !#-\[	\]-~])
escape          ([\\0\"nrt])
notescape       ([^\\0\"nrt])
hexa            (x(([2-6][0-9a-fA-F])|(7[0-9a-eA-E])))

%%
void                                                                            return VOID;
int                                                                             return INT;
byte                                                                            return BYTE;
bool                                                                            return BOOL;
and                                                                             return AND;
or                                                                              return OR;
not                                                                             return NOT;
true                                                                            return TRUE;
false                                                                           return FALSE;
return                                                                          return RETURN;
if                                                                              return IF;
else                                                                            return ELSE;
while                                                                           return WHILE;
break                                                                           return BREAK;
continue                                                                        return CONTINUE;
;                                                                               return SC;
,                                                                               return COMMA;
\(                                                                              return LPAREN;
\)                                                                              return RPAREN;
\{                                                                              return LBRACE;
\}                                                                              return RBRACE;
\[                                                                              return LBRACK;
\]                                                                              return RBRACK;
=                                                                               return ASSIGN;
[=!<>]=|<|>                                                                     return RELOP;
[-+*/]                                                                          return BINOP;
\/\/[^\r\n]*                                                                    return COMMENT;
{letter}{digitletter}*                                                          return ID;
0|([1-9]+{digit}*)                                                              return NUM;
\"({string}|\\{escape}|\\{hexa})*\"                                             return STRING;
\"({string}|\\{escape}|\\{hexa})*                                               return UNCLOSED_STRING;
\"({string}|\\{escape}|\\{hexa})*\\{notescape}                                  return UNDEFINED_ESCAPE;
\"({string}|\\{escape}|\\{hexa})*\\x([^0-9a-fA-F]|([^0-7][0-9a-fA-F])|([0-7][^0-9a-fA-F])|([^0-7][^0-9a-fA-F])|([01][0-9a-fA-F])|7[fF])    return UNDEFINED_HEXA;
{whitespace}                                                                    ;
.                                                                               return UNKNOWN_CHAR;
%%