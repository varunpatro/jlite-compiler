open Jlite_lexer;;
open Jlite_parser;;

let main () =
  try
    let lexbuf = Lexing.from_channel stdin in
      Jlite_parser.input Jlite_lexer.prog_lex lexbuf

  with End_of_file -> exit 0
let _ = Printexc.print main ()