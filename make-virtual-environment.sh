#!/usr/bin/env bash

VENV_NAME=$1
if [[ -z $VENV_NAME ]]
then
  echo "You must specify a name for the new virtual environment"
  exit 1
fi

# Make sure to use --system-site-packages, so python can find
# Homebrew-installed or other system-installed packages (numpy, mpi4py,...)
python3 -m venv --system-site-packages ${VENV_NAME} || { echo "Failed to create venv" ; exit 1; }
source ${VENV_NAME}/bin/activate || { echo "Failed to activate venv"; exit 1; }
python -m pip install -U pip
deactivate

echo "Make sure to source the bin/activate script under this directory"
echo "whenever you want to use this virtual environment."
