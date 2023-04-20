// Passed
#include <random>
#include <iostream>
#include <unistd.h>

int somefunc(int x) {
    int i = 0;
    int j = 0;
    int sum = 0;
    for (i = 1; i < x; i++) {
        sum += x/i;
    }
    for (j = 0; j < x; j+=2) {
        sum += x*j;
    }
    return sum;
}

int main() {
    int c = 0;
    c+= somefunc(10);
    c+= somefunc(-10);
    c+= somefunc(0);
    c+= somefunc(4);
    while (true) {
        int x = rand() % 20 - 10;
        somefunc(x);
    }
    return c;
}
/*
    Test Result :
        path : 0    times: 2
        path : 1    times: 0
        path : 2    times: 2
        path : 3    times: 10
        path : 4    times: 2
        path : 5    times: 0
        path : 6    times: 5
        path : 7    times: 2
    
    Sum to path :
        0  _Z8somefunci_block_1  _Z8somefunci_block_2  _Z8somefunci_block_3  _Z8somefunci_block_4 
        1  _Z8somefunci_block_1  _Z8somefunci_block_2  _Z8somefunci_block_5  _Z8somefunci_block_6  _Z8somefunci_block_7  _Z8somefunci_block_8  
        2  _Z8somefunci_block_1  _Z8somefunci_block_2  _Z8somefunci_block_5  _Z8somefunci_block_6  _Z8somefunci_block_9  
        3  _Z8somefunci_block_2  _Z8somefunci_block_3  _Z8somefunci_block_4  
        4  _Z8somefunci_block_2  _Z8somefunci_block_5  _Z8somefunci_block_6  _Z8somefunci_block_7  _Z8somefunci_block_8  
        5  _Z8somefunci_block_2  _Z8somefunci_block_5  _Z8somefunci_block_6  _Z8somefunci_block_9  
        6  _Z8somefunci_block_6  _Z8somefunci_block_7  _Z8somefunci_block_8 
        7  _Z8somefunci_block_6  _Z8somefunci_block_9   
*/