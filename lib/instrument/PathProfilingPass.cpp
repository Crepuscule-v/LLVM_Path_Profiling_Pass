#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include <vector>
#include <unordered_map>
#include <queue>

using namespace llvm;

typedef struct Edge {
    BasicBlock* src;
    BasicBlock* dst;
    int val;
    int inc;
    bool isInSpanningTree;
    bool isBackedge;
    bool isSelfLoop;
    bool isDummyedge;
    bool isExitToEntry;

    Edge(BasicBlock *src, BasicBlock *dst) 
        : src(src), dst(dst), val(0), inc(0), isInSpanningTree(false), 
          isBackedge(false), isSelfLoop(false), isDummyedge(false), isExitToEntry(false) {}
} Edge;

typedef BasicBlock* Node;
typedef std::vector<Edge *> Edges;
typedef std::vector<Node> Nodes; 

Edge* createEdge(BasicBlock *src, BasicBlock *dst) {
    return new Edge(src, dst);
}

namespace {
    class PathProfilingPass : public ModulePass {
        public:
            static char ID;
            PathProfilingPass() : ModulePass(ID) {}

            bool runOnModule(Module &);
            void processFunction(Function &, Module &);
            void init_nodes(Function &);
            void init_edges(Function &);
            void set_entry_and_exit_node();
            void find_backedges(Node, std::unordered_map<Node, int> &);
            void update_edges_vec_with_backedge_info();
            Edges get_out_edges_vec(Node, Edges);
            void calculate_val_for_edges();
            void select_spanning_tree();
            void calculate_inc_for_chords();
            bool inc_dfs(Edges, Node, Node, Node, int &) 

        private:
            Node entry_node, exit_node;
            Edges edges_vec;
            std::unordered_map<Edge*, bool> backedges_map;      // record if an edge is a backedge, just for update edges_vec
            Nodes nodes_vec;
            std::unordered_map<Node, int> num_paths_map;        // record numpaths for each node
            Edges spanning_tree_vec;
    };
}

void PathProfilingPass::init_nodes(Function &F) {
    int idx = 0;
    for (auto &BB : F) {
        nodes_vec.push_back(&BB);
        std::string name = "block_" + std::to_string(++ idx);       
        BB.setName(name);           // just for debugging
    }
}

void PathProfilingPass::init_edges(Function &F) {
    for (auto &BB : F) {
        // get all the successors from terminator instruction of current basicblock
        const Instruction* instr = BB.getTerminator();
        for (int i = 0; i < instr -> getNumSuccessors(); i ++)
        {
            BasicBlock* dst = instr -> getSuccessors(i);
            Edge new_edge = createEdge(&BB, dst);
            edges_vec.push_back(new_edge);
        }
    }
}

void PathProfilingPass::set_entry_and_exit_node() 
{
    std::unordered_map<Node, std::pair<int, int>> degreeOfNodes;             // recode in degree and out degree of nodes
    int entry_cnt = 0, exit_cnt = 0;
    for (auto bb : nodes_vec) degreeOfNodes[bb] = {0, 0};
    
    for (auto edge : edges_vec) {
        auto src = edge.src;
        auto dst = edge.dst;
        degreeOfNodes[src].second += 1;
        degreeOfNodes[dst].first += 1;
    }

    for (auto bb : nodes_vec) {
        if (degreeOfNodes[bb].first == 0) {
            entry_cnt ++;
            this -> entry_node = &bb;
        }
        if (degreeOfNodes[bb].second == 0) {
            exit_cnt ++;
            this -> exit_node = &bb;
        }
    }

    if (entry_cnt != 1 || exit_cnt != 1) {
        err() << "Invalid CFG" << "\n";
        exit(1);
    }

    return;
}

Edges PathProfilingPass::get_out_edges_vec(Node node, Edges tmp_edges_vec)
{
    // get all outgoing edges, maybe we can improve it by using adjList
    Edges tmp;
    for (auto edge : tmp_edges_vec) {
        if (edge -> src == node && edge -> dst != node) tmp.push_back(edge);
    }
    return tmp;
}

void PathProfilingPass::find_backedges(Node curr_node, std::unordered_map<Node, int> &record)
{
    // -1 : unvisit, 0 : visiting, 1 : visited
    record[curr_node] = 0;
    Edges out_edges_of_curr_node = get_out_edges_vec(curr_node, edges_vec);     
    for (auto edge : out_edges_of_curr_node) {
        auto node = edge -> dst;
        if (record[node] = 1) continue;        
        if (record[node] = 0) {
            if (node == curr_node)  continue;                       // self loop
            backedges_vec[edge] = true;      
        }
        else {
            find_backedges(node, record);
        }
    }
    record[curr_node] = 1;
}

void PathProfilingPass::update_edges_vec_with_backedge_info() {
    for (auto &edge : edges_vec) {
        if (backedges_map.find(edge) != backedges_map.end()) {
            edge.isBackedge = true;
            Node src = edge -> src;
            Node dst = edge -> dst;
            // add dummy edges
            Edge* dummy_entry_to_backedge = createEdge(entry, dst);
            Edge* dummy_backedge_to_exit = createEdge(src, exit);
            dummy_entry_to_backedge.isDummy = true;
            dummy_entry_to_backedge.isDummy = true;
            edges_vec.push_back(dummy_entry_to_backedge);
            edges_vec.push_back(dummy_backedge_to_exit);
        }
    }
}

