rm -rf build

build project
cmake -B build
cd build 
make
cd ..

# we will get `build/lib/instrument/libpathprofilePass.a` & `build/lib/runtime/libpathprofileRt.a`

# compile test with our pass 
CLANG=clang++-15
OPT=opt-15
TEST_FILE=basic_test/basic.cpp     # modify it to switch test file

cd tests
$CLANG -emit-llvm -S $TEST_FILE -o test.ll

$OPT -load ../build/lib/instrument/libpathProfilePass.so -S --pathProfile -enable-new-pm=0 test.ll -o test1.ll
$OPT -dot-cfg -enable-new-pm=0 -disable-output test1.ll        # get cfg for each function
cp ../build/lib/runtime/libpathProfileRt.so ./
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)

$CLANG -c test1.ll -o test1.o
$CLANG test1.o -L../build/lib/runtime/ -lpathProfileRt -o test
