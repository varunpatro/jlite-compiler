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
let keyword = "class" | "if" | "else" | "while" | "readln" | "println" | "return" | "new" | "this" | "null"
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
  | keyword as kw { KEYWORD(kw) }
  | boolean as b { BOOLEAN(bool_of_string b) }
  | integer as i { INTEGER(int_of_string i) }
  | string as str { STRING(str) }
  | identifier as id { IDENTIFIER(Jlite_structs.SimpleVarId id) }
  | classname as cname { CLASS_NAME(cname) }
  | unary_op as u { OP(Jlite_structs.UnaryOp (String.make 1 u)) }
  | boolean_op as b { OP(Jlite_structs.BooleanOp b) }
  | relational_op as r { OP(Jlite_structs.RelationalOp r) }
  | arithmetic_op as a { OP(Jlite_structs.ArithmeticOp (String.make 1 a)) }
  | whitespace { WHITESPACE }
  | ';' { SEMICOLON }
  | '{' { OPEN_BRACE }
  | '}' { CLOSE_BRACE }
  | '(' { OPEN_PAREN }
  | ')' { CLOSE_PAREN }
  | ',' { COMMA }
  | "/*" { OPEN_MULTI_COMMENT }
  | "//" { SINGLE_COMMENT }
  | eof { exit 0 }

and single_line_comment_lex = parse
  | newline { prog_lex lexbuf }
  | _ { single_line_comment_lex lexbuf }

and multi_line_comment_lex = parse
  | "*/" { prog_lex lexbuf }
  | _ { multi_line_comment_lex lexbuf }