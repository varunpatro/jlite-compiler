{
    open Printf
    open Jlite_parser
}

let lowercase = ['a'-'z']
let uppercase = ['A'-'Z']
let digit = ['0'-'9']
let underscore = '_'
let whitespace = ' ' | '\t'
let newline = '\r' | '\n' | "\r\n"

let whitespaces = whitespace+
let keyword = "class" | "if" | "else" | "while" | "readln" | "println" | "return" | "new" | "this" | "null"
let boolean = "true" | "false"
let identifier = lowercase (lowercase | uppercase | underscore | digit)*
let classname = uppercase (lowercase | uppercase | underscore | digit)*
let integer = digit+
let string = "\"[^\"\\\\]*(\\\\.[^\"\\\\]*)*\""

(* Punctuation *)
let semicolon = ";"
let open_curly = "{"
let close_curly = "}"
let open_paren = "("
let close_paren = ")"
let comma = ","
let open_multi_comment = "/*"
let close_multi_comment = "*/"
let single_comment = "//"

(* Operators *)
let unary_op = "!" | "-"
let binary_op = "=" | "||" | "&&" | ">" | "<" | "." | "==" | ">=" | "<=" | "!=" | "+" | "-" | "*" | "/"


rule prog_lex = parse
  | keyword as kw { printf "kw: %s\n" kw; prog_lex lexbuf }
  | boolean as b { printf "bool: %s\n" b; prog_lex lexbuf }
  | identifier as id { printf "id: %s\n" id; prog_lex lexbuf }
  | classname as cname { printf "cname: %s\n" cname; prog_lex lexbuf }
  | integer as i { printf "i: %s\n" i; prog_lex lexbuf }
  | string as str { printf "str: %s\n" str; prog_lex lexbuf }
  | unary_op as u { printf "u: %c\n" u; prog_lex lexbuf }
  | binary_op as b { printf "b: %s\n" b; prog_lex lexbuf }
  | semicolon as s { printf "s: %c\n" s; prog_lex lexbuf }
  | open_curly as oc { printf "oc: %c\n" oc; prog_lex lexbuf }
  | close_curly as cc { printf "cc: %c\n" cc; prog_lex lexbuf }
  | open_paren as op { printf "op: %c\n" op; prog_lex lexbuf }
  | close_paren as cp { printf "cp: %c\n" cp; prog_lex lexbuf }
  | comma as c { printf "comma: %c\n" c; prog_lex lexbuf }
  | open_multi_comment as omc { printf "omc: %s\n" omc; multi_line_comment_lex lexbuf }
  | single_comment as sc { printf "sc: %s\n" sc; single_line_comment_lex lexbuf }
  | whitespaces as w { printf "w: %s\n" w; prog_lex lexbuf }
  | newline { prog_lex lexbuf }
  | eof { exit 0 }

and single_line_comment_lex = parse
  | newline { prog_lex lexbuf }
  | _ { single_line_comment_lex lexbuf }

and multi_line_comment_lex = parse
  | close_multi_comment { prog_lex lexbuf }
  | _ { multi_line_comment_lex lexbuf }

{
  let main () =
    let lexbuf = Lexing.from_channel stdin in 
    prog_lex lexbuf
  let _ = main ()
}