%{
	open Printf
	open Jlite_structs
%}

%token <bool> BOOLEAN_LIT
%token <int> INTEGER_LIT
%token <string> STRING_LIT
%token <Jlite_structs.var_id> MAIN_IDENTIFIER
%token <Jlite_structs.var_id> IDENTIFIER
%token <Jlite_structs.class_name> CLASS_NAME
%token <Jlite_structs.jlite_type> VOID INTEGER BOOLEAN STRING
%token <Jlite_structs.jlite_op> OP
%token CLASS IF ELSE WHILE READLN PRINTLN RETURN NEW
%token THIS NULL
%token OPEN_BRACE CLOSE_BRACE OPEN_PAREN CLOSE_PAREN
%token COMMA SEMICOLON
%token OPEN_MULTI_COMMENT CLOSE_MULTI_COMMENT SINGLE_COMMENT
%token EOF

%start input
%type <Jlite_structs.jlite_program> input

%%

input:
	| program EOF { $1 }
	;

program:
	| class_main class_decl_list { ($1, $2) }
	;

class_main:
	| CLASS CLASS_NAME OPEN_BRACE VOID MAIN_IDENTIFIER OPEN_PAREN fml_list CLOSE_PAREN md_body CLOSE_BRACE {
		let class_name = $2 in
		let md_decl = {
			rettype = $4;
			jliteid = $5;
			params = $7;
			localvars = fst $9;
			stmts = snd $9;
		} in
		(class_name, md_decl)
	}
	;

class_decl_list:
	| /* empty */ { [] }
	| class_decl_list class_decl { $1 @ [$2] }
	;

class_decl:
	| CLASS CLASS_NAME OPEN_BRACE var_decl_list md_decl_list CLOSE_BRACE { ($2, $4, $5) }
	;

md_decl_list:
	| /* empty */ { [] }
	| md_decl md_decl_list { $1 :: $2 }
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
	| VOID { $1 }
	| INTEGER { $1 }
	| BOOLEAN { $1 }
	| STRING { $1 }
	;

id:
	| IDENTIFIER { $1 }
	| MAIN_IDENTIFIER { $1 }
	;