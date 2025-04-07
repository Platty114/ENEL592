import os
from pprint import pprint
from hfg_engine import HFG, HFGEdge
from data import isolated_insertions 

path_to_flist_dir = "./src/flists/insertions"
path_to_output_dir = "./src/analyze_insertions/"

def analyze_insertions():
    insertion_data = {}

    for design_name, flist_folder, design_flist in isolated_insertions:
        flist_file_path = path_to_flist_dir + "/" + flist_folder + "/"
        cwe_name, hdc_type = flist_folder.split("/")
        current_module = HFG(os.path.join(flist_file_path, design_flist))

        if cwe_name not in insertion_data:
            insertion_data[cwe_name] = {}

        if hdc_type not in insertion_data[cwe_name]:
            insertion_data[cwe_name][hdc_type] = {
                "num_exp_edges": 0,
                "num_imp_edges": 0,
                "num_exp_conds": 0,
                "avg_num_conds": 0,
                "num_flows": 0,
                "tot_flow_len": 0,
                "avg_flow_len": 0
            }

        for signal_name in current_module.get_signals():
            
            signals, flows = current_module.get_descendant_signals_and_paths(signal_name)

            for flow in flows:
                insertion_data[cwe_name][hdc_type]["num_flows"] += 1
                insertion_data[cwe_name][hdc_type]["tot_flow_len"] += len(flow)
                for edge in flow:
                    if edge.type == "Explicit":
                        insertion_data[cwe_name][hdc_type]["num_exp_edges"] += 1
                        insertion_data[cwe_name][hdc_type]["num_exp_conds"] += len(edge.conds)
                    
                    else:
                        insertion_data[cwe_name][hdc_type]["num_imp_edges"] += 1
    

    for cwe in insertion_data:
        if not os.path.exists(path_to_output_dir):
            os.makedirs(path_to_output_dir)
        
        file = open(path_to_output_dir + cwe + ".txt", "w")

        for cwe_type in insertion_data[cwe]:
            num_exp_edges = insertion_data[cwe][cwe_type]["num_exp_edges"]
            num_exp_conds = insertion_data[cwe][cwe_type]["num_exp_conds"]
            insertion_data[cwe][cwe_type]["avg_num_conds"] = num_exp_conds / num_exp_edges 
            
            tot_flow_len = insertion_data[cwe][cwe_type]["tot_flow_len"]
            num_flows = insertion_data[cwe][cwe_type]["num_flows"]
            insertion_data[cwe][cwe_type]["avg_flow_len"] = tot_flow_len / num_flows
            
            file.write(cwe_type + "\n")

            for statistic in insertion_data[cwe][cwe_type]:
                file.write(statistic + ": " + str(insertion_data[cwe][cwe_type][statistic]))
                file.write("\n")
            
            file.write("\n\n")





analyze_insertions()

