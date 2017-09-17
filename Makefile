jlite_main: jlite_lexer.ml jlite_parser.ml jlite_main.ml
	ocamlc -c jlite_structs.ml
	ocamlc -c jlite_parser.mli
	ocamlc -c jlite_parser.ml
	ocamlc -c jlite_lexer.ml
	ocamlc -c jlite_main.ml
	ocamlc -o jlite_main jlite_lexer.cmo jlite_parser.cmo jlite_structs.cmo jlite_main.cmo

jlite_lexer.ml: jlite_lexer.mll jlite_parser.ml
	ocamllex jlite_lexer.mll

jlite_parser.ml: jlite_structs.ml jlite_parser.mly
	ocamlyacc jlite_parser.mly

clean:
	rm *.cmi *.cmo *.mli jlite_lexer.ml jlite_parser.ml jlite_parser.output jlite_main