from hfg_engine import HFG, HFGEdge

# calculates and presents statistics related to the given 
# triplet set. Provides statistics such as the average length
# of vulnerable, common and patched information flows,
# the minimum length and the maximum length of each, as well as
# the number of flows in each
def generate_triplet_statistics(triplet):
    triplet_stats = {
        "vulnerable": generate_flow_statistics(triplet["vulnerable"]),
        "patched": generate_flow_statistics(triplet["patched"]),
        "common": generate_flow_statistics(triplet["common"])
    }

    display_triplet_statistics(triplet_stats) 

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
def display_triplet_statistics(stats):

    print("----------------------------")
    for triplet_type in stats:
        print("statistics for " + triplet_type + " flows:")
        print("----------------------------")
        for data_point in stats[triplet_type]:
            print(data_point + ": " + str(stats[triplet_type][data_point]))
        print("----------------------------")

#display vulnerability_data for a given detection routine
def display_module_stats(vulnerability_data):

    print("----------------------------")
    for module in vulnerability_data:
        print("vulnerability statistics for " + module)
        print("----------------------------")
        for data_point in vulnerability_data[module]:
            print(data_point + ": " + str(vulnerability_data[module][data_point]))
        print("----------------------------")
















    
