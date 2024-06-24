%token NUM;
%token IDENT;
%%
stlist :
       | stlist stat '\n'
       ;
stat   : var '=' expr      { stab[$1].val = $3; printf("%d\n", $3); }
       | var '=' stat      { stab[$1].val = stab[$3].val; printf("%d\n", stab[$3].val); }
       ;
expr   : prim              { $$ = $1; }
       | expr '+' prim     { $$ = $1 + $3; }
       | expr '-' prim     { $$ = $1 - $3; }
       ;
prim   : NUM               { $$ = atoi(yytext); }
       | var               { $$ = stab[$1].val; }
       | '(' expr ')'      { $$ = $2; }
       ;
var    : IDENT             { $$ = lookup(yytext); }
       ;
