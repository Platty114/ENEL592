import os
from pprint import pprint
from hfg_engine import HFG, HFGEdge


path_to_flist_dir = "./flists"
demos = [
    ("test_00.f"            , "./hfg_edges_test_00.pkl"             ),
    ("test_01_FWRISC-MDS.f" , "./hfg_edges_fwrisc_mul_div_shift.pkl"),
    ("test_02_cva6_serdiv.f", "./hfg_edges_serdiv.pkl"              ),
    ("test_custom_01.f"     , "./hfg_edges_test_custom_01_top.pkl"  ),
]

for curr_flist, curr_pkl in demos:
    HFG(os.path.join(path_to_flist_dir, curr_flist))

#Leave this set to 2 for proper execution of the cells below
demo_index = 0

demo_hfg_a = HFG(os.path.join(path_to_flist_dir, "test_1234.f")) #Build HFG from scratch using RTL 
#demo_hfg_b = HFG("", i_fp_to_hfg_pickle_file=demos[demo_index][1])      #Build HFG from saved pickle/serialization file

#assert demo_hfg_a == demo_hfg_b

print(demo_hfg_a.get_signals())

results_a_sigs, results_a_path_to_sigs = demo_hfg_a.get_descendant_signals_and_paths("Locked_register_example.debug_unlocked", False)
pprint(results_a_sigs)
pprint(results_a_path_to_sigs)
#print(HFGEdge(demo_hfg_a.__hfg__['Locked_register_example.debug_unlocked']['Locked_register_example.Data_out'][0]))
for i in results_a_path_to_sigs:
    print("---------")
    for j in i:
        print(j)