std::vector<Node> PathProfilingPass::topological_sort() {
    std::vector<Node> sorted_nodes_vec;         // in positive order
    std::unordered_map<Node, int> in_degree_map;
    std::queue<Node> q;
    Edges tmp_edges_vec;
    for (auto edge : edges_vec) {
        if (edge -> isBackedge == false) {
            tmp_edges_vec.push_back(edge);
            in_degree_map.find(edge -> dst) == in_degree_map.end() ? in_degree_map[edge -> dst] = 1 : in_degree_map[edge -> dst] += 1;
        }
    }

    q.push(entry_node);
    while (!q.empty()) {
        auto curr_node = q.front();
        sorted_nodes_vec.push_back(curr_node);
        q.pop();
        auto out_edges = get_out_edges_vec(curr_node, tmp_edges_vec);    // DAG
        for (auto edge : out_edges) {
            in_degree_map[edge -> dst] -= 1;
            if (in_degree_map[edge -> dst] == 0) q.push(edge -> dst);
        }
    }
    return sorted_nodes_vec;
}

void PathProfilingPass::calculate_val_for_edges() {
    // get topological order 
    auto sorted_nodes_vec = topological_sort();
    // cal val in a reverse order
    Edges tmp_edges_vec;
    for (auto edge : edges_vec) {
        if (edge -> isBackedge == false) tmp_edges_vec.push_back(edge);
    }
    for (int i = sorted_nodes_vec.size() - 1; i --; i >= 0) {
        auto curr_node = sorted_nodes_vec[i];
        if (curr_node == exit_node) num_paths_map[curr_node] = 1;           // leaf node
        else {
            num_paths_map[curr_node] = 0;
            auto out_edges = get_out_edges_vec(curr_node, tmp_edges_vec);
            for (auto &edge : out_edges) {
                edge -> val = num_paths_map[curr_node];
                num_paths_map[curr_node] = num_paths_map[curr_node] + num_paths_map[edge -> dst];
            }
        }
    }
}

Node find_ufs(Node node, std::unordered_map<Node, Node> father) {
    if (father[node] != node) father[node] = find_ufs(father[node]);
    return father[node];
}

void PathProfilingPass::select_spanning_tree() {
    // add exit -> entry edge
    auto exit_to_entry_edge = create_edge(exit_node, entry_node);
    exit_to_entry_edge -> isExitToEntry = true;
    edges_vec.push_back(exit_to_entry_edge);

    // select spanning tree using union-find set
    std::unordered_map<Node, Node> father;
    for (auto node : nodes_vec)  father[node] = node;
    father[exit_node] = entry_node;             // exit2entry edge will be the first edge to be selected 
    int cnt = 1;
    for (auto &edge : edges_vec) {
        if (edge -> isBackedge) continue;
        else if (edge -> isExitToEntry) {
            edge -> isInSpanningTree = true;
            spanning_tree_vec.push_back(edge);
        }
        else {
            auto src = edge -> src;
            auto dst = edge -> dst;
            auto src_father = find_ufs(src, father);
            auto dst_father = find_ufs(dst, father);
            if (src_father == dst_father)  continue;        // skip the edge, otherwise will form a ring
            edge -> isInSpanningTree = true;
            spanning_tree_vec.push_back(edge);
            father[src] = dst_father;
        }
        if (spanning_tree_vec.size() == nodes_vec.size() - 1) break;
    }
    return;
}

bool PathProfilingPass::inc_dfs(Edges tree, Node curr_node, Node dst, Node prev_node, int &cur_inc) {
    if (curr_node == dst) return true;
    if (out_edges.size() == 1 && out_edges[0].dst == prev_node) return false;       // 叶子节点
    auto out_edges = get_out_edges_vec(curr_node, tree);
    for (auto edge : out_edges) {
        if (edge -> dst == prev_node) continue;
        else {
            cur_inc += edge -> val;
            if (inc_dfs(tree, edge -> dst, dst, curr_node, cur_inc)) break;
            else cur_inc -= edge -> val;
        }
    }
    return true;
}

void PathProfilingPass::calculate_inc_for_chords() {
    // build a new undirected tree using generated spanning tree
    Edges undirected_spanning_tree_vec;
    for (auto edge : spanning_tree_vec) {
        auto src = edge -> src;
        auto dst = edge -> dst;
        int val = edge -> val;
        auto reverse_edge = createEdge(dst, src);
        reverse_edge -> val = 0 - val;
        undirected_spanning_tree_vec.push_back(reverse_edge);
        undirected_spanning_tree_vec.push_back(edge);
    }

    // calculate inc for each chord through dfs 
    for (auto &edge : edges_vec) {
        if (!edge -> isInSpanningTree) {
            auto src = edge -> src;
            auto dst = edge -> dst;
            int inc = 0;
            inc_dfs(undirected_spanning_tree_vec, dst, src, src, inc);
            edge -> inc = inc + edge -> val;
        }
    }

    return;
}

void PathProfilingPass::processFunction(Function &F, Module &M) {
    // initialize 
    init_nodes(F);
    init_edges(F);
    set_entry_and_exit_node();
    
    // find backedges
    std::unordered_map<Node, int> record;
    for (auto node : nodes_vec) record[node] = -1;
    find_backedges(this -> entry_node, nodes_vec, edges_vec, record);

    // update edges_vec with backedge info to generate a DAG graph
    update_edges_vec_with_backedge_info();

    // calculate val for each edge
    calculate_val_for_edges();

    // add exit -> entry edge and select a spanning tree
    select_spanning_tree();

    // caluculate inc for each chord
    calculate_inc_for_chords();

    // instrument


    return true;
}

bool PathProfilingPass::runOnModule(Module &M) {
    for (auto &F : M)
    {
        errs() << "Function " << F.getName() << "\n";
        processFunction(F, M);
    }
    return true;
}


char PathProfilingPass::ID = 0;
static RegisterPass<PathProfilingPass> P("pathprofile", "A pass for path profiling");
