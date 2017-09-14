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

let relational_op = ">(=)?" | "<(=)?" | "(!|=)?="

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
  | relational_op as r { RELATIONAL_OP(Jlite_structs.RelationalOp r) }
  | "||" as b { OR_BOOLEAN_OP(Jlite_structs.BooleanOp b) }
  | "&&" as b { AND_BOOLEAN_OP(Jlite_structs.BooleanOp b) }
  | '+' as a { PLUS(Jlite_structs.ArithmeticOp (String.make 1 a)) }
  | '-' as a { MINUS(Jlite_structs.ArithmeticOp (String.make 1 a)) }
  | '*' as a { TIMES(Jlite_structs.ArithmeticOp (String.make 1 a)) }
  | '/' as a { DIVIDE(Jlite_structs.ArithmeticOp (String.make 1 a)) }
  | '=' { EQUAL }
  | '!' { EXCLAMATION }
  | '.' { PERIOD }
  | ';' { SEMICOLON }
  | '{' { OPEN_BRACE }
  | '}' { CLOSE_BRACE }
  | '(' { OPEN_PAREN }
  | ')' { CLOSE_PAREN }
  | ',' { COMMA }
  | "/*" { multi_line_comment_lex lexbuf }
  | "//" { single_line_comment_lex lexbuf }
  | whitespace { prog_lex lexbuf }
  | eof { EOF }

and single_line_comment_lex = parse
  | newline { prog_lex lexbuf }
  | _ { single_line_comment_lex lexbuf }

and multi_line_comment_lex = parse
  | "*/" { prog_lex lexbuf }
  | _ { multi_line_comment_lex lexbuf }