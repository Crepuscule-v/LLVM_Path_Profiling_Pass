#include <cstdio>
#include <cstring>
#include <iostream>

typedef struct func_node {
    __uint64_t* counter;
    int path_num;
    char* func_name;
    struct func_node* next;
} func_node;

func_node* start = nullptr;
func_node* end = nullptr;

extern "C" void updateCounter(int idx, func_node *node) {
    std::cout << node -> func_name << "  path : " << idx << " plus 1" << std::endl;
    node -> counter[idx] ++;
}

// TODO: implement continuous mode & replace it by allocating memory for global array in IR
extern "C" void* initCounter(int size, char *func_name) {
    std::cout << size << "  " << func_name << std::endl;
    func_node* node = new func_node;
    __uint64_t* counter = new __uint64_t [size] ();         // initialize with 0
    std::cout << "malloc finished " << std::endl;
    node -> counter = counter;
    node -> path_num = size;
    node -> func_name = func_name;
    node -> next = nullptr;

    if (start == nullptr) start = end = node;
    else {
        end -> next = node;
        end = node;
    }
    return node;
}

// TODO:
void free_memory(){}