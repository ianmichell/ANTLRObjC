#!/bin/sh
OBJ_DIR="../build/ANTLR.build/Coverage/ANTLRTests.build/Objects-normal/x86_64"
mkdir -p coverage
pushd coverage
#find ${OBJ_DIR} -name *.gcda -exec gcov -o $OBJ_DIR {} \;
#lcov --directory ${OBJ_DIR} --zerocounters
lcov --directory ${OBJ_DIR} --capture --output-file ANTLR.info
genhtml ANTLR.info
popd
