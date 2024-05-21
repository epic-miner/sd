#!/bin/bash

# Install necessary packages
pip install pyngrok diffusers transformers accelerate gradio

# Clone the repository
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git

# Navigate into the cloned directory
cd stable-diffusion-webui

# Download the pre-trained model
mkdir -p models/Stable-diffusion
wget -O models/Stable-diffusion/model.ckpt https://huggingface.co/CompVis/stable-diffusion-v-1-4-original/resolve/main/sd-v1-4.ckpt

# Install Python dependencies
pip install -r requirements.txt

# Launch the application
python launch.py --share --port 7860
