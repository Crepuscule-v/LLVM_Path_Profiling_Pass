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

    Edge(BasicBlock *src, BasicBlock *dst) 
        : src(src), dst(dst), val(0), inc(0), isInSpanningTree(false), 
          isBackedge(false), isSelfLoop(false), isDummyedge(false) {}
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
            void find_backedges(Node curr_node, std::unordered_map<Node, int> &record);
            void update_edges_vec_with_backedge_info();

        private:
            Node entry_node, exit_node;
            Edges edges_vec, backedges_vec;
            Nodes nodes_vec;
    };
}

void PathProfilingPass::init_nodes(Function &F) {
    for (auto &BB : F) nodes_vec.push_back(&BB);
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


void PathProfilingPass::find_backedges(Node curr_node, std::unordered_map<Node, int> &record)
{
    // -1 : unvisit, 0 : visiting, 1 : visited
    record[curr_node] = 0;
    std::vector<Edge> out_edges_of_curr_node = get_out_edges_vec(curr_node, edges_vec);     // get all outgoing edges for dfs, maybe we can improve it by using adjList
    for (auto edge : out_edges_of_curr_node) {
        auto node = edge.dst;
        if (record[node] = 1) continue;        
        if (record[node] = 0) {
            if (node == curr_node)  continue;                       // self loop
            backedges_vec.push_back(createEdge(curr_node, node));      
        }
        else {
            find_backedges(node, nodes_vec, edges_vec, record, backedges_vec);
        }
    }
    record[curr_node] = 1;
}

void PathProfilingPass::update_edges_vec_with_backedge_info() {
    
}

void PathProfilingPass::processFunction(Function &F, Module &M) {
    // initialize 
    init_nodes(F);
    init_edges(F);
    set_entry_and_exit_node();
    
    // find backedges
    std::unordered_map<Node, int> record;
    std::vector<Edge> backedges_vec;
    for (auto node : nodes_vec) record[node] = -1;
    find_backedges(this -> entry_node, nodes_vec, edges_vec, record, backedges_vec);

    // update edges_vec with backedge info to generate a DAG graph
    update_edges_vec_with_backedge_info();

    // calculate val each edges

    // add exit -> entry edge and select a spanning tree

    // caluculate inc for each chord

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
