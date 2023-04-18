# compile test with our pass 
CLANG=clang++-15
OPT=opt-15
TEST_FILE_PATH=self_cycle_test
TEST_FILE=self_cycle_test.cpp             # modify it to switch test file

$CLANG -emit-llvm -S $TEST_FILE -o test.ll
$OPT -dot-cfg -enable-new-pm=0 -disable-output test.ll        # get cfg for each function

$OPT -load ../../build/lib/instrument/libpathProfilePass.so -S --pathProfile -enable-new-pm=0 test.ll -o test1.ll

$CLANG -c test1.ll -o test1.o -g 
$CLANG test1.o -L../../build/lib/runtime/ -lpathProfileRt -o test -g 

# need to export LD_LIBRARY_PATH
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/fuzz/Desktop/LLVM_path_profiling_pass/build/lib/runtime