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
%token <Jlite_structs.jlite_op> OR_BOOLEAN_OP AND_BOOLEAN_OP RELATIONAL_OP PLUS MINUS TIMES DIVIDE
%token CLASS IF ELSE WHILE READLN PRINTLN RETURN NEW
%token THIS NULL
%token EQUAL EXCLAMATION PERIOD
%token OPEN_BRACE CLOSE_BRACE OPEN_PAREN CLOSE_PAREN
%token COMMA SEMICOLON
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

stmt_list_min_one:
	| stmt { [$1] }
	| stmt_list_min_one stmt { $1 @ [$2] }
	;

stmt_list:
	| /* empty */ { [] }
	| stmt_list stmt { $1 @ [$2] }
	;

stmt:
	| if_part else_part { Jlite_structs.IfStmt(fst $1, snd $1, $2) }
	| WHILE OPEN_PAREN exp CLOSE_PAREN OPEN_BRACE stmt_list_min_one CLOSE_BRACE { Jlite_structs.WhileStmt($3, $6) }
	| READLN OPEN_PAREN id CLOSE_PAREN SEMICOLON { Jlite_structs.ReadStmt $3 }
	| PRINTLN OPEN_PAREN id CLOSE_PAREN SEMICOLON { Jlite_structs.PrintStmt (Jlite_structs.Var $3) }
	| id EQUAL exp SEMICOLON { Jlite_structs.AssignStmt($1, $3) }
	| atom PERIOD id EQUAL exp SEMICOLON { Jlite_structs.AssignFieldStmt(Jlite_structs.FieldAccess($1, $3), $5) }
	| atom OPEN_PAREN exp_list CLOSE_PAREN SEMICOLON { Jlite_structs.MdCallStmt(Jlite_structs.MdCall($1, $3)) }
	| RETURN exp SEMICOLON { Jlite_structs.ReturnStmt $2 }
	| RETURN SEMICOLON { Jlite_structs.ReturnVoidStmt }
	;

if_part:
	| IF OPEN_PAREN exp CLOSE_PAREN OPEN_BRACE stmt_list_min_one CLOSE_BRACE { ($3, $6) }
	;

else_part:
	| ELSE OPEN_BRACE stmt_list_min_one CLOSE_BRACE { $3 }
	;

exp:
	| bexp { $1 }
	| aexp { $1 }
	| sexp { $1 }
	;

bexp:
	| bexp OR_BOOLEAN_OP conj { Jlite_structs.BinaryExp($2, $1, $3) }
	| conj { $1 }
	;

conj:
	| conj AND_BOOLEAN_OP rexp { Jlite_structs.BinaryExp($2, $1, $3) }
	| rexp { $1 }
	;

rexp:
	| aexp RELATIONAL_OP aexp { Jlite_structs.BinaryExp($2, $1, $3) }
	| bgrd { $1 }
	;

bgrd:
	| EXCLAMATION bgrd { $2 }
	| BOOLEAN_LIT { Jlite_structs.BoolLiteral $1 }
	| atom { $1 }
	;

aexp:
	| aexp PLUS term { Jlite_structs.BinaryExp($2, $1, $3) }
	| aexp MINUS term { Jlite_structs.BinaryExp($2, $1, $3) }
	| term { $1 }
	;

sexp:
	| STRING_LIT { Jlite_structs.StringLiteral $1 }
	| atom { $1 }
	;

term:
	| term TIMES factor { Jlite_structs.BinaryExp($2, $1, $3) }
	| term DIVIDE factor { Jlite_structs.BinaryExp($2, $1, $3) }
	| factor { $1 }
	;

factor:
	| INTEGER_LIT { Jlite_structs.IntLiteral $1 }
	| MINUS factor { Jlite_structs.UnaryExp ($1, $2) }
	| atom { $1 }
	;

atom:
	| atom PERIOD id { Jlite_structs.FieldAccess($1, $3) }
	| atom OPEN_PAREN exp_list CLOSE_PAREN { Jlite_structs.MdCall($1, $3) }
	| THIS { Jlite_structs.ThisWord }
	| id { Jlite_structs.Var $1 }
	| NEW CLASS_NAME OPEN_PAREN CLOSE_PAREN { Jlite_structs.ObjectCreate $2 }
	| OPEN_PAREN exp CLOSE_PAREN { $2 }
	| NULL { Jlite_structs.NullWord }
	;

exp_list:
	| /* empty */ { [] }
	| exp exp_rest_list { $1 :: $2 }
	;

exp_rest_list:
	| /* empty */ { [] }
	| exp_rest_list exp_rest { $1 @ [$2] }
	;

exp_rest:
	| COMMA exp { $2 }

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