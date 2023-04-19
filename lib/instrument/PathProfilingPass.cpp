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
#include <set> 

using namespace llvm;

typedef struct Edge {
    BasicBlock* src;
    BasicBlock* dst;
    int val;                    // 32 bit
    int inc;                    // 32 bit
    bool isInSpanningTree;
    bool isBackedge;
    bool isSelfLoop;
    bool isDummyedge;
    bool isExitToEntry;
    BasicBlock* another_node_in_backedge;   // record this node when curr edge is a dummyEdge

    Edge(BasicBlock* src, BasicBlock* dst) 
        : src(src), dst(dst), val(0), inc(0), isInSpanningTree(false), 
          isBackedge(false), isSelfLoop(false), isDummyedge(false), isExitToEntry(false), another_node_in_backedge(nullptr){}
} Edge;

typedef BasicBlock* Node;
typedef std::vector<Edge *> Edges;
typedef std::vector<Node> Nodes; 

Edge* createEdge(BasicBlock *src, BasicBlock *dst) {
    return new Edge(src, dst);
}

class PathProfilingPass : public ModulePass {
    public:
        static char ID;
        PathProfilingPass() : ModulePass(ID) {}

        bool runOnModule(Module &);
        Edges processFunction(Function &, Module &);
        void init_nodes(Function &, Nodes &);
        void init_edges(Function &, Edges &);
        void set_entry_and_exit_node(Nodes &, Edges &, Node &, Node &);
        void find_backedges(Node, Nodes &, Edges &, std::unordered_map<Node, int> &, std::unordered_map<Edge*, bool> &);
        void update_edges_vec_with_backedge_info(Edges &, std::unordered_map<Edge*, bool> &, Node &, Node &);
        void calculate_val_for_edges(Nodes &, Edges &, std::unordered_map<Node, int> &, Node &, Node &);
        void select_spanning_tree(Nodes &, Edges &, Node &, Node &, Edges &);
        void calculate_inc_for_chords(Edges &, Edges);
        bool inc_dfs(Edges, Node, Node, Node, int &);
        void instrument(Function*, Module*, Nodes &, Edges &, Node &, Node &, int);
        void setPhiNodes(BasicBlock*, BasicBlock*, BasicBlock*);
        void instr_for_edges(Function*, Module*, Value*, Value*, Edges, Node &, Node &);
        void instr_at_exit(Function*, Module*, Value*, Value*, Node &, Node &);
        Node find_ufs(Node, std::unordered_map<Node, Node>);
        Nodes topological_sort(Edges, Nodes &, Node &);
        Edges get_out_edges_vec(Node, Edges);
        void init_rt_func(Module*);
        std::pair<Value*, Value*> instr_before_entry(Function*, Module*, BasicBlock*, int);
        void update_decode_map(std::string, Edges, Node, Node, std::unordered_map<std::string, std::unordered_map<int, std::string>> &);
        void dfs_to_decode(Edges, std::set<Node>, Node, std::unordered_map<int, std::string> &, int , std::string, Edges, Node);
        void generate_dot_graph(Function *, Edges);
};

void PathProfilingPass::init_nodes(Function &F, Nodes &nodes_vec) {
    int idx = 0;
    for (auto &BB : F) {
        nodes_vec.push_back(&BB);
        std::string name = "block_" + std::to_string(++ idx);       
        errs() << name << "\n";
        BB.setName(name);           // just for debugging
    }
    errs() << "basic block num :" << nodes_vec.size() << "\n";
    return;
}

void PathProfilingPass::init_edges(Function &F, Edges &edges_vec) {
    for (auto &BB : F) {
        // get all the successors from terminator instruction of current basicblock
        const Instruction* instr = BB.getTerminator();
        for (int i = 0; i < instr -> getNumSuccessors(); i ++)
        {
            BasicBlock* dst = instr -> getSuccessor(i);
            if (&BB == dst) continue;                       // skip self loop
            Edge* new_edge = createEdge(&BB, dst);
            edges_vec.push_back(new_edge);
        }
    }
    return;
}

