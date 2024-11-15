import argparse
import logging
import warnings
from codetiming import Timer
import os
import pyslang as ps
assert ps.__version__ == "3.0.310"

import pickle
import codecs

def pickle_object(i_obj, i_output_file_path=None):
    pickled_obj_str = codecs.encode(pickle.dumps(i_obj), "base64").decode()
    
    if i_output_file_path != None:
        with open(i_output_file_path, "w") as f:
            f.write(pickled_obj_str)

    return pickled_obj_str

def unpickle_object_from_str(i_pickle_obj_str):
    return pickle.loads(codecs.decode(i_pickle_obj_str.encode(), "base64"))

def unpickle_object_from_file(i_pickle_file_fp):
    with open(i_pickle_file_fp, "r") as f:
        return unpickle_object_from_str(f.read())
    
class VisitorForSymbol:
    def __init__(self):
        self.symbol_id_to_symbol = dict()
        self.sourceRange_to_symbol_id = dict()
        self.kind_to_symbol_id = dict()

        self.symbol_id = 0
    
    def visit(self, symbol):
        self.symbol_id_to_symbol[self.symbol_id] = symbol
        
        try:
            self.kind_to_symbol_id[symbol.kind].append(self.symbol_id)
        except KeyError:
            self.kind_to_symbol_id[symbol.kind] = [self.symbol_id]

        try:
            hashable_sourceRange = (symbol.syntax.sourceRange.start, symbol.syntax.sourceRange.end)
            try:
                self.sourceRange_to_symbol_id[hashable_sourceRange].append(self.symbol_id)
            except KeyError:
                self.sourceRange_to_symbol_id[hashable_sourceRange] = [self.symbol_id]
        except AttributeError:
            pass
        self.symbol_id += 1

