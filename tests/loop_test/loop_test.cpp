// passed
#include <iostream>

void easy_loop(int val, int p) {
    std::cout << "pos 1" << std::endl;
    if (val > 5) {
        std::cout << "pos 2" << std::endl;
        // loop
        for (int i = 0; i < p; i ++) {
            std::cout << "pos 3" << std::endl;
        }
    }
    std::cout << "pos 4" << std::endl;
}

int main() {
    std::cout << "hello world" << std::endl;
    easy_loop(10, 4);
    easy_loop(4, 4);
    easy_loop(6, 0);
}

/* 
Test Result :
    path : 0 times: 1
    path : 1 times: 1
    path : 2 times: 1
    path : 3 times: 3
    path : 4 times: 1

Sum to path
    4  _Z9easy_loopii_block_3  _Z9easy_loopii_block_6  _Z9easy_loopii_block_7  
    3  _Z9easy_loopii_block_3  _Z9easy_loopii_block_4  _Z9easy_loopii_block_5  
    2  _Z9easy_loopii_block_1  _Z9easy_loopii_block_7  
    1  _Z9easy_loopii_block_1  _Z9easy_loopii_block_2  _Z9easy_loopii_block_3  _Z9easy_loopii_block_6  _Z9easy_loopii_block_7  
    0  _Z9easy_loopii_block_1  _Z9easy_loopii_block_2  _Z9easy_loopii_block_3  _Z9easy_loopii_block_4  _Z9easy_loopii_block_5  
*/