void PathProfilingPass::set_entry_and_exit_node(Nodes &nodes_vec, Edges &edges_vec, Node &entry_node, Node &exit_node) 
{
    std::unordered_map<Node, std::pair<int, int>> degreeOfNodes;             // recode in degree and out degree of nodes
    int entry_cnt = 0, exit_cnt = 0;
    for (auto bb : nodes_vec) degreeOfNodes[bb] = {0, 0};
    
    for (auto edge : edges_vec) {
        auto src = edge -> src;
        auto dst = edge -> dst;
        degreeOfNodes[src].second += 1;
        degreeOfNodes[dst].first += 1;
    }
    for (auto bb : nodes_vec) {
        if (degreeOfNodes[bb].first == 0) {
            entry_cnt ++;
            entry_node = bb;
        }
        if (degreeOfNodes[bb].second == 0) {
            exit_cnt ++;
            exit_node = bb;
        }
    }
    if (entry_cnt != 1 || exit_cnt != 1) {
        throw "Invalid CFG";
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

void PathProfilingPass::find_backedges(Node curr_node, Nodes &nodes_vec, Edges &edges_vec, std::unordered_map<Node, int> &record, std::unordered_map<Edge*, bool> &backedges_map)
{
    // -1 : unvisited, 0 : visiting, 1 : visited
    record[curr_node] = 0;
    Edges out_edges_of_curr_node = get_out_edges_vec(curr_node, edges_vec);     
    for (auto edge : out_edges_of_curr_node) {
        // errs() << "next node : " << edge -> dst -> getName() << "  "  << record[edge -> dst] << "\n";
        auto node = edge -> dst;
        if (record[node] == 1) continue;        
        if (record[node] == 0) {
            backedges_map[edge] = true;      
        }
        else {
            find_backedges(node, nodes_vec, edges_vec, record, backedges_map);
        }
    }
    record[curr_node] = 1;
}

void PathProfilingPass::update_edges_vec_with_backedge_info(Edges &edges_vec, std::unordered_map<Edge*, bool> &backedges_map, Node &entry_node, Node &exit_node) {
    for (auto &edge : edges_vec) {
        if (backedges_map.find(edge) != backedges_map.end()) {
            edge -> isBackedge = true;
            Node src = edge -> src;
            Node dst = edge -> dst;

            // add dummy edges
            Edge* dummy_entry_to_backedge = createEdge(entry_node, dst);
            dummy_entry_to_backedge -> another_node_in_backedge = src;
            Edge* dummy_backedge_to_exit = createEdge(src, exit_node);
            dummy_backedge_to_exit -> another_node_in_backedge = dst;
            dummy_entry_to_backedge -> isDummyedge = true;
            dummy_backedge_to_exit -> isDummyedge = true;
            edges_vec.push_back(dummy_entry_to_backedge);
            edges_vec.push_back(dummy_backedge_to_exit);
        }
    }
}

Nodes PathProfilingPass::topological_sort(Edges edges_vec, Nodes &nodes_vec, Node &entry_node) {
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

    for (int i = 0; i < sorted_nodes_vec.size(); i ++) {
        errs() << sorted_nodes_vec[i] -> getName() << " indegree  " << in_degree_map[sorted_nodes_vec[i]] << "\n";
    }

    return sorted_nodes_vec;
}

void PathProfilingPass::calculate_val_for_edges(Nodes &nodes_vec, Edges &edges_vec, std::unordered_map<Node, int> &num_paths_map, Node &entry_node, Node &exit_node) {
    // get topological order 
    auto sorted_nodes_vec = topological_sort(edges_vec, nodes_vec, entry_node);
    // cal val in a reverse order
    Edges tmp_edges_vec;
    for (auto edge : edges_vec) {
        if (edge -> isBackedge == false) tmp_edges_vec.push_back(edge);
    }
    errs() << "sorted_nodes_vec.size() : " << sorted_nodes_vec.size() << "\n";
    for (int i = sorted_nodes_vec.size() - 1; i >= 0; i --) {
        auto curr_node = sorted_nodes_vec[i];
        errs() << i << " : curr node " << curr_node -> getName() << "  exit node " << exit_node -> getName() << "\n";
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

Node PathProfilingPass::find_ufs(Node node, std::unordered_map<Node, Node> father) {
    if (father[node] != node) father[node] = find_ufs(father[node], father);
    return father[node];
}

void PathProfilingPass::select_spanning_tree(Nodes &nodes_vec, Edges &edges_vec, Node &entry_node, Node &exit_node, Edges &spanning_tree_vec) {
    // add exit -> entry edge
    auto exit_to_entry_edge = createEdge(exit_node, entry_node);
    errs() << "exit_node " << exit_node -> getName() << " entry_node " << entry_node -> getName() << "\n";
    exit_to_entry_edge -> isExitToEntry = true;
    exit_to_entry_edge -> isInSpanningTree = true;
    edges_vec.push_back(exit_to_entry_edge);

    // select spanning tree using union-find set
    std::unordered_map<Node, Node> father;
    for (auto node : nodes_vec)  father[node] = node;
    father[exit_node] = entry_node;                         // exit2entry edge will be the first edge to be selected 
    spanning_tree_vec.push_back(exit_to_entry_edge);
    
    for (auto &edge : edges_vec) {              
        if (edge -> isBackedge || edge -> isExitToEntry) continue;
        else {
            auto src = edge -> src;
            auto dst = edge -> dst;
            auto src_father = find_ufs(src, father);
            auto dst_father = find_ufs(dst, father);
            if (src_father == dst_father)  continue;        // skip the edge, otherwise will form a ring
            edge -> isInSpanningTree = true;
            spanning_tree_vec.push_back(edge);
            errs() << "src node : " << src -> getName() << " dst node : " << dst -> getName() << "\n";
            father[src_father] = dst_father;                // combine the tree
        }
        if (spanning_tree_vec.size() == nodes_vec.size() - 1) break;
    }
    return;
}

bool PathProfilingPass::inc_dfs(Edges tree, Node curr_node, Node dst, Node prev_node, int &cur_inc) {
    // errs() << "curr node " << curr_node -> getName() << " prev node " << prev_node -> getName() << "\n";
    if (curr_node == dst) return true;
    auto out_edges = get_out_edges_vec(curr_node, tree);
    if (out_edges.size() == 1 && out_edges[0] -> dst == prev_node) return false;       // 叶子节点
    bool flag = false;
    for (auto edge : out_edges) {
        if (edge -> dst == prev_node) {
            continue;
        }
        else {
            flag = true;
            cur_inc += edge -> val;
            if (inc_dfs(tree, edge -> dst, dst, curr_node, cur_inc)) break;
            cur_inc -= edge -> val;
            flag = false;               // it means this path is blocked, we should go back and take another path
        }
    }
    if (flag) return true;
    return false;
}

void PathProfilingPass::calculate_inc_for_chords(Edges &edges_vec, Edges spanning_tree_vec) {
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
        if (!edge -> isInSpanningTree && !edge -> isBackedge) {
            errs() << " cal inc for " << edge -> src -> getName() << "  " << edge -> dst -> getName() << "  " << "\n";
            auto src = edge -> src;
            auto dst = edge -> dst;
            int inc = 0;
            inc_dfs(undirected_spanning_tree_vec, dst, src, src, inc);
            edge -> inc = inc + edge -> val;
        }
    }
    return;
}

std::pair<Value*, Value*> PathProfilingPass::instr_before_entry(Function *F, Module *M, BasicBlock* entry_node, int path_num) {
    // Allocate memory and init
    auto func_counter_name = "_" + F -> getName() + "_" + "counter_array";
    auto &context = F -> getContext();
    PointerType* ptr_type_int8 = PointerType::get(Type::getInt8Ty(context), 0);
    Constant* null_ptr = ConstantPointerNull::get(ptr_type_int8);
    // A generic pointer, will be assigned with a void*
    GlobalVariable* func_counter_ptr = new GlobalVariable(*M, ptr_type_int8, false, GlobalValue::PrivateLinkage, 0, func_counter_name);
    func_counter_ptr -> setAlignment(Align(8));
    func_counter_ptr -> setInitializer(null_ptr);

    // insert judge block before entry_node! important
    BasicBlock* judge_basicblock = BasicBlock::Create(context, "block_judge", F, entry_node);           // judge if we need to init 
    BasicBlock* init_counter_basicblock = BasicBlock::Create(context, "block_init", F);

    IRBuilder<> judge_builder(judge_basicblock);
    IRBuilder<> init_counter_builder(init_counter_basicblock);

    // Create a local variable 'r' before entry the function which store the path values
    Value* r_ptr = judge_builder.CreateAlloca(Type::getInt32Ty(context), nullptr, "r_ptr");
    // initialize 'r' with 0
    Value* zero32 = ConstantInt::get(Type::getInt32Ty(context), 0, false);
    Value* zero64 = ConstantInt::get(Type::getInt64Ty(context), 0, false);
    judge_builder.CreateStore(zero32, r_ptr);     

    // judge if the global counter has been initialized
    Value* counter_ptr_val = judge_builder.CreateLoad(ptr_type_int8, func_counter_ptr);
    auto cmp_res = judge_builder.CreatePtrDiff(ptr_type_int8, counter_ptr_val, null_ptr);
    auto flag = judge_builder.CreateICmpEQ(cmp_res, zero64);                    // return true if equal
    judge_builder.CreateCondBr(flag, init_counter_basicblock, entry_node);

    // call counter_init_func from runtime
    std::vector<Value *> args;
    Value* counter_entry_num_ptr = ConstantInt::get(Type::getInt32Ty(context), path_num, false);
    auto func_name = init_counter_builder.CreateGlobalString(F -> getName());
    Value* func_name_ptr = init_counter_builder.CreatePointerCast(func_name, ptr_type_int8);
    args.push_back(counter_entry_num_ptr);
    args.push_back(func_name_ptr);
    auto counter_init_func = M -> getOrInsertFunction(
        "initCounter",
        Type::getInt8PtrTy(context),        // return type
        Type::getInt32Ty(context),          // args
        Type::getInt8PtrTy(context)         // args
    );

    Value* counter_addr = init_counter_builder.CreateCall(counter_init_func, args);     // start addr of counter global array
    init_counter_builder.CreateStore(counter_addr, func_counter_ptr);
    init_counter_builder.CreateBr(entry_node);

    return {r_ptr, func_counter_ptr};
}

void PathProfilingPass::setPhiNodes(BasicBlock* dst, BasicBlock* src, BasicBlock* new_block) {
    // to be discussed
    for (auto iter = dst -> begin(); iter != dst -> end(); iter ++) {
        auto instr_ptr = &(*iter);
        if (auto *phi_node = dyn_cast<PHINode>(instr_ptr)) {
            for (int i = 0; i < phi_node -> getNumIncomingValues(); i ++) {
                if (phi_node -> getIncomingBlock(i) == src) {
                    phi_node -> setIncomingBlock(i, new_block);
                }
            }
        }
    }
}

void PathProfilingPass::instr_for_edges(Function *F, Module *M, Value *r_ptr, Value *counter_ptr, Edges edges_vec, Node &entry_node, Node &exit_node) {
    // get type of r_ptr & counter_ptr
    auto &context = F -> getContext();
    PointerType* ptr_type_int8 = PointerType::get(Type::getInt8Ty(context), 0);
    
    for (auto edge : edges_vec) {
        if (!edge -> isInSpanningTree && !edge -> isDummyedge && edge -> inc != 0) {
            // instrument for normal edges
            auto src = edge -> src;
            auto dst = edge -> dst;
            BasicBlock* newBlock = BasicBlock::Create(context, "", F, dst);        // llvm will generete a unique name for bb if we use ""
            IRBuilder<> builder(newBlock);
            Value* r = builder.CreateLoad(Type::getInt32Ty(context), r_ptr);
            Value* inc_val = ConstantInt::get(Type::getInt32Ty(context), edge -> inc, false);
            Value* res = builder.CreateAdd(r, inc_val);
            builder.CreateStore(res, r_ptr);

            // change control flow
            builder.CreateBr(dst);
            Instruction* terminator = src -> getTerminator();
            for (int i = 0; i < terminator -> getNumSuccessors(); i ++) {
                if (terminator -> getSuccessor(i) == dst) {
                    terminator -> setSuccessor(i, newBlock);
                    setPhiNodes(dst, src, newBlock);
                    break;
                }
            }
        }
        else if (edge -> isBackedge) {
            // instrument for backedges
            auto src = edge -> src;
            auto dst = edge -> dst;
            int inc_to_add = 0;
            int inc_to_reset = 0;
            for (auto tmp_edge : edges_vec) {
                // exit_node need to be cal 
                if (tmp_edge -> src == src && tmp_edge -> dst == exit_node)  inc_to_add = tmp_edge -> inc;
                if (tmp_edge -> src == entry_node && tmp_edge -> dst == dst) inc_to_reset = tmp_edge -> inc;
            }
            BasicBlock* newBlock = BasicBlock::Create(context, "", F, dst);
            IRBuilder<> builder(newBlock);
            
            // r += inc(edge[backedge.source, exit])
            Value* r = builder.CreateLoad(Type::getInt32Ty(context), r_ptr);
            Value* inc_to_add_val = ConstantInt::get(Type::getInt32Ty(context), inc_to_add, false);
            Value* res = builder.CreateAdd(r, inc_to_add_val);
            builder.CreateStore(res, r_ptr);

            // path_table[r] ++
            std::vector<Value *> args;
            Value* counter_addr = builder.CreateLoad(ptr_type_int8, counter_ptr);
            Value* idx = builder.CreateLoad(Type::getInt32Ty(context), r_ptr);
            args.push_back(idx);
            args.push_back(counter_addr);

            auto counter_update_func = M -> getOrInsertFunction(
                "updateCounter",
                Type::getVoidTy(context),
                Type::getInt32Ty(context),
                Type::getInt8PtrTy(context)
            );
            builder.CreateCall(counter_update_func, args);

            // r = inc(edge[entry, backedge.dst])
            Value* inc_to_reset_val = ConstantInt::get(Type::getInt32Ty(context), inc_to_reset, false);
            builder.CreateStore(inc_to_reset_val, r_ptr);

            // change control flow
            builder.CreateBr(dst);
            auto terminator = src -> getTerminator();
            for (int i = 0; i < terminator -> getNumSuccessors(); i++) {
                if (terminator -> getSuccessor(i) == dst) {
                    terminator->setSuccessor(i, newBlock);
                    setPhiNodes(dst, src, newBlock);
                    break;
                }
            }
        }
    }
    return;
}

void PathProfilingPass::instr_at_exit(Function* F, Module *M, Value* r_ptr, Value* counter_ptr, Node &entry_node, Node &exit_node) {
    // instrument before the terminator instruction of the exit basicblock
    auto &context = F -> getContext();
    PointerType* ptr_type_int8 = PointerType::get(Type::getInt8Ty(context), 0);
    Instruction* term_instr = exit_node -> getTerminator();
    IRBuilder<> builder(term_instr);
    std::vector<Value *> args;
    Value* counter_addr = builder.CreateLoad(ptr_type_int8, counter_ptr);
    Value* idx = builder.CreateLoad(Type::getInt32Ty(context), r_ptr);
    args.push_back(idx);
    args.push_back(counter_addr);

    auto counter_update_func = M -> getOrInsertFunction(
        "updateCounter",
        Type::getVoidTy(context),
        Type::getInt32Ty(context),
        Type::getInt8PtrTy(context)
    );

    builder.CreateCall(counter_update_func, args);
}

void PathProfilingPass::instrument(Function* F, Module* M, Nodes &nodes_vec, Edges &edges_vec, Node &entry_node, Node &exit_node, int path_num) {
    // init r_ptr && counter_ptr
    std::pair<Value*, Value*> ptr_pair = instr_before_entry(F, M, entry_node, path_num);

    // update r with inc 
    instr_for_edges(F, M, ptr_pair.first, ptr_pair.second, edges_vec, entry_node, exit_node);

    // update counter
    instr_at_exit(F, M, ptr_pair.first, ptr_pair.second, entry_node, exit_node);
}

void verify_val_result(Edges edges_vec) {
    for (auto edge : edges_vec) {
        errs() << edge -> src ->getName() << " -> " << edge -> dst ->getName() << " : " << edge -> val << "\n";
    }
}

void verify_spanning_tree(Edges spanning_tree_vec) {
    for (auto edge : spanning_tree_vec) {
        errs() << edge -> src ->getName() << " -> " << edge -> dst ->getName() << " : " << edge -> isInSpanningTree << "\n";
    }
}

void verify_inc_result(Edges edges_vec) {
    for (auto edge : edges_vec) {
        if (edge -> isInSpanningTree == false && edge -> isExitToEntry == false && edge -> isBackedge == false) {
            errs() << edge -> src ->getName() << " -> " << edge -> dst ->getName() << " : " << edge -> inc << "\n";
        }
    }
}

void print_result(Function *F, Module *M) {
    auto &context = F -> getContext();
    ReturnInst* retInst = nullptr;
    for (auto &BB : *F) {
        for (auto &Instr : BB) {
            if (ReturnInst* ret = dyn_cast<ReturnInst>(&Instr)) {
                retInst = ret;
                break;
            }
        }
    }
    auto print_result = M -> getOrInsertFunction(
        "print_result",
        FunctionType::get(Type::getVoidTy(context), false)
    );
    if (retInst) {
        IRBuilder<> builder(retInst);
        builder.CreateCall(print_result);
    }
    return;
}   

void verify_backedge(std::unordered_map<Edge*, bool> backedge_map) {
    errs() << "All backedges : " << "\n";
    for (auto iter = backedge_map.begin(); iter != backedge_map.end(); iter ++) {
        errs() << iter -> first -> src -> getName() << "  " << iter -> first -> dst -> getName() << "\n";
    }
    return;
}

void verify_updated_edges(Edges edges_vec) {
    errs() << "print updated edges with backedge info" << "\n";
    for (auto edge : edges_vec) {
        if (edge -> isBackedge == false) {
            errs() << edge -> src -> getName() << "  " << edge -> dst -> getName() << "\n";
        }
    }
    return;
}

Edges PathProfilingPass::processFunction(Function &F, Module &M) {
    // variables 
    Node entry_node, exit_node;
    Edges edges_vec;
    std::unordered_map<Edge*, bool> backedges_map;      // record if an edge is a backedge, just for update edges_vec
    Nodes nodes_vec;
    std::unordered_map<Node, int> num_paths_map;        // record numpaths for each node
    Edges spanning_tree_vec;

    // initialize 
    errs() << "######### initialize ########## "  << "\n";
    init_nodes(F, nodes_vec);
    if (nodes_vec.size() == 0) return {};               // skip special functions, e.g. ios_base4Init
    init_edges(F, edges_vec);
    set_entry_and_exit_node(nodes_vec, edges_vec, entry_node, exit_node);
    
    // find backedges
    errs() << "######### find backedges ########## "  << "\n";
    std::unordered_map<Node, int> record;
    for (auto node : nodes_vec) record[node] = -1;
    find_backedges(entry_node, nodes_vec, edges_vec, record, backedges_map);
    verify_backedge(backedges_map);

    // update edges_vec with backedge info to generate a DAG graph
    errs() << "######### update_edges_vec_with_backedge_info ########## "  << "\n";
    update_edges_vec_with_backedge_info(edges_vec, backedges_map, entry_node, exit_node);
    verify_updated_edges(edges_vec);

    // calculate val for each edge
    errs() << "######### calculate val for each edge ########## "  << "\n";
    calculate_val_for_edges(nodes_vec, edges_vec, num_paths_map, entry_node, exit_node);
    verify_val_result(edges_vec);

    // add exit -> entry edge and select a spanning tree
    errs() << "######### select_spanning_tree ########## "  << "\n";
    select_spanning_tree(nodes_vec, edges_vec, entry_node, exit_node, spanning_tree_vec);
    verify_spanning_tree(spanning_tree_vec);

    // caluculate inc for each chord
    errs() << "######### calculate_inc_for_chords ########## "  << "\n";
    calculate_inc_for_chords(edges_vec, spanning_tree_vec);
    verify_inc_result(edges_vec);

    // instrument part
    errs() << "######### instrument ########## "  << "\n";
    instrument(&F, &M, nodes_vec, edges_vec, entry_node, exit_node, num_paths_map[entry_node]);
    
    // print path statistical results before return
    if (F.getName() == "main") print_result(&F, &M);

    return edges_vec;
}

std::set<std::string> excluded_function_set {
    "initCounter",
    "updateCounter",
    "print_result",
    "__cxx_global_var_init",
    "__cxa_atexit",
    "_GLOBAL__sub_I_basic.cpp",
    "_ZNSt8ios_base4InitD1Ev",
    "_ZNSt8ios_base4InitC1Ev",
    "_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc",
    "_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_",
    "_ZNSolsEPFRSoS_E"
};

std::string FUNCTION_DAG_GRAPH_DIR_NAME = "function_dag_graph_dir";

void PathProfilingPass::generate_dot_graph(Function *F, Edges edges_vec) {
    std::error_code errorCode;
    std::string func_name = F -> getName().str();
    std::string filename = FUNCTION_DAG_GRAPH_DIR_NAME + "/" + "dagGraph." + func_name + ".dot";

    raw_fd_ostream dotFile(filename.c_str(), errorCode);
    if (errorCode) {
        errs() << "Open " << filename << "failed \n";
        return;
    }
    dotFile << "digraph " << func_name << "\{ \n";
    dotFile << "label=\"Graph for" << func_name << "\"\n";
    for (auto edge : edges_vec) {
        auto src = edge -> src;
        auto dst = edge -> dst;
        dotFile << "\t\"" << src -> getName().str() << "\" -> " << " \"" << dst -> getName().str() << "\"\n\t";
        int inc = edge -> inc;
        if (edge -> isBackedge) {
            dotFile << "[color=darkslategray1][edge_type=back_edge][inc=" << 0 << "]" << "\n"; 
        }
        else if (edge -> isExitToEntry) {
            dotFile << "[color=chartreuse1][edge_type=exit_to_entry][inc=" << 0 << "]" << "\n";
        }
        else if (edge -> isDummyedge) {
            if (edge -> inc != 0) {
                dotFile << "[label=" << inc << "]" << "[color=deeppink][edge_type=dummy_edge][inc=" << inc << "]"; 
            }
            else dotFile << "[color=deeppink][edge_type=dummy_edge][inc=" << 0 << "]"; 
            dotFile << "[another_node_in_backedge=" << edge -> another_node_in_backedge -> getName().str() << "]" << "\n";
        }
        else {
            if (edge -> inc != 0) {
                dotFile << "[label=" << inc << "]" << "[color=black][edge_type=normal_edge][inc=" << inc << "]" << "\n"; 
            }
            else dotFile << "[color=black][edge_type=normal_edge][inc=" << 0 << "]" << "\n"; 
        }
    }
    dotFile << "}\n";
    return;
}

void write_func_name_set_to_file(std::set<std::string> func_name_set) {
    std::error_code errorCode;
    std::string filename = FUNCTION_DAG_GRAPH_DIR_NAME + "/" + "func_name_list.txt";

    raw_fd_ostream funcnameFile(filename.c_str(), errorCode);
    if (errorCode) {
        errs() << "Open " << filename << "failed \n";
        return;
    }
    
    for (auto iter = func_name_set.begin(); iter != func_name_set.end(); iter ++) {
        funcnameFile << *iter << "\n";
    }
    return;
}

bool PathProfilingPass::runOnModule(Module &M) {
    std::unordered_map<std::string, std::unordered_map<int, std::string>> decode_map;   // {"func" : {"path_sum" : "path"}}
    std::set<std::string> func_name_set;
    for (auto &F : M)
    {
        if (excluded_function_set.find(F.getName().str()) != excluded_function_set.end()) {
            errs() << "skip function  " << F.getName() << "\n";
            continue;
        }
        func_name_set.insert(F.getName().str());
        errs() << "Function " << F.getName() << "\n";
        Edges edges_vec = processFunction(F, M);
        generate_dot_graph(&F, edges_vec);
        write_func_name_set_to_file(func_name_set);
        Node entry_node, exit_node;
        errs() << "----------\n\n" << "\n";
    }

    // Save the instrumented IR to a file before verification, just for debugging
    /*
    std::error_code EC;
    llvm::raw_fd_ostream IRFile("instrumented_ir.ll", EC);
    if (!EC) {
        M.print(IRFile, nullptr);
        IRFile.close();
    } else {
        errs() << "Error opening output file: " << EC.message() << "\n";
    }
    */
    return true;
}

char PathProfilingPass::ID = 0;
static RegisterPass<PathProfilingPass> X("pathProfile", "A pass for path profiling");