class VisitorForNode:
    def __init__(self, visitor_for_symbol):
        self.visitor_for_symbol = visitor_for_symbol
        self.node_id_to_node = dict()
        self.node_id_to_pid  = {0:None}
        self.node_id_to_cids = dict()
        self.node_id_to_name = {0:""}
        self.node_id_to_name_symbol = {0:""}
        self.node_id_to_predicates = {0:[]}

        self.kind_to_node_ids = dict()
        
        self.level = 0
        self.num_children_in_level = 1
        self.num_children_in_next_level = 0
        self.num_children_processed = 0
        self.processed_children_ids = list()

        self.node_id = 0

    def find_corresponding_child_id(self, parent_id, child_node):
        for curr_cid in self.node_id_to_cids:
            if self.node_id_to_node[curr_cid] == child_node:
                return curr_cid

        raise RuntimeError("The given node is not a child of the indicated parent node.")

    def process_node_for_predicates(self, node):
        pid = self.node_id_to_pid[self.node_id]
        if pid == None:
            return
        p_node = self.node_id_to_node[pid]

        new_predicate = []
        if p_node.kind == ps.SyntaxKind.ConditionalStatement:
            if p_node.statement == node:
                new_predicate = [(self.find_corresponding_child_id(pid, p_node.predicate), True)]
            elif p_node.elseClause == node:
                new_predicate = [(self.find_corresponding_child_id(pid, p_node.predicate), False)]
        if p_node.kind == ps.SyntaxKind.ConditionalExpression:
            if   p_node.left  == node:
                new_predicate = [(self.find_corresponding_child_id(pid, p_node.predicate), True)]
            elif p_node.right == node:
                new_predicate = [(self.find_corresponding_child_id(pid, p_node.predicate), False)]
        
        prev_predicates = self.node_id_to_predicates[pid]
        self.node_id_to_predicates[self.node_id] = prev_predicates+new_predicate
    
    def process_node_for_name(self, node):
        pid = self.node_id_to_pid[self.node_id]
        if pid == None:
            return
        p_node = self.node_id_to_node[pid]
        prev_name = self.node_id_to_name[pid]

        new_name = None
        # if node.kind == ps.SyntaxKind.CompilationUnit:
        #     new_name = "/"
        if node.kind == ps.SyntaxKind.ModuleDeclaration:
            new_name = node.header.name.value
        elif node.kind == ps.SyntaxKind.HierarchicalInstance:
            new_name = node.decl.name.value
        elif node.kind == ps.SyntaxKind.Declarator:
            new_name = node.name.value

        if new_name == None:
            self.node_id_to_name[self.node_id] = f"{prev_name}"
        else:
            self.node_id_to_name[self.node_id] = f"{prev_name}.{new_name}"
        


    def visit(self, node, use_queue=False):
        self.node_id_to_node[self.node_id] = node
        self.node_id_to_cids[self.node_id] = list()

        self.process_node_for_predicates(node)
        self.process_node_for_name(node)
        try:
            self.kind_to_node_ids[node.kind].append(self.node_id)
        except KeyError:
            self.kind_to_node_ids[node.kind] = [self.node_id]

        self.num_children_processed += 1
        self.processed_children_ids.append(self.node_id)
        try:
            for i in range(len(node)):
                self.num_children_in_next_level += 1
                child_id = self.node_id + (self.num_children_in_level - self.num_children_processed) + self.num_children_in_next_level
                self.node_id_to_pid[child_id] = self.node_id
                self.node_id_to_cids[self.node_id].append(child_id)

                if use_queue:
                    self.queue.append(node.__getitem__(i))
        except TypeError:
            # This exception is required because, unlike SyntaxNode, Token
            # objects do not have a len() function (i.e., getChildCount)
            pass
        

        if self.num_children_processed == self.num_children_in_level:
            self.level += 1
            self.num_children_in_level = self.num_children_in_next_level
            self.num_children_in_next_level = 0
            self.num_children_processed = 0
            self.processed_children_ids = list()

        self.node_id += 1


    def traverse_tree(self, starting_node):

        self.queue = [starting_node]

        while len(self.queue) > 0:
            curr_node = self.queue.pop(0)
            self.visit(curr_node, use_queue=True)
        
        return True
    
    def __get_hp_for_identifier_resolve_missing_symbol_id__(self, nid):
        curr_nid = nid
        hps = list()

        while curr_nid != None:
            curr_node = self.node_id_to_node[curr_nid]
            # print(f"curr_nid = {curr_nid} | {curr_node.kind}")
            symbol_ids = self.visitor_for_symbol.sourceRange_to_symbol_id.get((curr_node.sourceRange.start, curr_node.sourceRange.end))
            if symbol_ids != None:
                for symbol_id in symbol_ids:
                    curr_symbol = self.visitor_for_symbol.symbol_id_to_symbol[symbol_id]
                    try:
                        if curr_symbol.getSymbolReference() != None:
                            hps.append(curr_symbol.getSymbolReference().hierarchicalPath)
                    except AttributeError:
                        pass
                
            curr_nid = self.node_id_to_pid[curr_nid]
        
        token_node = self.node_id_to_node[nid]
        #warnings.warn(f"Could not resolve identifier ({token_node.__str__().strip()}) to hierarchicalPath")
        return hps

    def get_hp_for_identifier(self, nid):
        hps = list()

        token_node = self.node_id_to_node[nid]
        token_symbol_ids = self.visitor_for_symbol.sourceRange_to_symbol_id.get((token_node.range.start, token_node.range.end))
        if token_symbol_ids == None:
            return self.__get_hp_for_identifier_resolve_missing_symbol_id__(self.node_id_to_pid[nid])
        for token_symbol_id in token_symbol_ids:
            token_symbol = self.visitor_for_symbol.symbol_id_to_symbol[token_symbol_id]
            hps.append(token_symbol.getSymbolReference().hierarchicalPath)
        return hps

    def extract_kinds_from_descendants(self, nid, desired_kinds=[ps.TokenKind.Identifier]):
        desired_nids = list()

        queue = [(nid, [])]
        while len(queue) > 0:
            curr_nid, curr_metadata = queue.pop(0)
            curr_node = self.node_id_to_node[curr_nid]
            
            if curr_node.kind in desired_kinds:
                desired_nids.append(curr_nid)

            for curr_cid in self.node_id_to_cids[curr_nid]:
                new_metadata = []
                queue.append((curr_cid, curr_metadata+new_metadata))

        return desired_nids
    
    def within_same_construct(self, i_hp_sig_a, i_hp_sig_b):
        return i_hp_sig_a.split(".")[:-1] == i_hp_sig_b.split(".")[:-1]
    
    def extract_flow_from_NonblockingAssignmentExpression(self, nid, hfg_edges, debug_file, syntax_tree_id):
        left_ids  = list()
        right_ids = list()
        pred_ids = set()
        select_ids = list()
        
        queue = [(nid, [])]
        while len(queue)>0:
            curr_nid, curr_metadata = queue.pop(0)
            curr_node = self.node_id_to_node[curr_nid]

            #S: Add the predicates for the current identifier
            for curr_pred_id, curr_truth_value in self.node_id_to_predicates[curr_nid]:
                pred_ids.add((curr_pred_id, curr_truth_value))

            if   curr_node.kind == ps.TokenKind.Identifier and "left" in curr_metadata  and "select" not in curr_metadata:
                left_ids.append(curr_nid)
            elif curr_node.kind == ps.TokenKind.Identifier and "left" in curr_metadata  and "select"     in curr_metadata:
                select_ids.append(curr_nid)
            elif curr_node.kind == ps.TokenKind.Identifier and "right" in curr_metadata and "select" not in curr_metadata:
                right_ids.append(curr_nid)
            elif curr_node.kind == ps.TokenKind.Identifier and "right" in curr_metadata and "select"     in curr_metadata:
                select_ids.append(curr_nid)

            for curr_cid in self.node_id_to_cids[curr_nid]:
                curr_child = self.node_id_to_node[curr_cid]
                new_metadata = []
                if curr_node.kind in [ps.SyntaxKind.NonblockingAssignmentExpression, ps.SyntaxKind.AssignmentExpression] :
                    if   curr_child == curr_node.left         :
                        new_metadata.append("left")
                    elif curr_child == curr_node.attributes   :
                        new_metadata.append("skip")#new_metadata.append("attributes")
                    elif curr_child == curr_node.operatorToken:
                        new_metadata.append("skip")#new_metadata.append("operatorToken")
                    elif curr_child == curr_node.right        :
                        new_metadata.append("right")
                elif curr_node.kind in [ps.SyntaxKind.ElementSelect]:
                    if curr_child == curr_node.selector:
                        new_metadata.append("select")
                elif curr_node.kind == ps.SyntaxKind.BitSelect:
                    if curr_child == curr_node.expr:
                        new_metadata.append("select")
                elif curr_node.kind == ps.SyntaxKind.ConditionalExpression:
                    if curr_child == curr_node.predicate :
                        new_metadata.append("skip")
                    # elif curr_child == curr_node.left      :
                    # elif curr_child == curr_node.right     :

                if "skip" not in new_metadata:
                    queue.append((curr_cid, curr_metadata+new_metadata))
        
        print("\tSTART###########################################", file=debug_file)
        print(f"\t\tl_ids: {left_ids}" , file=debug_file)
        print(f"\t\tr_ids: {right_ids}", file=debug_file)
        for lid in left_ids:
            l_hps = self.get_hp_for_identifier(lid)
            for rid in right_ids:

                print(f"\t\t[nid = {rid}] {self.node_id_to_node[rid].__str__()}", file=debug_file)
                curr_pred_list = self.node_id_to_predicates[rid]
                curr_pred_list = [ (self.node_id_to_node[pred_nid].__str__(), bool_val) for pred_nid,bool_val in curr_pred_list]
                print(f"\t\t{curr_pred_list}", file=debug_file)


                print(f"\t\t{self.node_id_to_node[nid].__str__().strip()}", file=debug_file)
                r_hps = self.get_hp_for_identifier(rid)
                # assert len(r_hps) == len(l_hps) or len(r_hps) < len(l_hps), f"len(r_hps) = {len(r_hps), r_hps}  | len(l_hps) = {len(l_hps), l_hps}"
                if len(r_hps) == len(l_hps):
                    print(f"\t\tassert len(r_hps) ({len(r_hps)}) == len(l_hps) ({len(l_hps)}) == TRUE", file=debug_file)
                    for i, r_hp in enumerate(r_hps):
                        if self.within_same_construct(r_hp, l_hps[i]):
                            print(f"\t\t{r_hp} --E--> {l_hps[i]}", file=debug_file)
                            try:
                                hfg_edges[ (r_hp, l_hps[i], "Explicit", len(hfg_edges.keys())) ] += [(f"{self.node_id_to_node[nid].__str__().strip()}", curr_pred_list, syntax_tree_id, self.node_id_to_node[nid])]
                            except:
                                hfg_edges[ (r_hp, l_hps[i], "Explicit", len(hfg_edges.keys())) ]  = [(f"{self.node_id_to_node[nid].__str__().strip()}", curr_pred_list, syntax_tree_id, self.node_id_to_node[nid])]
                else:
                    print(f"\t\tassert len(set(r_hps)) == len(set(l_hps)) | ({len(set(r_hps))}) == ({len(set(l_hps))}) == {len(set(r_hps))==len(set(l_hps))}", file=debug_file)
                    for r_hp in set(r_hps):
                        for l_hp in set(l_hps):
                            if self.within_same_construct(r_hp, l_hp):
                                print(f"\t\t{r_hp} --E--> {l_hp}", file=debug_file)
                                try:
                                    hfg_edges[ (r_hp, l_hp, "Explicit", len(hfg_edges.keys())) ] += [(f"{self.node_id_to_node[nid].__str__().strip()}", curr_pred_list, syntax_tree_id, self.node_id_to_node[nid])]
                                except:
                                    hfg_edges[ (r_hp, l_hp, "Explicit", len(hfg_edges.keys())) ]  = [(f"{self.node_id_to_node[nid].__str__().strip()}", curr_pred_list, syntax_tree_id, self.node_id_to_node[nid])]
                print("", file=debug_file)

            for curr_pred_id, curr_truth_value in pred_ids:
                for identifier_id in self.extract_kinds_from_descendants(curr_pred_id, [ps.TokenKind.Identifier]):
                    for i_hp in set(self.get_hp_for_identifier(identifier_id)):
                        for l_hp in set(l_hps):
                            if self.within_same_construct(i_hp, l_hp):
                                print(f"\t\t{i_hp} --I--> {l_hp}", file=debug_file)
                                curr_pred_list = self.node_id_to_predicates[identifier_id]
                                curr_pred_list = [ (self.node_id_to_node[pred_nid].__str__(), bool_val) for pred_nid,bool_val in curr_pred_list]
                                try:
                                    hfg_edges[ (i_hp, l_hp, "Implicit", len(hfg_edges.keys())) ] += [(f"{self.node_id_to_node[nid].__str__().strip()}", curr_pred_list, syntax_tree_id, self.node_id_to_node[nid])]
                                except:
                                    hfg_edges[ (i_hp, l_hp, "Implicit", len(hfg_edges.keys())) ]  = [(f"{self.node_id_to_node[nid].__str__().strip()}", curr_pred_list, syntax_tree_id, self.node_id_to_node[nid])]


        print("\tEND#############################################", file=debug_file)

    def build_module_to_port_to_direction(self, module_to_port_to_direction):
        #S:
        # module_to_port_to_direction = dict()

        #S: Collect the module declarations
        module_decls = self.kind_to_node_ids.get(ps.SyntaxKind.ModuleDeclaration, [])
        module_decl_headers = []
        module_decl_header_names = []
        module_decl_header_ports = []
        module_decl_header_port_headers = []
        module_decl_header_port_decls = []

        #S: Collect the name of the module declarations
        for curr_nid in module_decls:
            headers = self.extract_kinds_from_descendants(curr_nid, desired_kinds=[ps.SyntaxKind.ModuleHeader])
            assert len(headers) == 1
            module_decl_headers.append(headers[0])

        for i, curr_nid in enumerate(module_decl_headers):
            names = self.extract_kinds_from_descendants(curr_nid, desired_kinds=[ps.TokenKind.Identifier])
            assert len(names) >= 1
            if self.node_id_to_node[module_decl_headers[i]].name == self.node_id_to_node[names[0]]:
                module_decl_header_names.append(names[0])
                module_to_port_to_direction[self.node_id_to_node[module_decl_headers[i]].name.__str__().strip()] = dict()

            ports = self.extract_kinds_from_descendants(curr_nid, desired_kinds=[ps.SyntaxKind.ImplicitAnsiPort])
            assert len(ports) >= 1
            module_decl_header_ports.append(ports)

        for i, ports in enumerate(module_decl_header_ports):
            module_name = self.node_id_to_node[module_decl_headers[i]].name.__str__().strip()

            curr_headers = list()
            curr_decls = list()
            for curr_nid in ports:
                headers = self.extract_kinds_from_descendants(curr_nid, desired_kinds=[ps.SyntaxKind.VariablePortHeader])
                assert len(headers) == 1
                curr_headers.append(headers[0])

                decls = self.extract_kinds_from_descendants(curr_nid, desired_kinds=[ps.SyntaxKind.Declarator])
                assert len(decls) == 1
                curr_decls.append(decls[0])

                port_name      = self.node_id_to_node[decls[0]].name.__str__().strip()
                port_direction = self.node_id_to_node[headers[0]].direction.__str__().strip()
                module_to_port_to_direction[module_name][port_name] = port_direction


            module_decl_header_port_headers.append(curr_headers)
            module_decl_header_port_decls  .append(curr_decls  )
        
    def collect_port(self, module_to_port_to_direction, hfg_edges, output_file, syntax_tree_id):
        #S: Create connections for each port connection in each module instantiation
        for curr_nid in self.kind_to_node_ids.get(ps.SyntaxKind.HierarchyInstantiation, []):
            hier_instantiation = self.node_id_to_node[curr_nid]

            curr_cids = self.node_id_to_cids[curr_nid]

            nid_hier_type = [cid for cid in curr_cids if self.node_id_to_node[cid]==hier_instantiation.type]
            hier_type       = [self.node_id_to_node[cid] for cid in nid_hier_type]
            assert len(hier_type) == 1
            nid_hier_type = nid_hier_type[0]
            hier_type = hier_type[0]

            nid_hier_parameters = [cid for cid in curr_cids if self.node_id_to_node[cid]==hier_instantiation.parameters]
            hier_parameters = [self.node_id_to_node[cid] for cid in nid_hier_parameters]
            assert len(hier_parameters) == 1 or len(hier_parameters) == 0 
            nid_hier_parameters = nid_hier_parameters[0] if len(hier_parameters) == 1 else None
            hier_parameters = hier_parameters[0] if len(hier_parameters) == 1 else None

            nid_hier_instances = [cid for cid in curr_cids if self.node_id_to_node[cid]==hier_instantiation.instances]
            hier_instances  = [self.node_id_to_node[cid] for cid in nid_hier_instances]
            assert len(hier_instances) == 1
            nid_hier_instances = nid_hier_instances[0]
            hier_instances  = hier_instances[0] if len(hier_instances) == 1 else None


            nid_hier_instance = self.node_id_to_cids[nid_hier_instances][0]
            curr_cids = self.node_id_to_cids[nid_hier_instance]
            # print(curr_cids)
            assert len(hier_instantiation.instances) == 1
            nid_inst_connections = [cid for cid in curr_cids if self.node_id_to_node[cid]==hier_instantiation.instances[0].connections]
            inst_connections = [self.node_id_to_node[cid] for cid in nid_inst_connections]
            assert len(inst_connections) == 1
            nid_inst_connections = nid_inst_connections[0]
            inst_connections  = inst_connections[0] if len(inst_connections) == 1 else None

            curr_cids = self.node_id_to_cids[nid_inst_connections]
            for nid_connection in curr_cids:
                curr_connection = self.node_id_to_node[nid_connection]

                connection_cids = self.node_id_to_cids[nid_connection]

                if curr_connection.kind == ps.SyntaxKind.NamedPortConnection:
                    connection_name_id = [cid for cid in connection_cids if self.node_id_to_node[cid]==curr_connection.name]
                    connection_expr_id = [cid for cid in connection_cids if self.node_id_to_node[cid]==curr_connection.expr]
                    connection_name_ob = [self.node_id_to_node[cid] for cid in connection_name_id][0]
                    connection_expr_ob = [self.node_id_to_node[cid] for cid in connection_expr_id][0]
                    
                    connection_dir = None
                    try:
                        connection_dir = module_to_port_to_direction[hier_instantiation.type.__str__().strip()][connection_name_ob.__str__().strip()].split()[-1].__str__().strip()
                    except KeyError:
                        print(hier_instantiation.type.__str__().strip())
                        print(module_to_port_to_direction.keys())
                        raise KeyError()


                    hp_port = self.node_id_to_name[connection_name_id[0]][1:] + "." + connection_name_ob.__str__().strip()
                    identifiers_in_expr = self.extract_kinds_from_descendants(connection_expr_id[0], desired_kinds=[ps.TokenKind.Identifier])
                    hp_identifiers_in_expr = [self.get_hp_for_identifier(nid)[0] for nid in identifiers_in_expr]

                    src_hps = None
                    dst_hps = None
                    if connection_dir=="input":
                        src_hps = hp_identifiers_in_expr
                        dst_hps = [hp_port]
                    else:
                        src_hps = [hp_port]
                        dst_hps = hp_identifiers_in_expr

                    for src_hp in src_hps:
                        for i, dst_hp in enumerate(dst_hps):
                            curr_pred_list = self.node_id_to_predicates[identifiers_in_expr[i]]
                            try:
                                hfg_edges[ (src_hp, dst_hp, "Explicit", len(hfg_edges.keys())) ] += [(f"{self.node_id_to_node[curr_nid].__str__().strip()}", curr_pred_list, syntax_tree_id, self.node_id_to_node[curr_nid])]
                            except:
                                hfg_edges[ (src_hp, dst_hp, "Explicit", len(hfg_edges.keys())) ]  = [(f"{self.node_id_to_node[curr_nid].__str__().strip()}", curr_pred_list, syntax_tree_id, self.node_id_to_node[curr_nid])]
