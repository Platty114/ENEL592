from hfg_engine import HFG, HFGEdge

#compares a hfg that contains a vulnerability to it's
#equivalent hfg that has had the vulnerability patched
#returns 3 lists of signal paths, ones that are in both,
#ones that are only in the vulnerable hfg and ones
#that are only in the patched hfg
def create_vuln_triplets (vulnerable_hfg, patched_hfg):
    triplets = {}
    common_paths = {}
    vulnerable_paths = {}
    patched_paths = {}

    #add all descepant paths from vuln hfg to vulnerable_paths
    for vuln_signal_name in vulnerable_hfg.get_signals():
        #TODO: this should be made less error prone later
        module_name, signal_name = vuln_signal_name.split(".")

        signals, path_to_signals = vulnerable_hfg.get_descendant_signals_and_paths(vuln_signal_name, False)
         
        #now add all paths to vulnerable_paths 
        for i in path_to_signals:
            if signal_name not in vulnerable_paths:
                vulnerable_paths[signal_name] = []
            vulnerable_paths[signal_name].append(i)


    #add all descepant paths from patched hfg to patched_paths
    for patched_signal_name in patched_hfg.get_signals():
        #TODO: this should be made less error prone later
        module_name, signal_name = patched_signal_name.split(".")

        signals, path_to_signals = patched_hfg.get_descendant_signals_and_paths(patched_signal_name, False)
         
        #now add all paths to patched_paths 
        for i in path_to_signals:
            if signal_name not in patched_paths:
                patched_paths[signal_name] = []
            patched_paths[signal_name].append(i)


    # now we need to go through and perform some sort of comparison 
    common_paths, patched_paths, vulnerable_paths = compare_path_sets(vulnerable_paths, patched_paths)

    triplets["vulnerable"] = vulnerable_paths
    triplets["patched"] = patched_paths
    triplets["common"] = common_paths 

    return triplets

#compares two sets of paths, returning three dictionaries. 
# one contains the patched paths,
# another the vulnerable paths,
# and the last one has the common ones
def compare_path_sets(vulnerable_paths, patched_paths):
    set_of_common_flows = {}
    set_of_patch_only_flows = {}
    set_of_vuln_only_flows = {}

    #seperate out flows that only exist in the patched paths
    #from common flows
    for signal_name in vulnerable_paths:
        vuln_flows = vulnerable_paths[signal_name]

        if signal_name in patched_paths:
            #perform cross comparison between vulns and patched
            for patched_flow in patched_paths[signal_name]:
                #path comparison operation, true if patched_flow is in vuln_flows
                common = compare_flows(patched_flow, vuln_flows)

                if common == True:
                    #need to add the flow to common set
                    if signal_name not in set_of_common_flows:
                        set_of_common_flows[signal_name] = []
                    set_of_common_flows[signal_name].append(patched_flow)
                else:
                    #need to add the flow to the patch only list
                    if signal_name not in set_of_patch_only_flows:
                        set_of_patch_only_flows[signal_name] = []
                    set_of_patch_only_flows[signal_name].append(patched_flow) 
        else:
            #signal only exists in vuln 
            set_of_vuln_only_flows[signal_name] = vuln_flows 

    #seperate out flows that only exist in the vulnerable paths
    for signal_name in patched_paths:
        patched_flows = patched_paths[signal_name]

        if signal_name in vulnerable_paths:
            #perform cross comparison between vulns and patched
            for vulnerable_flow in vulnerable_paths[signal_name]:
                #path comparison operation, true if patched_flow is in vuln_flows
                common = compare_flows(vulnerable_flow, patched_flows)
                
                #only need to worry about vulnerable only paths
                if common == False:
                    #need to add the flow to the patch only list
                    if signal_name not in set_of_vuln_only_flows:
                        set_of_vuln_only_flows[signal_name] = []
                    set_of_vuln_only_flows[signal_name].append(vulnerable_flow) 

    return set_of_common_flows, set_of_patch_only_flows, set_of_vuln_only_flows



def compare_flows(patched_flow, vuln_flows):
    common = False
    num_com_edges = 0
    num_com_edges_req = len(patched_flow)

    for flow in vuln_flows:
        num_com_edges = 0
        for edge in flow:
            #detect sequence of edges
            if num_com_edges == num_com_edges_req:
                break
            elif compare_edges(edge, patched_flow[num_com_edges]):
                num_com_edges += 1
            else:
                num_com_edges = 0
        if num_com_edges == num_com_edges_req:
                break


    #each flow is an array of edges, need to see if the flows match
    if num_com_edges == num_com_edges_req:
        common = True

    return common



def compare_edges(edge_1, edge_2):
    #compare the type of edge, conditions required
    #source signal and destination signal 
    types_match = edge_1.type == edge_2.type
    conds_match = edge_1.conds == edge_2.conds
    #TODO: make this less error prone
    edge_1_src = edge_1.src_sig.rsplit(".", 1)[1]
    edge_2_src = edge_2.src_sig.rsplit(".", 1)[1]
    edge_1_dst = edge_1.dst_sig.rsplit(".", 1)[1]
    edge_2_dst = edge_2.dst_sig.rsplit(".", 1)[1]
    srcs_match = edge_1_src == edge_2_src
    dsts_match = edge_1_dst == edge_2_dst

    if types_match and conds_match and srcs_match and dsts_match:
        return True 
    
    return False


#takes a triplet type (vulnerable, patched, common), returns the number of flows held within it
def determine_triplet_length(triplet):
    
    triplet_length = 0

    for signal_name in triplet:
        triplet_length += len(triplet[signal_name])

    return triplet_length


