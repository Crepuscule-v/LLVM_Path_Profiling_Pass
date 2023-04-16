#include <cstdio>
#include <cstring>

typedef struct func_node {
    __uint64_t* counter;
    int path_num;
    char* func_name;
    struct func_node* next;
} func_node;

func_node* start = nullptr;
func_node* end = nullptr;

void updateCounter(func_node *entry, int idx) {
    entry -> counter[idx] ++;
}

void* initCounter(int size, char *func_name) {
    func_node* node = new func_node;
    __uint64_t* counter = new __uint64_t [size] ();         // initialize with 0

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