{
    open Printf
    open Jlite_parser
}

let lowercase = ['a'-'z']
let uppercase = ['A'-'Z']
let digit = ['0'-'9']
let underscore = '_'
let whitespace_char = ' ' | '\t'
let newline = '\r' | '\n' | "\r\n"

let whitespace = (whitespace_char | newline)+
let boolean = "true" | "false"
let identifier = lowercase (lowercase | uppercase | underscore | digit)*
let classname = uppercase (lowercase | uppercase | underscore | digit)*
let integer = digit+
let string = "\"[^\"\\\\]*(\\\\.[^\"\\\\]*)*\""

(* Operators *)
let unary_op = '!' | '-'
let assignment = '='
let period = '.'
let boolean_op = "||" | "&&"
let relational_op = ">(=)?" | "<(=)?" | "(!|=)?="
let arithmetic_op = "+" | "-" | "*" | "/"


rule prog_lex = parse
  | "class" { CLASS }
  | "if" { IF }
  | "else" { ELSE }
  | "while" { WHILE }
  | "readln" { READLN }
  | "println" { PRINTLN }
  | "return" { RETURN }
  | "new" { NEW }
  | "this" { THIS }
  | "null" { NULL }
  | "Void" { VOID(Jlite_structs.VoidT) }
  | "Int" { INTEGER(Jlite_structs.IntT) }
  | "Bool" { BOOLEAN(Jlite_structs.BoolT) }
  | "String" { STRING(Jlite_structs.StringT) }
  | boolean as b { BOOLEAN_LIT(bool_of_string b) }
  | integer as i { INTEGER_LIT(int_of_string i) }
  | string as str { STRING_LIT(str) }
  | identifier as id {
    match id with
        "main" -> MAIN_IDENTIFIER(Jlite_structs.SimpleVarId "main")
      | x -> IDENTIFIER(Jlite_structs.SimpleVarId x)
  }
  | classname as cname { CLASS_NAME(cname) }
  | unary_op as u { OP(Jlite_structs.UnaryOp (String.make 1 u)) }
  | boolean_op as b { OP(Jlite_structs.BooleanOp b) }
  | relational_op as r { OP(Jlite_structs.RelationalOp r) }
  | arithmetic_op as a { OP(Jlite_structs.ArithmeticOp (String.make 1 a)) }
  | whitespace { prog_lex lexbuf }
  | ';' { SEMICOLON }
  | '{' { OPEN_BRACE }
  | '}' { CLOSE_BRACE }
  | '(' { OPEN_PAREN }
  | ')' { CLOSE_PAREN }
  | ',' { COMMA }
  | "/*" { OPEN_MULTI_COMMENT }
  | "//" { SINGLE_COMMENT }
  | eof { EOF }

and single_line_comment_lex = parse
  | newline { prog_lex lexbuf }
  | _ { single_line_comment_lex lexbuf }

and multi_line_comment_lex = parse
  | "*/" { prog_lex lexbuf }
  | _ { multi_line_comment_lex lexbuf }