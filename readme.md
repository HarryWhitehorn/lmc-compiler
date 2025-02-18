# lmc compiler

A simple *compiler* for turning LMC [Mnemonic Instructions](https://en.wikipedia.org/wiki/Little_man_computer#Instructions) into decimal format.

The `/programs` folder holds some examples, with `.txt` showing Mnemonic format and `.lmc` showing the decimal format.

## Building

Requires Bison (3.0) and Flex (2.6).
Requires [Gengetopts](https://www.gnu.org/software/gengetopt/gengetopt.html#Installation) (2.23).

## Usage

```sh
Usage: lmc_compiler -i <input> [options]

  -h, --help           Print help and exit
  -V, --version        Print version and exit
  -i, --input=STRING   Path to the input file
  -o, --output=STRING  Path to the output .lmc file
  -d, --debug          Prints additional debug information to stdout (default=off)
  -p, --print          Prints the output of the compilation  (default=on)
  -c, --comments       WIP: Preserve comments in the output  (default=off)  
```

## todos

- BUG potential bug / discrepancy where a final dat may be a line later than needed. Test further.
- TODO Add comment handling.
- TODO Use snprintf for safety?
- TODO Error Raising where appropriate.
- TODO Full comments.
- TODO Write tests.
- TODO Write readme.md

## Appendix

[Flex/Bison Tutorial](https://aquamentus.com/flex_bison.html)
[Simple Github Repo Example](https://github.com/IvanoBilenchi/flex-bison-example/tree/master)