# compile test with our pass 
CLANG=clang++-15
OPT=opt-15
TEST_FILE_PATH=basic_test
TEST_FILE=basic.cpp     # modify it to switch test file

$CLANG -emit-llvm -S $TEST_FILE -o test.ll

$OPT -load ../../build/lib/instrument/libpathProfilePass.so -S --pathProfile -enable-new-pm=0 test.ll -o test1.ll
$OPT -dot-cfg -enable-new-pm=0 -disable-output test1.ll        # get cfg for each function

$CLANG -c test1.ll -o test1.o -g 
$CLANG test1.o -L../../build/lib/runtime/ -lpathProfileRt -o test -g 

# need to export LD_LIBRARY_PATH