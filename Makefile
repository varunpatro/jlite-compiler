all: lexer
	ocamlc -c jlite_main.ml
	ocamlc -o jlite_main jlite_lexer.cmo jlite_parser.cmo jlite_main.cmo

parser: jlite_parser.ml
	ocamlc -c jlite_parser.ml

lexer: parser jlite_lexer.ml
	ocamlc -c jlite_lexer.ml

jlite_parser.ml: jlite_parser.mly
	ocamlyacc jlite_parser.mly
	ocamlc -c jlite_parser.mli

jlite_lexer.ml: jlite_lexer.mll
	ocamllex jlite_lexer.mll

clean:
	rm *.cmi *.cmo *.mli jlite_lexer.ml jlite_parser.ml