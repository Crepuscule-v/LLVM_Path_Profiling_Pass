import os
import ctypes
import mmap
import json
import time
import cxxfilt

class FuncNode(ctypes.Structure):
    _fields_ = [
        ('counter', ctypes.POINTER(ctypes.c_uint64)),
        ('counter_size', ctypes.c_int),
        ('func_name', ctypes.c_char_p),
        ('next', ctypes.POINTER(ctypes.c_uint8))        # no practical use, just for judge end
    ]

def demangle_cpp_func(funcname: str) -> str:
    try:
        demangled: str = cxxfilt.demangle(funcname)
        return demangled
    except Exception:
        return funcname

def parser(file_name):
    with open(file_name, 'rb') as file:
        file_size = os.path.getsize(file_name)
        data = mmap.mmap(file.fileno(), file_size, access=mmap.ACCESS_READ)
        func_nodes_map = {}
        curr_offset = 0
        while True:
            tmp_map = {}
            node = FuncNode.from_buffer_copy(data, curr_offset)
            counter_size = node.counter_size

            # read func_name from memory byte by byte
            func_name_offset = curr_offset + ctypes.sizeof(FuncNode)
            func_name = b''
            while data[func_name_offset] != 0:
                func_name += bytes([data[func_name_offset]])
                func_name_offset += 1
            func_name = func_name.decode('utf-8')
            
            # read counter array
            counter_array_offset = curr_offset + ctypes.sizeof(FuncNode) + len(func_name) + 1
            ArrayType = ctypes.c_uint64 * counter_size
            counter_array = ArrayType.from_buffer_copy(data, counter_array_offset)
            counter = [counter_array[i] for i in range(counter_size)]

            tmp_map["counter_size"] = counter_size
            tmp_map["counter"] = counter
            func_nodes_map[demangle_cpp_func(func_name)] = tmp_map
            if not node.next:
                break
            
            curr_offset += ctypes.sizeof(FuncNode) + counter_size * ctypes.sizeof(ctypes.c_uint64) + len(func_name) + 1
    return func_nodes_map

if __name__ == "__main__":
    path_prefix = "tests/multi_backedge_test/"
    file_name = "path_profile.profraw"
    func_nodes_map = parser(path_prefix + file_name)
    time.sleep(1)
    print(str(func_nodes_map))
    # json_str = json.dumps(func_nodes_map)
    # with open('profdata.json', 'w') as json_file:
    #     json_file.write(json_str)