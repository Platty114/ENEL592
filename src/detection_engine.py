from hfg_engine import HFG, HFGEdge
from triplet_engine import compare_flows, determine_triplet_length 

# detects the presence of a unpatched vulnerability within
# a design 
def detect_vulnerability(design_hfg, triplet):
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

    system_vulnerability_data = {}

    total_vuln_flows = determine_triplet_length(triplet["vulnerable"])
    total_patched_flows = determine_triplet_length(triplet["patched"])
    total_common_flows = determine_triplet_length(triplet["common"])

    for module_name in design_signal_paths:
        
        num_vuln_flows = 0
        num_patched_flows = 0
        num_common_flows = 0
        threshold_vuln = 0.0
        threshold_patch = 0.0
        threshould_common = 0.0

        system_vulnerability_data[module_name] = {}

        for signal_name in design_signal_paths[module_name]:
            #now compare flows 
            if signal_name in triplet["vulnerable"]:
                for vuln_flow in triplet["vulnerable"][signal_name]:
                    if compare_flows(
                        vuln_flow,
                        design_signal_paths[module_name][signal_name]
                    ) == True:
                        num_vuln_flows += 1.0
                        
            if signal_name in triplet["patched"]:
                for patch_flow in triplet["patched"][signal_name]:
                    if compare_flows(
                        patch_flow, 
                        design_signal_paths[module_name][signal_name]
                    ) == True:
                        num_patched_flows += 1.0

            if signal_name in triplet["common"]:
                for common_flow in triplet["common"][signal_name]:
                    if compare_flows(
                        common_flow, 
                        design_signal_paths[module_name][signal_name]
                    ) == True:
                        num_common_flows += 1.0

        threshold_vuln = num_vuln_flows / total_vuln_flows
        threshold_patch = num_patched_flows / total_patched_flows
        threshold_common = num_common_flows / total_common_flows
        vulnerability_found = False
        if (threshold_vuln > threshold_patch) and (threshold_common > 0.8):
            vulnerability_found = True

        system_vulnerability_data[module_name]["vulnerability_threshold"] = threshold_vuln
        system_vulnerability_data[module_name]["patched_threshold"] = threshold_patch
        system_vulnerability_data[module_name]["common_threshold"] = threshold_common
        system_vulnerability_data[module_name]["vulnerability_found"] = vulnerability_found


    
    return system_vulnerability_data
