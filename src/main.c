#include "compile.h"

const char *INPUT_PATH = "c:\\Users\\harry\\Documents\\GitHub\\lmc-compiler\\programs\\demo.txt";
const char *OUTPUT_PATH = "c:\\Users\\harry\\Documents\\GitHub\\lmc-compiler\\programs\\out.lmc";


int main(int argc, char **argv)
{
  // argv[1] - input path
  // argv[2] - output path
  char *input;
  char *output;
  switch (argc){
    case 1:
      // No args; Use defaults
      input = INPUT_PATH;
      output = OUTPUT_PATH;
      break;
    case 2:
      // Input; Use same path but change filetype for output
      input = argv[1];
      output = strdup(input);
      output = strcat(output,".lmc"); // TODO strip previous filetype
      break;
    case 3:
      // Input and Output; Use args
      input = argv[1];
      output = argv[2];
      break;
    default:
      // TODO: Raise Error / Error Handling
      return -1;
      break;
  }
  if (compile(input, output) == 0) {
    printf("\nCompiled '%s' to '%s'", input, output);
  }
  else{
    printf("\nError compiling '%s' to '%s'", input, output);
  }
  return 0;
}
