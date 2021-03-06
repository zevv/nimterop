import os, strutils

import "."/git

const sourcePath = currentSourcePath().split({'\\', '/'})[0..^3].join("/") & "/inc"

proc treesitterSetup*() =
  gitPull("https://github.com/tree-sitter/tree-sitter/", "inc/treesitter", """
include/*
src/runtime/*
""")

  gitPull("https://github.com/JuliaStrings/utf8proc", "inc/utf8proc", """
*.c
*.h
""")

  let
    stack = sourcePath & "/treesitter/src/runtime/stack.c"

  stack.writeFile(stack.readFile().replace("inline Stack", "Stack"))

proc treesitterCSetup*() =
  gitPull("https://github.com/tree-sitter/tree-sitter-c", "inc/treesitter_c", """
src/*.h
src/*.c
src/*.cc
""")

  let
    headerc = sourcePath & "/treesitter_c/src/parser.h"

  headerc.writeFile("""
    typedef struct TSLanguage TSLanguage;
    const TSLanguage *tree_sitter_c();
  """)

proc treesitterCppSetup*() =
  gitPull("https://github.com/tree-sitter/tree-sitter-cpp", "inc/treesitter_cpp", """
src/*.h
src/*.c
src/*.cc
""")

  let
    headercpp = sourcePath & "/treesitter_cpp/src/parser.h"

  headercpp.writeFile("""
    typedef struct TSLanguage TSLanguage;
    const TSLanguage *tree_sitter_cpp();
  """)
