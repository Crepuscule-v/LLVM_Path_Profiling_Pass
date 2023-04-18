// Passed 
void myfunc(int x) {
    int i = 0;
    int p = 0;
    for (i = 0; i < x; i++) {
        if (i == 4) continue;
        p ++;
    }
    return;
}

int main() {
    myfunc(5);
    myfunc(-5);
    myfunc(0);
    myfunc(4);
    return 0;
}

/* Test Result
    path : 0    times: 0
    path : 1    times: 2
    path : 2    times: 2
    path : 3    times: 1
    path : 4    times: 11
    path : 5    times: 2

    sum to path :  
    5  myfunc_block_2  myfunc_block_7  
    4  myfunc_block_2  myfunc_block_3  myfunc_block_5  myfunc_block_6  
    3  myfunc_block_2  myfunc_block_3  myfunc_block_4  myfunc_block_6  
    2  myfunc_block_1  myfunc_block_2  myfunc_block_7  
    1  myfunc_block_1  myfunc_block_2  myfunc_block_3  myfunc_block_5  myfunc_block_6  
    0  myfunc_block_1  myfunc_block_2  myfunc_block_3  myfunc_block_4  myfunc_block_6  
*/