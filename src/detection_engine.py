from hfg_engine import HFG, HFGEdge

#compares a hfg that contains a vulnerability to it's
#equivalent hfg that has had the vulnerability patched
#returns 3 lists of signal paths, ones that are in both,
#ones that are only in the vulnerable hfg and ones
#that are only in the patched hfg
#at the moment this will only detect type 1 vulnerabilities
def compare_vuln_to_patched (vulnerable_hfg, patched_hfg):
    common_paths = []
    vulnerable_paths = []
    patched_paths = []
    #print all descendant signal paths for vulnerable module
    for vuln_signal_name in vulnerable_hfg.get_signals():
        print("++++++++" + signal_name + "+++++++")
        results_a_sigs, results_a_path_to_sigs = vulnerable_hfg.get_descendant_signals_and_paths(vuln_signal_name, False)
        for i in results_a_path_to_sigs:
            print("---------")
            for j in i:
                print(j)

    #print all descendant signal paths for patched module
    print("========PATCHED FLOWS========")
    for signal_name in patched_hfg.get_signals():
        print("++++++++" + signal_name + "+++++++")
        results_b_sigs, results_b_path_to_sigs = patched_hfg.get_descendant_signals_and_paths(signal_name, False)
        for i in results_b_path_to_sigs:
            print("---------")
            for j in i:
                print(j) 

     

