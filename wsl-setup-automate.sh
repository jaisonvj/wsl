#!/bin/bash
##################################
# Author : jaison
# Date : 20/09/2023
# This script will install openssh and zsh shell in the ubuntu
# Version: V1
##################################
set -x # debug mode or shows the commands the is executing
set -e # exit the script when there is an error
set -o # to find pipelinefail
###########in window please execute followin command###############

# ssh-keygen -t rsa
# copy copy C:\Users\jaiso\.ssh\id_rsa.pub D:\Downloads\

######################### installing zsh #############################################

# Define the path to this script
script_path=$(readlink -f "$0")

### Installing Zsh and Customizing Zshrc #####

# Get the current username
username=$(whoami)
password=jaison

# Define the backup directory path
backup_dir=~/zshshell

# Define the URL of the .zshrc file on GitHub
github_repo="https://github.com/r-k-16/Linux.git"
zshrc_path="zsh/zshrc"

# Check if the backup directory exists and is not empty
if [ -d "$backup_dir" ] && [ -n "$(ls -A "$backup_dir")" ]; then
  echo "Removing existing backup directory: $backup_dir"
  rm -rf "$backup_dir"
fi

mkdir "$backup_dir"

# Clone the GitHub repository to the backup directory
git clone "$github_repo" "$backup_dir"

# Check if the repository was successfully cloned
if [ $? -eq 0 ]; then
  echo "Successfully cloned the GitHub repository to $backup_dir."
else
  echo "Failed to clone the GitHub repository. Exiting."
  exit 1
fi

# Copy the .zshrc file from the cloned repository to the backup directory
cp "$backup_dir/$zshrc_path" "$backup_dir"

# Define the line to be added to the sudoers file
sudoers_line="$username ALL=(ALL) NOPASSWD: ALL"

# Check if the line is already present in the sudoers file
if ! sudo grep -qF "$sudoers_line" /etc/sudoers; then
  # If the line is not found, add it to the sudoers file
  echo "$sudoers_line" | sudo tee -a /etc/sudoers
fi

# Update package repository
sudo apt update

# Install zsh, related packages and expect package for automation 
sudo apt-get install -y zsh zsh-autosuggestions zsh-syntax-highlighting expect

# Use expect to automate zsh-newuser-install and exit zsh shell after that.
expect << EOF
spawn zsh
expect {
  "This is the Z Shell configuration function for new users," {
    send "2\r"
    exp_continue
  }
  "Do you want to see what changed (y/n)?" {
    send "n\r"
    exp_continue
  }
  "% " {
    send "exit\r"
  }
}
EOF

# Use expect to change the login shell to zsh with sudo
expect << EOF
spawn sudo chsh -s /usr/bin/zsh "$username"
expect {
  "Password:" {
    send "$password\r"
    exp_continue
  }
  eof
}
EOF

# Remove the existing .zshrc file if it exists
rm ~/.zshrc

# Move the custom zshrc to the home directory
mv "$backup_dir/zshrc" ~/.zshrc

# Remove the backup directory after moving .zshrc file.
rm -rf "$backup_dir"

# Inform the user to restart the terminal.
echo "Please restart your terminal to apply changes."

########################################################################################

####  enabling open ssh ####

# Install the OpenSSH server
sudo apt install -y openssh-server

# Generate new host keys
ssh-keygen -A

# Start the SSH service
sudo service ssh start

# Allow SSH through the firewall
sudo ufw allow ssh

# Create the .ssh directory and authorized_keys file if they don't exist
mkdir -p ~/.ssh
touch ~/.ssh/authorized_keys

# Copy the public key to the authorized_keys file
cp /mnt/d/Downloads/id_rsa.pub ~/.ssh/authorized_keys

# Define the SSH configuration file path
ssh_config="/etc/ssh/sshd_config"

# Check if PasswordAuthentication exists in the sshd_config file
if grep -q "^PasswordAuthentication" $ssh_config; then
    # If it exists, change its value to yes
    sudo sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/' $ssh_config
else
    # If it doesn't exist, append PasswordAuthentication yes to the file
    echo "PasswordAuthentication yes" | sudo tee -a $ssh_config
fi

# Restart the SSH service to apply the changes
sudo service ssh restart

# Install net-tools for network information utilities such as ifconfig
sudo apt install -y net-tools

# Get the IP address of the eth0 interface and print it in the format ssh username@eth0ip
echo "**You can SSH using: ssh $USER@$(ifconfig eth0 | grep 'inet ' | awk '{print $2}')**"

### install docker using ###

# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04 

### install minkube using ###

# https://minikube.sigs.k8s.io/docs/start/
