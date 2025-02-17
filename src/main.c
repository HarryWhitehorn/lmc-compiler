#include "cmdline.h"
#include "compile.h"

const char *INPUT_PATH = "../programs/demo.txt";
const char *OUTPUT_PATH = "../programs/out.lmc";


int main(int argc, char *argv[])
{
  struct gengetopt_args_info args;

  if (cmdline_parser(argc, argv, &args) != 0)
  {
    fprintf(stderr, "Error parsing arguments\n");
    return EXIT_FAILURE;
  }

  /* Filepaths */
  // Input file
  if (args.input_given)
  {
    compileFromFile(args.input_arg);
    if (args.debug_flag)
    {
      printf("Input file: %s\n", args.input_arg);
    }
  }
  else
  {
    fprintf(stderr, "No input file specified\n");
    return EXIT_FAILURE;
  }

  // Output file
  if (args.output_given)
  {
    if (args.debug_flag)
    {
      printf("Output file: %s\n", args.output_arg);
    }
    printf("Writing to %s\n", args.output_arg);
    instructionsToFile(args.output_arg);
  }

  /* flags */
  // debug
  if (args.debug_flag)
  {
    printf("Debug flag enabled\n");
  }

  // print
  if (args.print_flag)
  {
    if (args.debug_flag)
    {
      printf("Print flag enabled\n");
    }
    instructionToStdout();
  }

  // comments
  if (args.comments_flag)
  {
    if (args.debug_flag)
    {
      printf("Comments flag enabled\n");
      // TODO handle comments
    }
  }

  cmdline_parser_free(&args);
  return EXIT_SUCCESS;
}
