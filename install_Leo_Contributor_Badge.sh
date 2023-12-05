#!/bin/bash
cd /root
# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "You need to run this script with root permission. Please use 'sudo' or switch to the root user."
    exit 1
fi

# Check the Linux distribution
if command -v apt-get &> /dev/null; then
    # Ubuntu or Debian
    echo "Detected Ubuntu/Debian distribution."
    apt-get update
    apt-get install git -y
elif command -v yum &> /dev/null; then
    # CentOS or Red Hat
    echo "Detected CentOS/Red Hat distribution."
    yum install git -y
else
    echo "Unsupported distribution. Please install Git manually."
    exit 1
fi

echo -e "Git has been installed successfully.\n\n"


echo -e "Install Rust.\n\n"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh


echo -e "1.Clone and install AleoHQ/leo.\n\n"
git clone https://github.com/AleoHQ/leo
sleep 1
cd leo
cargo install --path .
sleep 1

leo account new

echo -e "2. Working with Leo\n\n"
leo example tictactoe
sleep 2
cd tictactoe
leo run new
sleep 2


echo -e "3. Push your Leo app to GitHub"
git init
git add .

# Prompt user for email address
read -p "Enter your Github user email address: " userEmail

# Validate email format (optional)
if [[ ! "$userEmail" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "Invalid email address format. Please enter a valid email address."
    exit 1
fi
# Configure Git user email globally
git config --global user.email "$userEmail"
sleep 2
# Get user input for Git global user name
read -p "Enter your Git global user name: " newUserName

# Check if the entered user name is not empty
if [ -z "$newUserName" ]; then
    echo "Error: User name cannot be empty. Please try again."
    exit 1
fi

# Set Git global user name
git config --global user.name "$newUserName"
sleep 2

git commit -m "Hello Aleo"

git branch -m main

read -p "Enter your Github YOUR_REPOSITORY_LINK: " repoURL
git remote add origin $repoURL
git remote -v


keyFile="/root/.ssh/id_rsa"
if [[ -f "$keyFile" ]]; then
    echo "SSH key already exists at: $keyFile. Skipping key generation."
    echo -e "\n"
    cat /root/.ssh/id_rsa.pub
else
    # Generate SSH key
    ssh-keygen -t rsa -b 4096 -C "aaaaaaaaa" -f "$keyFile"
    echo "SSH key has been generated at: $keyFile"
    echo -e "\n"
    cat /root/.ssh/id_rsa.pub
fi

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa


echo -e "1.Truy cap github setting: https://github.com/settings/profile \n2. Add sshkey ben tren vao"

read -p "3. An phim Enter de tiep tuc" 

# cd /root/leo/tictactoe/
# eval "$(ssh-agent -s)"
# ssh-add ~/.ssh/id_rsa
# git push -f origin main

# echo "Git push completed successfully."



