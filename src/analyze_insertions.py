import os
from pprint import pprint
from hfg_engine import HFG, HFGEdge
from data import isolated_insertions 

path_to_flist_dir = "./src/flists/insertions"

for design_name, flist_folder, design_flist in isolated_insertions:
    flist_file_path = path_to_flist_dir + "/" + flist_folder + "/"
    HFG(os.path.join(flist_file_path, design_flist))
