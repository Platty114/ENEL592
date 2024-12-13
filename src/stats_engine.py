import os
from hfg_engine import HFG, HFGEdge

path_to_output_folder = "./output/"

# calculates and presents statistics related to the given 
# triplet set. Provides statistics such as the average length
# of vulnerable, common and patched information flows,
# the minimum length and the maximum length of each, as well as
# the number of flows in each
def triplet_statistics_as_string(triplet):
    triplet_stats = {
        "vulnerable": generate_flow_statistics(triplet["vulnerable"]),
        "patched": generate_flow_statistics(triplet["patched"]),
        "common": generate_flow_statistics(triplet["common"])
    }

    return create_triplet_statistics_string(triplet_stats) 

# generates the minimum, max, and average number of flows, 
# and total number for a given of infromation flows
def generate_flow_statistics(set_of_flows):
    min_flow_length = float("inf") 
    max_flow_length = 0
    avg_flow_length = 0 
    total_num_flows = 0
    total_flow_length = 0

    for signal_name in set_of_flows:
         
        for flow in set_of_flows[signal_name]:

            total_num_flows += 1     
            cur_flow_length = len(flow) 
            total_flow_length += cur_flow_length
            if cur_flow_length < min_flow_length:
                min_flow_length = cur_flow_length
            elif cur_flow_length > max_flow_length:
                max_flow_length = cur_flow_length

    avg_flow_length = total_flow_length / total_num_flows

    return {
        "min_flow_length": min_flow_length,
        "max_flow_length": max_flow_length,
        "avg_flow_length": avg_flow_length,
        "total_num_flows": total_num_flows,
        "total_flow_length": total_flow_length
    }

#displays the given triplet statistics
def create_triplet_statistics_string(stats):
    string = ""
    string += "----------------------------\n"
    for triplet_type in stats:
        string += "statistics for " + triplet_type + " flows:" + "\n"
        string += "----------------------------\n"
        for data_point in stats[triplet_type]:
            string += data_point + ": " + str(stats[triplet_type][data_point]) + "\n"
        string += "----------------------------\n"

    return string

#display vulnerability_data for a given detection routine
def module_stats_as_string(vulnerability_data):
    string = ""
    string += "----------------------------\n"
    for module in vulnerability_data:
        string += "vulnerability statistics for " + module + "\n"
        string += "----------------------------\n"
        for data_point in vulnerability_data[module]:
            string += data_point + ": " + str(vulnerability_data[module][data_point]) + "\n"
        string += "----------------------------\n"

    return string



#writes a statistics_string to a file
def write_statistics(statistics_string, file_name):

    if not os.path.exists(path_to_output_folder):
        os.makedirs(path_to_output_folder)

    file = open(path_to_output_folder + file_name + ".txt", "w")

    file.write(statistics_string)

    file.close()













    
