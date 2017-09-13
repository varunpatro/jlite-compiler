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
%token CLASS IF ELSE WHILE READLN PRINTLN RETURN NEW
%token THIS NULL
%token OPEN_BRACE CLOSE_BRACE OPEN_PAREN CLOSE_PAREN
%token COMMA SEMICOLON
%token OPEN_MULTI_COMMENT CLOSE_MULTI_COMMENT SINGLE_COMMENT

%start input
%type <Jlite_structs.md_decl> input

%%

input:
	| md_decl { $1 }
	;

md_decl:
	| var_type id OPEN_PAREN fml_list CLOSE_PAREN md_body  {
		{
			rettype = $1;
			jliteid = $2;
			params = $4;
			localvars = fst $6;
			stmts = snd $6;
		}
	}
	;

fml_list:
	| /* empty */ { [] }
	| var_type id fml_rest_list { ($1, $2) :: $3 }
	;

fml_rest_list:
	| /* empty */ { [] }
	| fml_rest_list fml_rest { $1 @ [$2] }
	;

fml_rest:
	| COMMA var_type id { ($2, $3) }
	;

md_body:
	| OPEN_BRACE var_decl_list stmt stmt_list CLOSE_BRACE { ($2, $3 :: $4) }
	;

stmt_list:
	| /* empty */ { [] }
	| stmt_list stmt { $1 @ [$2] }
	;

stmt:
	| RETURN SEMICOLON { Jlite_structs.ReturnVoidStmt }
	;

var_decl_list:
	| /* empty */ { [] }
	| var_decl_list var_decl { $1 @ [$2] }
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