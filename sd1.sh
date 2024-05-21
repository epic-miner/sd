#!/bin/bash

# Function to handle errors
handle_error() {
  echo "Error on line $1"
  exit 1
}

# Trap errors
trap 'handle_error $LINENO' ERR

# Check if the user wants to skip ngrok setup
SKIP_NGROK=false
for arg in "$@"; do
  if [ "$arg" == "--skip-ngrok" ]; then
    SKIP_NGROK=true
  fi
done

# Update and upgrade system
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install -y git python3 python3-venv python3-pip wget

if [ "$SKIP_NGROK" = false ]; then
  # Prompt for ngrok auth token
  read -sp 'Enter your ngrok auth token: ' NGROK_AUTH_TOKEN
  echo

  # Download and install ngrok
  wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
  tar -xvf ngrok-v3-stable-linux-amd64.tgz
  sudo mv ngrok /usr/local/bin/

  # Authenticate ngrok
  ngrok authtoken "$NGROK_AUTH_TOKEN"

  # Start ngrok
  ngrok http 7865 &
  NGROK_PID=$!

  # Wait for ngrok to start
  sleep 5
fi

# Clone the repository
git clone https://github.com/epic-miner/vvv.git
cd vvv/stable-diffusion-webui

# Create a virtual environment
python3 -m venv venv

# Activate the virtual environment
source venv/bin/activate

# Install Python dependencies
pip install -r requirements.txt

# Launch the application
python launch.py &
APP_PID=$!

if [ "$SKIP_NGROK" = false ]; then
  # Wait for ngrok to complete if it's running
  wait $NGROK_PID
fi

# Wait for the application to complete
wait $APP_PID
