import os
from pprint import pprint
from hfg_engine import HFG, HFGEdge
from detection_engine import compare_vuln_to_patched

path_to_flist_dir = "./flists"
demos = [
    ("test_00.f"            , "./hfg_edges_test_00.pkl"             ),
    ("test_01_FWRISC-MDS.f" , "./hfg_edges_fwrisc_mul_div_shift.pkl"),
    ("test_02_cva6_serdiv.f", "./hfg_edges_serdiv.pkl"              ),
    ("test_custom_01.f"     , "./hfg_edges_test_custom_01_top.pkl"  ),
]

#generate hfg for each design in flists
#for curr_flist, curr_pkl in demos:
#    HFG(os.path.join(path_to_flist_dir, curr_flist))

#build an HFG for vulnerable module
vulnerable_module = HFG(os.path.join(path_to_flist_dir, "cwe-1231.f"))

#build an HFG for patched module
pathced_module = HFG(os.path.join(path_to_flist_dir, "cwe-1231_fixed.f")) 

print("--------hfg_a_signals--------")
print(vulnerable_module.get_signals())
print("--------hfg_b_signals--------")
print(pathced_module.get_signals())

#compared vulnerable module to patched module
compare_vuln_to_patched(vulnerable_module, pathced_module)
