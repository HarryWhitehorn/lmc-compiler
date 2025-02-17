# lmc compiler

## GNU

[Flex/Bison Tutorial](https://aquamentus.com/flex_bison.html)
[Simple Github Repo Example](https://github.com/IvanoBilenchi/flex-bison-example/tree/master)

### Lexer

Flex

### Passer

Bison

#### Notes

- Identifiers are in LIFO linked list
    - TODO change to FIFO?
- Instructions are FIFO linked list

## Main

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
