import graphviz
import networkx as nx 
import pydot 
import cxxfilt
from typing import List, Dict
import json

func_list = []
sum_to_path_map = {}
path_prefix = "tests/multi_backedge_test/function_dag_graph_dir/"           # modify it to the path of your .dot file 

def demangle_cpp_func(funcname: str) -> str:
    try:
        demangled: str = cxxfilt.demangle(funcname)
        return demangled
    except Exception:
        return funcname

def parse_dot_file_to_networkx(file_path):
    with open(file_path, 'r') as file:
        dot_content = file.read()
    dot_graph = graphviz.Source(dot_content)
    pydot_graph = pydot.graph_from_dot_data(dot_graph.source)[0]
    return nx.drawing.nx_pydot.from_pydot(pydot_graph)

def process_dot(file_name : str, func_name : str):
    nx_graph = parse_dot_file_to_networkx(path_prefix + file_name)
    return process(nx_graph, func_name)

def dfs(curr_node : str, curr_path : List, path_sum : int, edge_map : Dict, node_map : Dict, ed_node_list : List, exit_node : str, tmp_sum_to_path_map : Dict):
    print(curr_node)
    if curr_node in ed_node_list:
        if curr_node != exit_node:
            path_sum += edge_map[str((curr_node, exit_node))][0]["inc"]
        tmp_sum_to_path_map[path_sum] = curr_path.copy()                    # We need to copy it to a new list (just a feature for python-like language)
        return

    for node in node_map[curr_node]:
        for edge in edge_map[str((curr_node, node))]:
            if edge["edge_type"] == "normal_edge":
                path_sum += edge["inc"]
                curr_path.append(node)
                dfs(node, curr_path, path_sum, edge_map, node_map, ed_node_list, exit_node, tmp_sum_to_path_map)
                curr_path.pop()
                path_sum -= edge["inc"]
    return

def process(nx_graph, func_name):
    edge_map = {}                                           # Note that there may be multiple edges between two points, so we use list to store the edge inside the map
    node_map = {}               
    entry_node = ""
    exit_node = ""
    ed_node_list = []
    st_node_list = []
    for src, dst, attrs in nx_graph.edges(data=True):
        if src not in node_map:
            node_map[src] = []
        node_map[src].append(dst)
        idx = str((src, dst))                               # as key of edge_map
        new_edge = {}
        for key in attrs:
            if key == "edge_type":
                new_edge["edge_type"] = attrs[key]
                if (attrs[key] == "exit_to_entry"):
                    entry_node = dst
                    exit_node = src
                    ed_node_list.append(exit_node)
                elif (attrs[key] == "back_edge"):
                    ed_node_list.append(src)
                    st_node_list.append(dst)
                elif (attrs[key] == "dummy_edge"):
                    new_edge["another_node_in_backedge"] = attrs["another_node_in_backedge"]
            elif key == "inc":
                new_edge["inc"] = int(attrs[key])
        if idx not in edge_map:
            edge_map[idx] = []
        edge_map[idx].append(new_edge)

    for key in node_map:
        node_map[key] = list(set(node_map[key]))            # remove duplication nodes

    tmp_sum_to_path_map = {}
    # start node is entry_node 
    dfs(entry_node, [entry_node], 0, edge_map, node_map, ed_node_list, exit_node, tmp_sum_to_path_map)
    # start node is backedge dst node 
    for node in st_node_list:
        for edge in edge_map[str((entry_node, node))]:
            if (edge["edge_type"] != "dummy_edge"):
                continue;
            inc = edge["inc"]
            path_list = []
            from_node = "(from " + edge["another_node_in_backedge"] + ")"       # means backedge source 
            path_list = [from_node, node]
            dfs(node, path_list, inc, edge_map, node_map, ed_node_list, exit_node, tmp_sum_to_path_map)
    
    sum_to_path_map[demangle_cpp_func(func_name)] = tmp_sum_to_path_map

def read_func_name():
    with open(path_prefix + "func_name_list.txt") as file:
        line = file.readline()
        while line:
            line = line.replace("\n", "")
            func_list.append(line)
            line = file.readline()

def decode():
    read_func_name()
    for item in func_list:
        graph_file_name = "dagGraph." + item + ".dot"
        process_dot(graph_file_name, item)
    
    json_str = json.dumps(sum_to_path_map)
    with open('sum_to_path_map.json', 'w') as json_file:
        json_file.write(json_str)

if __name__ == "__main__":
    decode()
