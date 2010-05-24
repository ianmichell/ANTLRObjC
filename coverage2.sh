#!/bin/sh
OBJROOT=`pwd`/build     
FRAMEWORK_NAME=ANTLR
FRAMEWORK_OBJ_DIR="${OBJROOT}/${FRAMEWORK_NAME}.build/${CONFIGURATION}/${FRAMEWORK_NAME}.build/Objects-normal/x86_64"
mkdir -p coverage
pushd coverage
find "${OBJROOT}" -name *.gcda -exec gcov -o "${FRAMEWORK_OBJ_DIR}" {} \;
popd 