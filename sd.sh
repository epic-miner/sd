#!/bin/bash

# Update and upgrade system
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install -y git python3 python3-venv python3-pip

# Clone the repository
git clone https://github.com/epic-miner/vvv.git
cd vvv
# Navigate into the cloned directory
cd stable-diffusion-webui

# Create a virtual environment
python3 -m venv venv

# Activate the virtual environment
source venv/bin/activate

# Install Python dependencies
pip install -r requirements.txt

# Launch the application
python launch.py --share
