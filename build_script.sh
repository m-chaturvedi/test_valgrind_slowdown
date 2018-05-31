#!/bin/bash
set -exo pipefail
VALGRIND_OPTIONS="  --leak-check=full \
        --trace-children=yes \
        --track-origins=yes \
        --show-leak-kinds=definite,possible \
        "
MAIN=lorenz.cpp
OPT=$1

# WITH O0
if [ $OPT -eq 0 ]; then
        clang++-4.0 -std=c++11  $MAIN  -lboost_math_tr1 -o clang_out 
        eval "time ./clang_out"

        g++ -std=c++11 $MAIN -lboost_math_tr1 -o gcc_out  
        eval "time ./gcc_out"
# WITH O1
elif [ $OPT -eq 1 ];then
        clang++-4.0 -O1 -std=c++11  $MAIN  -lboost_math_tr1 -o clang_out 
        eval "time ./clang_out"

        g++ -O1 -std=c++11 $MAIN -lboost_math_tr1 -o gcc_out  
        eval "time ./gcc_out"
# WITH O1 and gprof
elif [ $OPT -eq 2 ]; then
        clang++-4.0 -std=c++11 -pg -O1  $MAIN  -lboost_math_tr1 -o clang_out 
        eval "time ./clang_out"
        gprof ./clang_out gmon.out > clang_analysis.txt;

        g++ -std=c++11 -pg -O1 $MAIN -lboost_math_tr1 -o gcc_out  
        eval "time ./gcc_out"
        gprof ./gcc_out gmon.out > gcc_analysis.txt;
# WITH O1 and Valgrind
elif [ $OPT -eq 3 ]; then
        clang++-4.0 -std=c++11 -g -O1  $MAIN  -lboost_math_tr1 -o clang_out 
        eval "time valgrind $VALGRIND_OPTIONS ./clang_out"
        g++ -std=c++11 -g -O1 $MAIN -lboost_math_tr1 -o gcc_out  
        eval "time valgrind $VALGRIND_OPTIONS ./gcc_out"

fi


