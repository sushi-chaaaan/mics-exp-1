alpha   [a-zA-Z]
digit   [0-9]
white   [\n\t ]
%%
read                        { return READ; }
print                       { return PRINT; }
while                       { return WHILE; }
"++"                        { return PLUSPLUS; }
"<="                        { return LTE; }
">="                        { return GTE; }
"=="                        { return EQ; }
"&&"                        { return AND; }
"||"                        { return OR; }
{alpha}({alpha}|{digit})*   { return IDENT; }
{digit}+                    { return NUM; }
[+\-=!();{}<>]               { return yytext[0]; }
{white}
