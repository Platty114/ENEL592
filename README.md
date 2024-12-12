# ENEL592 - Implementation

## Description
- This repo contains a basic implementation of a hardware vulnerability detection tool. The tool is built on top of a preexisting tool, which generates graph representations of Hardware Designs called a HyperFlow Graph. This representation is used to perform analysis on a vulnerability, it's patch, and the hardware system selected for vulnerability detection. The output of this tool is a set of statistics about the given vulnerability, it's patch, as well as information on whether the modules in the chosen hardware system feature the given vulnerbaility. For the moment, this tool is only able to detect type 1 vulnerabilities, which means it is only able to find exact copies.

## Install, Setup, and Run the tool

### Instalation Procedure
- This tool makes use of Python 3, so a valid python 3 interpreter is required. To setup / install all required dependancies for the tool. For those using a bash based terminal emulator all that is required to setup the tool is

    1. making the setup.sh bash script executable.
    2. execturing the setup.sh bash script.

- this can be done using the following commands from the root of the directory

    1. ```chmod +x setup.sh```
    2. ```./setup.sh```

- otherwise, the install steps can be performed manually
    
    1. ```python3 -m venv ./.venv```
    2. ```source .venv/bin/activate```
    3. ```pip install pyslang==3.0.310```
    4. ```pip install codetiming```

### Run the tool
- Running the tool is simple. Just use the provided bash shell script or run the main.py file manually.

- bash
    1. ```chmod +x run.sh```
    2. ```./run.sh```

- manual
    1. ```python3 src/main.py```


## Examples

## Credits
