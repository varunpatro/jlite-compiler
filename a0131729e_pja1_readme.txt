# jlite-compiler

This project uses `ocamllex` and `ocamlyacc` to create a compiler that reads a program from standard input.

## Building

Simply run `make` to build a `jlite_main` binary.

    $ make

Here's the expected output:

    ocamlyacc jlite_parser.mly
    1 rule never reduced
    6 reduce/reduce conflicts.
    ocamllex jlite_lexer.mll
    126 states, 5452 transitions, table size 22564 bytes
    ocamlc -c jlite_structs.ml
    ocamlc -c jlite_parser.mli
    ocamlc -c jlite_parser.ml
    ocamlc -c jlite_lexer.ml
    ocamlc -c jlite_main.ml
    ocamlc -o jlite_main jlite_lexer.cmo jlite_parser.cmo jlite_structs.cmo jlite_main.cmo


## Running

To run simply pass in the source code of a jlite program on standard input. For example, here's the contents of the file `./good_input/super_simple_main.j`:

    $ cat ./good_input/super_simple_main.j

    class Test {
      Void main() {
        return null;
      }
    }

We can pass this program to `jlite_main` to as following:

    $ ./jlite_main < ./good_input/super_simple_main.j


    ======= JLite Program =======

    class Test{
      void main(){
        Return null;
      }

    }



    ======= End of JLite Program =======

There are several other example jlite programs in the `good_input/` folder. The examples in the `bad_input/` folder are incorrect jlite programs and will generate a parse error as following:

    $ ./jlite_main < ./bad_input/simple_main.j

    Fatal error: exception Parsing.Parse_error

## Components

This project makes use of `ocamllex` and `ocamlyacc`.

## Grammar

The grammar of jlite can be found in the attached pdf file `pja1.pdf`