#                     arrow = "<--E--" if connection_dir=="input" else "--E-->"
#                     print(f"Name: {hp_port} {arrow} Expr: {self.get_hp_for_identifier(identifiers_in_expr[0])} | Direction: {connection_dir}")
                else:
                    pass
                    #warnings.warn(f"Flow extraction from ({curr_connection.kind}) is not yet supported")  

class __HFGEnginePyslangTopdown__:
    def __init__(self, i_flist_fp) -> None:
        # logging.basicConfig(level=logging.DEBUG)
        self.flist_fp = i_flist_fp
        self.build_tree()
        self.build_hfg()
    
    def build_tree(self) -> None:
        # logging.debug('Building Tree')
        self.driver = ps.Driver()
        self.driver.addStandardArgs()
        self.driver.processCommandFiles(self.flist_fp, makeRelative=True)
        self.driver.processOptions()
        self.driver.parseAllSources()
        
        self.compilation = self.driver.createCompilation()
        successful_compilation = self.driver.reportCompilation(self.compilation, False)
        if successful_compilation:
            # logging.debug(f"Number of syntax trees: {len(self.driver.syntaxTrees)}")
            self.tree = self.driver.syntaxTrees[0]
           
        
    def build_hfg(self) -> None:
        #S: Generate symbol visitor and populate it
        my_visitor_for_symbol = VisitorForSymbol()
        self.compilation.getRoot().visit(my_visitor_for_symbol.visit)
        
        
        global_module_to_port_to_direction = dict()
        for i, curr_syntax_tree in enumerate(self.compilation.getSyntaxTrees()):
            my_visitor_for_node = VisitorForNode(my_visitor_for_symbol)
            my_visitor_for_node.traverse_tree(curr_syntax_tree.root)
            my_visitor_for_node.build_module_to_port_to_direction(global_module_to_port_to_direction)
        
        #S:
        all_hfg_edges = dict()
        all_syntax_trees = list()
        with open("temp_debug_01.txt", "w") as debug_file:
            for i, curr_syntax_tree in enumerate(self.compilation.getSyntaxTrees()):
                print(f"Syntax Tree #{i+1}", file=debug_file)

                my_visitor_for_node = VisitorForNode(my_visitor_for_symbol)
                my_visitor_for_node.traverse_tree(curr_syntax_tree.root)

                for curr_nid in my_visitor_for_node.kind_to_node_ids.get(ps.SyntaxKind.NonblockingAssignmentExpression, []):
                    my_visitor_for_node.extract_flow_from_NonblockingAssignmentExpression(curr_nid, all_hfg_edges, debug_file=debug_file, syntax_tree_id=i)

                for curr_nid in my_visitor_for_node.kind_to_node_ids.get(ps.SyntaxKind.AssignmentExpression, []):
                    my_visitor_for_node.extract_flow_from_NonblockingAssignmentExpression(curr_nid, all_hfg_edges, debug_file=debug_file, syntax_tree_id=i)
                    
                my_visitor_for_node.collect_port(global_module_to_port_to_direction, all_hfg_edges, output_file=debug_file, syntax_tree_id=i)

                all_syntax_trees.append(curr_syntax_tree)
                
        #S: Create clean data structure for exporting
        to_export_nodes = dict()
        to_export_edges = dict()

        with open(f"hfg_edges_{self.compilation.getRoot().topInstances[0].name}.txt", "w") as output_file:
            for i, (k,v) in enumerate(all_hfg_edges.items()):
                src_sig, dst_sig, e_type, e_id = k
                sf,sl,sc,ef,el,ec = self.get_f_l_c(self.compilation.sourceManager, v[0][3])
                print(f"┌──────────────────────────────┐", file=output_file)
                print(f"│  HyperFlow Graph Edge Info.  │", file=output_file)
                print(f"├──────────────────────────────┤", file=output_file)
                print(f"╞═ HFG Edge/Flow ID           ═╪═ {repr(e_id   )}", file=output_file)
                print(f"╞═ HFG Edge/Flow Type         ═╪═ {repr(e_type )}", file=output_file)
                print(f"╞═ Necessary Conditions       ═╪═ {repr(v[0][1])}", file=output_file)
                print(f"╞═ Source      Signal (Head)  ═╪═ {repr(src_sig)}", file=output_file)
                print(f"╞═ Destination Signal (Tail)  ═╪═ {repr(dst_sig)}", file=output_file)
                print(f"╞═ Source Assignment (SA)     ═╪═ {repr(v[0][0])}", file=output_file)
                print(f"╞═ SA Location - Start File   ═╪═ {repr(sf     )}", file=output_file)
                print(f"╞═ SA Location - Start Line   ═╪═ {repr(sl     )}", file=output_file)
                print(f"╞═ SA Location - Start Column ═╪═ {repr(sc     )}", file=output_file)
                print(f"╞═ SA Location - End   File   ═╪═ {repr(ef     )}", file=output_file)
                print(f"╞═ SA Location - End   Line   ═╪═ {repr(el     )}", file=output_file)
                print(f"╞═ SA Location - End   Column ═╪═ {repr(ec     )}", file=output_file)
                print(f"└──────────────────────────────┘", file=output_file)
                print("", file=output_file)

                curr_edge = dict()
                curr_edge[f"HFG Edge/Flow ID          "] = str(e_id   )
                curr_edge[f"HFG Edge/Flow Type        "] = str(e_type )
                curr_edge[f"Necessary Conditions      "] = v[0][1]
                curr_edge[f"Source      Signal (Head) "] = str(src_sig)
                curr_edge[f"Destination Signal (Tail) "] = str(dst_sig)
                curr_edge[f"Source Assignment (SA)    "] = str(v[0][0])
                curr_edge[f"SA Location - Start File  "] = str(sf     )
                curr_edge[f"SA Location - Start Line  "] = str(sl     )
                curr_edge[f"SA Location - Start Column"] = str(sc     )
                curr_edge[f"SA Location - End   File  "] = str(ef     )
                curr_edge[f"SA Location - End   Line  "] = str(el     )
                curr_edge[f"SA Location - End   Column"] = str(ec     )

                try:
                    to_export_edges[src_sig][dst_sig] += [curr_edge]
                except KeyError:
                    try:
                        to_export_edges[src_sig][dst_sig] = [curr_edge]
                    except KeyError:
                        to_export_edges[src_sig] = dict()
                        to_export_edges[src_sig][dst_sig] = [curr_edge]
        
        #S: Pickle hfg_edges
        pickle_object(to_export_edges, f"hfg_edges_{self.compilation.getRoot().topInstances[0].name}.pkl")
        
        self.to_export_edges = to_export_edges
                
                
    def get_f_l_c(self, i_sm, i_node):
        tree_sm = i_sm#i_tree.getDefaultSourceManager()

        curr_sr = None
        if issubclass(i_node.kind.__class__, ps.TokenKind) and (i_node.kind != ps.TokenKind.Unknown):
            curr_sr = i_node.range
        else:
            curr_sr = i_node.sourceRange

        sf = tree_sm.getFileName(curr_sr.start)
        sl = tree_sm.getLineNumber(curr_sr.start)
        sc = tree_sm.getColumnNumber(curr_sr.start)

        ef = tree_sm.getFileName(curr_sr.end)
        el = tree_sm.getLineNumber(curr_sr.end)
        ec = tree_sm.getColumnNumber(curr_sr.end)
        return (sf,sl,sc,ef,el,ec)

