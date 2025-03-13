# lmc compiler

A simple *compiler* for turning LMC [Mnemonic Instructions](https://en.wikipedia.org/wiki/Little_man_computer#Instructions) into decimal format.

Supports full instruction set as well as:

| Numeric Code  | Mnemonic code  | Instruction  | Description  |
|--- |--- |--- |--- |
| 922  | OTC  | OUTPUT CHARACTER  | Copy the value from the accumulator to the OUTBOX converting to an ascii character  |

The `/programs` directory holds some examples, with `.txt` showing mnemonic format and `.lmc` showing the decimal format.

## Building

### Library

- [Bison](https://www.gnu.org/software/bison/) (3.0)
- [Flex](https://www.gnu.org/software/flex/) (2.6)

### Executable

- Library requirements
- [Gengetopts](https://www.gnu.org/software/gengetopt/gengetopt.html#Installation) (2.23)

## Usage

### Command Line

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

### Library

#### Library Usage

The input program must first be parsed using one of the following public methods from `compile.h`:

```c
void compileFromFile(const char *inputPath); // Reads a files contents

void compileFromString(char *String); // Reads from a null-terminated string
```

The output program can then be accessed through any of the following public methods from `compile.h`:

```c
void instructionsToFile(const char *outputPath); // Writes to file

void instructionsToCharBuffer(char *Buffer); // Writes instructions as strings to buffer

void instructionsToIntBuffer(int *Buffer); // Writes instructions as ints to buffer

void instructionsToStdout(); // Prints to stdout
```

Once a input program has been loaded, it can be outputted via any of the `instructionsTo` methods, repeatedly, until a new program is loaded using one of the `compileFrom` methods or the parser is reset using `freeParser`.

```c
void freeParser(); // Frees the current loaded instructions from memory 
```

#### CMakeLists.txt

The library can be included in a CMakeLists.txt by using `FetchContent` as shown:

```CMakeLists.txt
include(FetchContent)

FetchContent_Declare(
    lmc_compiler
    GIT_REPOSITORY https://github.com/HarryWhitehorn/lmc-compiler.git
    GIT_TAG master
)

FetchContent_MakeAvailable(lmc_compiler)
```

#### Example

```c
#include "compile.h"

int main(int argc, char *argv[])
{
  // Compile from string
  char myInputString[] = "INP\nSTA 99\nINP\nADD 99\nOUT\nHLT\n";
  compileFromString(myInputString);

  // Write to buffer
  int myOutputBuffer[100] = { 0 };
  instructionsToIntBuffer(myOutputBuffer);

  // Print buffer
  size = sizeof(myOutputBuffer)/sizeof(myOutputBuffer[0]);
  for (int i=0; i<size; i++)
  {
    printf("%03d\n", myOutputBuffer[i]); // force three digits with "%03d" for clarity
  }

  // Free
  freeParser();

  return 0;
}
```

## todos

- BUG potential bug / discrepancy where a final dat may be a line later than needed. Test further.
- TODO Add comment handling.
- TODO Use snprintf for safety?
- TODO Exspand tests.
- TODO Modify CMakeLists.txt to be able to generate the library without the need for the exactable.

## Appendix

[Flex/Bison Tutorial](https://aquamentus.com/flex_bison.html)
[Simple Github Repo Example](https://github.com/IvanoBilenchi/flex-bison-example/tree/master)
