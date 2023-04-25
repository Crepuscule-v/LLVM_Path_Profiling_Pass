#include <cstdio>
#include <cstring>
#include <unistd.h>
#include <iostream>
#include <sys/mman.h>
#include <sys/stat.h>

typedef struct func_node {
    __uint64_t* counter;
    int counter_size;
    char* func_name;
    struct func_node* next;
} func_node;

func_node* start = nullptr;
func_node* end = nullptr;

const char* file_name = "path_profile.profraw";
int file_offset = 0;
bool continuous_mode = true;

extern "C" void updateCounter(int idx, func_node *node) {
    std::cout << node -> func_name << "  path : " << idx << " plus 1" << std::endl;
    node -> counter[idx] ++;
}

extern "C" void* initCounter(int size, char *func_name) {
    if (!continuous_mode) {    
        // std::cout << size << "  " << func_name << std::endl;
        func_node* new_node = new func_node;
        __uint64_t* counter = new __uint64_t [size] ();                 // initialize with 0
        // std::cout << "malloc finished " << std::endl;

        new_node -> counter = counter;
        new_node -> counter_size = size;
        new_node -> func_name = func_name;
        new_node -> next = nullptr;

        if (start == nullptr) start = end = new_node;
        else {
            end -> next = new_node;
            end = new_node;
        }
        return new_node;
    }
    else {
        FILE* fp = fopen(file_name, "r+b");
        if (fp == nullptr) {
            fp = fopen(file_name, "w+b");
            if (fp == nullptr) {
                throw "file open failed";
            }
        }

        // update file_offset
        size_t str_length = strlen(func_name) + 1;
        // std::cout << "size : " <<  sizeof(func_node) + size * sizeof(__uint64_t) + str_length << std::endl;
        file_offset += sizeof(func_node) + str_length + size * sizeof(__uint64_t);
        int fd = fileno(fp);
        // std::cout << "func_name : " << func_name << "  size : " << size << "  file_offset : " << file_offset << std::endl;
        // update file length 
        if (ftruncate(fd, file_offset) == -1) {
            fclose(fp);
            throw "ftruncate error";
        }

        // mmap 
        char* ptr = (char *) mmap(nullptr, file_offset, PROT_READ | PROT_WRITE, MAP_SHARED, fileno(fp), 0);
        if (ptr == MAP_FAILED) {
            fclose(fp);
            throw "mmap failed";
        }

        // start addr of new_node 
        func_node* new_node = reinterpret_cast<func_node *>(ptr + file_offset - sizeof(func_node) - str_length - size * sizeof(__uint64_t));
        new_node -> func_name = reinterpret_cast<char*>(new_node) + sizeof(func_node);
        new_node -> counter = reinterpret_cast<__uint64_t *>(reinterpret_cast<char *>(new_node) + sizeof(func_node) + str_length);
        new_node -> counter_size = size;
        new_node -> next = nullptr;
        
        // memcpy func_name to shared memory
        memcpy(new_node -> func_name, func_name, str_length);

        // init counter 
        for (int i = 0; i < size; i ++) {
            new_node -> counter[i] = 0;
        }

        // set linked list 
        if (start == nullptr) start = end = new_node;
        else {
            end -> next = new_node;
            end = new_node;
        }
        fclose(fp);
        return new_node;
    }
}

extern "C" void print_result() {
    auto p = start;
    while (p) {
        std::cout << "func_name " << p -> func_name << std::endl;
        for (int i = 0; i < p -> counter_size; i ++) {
            std::cout << "path : " << i << "    times: " << p -> counter[i] << std::endl;
        }
        std::cout << std::endl;
        auto tmp_ptr = p;
        p = p -> next;
        if (continuous_mode) {
            munmap(tmp_ptr, sizeof(func_node) + strlen(tmp_ptr -> func_name) + 1 + (tmp_ptr -> counter_size) * sizeof(__uint64_t));        // will unmap and free memory 
        }
        else {
            delete [] tmp_ptr -> counter;
            delete tmp_ptr;
        }
    }
    return;
}
