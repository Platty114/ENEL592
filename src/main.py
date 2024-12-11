import os
from pprint import pprint
from hfg_engine import HFG, HFGEdge
from triplet_engine import create_vuln_triplets 
from detection_engine import detect_vulnerability 
path_to_flist_dir = "./flists"
demos = [
    ("test_00.f"            , "./hfg_edges_test_00.pkl"             ),
    ("test_01_FWRISC-MDS.f" , "./hfg_edges_fwrisc_mul_div_shift.pkl"),
    ("test_custom_01.f"     , "./hfg_edges_test_custom_01_top.pkl"  ),
]

#generate hfg for each design in flists
#for curr_flist, curr_pkl in demos:
#    HFG(os.path.join(path_to_flist_dir, curr_flist))

#build an HFG for vulnerable module
vulnerable_module = HFG(os.path.join(path_to_flist_dir, "cwe-1231.f"))

#build an HFG for patched module
pathced_module = HFG(os.path.join(path_to_flist_dir, "cwe-1231_fixed.f")) 

#generate triplets for the vulnerability
triplets = create_vuln_triplets(vulnerable_module, pathced_module)

design_hfg = HFG(os.path.join(path_to_flist_dir, "cwe-1231.f"))

detect_vulnerability(design_hfg, triplets)
