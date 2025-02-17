# lmc compiler

[Reddit Comment on Steps](https://www.reddit.com/r/ProgrammingLanguages/comments/1475h9o/comment/jntyywr/)

## GNU

[Flex/Bison Tutorial](https://aquamentus.com/flex_bison.html)
[Simple Github Repo Example](https://github.com/IvanoBilenchi/flex-bison-example/tree/master)

### Lexer

Flex

### Passer (AST)

Bison

#### Notes

- Identifiers are in LIFO linked list
    - TODO change to FIFO?
- Instructions are FIFO linked list

## LLVM

[Reddit Comment on AST->LLVM](https://www.reddit.com/r/Compilers/comments/xpem02/comment/iq4d22g/)

## Main

### Inputs

- input filepath
    - required
    - string
- output filepath
    - optional
    - string

### Outputs

- print (stdout)
    - default: true
    - bool
- file
    - default: false
    - implicit with output path
    - requires string input
- ~~buffer~~
    - not from cli

### Options

- Comments
    - default: false
    - bool

## TODO

- potential bug / discrepancy where a final dat may be a line later than needed.
- ensure that identifiers and instructions are deleted after compile / on new compile

- Handle dynamic file input

- VS Code plugin / QT Editor
    - Syntax Highlighting
    - Linter
- Compiler
- Interpreter?
