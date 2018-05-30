#!/bin/bash
set -euxo pipefail
VALGRIND_OPTIONS="  --leak-check=full \
  --trace-children=yes \
  --track-origins=yes \
  --show-leak-kinds=definite,possible \
"
MAIN=lorenz.cpp

clang++-4.0 -std=c++11 -g -O1  $MAIN  -lboost_math_tr1 -o clang_out 
eval "time valgrind $VALGRIND_OPTIONS ./clang_out"
g++ -std=c++11 -g -O1 $MAIN -lboost_math_tr1 -o gcc_out  
eval "time valgrind $VALGRIND_OPTIONS ./gcc_out"

