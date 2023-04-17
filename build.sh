build project
cmake -B build
cd build 
make
cd ..

# we will get `build/lib/instrument/libpathprofilePass.a` & `build/lib/runtime/libpathprofileRt.a`

# compile test with our pass 
CLANG=clang++-15
OPT=opt-15
TEST_FILE=test1.cpp     # modify it to switch test file

cd tests
$CLANG -emit-llvm -S $TEST_FILE -o test.ll
$OPT -dot-cfg -enable-new-pm=0 -disable-output test.ll        # get cfg for each function
$OPT -load ../build/lib/instrument/libpathProfilePass.so -S --pathProfile -enable-new-pm=0 test.ll -o test1.ll

$CLANG -c test1.ll -o test1.o
$CLANG test1.o -L../build/lib/runtime/ -lpathProfileRt -o test -v