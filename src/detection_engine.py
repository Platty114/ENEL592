from hfg_engine import HFG, HFGEdge

#compares a hfg that contains a vulnerability to it's
#equivalent hfg that has had the vulnerability patched
#returns 3 lists of signal paths, ones that are in both,
#ones that are only in the vulnerable hfg and ones
#that are only in the patched hfg
#at the moment this will only detect type 1 vulnerabilities
def setup_vuln_detection (vulnerable_hfg, patched_hfg):
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
    compare_path_sets(vulnerable_paths, patched_paths, common_paths)

    print("Printing path variables")
    #for i in vulnerable_paths:
    #    for j in i:
    #        print(j)
    print(vulnerable_paths)
    print("--------------")
    #for i in patched_paths:
    #    for j in i:
    #        print(j)
        #print("+++++++++")
    print(patched_paths)


#compares two sets of paths, returns true or 
def compare_path_sets(vulnerable_paths, patched_paths, common_paths):

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
                    #need to add the flow to common set and remove from both patch and vuln
                    if signal_name not in set_of_common_flows:
                        set_of_common_flows[signal_name] = []
                    set_of_common_flows.append(patched_flow)
                    #TODO remove from patch and vuln
                else:
                    #need to add the flow to the patch only list
                    if signal_name not in set_of_patch_only_flows:
                        set_of_patch_only_flows[signal_name] = []
                    set_of_patch_only_flows.append(patched_flow) 
        else:
            #signal only exists in vuln 
            set_of_vuln_only_flows[signal_name] = vuln_flows 


def compare_flows(patched_flow, vuln_flows):
    #print(patched_flow)
    #for edge in patched_flow:
        #print(edge)
    print("-----------\n")
    print(vuln_flows)
    #for edges in vuln_flows:
        #for edge in edges:
            #print(edge)
    common = False
    num_com_edges = 0
    num_com_edges_req = len(patched_flow)

    for flow in vuln_flows:
        for edge in flow:
            print(num_com_edges)
            #detect sequence of edges
            if num_com_edges == num_com_edges_req:
                print("here 1")
                break
            elif compare_edges(edge, patched_flow[num_com_edges]):
                print("here2")
                num_com_edges += 1
            else:
                num_com_edges = 0

    if num_com_edges == num_com_edges_req:
        common = True
    #each flow is an array of edges, need to see if the flows match
    print(common) 
    assert(True == False)





def compare_edges(edge_1, edge_2):
    print(edge_1)
    print(edge_2)
    if edge_1.type == edge_2.type and edge_1.conds == edge_2.conds  and edge_1.sa == edge_2.sa:
        print("COMPARED = True")
        return True 
    print("COMPARED = False")
    return False