class HFGEdge():
    def __init__(self, i_hfg_edge_dict):
        self.id        = i_hfg_edge_dict[f"HFG Edge/Flow ID          "]
        self.type      = i_hfg_edge_dict[f"HFG Edge/Flow Type        "]
        self.conds     = i_hfg_edge_dict[f"Necessary Conditions      "]
        self.src_sig   = i_hfg_edge_dict[f"Source      Signal (Head) "]
        self.dst_sig   = i_hfg_edge_dict[f"Destination Signal (Tail) "]
        self.sa        = i_hfg_edge_dict[f"Source Assignment (SA)    "]
        self.sa_loc_sf = i_hfg_edge_dict[f"SA Location - Start File  "]
        self.sa_loc_sl = i_hfg_edge_dict[f"SA Location - Start Line  "]
        self.sa_loc_sc = i_hfg_edge_dict[f"SA Location - Start Column"]
        self.sa_loc_ef = i_hfg_edge_dict[f"SA Location - End   File  "]
        self.sa_loc_el = i_hfg_edge_dict[f"SA Location - End   Line  "]
        self.sa_loc_ec = i_hfg_edge_dict[f"SA Location - End   Column"]
        
    def __str__(self):
        string = ""
        string += f"┌──────────────────────────────┐\n"
        string += f"│  HyperFlow Graph Edge Info.  │\n"
        string += f"├──────────────────────────────┤\n"
        string += f"╞═ HFG Edge/Flow ID           ═╪═ {repr(self.id       )}\n"
        string += f"╞═ HFG Edge/Flow Type         ═╪═ {repr(self.type     )}\n"
        string += f"╞═ Necessary Conditions       ═╪═ {repr(self.conds    )}\n"
        string += f"╞═ Source      Signal (Head)  ═╪═ {repr(self.src_sig  )}\n"
        string += f"╞═ Destination Signal (Tail)  ═╪═ {repr(self.dst_sig  )}\n"
        string += f"╞═ Source Assignment (SA)     ═╪═ {repr(self.sa       )}\n"
        string += f"╞═ SA Location - Start File   ═╪═ {repr(self.sa_loc_sf)}\n"
        string += f"╞═ SA Location - Start Line   ═╪═ {repr(self.sa_loc_sl)}\n"
        string += f"╞═ SA Location - Start Column ═╪═ {repr(self.sa_loc_sc)}\n"
        string += f"╞═ SA Location - End   File   ═╪═ {repr(self.sa_loc_ef)}\n"
        string += f"╞═ SA Location - End   Line   ═╪═ {repr(self.sa_loc_el)}\n"
        string += f"╞═ SA Location - End   Column ═╪═ {repr(self.sa_loc_ec)}\n"
        string += f"└──────────────────────────────┘\n"
        
        return string
        
    
