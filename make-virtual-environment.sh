#!/usr/bin/env bash

# Make sure to use --system-site-packages, so python can find
# Homebrew-installed or other system-installed packages (numpy, mpi4py,...)
python3 -m venv --system-site-packages work-venv|| { echo "Failed to create venv" ; exit 1; }
source work-venv/bin/activate || { echo "Failed to activate venv"; exit 1; }
python -m pip install -U pip
python -m pip install nose
deactivate

echo "Make sure to source the bin/activate script under this directory"
echo "whenever you want to use this virtual environment."
