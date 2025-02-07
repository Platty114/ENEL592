#!/bin/bash

python3 -m venv ./.venv
source .venv/bin/activate

#pip install pyslang==3.0.310
pip install pyslang
pip install codetiming

echo "Setup Complete!\n"
