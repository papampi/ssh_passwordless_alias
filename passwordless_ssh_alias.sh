#!/bin/bash

# Check the operating system
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Linux OS detected
  echo "Linux OS detected."
  
  # Check if sshpass is installed and install it if necessary
  if ! command -v sshpass >/dev/null 2>&1; then
      echo "sshpass is not installed. Installing now..."
      sudo apt-get install sshpass -y
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS detected
  echo "macOS detected."
  
  # Check if Homebrew is installed
  if ! command -v brew >/dev/null 2>&1; then
      echo "Homebrew is not installed. Installing now..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Check if sshpass is installed and install it if necessary
  if ! command -v sshpass >/dev/null 2>&1; then
      echo "sshpass is not installed. Installing now..."
      brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb
  fi
else
  # Unsupported operating system
  echo "Unsupported operating system. This script only supports Linux and macOS."
  exit 1
fi

# Prompt the user for the SSH credentials for the server
read -p "Enter the SSH username for the server: " username
read -s -p "Enter the SSH password for the server: " password
echo ""
read -p "Enter the IP address of the server: " server_ip
read -p "Enter the SSH port for the server (default is 22): " ssh_port
ssh_port=${ssh_port:-22}

# Prompt the user for an alias name
read -p "Enter an alias name for the server (e.g. 'server1'): " alias_name

# Check if the SSH key pair already exists
if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    # SSH key pair does not exist, generate new SSH key pair
    echo "SSH key pair not found. Generating new SSH key pair..."
    ssh-keygen -t rsa -N "" -f "$HOME/.ssh/id_rsa"
else
    echo "SSH key pair found."
fi

# Check if the public key is available on the remote host
if ! ssh -q "$ssh_port $username@$server_ip" 'exit' >/dev/null 2>&1; then
  # Public key is not available, copy public key to remote host
  echo "Public key not found on remote host. Copying public key to remote host..."
  sshpass -p $password ssh-copy-id -p $ssh_port $username@$server_ip
fi

# Add an alias for the server to the ~/.bash_aliases file
echo "Adding an alias for the server to the ~/.bash_aliases file..."
echo "alias $alias_name='ssh $username@$server_ip -p $ssh_port'" >> ~/.bash_aliases
source ~/.bash_aliases

echo "Done! You can now connect to the server by typing '$alias_name' in the terminal."
