import os
from pprint import pprint
from hfg_engine import HFG, HFGEdge
from triplet_engine import create_vuln_triplets 
from detection_engine import detect_vulnerability 
from stats_engine import triplet_statistics_as_string, module_stats_as_string, write_statistics
from data import vunerabilities_and_patches, design_flists

path_to_flist_dir = "./src/flists"

#detect vulnerabilities in each design in flists
for design_name, design in design_flists:
    
    #check for each vulnerability in flists within the design
    for vuln_name, vuln, patch in vunerabilities_and_patches:

        #build an HFG for vulnerable module
        vulnerable_module = HFG(os.path.join(path_to_flist_dir, vuln ))

        #build an HFG for patched module
        pathced_module = HFG(os.path.join(path_to_flist_dir, patch)) 

        #generate triplets for the vulnerability
        triplets = create_vuln_triplets(vulnerable_module, pathced_module)
        
        #build and HFG for the design 
        design_hfg = HFG(os.path.join(path_to_flist_dir, design))

        #test for vulnerability in the design
        vulnerability_data = detect_vulnerability(design_hfg, triplets)

        #generate statistics about the triplet and display both triplet and module data
        triplet_statistics = triplet_statistics_as_string(triplets)
        design_statistics = module_stats_as_string(vulnerability_data)
        write_statistics(triplet_statistics, vuln_name)
        write_statistics(design_statistics, design_name + "_" + vuln_name)

