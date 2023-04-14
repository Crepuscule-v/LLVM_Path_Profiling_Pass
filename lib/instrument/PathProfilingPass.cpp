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

using namespace llvm;

typedef struct Edge {
    BasicBlock* src;
    BasicBlock* dst;
    int val;
    int inc;
    bool isInSpanningTree;
} Edge;

typedef struct Node {
    BasicBlock *bb;
    bool isEntry;
    bool isExit;
} Node;

typedef std::vector<Edge *> Edges;          // 用于保存 cfg
typedef std::vector<Node *> Nodes;    // 保存所有 bb

Edge* createEdge(BasicBlock *src, BasicBlock *dst) {
    Edge* edge = (Edge *)malloc(sizeof(Edge));
    edge -> src = src;
    edge -> dst = dst;
    edge -> val = 0;
    edge -> inc = 0;
    edge -> isInSpanningTee = false;
    return edge;
}

Node* createNode(BasicBlock *bb) {
    Node* node = (Node *)malloc(sizeof(Node));
    node -> bb = bb;
    node -> isEntry = false;
    node -> isExit = false;
    return node;
}

namespace {
    struct PathProfilingPass : public ModulePass {
        static char ID;
        PathProfilingPass() : ModulePass(ID) {}

        bool runOnModule(Module &);
        bool processFunction(Function &F, Module &M);
        Nodes init_nodes(Function &F);
        Edges init_edges(Function &F);
    };
}

Nodes PathProfilingPass::init_nodes(Function &F) {
    Nodes nodes_vec;
    for (auto &BB : F) {
        Node* node = createNode(&BB);
        nodes_vec.push_back(node);
    }
    return nodes_vec;
}

Edges PathProfilingPass::init_edges(Function &F) {
    Edges edges_vec;
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
    return edges_vec;
}

bool PathProfilingPass::processFunction(Function &F, Module &M) {
    // initialize 
    Nodes nodes_vec = initial_nodes(F);
    Edges edges_vec = initial_edges(F);


    return true;
}

bool PathProfilingPass::runOnModule(Module &M) {
    for (auto &F : M)
    {
        errs() << "Function " << F.getName() << "\n";
        if (!processFunction(F, M)) return false;
    }
    return true;
}


char PathProfilingPass::ID = 0;
RegisterPass<PathProfilingPass> X("pathprofiling", "a pass for path profiling");
