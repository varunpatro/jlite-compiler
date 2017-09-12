%{
	open Printf	
%}

%token WHITESPACE
%token <string> KEYWORD
%token <string> BOOLEAN INTEGER STRING
%token IDENTIFIER CLASS_NAME
%token OPEN_BRACE CLOSE_BRACE OPEN_PAREN CLOSE_PAREN
%token COMMA SEMICOLON
%token OPEN_MULTI_COMMENT CLOSE_MULTI_COMMENT SINGLE_COMMENT
%token UNARY_OP BINARY_OP

%start input
%type <unit> input

%%

input: BOOLEAN { printf "bool %s\n" $1; flush stdout }
;