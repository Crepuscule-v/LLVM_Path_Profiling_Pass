#include <iostream>

void exampleFunction(int input) {
    // 基本块 A
    std::cout << "Block A" << std::endl;
    std::cout << "Block B" << std::endl;
    if (input > 0) {
        // 基本块 B
        std::cout << "Block C" << std::endl;
    }
    // 基本块 C
    std::cout << "Block D" << std::endl;
}

int main() {
    std::cout<< "hello world" << std::endl;
    exampleFunction(1);
    std::cout<< "hello world 1" << std::endl;
    return 0;
}