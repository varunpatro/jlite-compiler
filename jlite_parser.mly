%{
	open Printf
	open Jlite_structs
%}

%token <string> KEYWORD
%token <bool> BOOLEAN
%token <int> INTEGER
%token <string> STRING
%token <Jlite_structs.var_id> IDENTIFIER
%token <Jlite_structs.class_name> CLASS_NAME
%token <Jlite_structs.jlite_op> OP
%token OPEN_BRACE CLOSE_BRACE OPEN_PAREN CLOSE_PAREN
%token COMMA SEMICOLON
%token OPEN_MULTI_COMMENT CLOSE_MULTI_COMMENT SINGLE_COMMENT

%start input
%type <Jlite_structs.var_decl> input

%%

input:
	| var_decl { $1 }
	;

var_decl:
	| var_type id SEMICOLON { ($1, $2) }
	;

var_type:
	| CLASS_NAME { Jlite_structs.ObjectT $1 }
	;

id:
	| IDENTIFIER { $1 }
	;