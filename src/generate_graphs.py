import os
from pprint import pprint
from hfg_engine import HFG, HFGEdge
from data import graph_flists

path_to_flist_dir = "./src/flists/graphs"

for design_name, design_flist in graph_flists:

    HFG(os.path.join(path_to_flist_dir, design_flist))
