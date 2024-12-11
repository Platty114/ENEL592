from hfg_engine import HFG, HFGEdge
from triplet_engine import compare_flows

# detects the presence of a unpatched vulnerability within
# a design 
def detect_vulnerability(design_hfg, triplet):

    for signal in triplet["patched"]:
       for flow in triplet["patched"][signal]:
           for edge in flow:
               print(edge)
           print("__________________________")
    print("======= end! ======= \n")
    #assert(True == False)
    design_signal_paths = {}
    
    # build dictionary of descendant paths for each signal in the design 
    for design_signal_name in design_hfg.get_signals():
        #TODO: this should be made less error prone later
        module_name, signal_name = design_signal_name.rsplit(".", 1)

        signals, path_to_signals = design_hfg.get_descendant_signals_and_paths(design_signal_name, False)
         
        #now add all paths to vulnerable_paths 
        for i in path_to_signals:
            if module_name not in design_signal_paths:
                design_signal_paths[module_name] = {}
            if signal_name not in design_signal_paths[module_name]:
                design_signal_paths[module_name][signal_name] = []
            design_signal_paths[module_name][signal_name].append(i)

    #determine the simularity to vulnerable or patched flows
    vulnerable_count = 0
    patched_count = 0
    #for module_name in design_signal_paths:
    #    for signal_name in design_signal_paths[module_name]:
    #        for flow in design_signal_paths[module_name][signal_name]:
    #            for edge in flow:
    #                print(edge)
    #assert(True == False)
    for module_name in design_signal_paths:
        for signal_name in design_signal_paths[module_name]:
            #now compare flows 
            if signal_name in triplet["vulnerable"]:
                for vuln_flow in triplet["vulnerable"][signal_name]:
                    if compare_flows(
                        vuln_flow,
                        design_signal_paths[module_name][signal_name]
                    ) == True:
                        
                        vulnerable_count += 1
                        
            if signal_name in triplet["patched"]:
                for patch_flow in triplet["patched"][signal_name]:
                    if compare_flows(
                        patch_flow, 
                        design_signal_paths[module_name][signal_name]
                    ) == True:
                        for edge in patch_flow:
                            print(edge)
                        print("-----")
                        patched_count += 1

    print(vulnerable_count)
    print(patched_count)

       
