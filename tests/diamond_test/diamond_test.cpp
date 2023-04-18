// Passed 
int somefunc(int x) {
    int i = 0;
    if (x == 0) {
        i = 5;
    }
    if (x <= 0) {
        i += -12;
    } else {
        i += x*2;
    }
    i*=3;
    if (x == 5) {
        i += 4;
    }
    return i + 4;
}

int main() {
    int c = 0;
    c+= somefunc(10);
    c+= somefunc(-10);
    c+= somefunc(0);
    c+= somefunc(4);
    return c;
}

/*
Test Result:
    path : 0    times: 0
    path : 1    times: 1
    path : 2    times: 0
    path : 3    times: 0
    path : 4    times: 0
    path : 5    times: 1
    path : 6    times: 0
    path : 7    times: 2

Sum to path:
    7  _Z8somefunci_block_1  _Z8somefunci_block_3  _Z8somefunci_block_5  _Z8somefunci_block_6  _Z8somefunci_block_8  
    6  _Z8somefunci_block_1  _Z8somefunci_block_3  _Z8somefunci_block_5  _Z8somefunci_block_6  _Z8somefunci_block_7  _Z8somefunci_block_8  
    5  _Z8somefunci_block_1  _Z8somefunci_block_3  _Z8somefunci_block_4  _Z8somefunci_block_6  _Z8somefunci_block_8  
    4  _Z8somefunci_block_1  _Z8somefunci_block_3  _Z8somefunci_block_4  _Z8somefunci_block_6  _Z8somefunci_block_7  _Z8somefunci_block_8  
    3  _Z8somefunci_block_1  _Z8somefunci_block_2  _Z8somefunci_block_3  _Z8somefunci_block_5  _Z8somefunci_block_6  _Z8somefunci_block_8  
    2  _Z8somefunci_block_1  _Z8somefunci_block_2  _Z8somefunci_block_3  _Z8somefunci_block_5  _Z8somefunci_block_6  _Z8somefunci_block_7  _Z8somefunci_block_8  
    1  _Z8somefunci_block_1  _Z8somefunci_block_2  _Z8somefunci_block_3  _Z8somefunci_block_4  _Z8somefunci_block_6  _Z8somefunci_block_8  
    0  _Z8somefunci_block_1  _Z8somefunci_block_2  _Z8somefunci_block_3  _Z8somefunci_block_4  _Z8somefunci_block_6  _Z8somefunci_block_7  _Z8somefunci_block_8  
*/