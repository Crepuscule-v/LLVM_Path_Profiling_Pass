# build project
cmake -B build
cd build 
make
cd ..

# we will get `build/lib/instrument/libpathprofilePass.a` & `build/lib/runtime/libpathprofileRt.a`

# compile test with our pass 
CLANG=clang++-15
OPT=opt-15
TEST_FILE=test1.cpp     # modify it to switch test file

$CLANG -emit-llvm -S tests/test1.cpp -o test.ll
$OPT -load ./build/lib/instrument/libpathprofilePass.a -S --pathProfile -enable-new-pm=0 test.ll -o test1.ll

$CLANG -c test1.ll -o test1.o
$CLANG test1.o ./build/lib/instrument/llibpathprofileRt.a -o test

./test
