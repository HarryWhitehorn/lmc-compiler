cmake_minimum_required(VERSION 3.21)

project(LMC_Compiler VERSION 1.0 LANGUAGES C)

set(SRC_DIR "${CMAKE_SOURCE_DIR}/src")
set(PARSER_DIR "${CMAKE_CURRENT_BINARY_DIR}")
set(GGO_DIR "${CMAKE_CURRENT_BINARY_DIR}")

find_package(FLEX 2.6 REQUIRED)
find_package(BISON 3.0 REQUIRED)

set(LEXER_OUT "${PARSER_DIR}/lexer.c")
set(PARSER_OUT "${PARSER_DIR}/parser.c")

flex_target(LEXER "${SRC_DIR}/lexer.l" "${LEXER_OUT}" DEFINES_FILE "${PARSER_DIR}/lexer.h")
bison_target(PARSER "${SRC_DIR}/parser.y" "${PARSER_OUT}" DEFINES_FILE "${PARSER_DIR}/parser.h")
add_flex_bison_dependency(LEXER PARSER)

add_custom_command(
    OUTPUT "${GGO_DIR}/cmdline.c" "${GGO_DIR}/cmdline.h"
    COMMAND gengetopt < "${SRC_DIR}/lmc_compiler.ggo" --output-dir "${GGO_DIR}"
    DEPENDS "${SRC_DIR}/lmc_compiler.ggo"
    COMMENT "Generating cmdline.c and cmdline.h using gengetopt"
)

add_custom_target(gengetopt_target
    DEPENDS "${GGO_DIR}/cmdline.c" "${GGO_DIR}/cmdline.h"
)

add_executable(lmc_compiler "${SRC_DIR}/main.c" 
    "${SRC_DIR}/compile.c" "${SRC_DIR}/compile.h"
    "${LEXER_OUT}" "${PARSER_OUT}"
    "${GGO_DIR}/cmdline.c" "${GGO_DIR}/cmdline.h"
)

target_include_directories(lmc_compiler PRIVATE "${PARSER_DIR}")

add_dependencies(lmc_compiler gengetopt_target)