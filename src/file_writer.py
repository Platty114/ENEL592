
path_to_output_folder = "./output/"

def write_statistics(statistics_string, vuln_name):
    file_name = vuln_name

    file = open(path_to_output_folder + file_name, "w")

    file.write(statistics_string)
    