class HFGPath():
    def __init__(self):
        pass

class HFG():
    def __init__(self, i_flist_fp, i_fp_to_hfg_pickle_file=None):
        self.__hfg__ = None
        self.signals = None
        self.edges   = None
        
        if i_fp_to_hfg_pickle_file == None:
            self.__hfg__ = __HFGEnginePyslangTopdown__(i_flist_fp).to_export_edges
        else:
            self.__hfg__ = unpickle_object_from_file(i_fp_to_hfg_pickle_file)
        
        self.get_signals()
    
    def __eq__(self, other):
        return self.__hfg__==other.__hfg__
    
    def get_signals(self):
        if self.signals == None:
            self.signals = set()
            for s_signal in self.__hfg__.keys():
                self.signals.add(s_signal)
                for d_signal in self.__hfg__[s_signal].keys():
                    self.signals.add(d_signal)
            
        return self.signals
    
    def get_descendant_signals_and_paths(self, i_src, allow_loops=False, i_dst=None):
        if i_src not in self.signals:
            raise ValueError(f"The provided i_src value ({i_src}) is not a signal in the design. Use <hfg instance>.get_signals() to get the list of signals present in the design.")
        if i_dst != None and i_dst not in self.signals:
            raise ValueError(f"The provided i_dst value ({i_dst}) is not a signal in the design. Use <hfg instance>.get_signals() to get the list of signals present in the design.")
            
        processed_signals = set()
        processed_paths = list()
        
        queue = [(i_src, 0, [])]
        
        while len(queue) > 0:
            curr_signal, curr_level, curr_path = queue.pop(0)
            
            if (curr_signal not in processed_signals) and self.__hfg__.get(curr_signal, False): 
                for child_sig in self.__hfg__[curr_signal].keys():
                    for i in range(len(self.__hfg__[curr_signal][child_sig])):
                        queue.append((child_sig, curr_level+1, curr_path+[HFGEdge(self.__hfg__[curr_signal][child_sig][i])] ) )
            
            processed_signals.add(curr_signal)
            processed_paths.append(curr_path)
            
            if i_dst != None and curr_signal == i_dst:
                break
            
        if allow_loops == False:
            processed_signals.remove(i_src)
            
        if len(processed_paths)==1 and len(processed_paths[0])==0:
            processed_paths = list()
        
        return processed_signals, processed_paths[1:]
    
    def get_ancestor_signals_and_paths(self, i_src, allow_loops=False, i_dst=None):
        if i_src not in self.signals:
            raise ValueError(f"The provided i_src value ({i_src}) is not a signal in the design. Use <hfg instance>.get_signals() to get the list of signals present in the design.")
        if i_dst != None and i_dst not in self.signals:
            raise ValueError(f"The provided i_dst value ({i_dst}) is not a signal in the design. Use <hfg instance>.get_signals() to get the list of signals present in the design.")
            
        processed_signals = set()
        processed_paths = list()
        
        queue = [(i_src, 0, [])]
        
        while len(queue) > 0:
            curr_signal, curr_level, curr_path = queue.pop(0)
            
            if (curr_signal not in processed_signals):
                
                for curr_k_src, curr_v_dsts in self.__hfg__.items():
                    if curr_signal in curr_v_dsts.keys():
                        for i in range(len(self.__hfg__[curr_k_src][curr_signal])):
                            queue.append((curr_k_src, curr_level+1, curr_path+[HFGEdge(self.__hfg__[curr_k_src][curr_signal][i])] ) )
            
            processed_signals.add(curr_signal)
            processed_paths.append(curr_path)
            
            if i_dst != None and curr_signal == i_dst:
                break
        
        if allow_loops == False:
            processed_signals.remove(i_src)
            
        if len(processed_paths)==1 and len(processed_paths[0])==0:
            processed_paths = list()
            
        
        return processed_signals, processed_paths[1:]
    
    def get_paths(self, i_src, i_dst):
        _, processed_paths = self.get_descendant_signals_and_paths(i_src, allow_loops=False, i_dst=i_dst)
        
        return [p for p in processed_paths if p[-1].dst_sig==i_dst]
        