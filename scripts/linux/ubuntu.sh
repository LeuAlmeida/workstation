#!/bin/bash

# ==================================
# Ubuntu Workstation Setup Script
# Version: 2.1.0
# Author: Léu Almeida
# Updated: May 2025
# ==================================

# ----------------------------------
# Color definitions
# ----------------------------------
NOCOLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHTGRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'
LIGHTPURPLE='\033[1;35m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'

# ----------------------------------
# Global variables
# ----------------------------------
TOTAL_STEPS=36
CURRENT_STEP=0
LOG_FILE="/tmp/workstation_setup_$(date +%Y%m%d%H%M%S).log"
ERROR_COUNT=0

# ----------------------------------
# Helper functions
# ----------------------------------

# Error handling function
handle_error() {
  local exit_code=$1
  local error_message=$2
  local ignore_error=${3:-false}
  
  if [ $exit_code -ne 0 ]; then
    echo "${RED}ERROR: $error_message (Exit code: $exit_code)${NOCOLOR}" | tee -a "$LOG_FILE"
    ERROR_COUNT=$((ERROR_COUNT + 1))
    
    if [ "$ignore_error" != "true" ]; then
      echo "${YELLOW}Do you want to continue despite this error? (y/n)${NOCOLOR}"
      read -r continue_choice
      if [ "$continue_choice" != "${continue_choice#[Yy]}" ]; then
        echo "${BLUE}Continuing with the installation...${NOCOLOR}"
        return 0
      else
        echo "${RED}Installation aborted due to error.${NOCOLOR}"
        exit $exit_code
      fi
    fi
  fi
  return 0
}

# Progress display function
show_progress() {
  local step_name=$1
  CURRENT_STEP=$((CURRENT_STEP + 1))
  echo ""
  echo "${LIGHTGREEN}[$CURRENT_STEP/$TOTAL_STEPS] $step_name ${NOCOLOR}"
  echo "----------------------------------------------------------------"
}

# Check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check version of installed software
check_version() {
  local package=$1
  local current_version=$2
  local required_version=$3
  
  if [ -z "$current_version" ]; then
    return 1 # No version found, needs installation
  fi
  
  # Simple version comparison - can be enhanced for more complex version strings
  if [ "$current_version" = "$required_version" ]; then
    return 0 # Versions match
  elif [[ "$current_version" > "$required_version" ]]; then
    return 0 # Current version is newer
  else
    return 1 # Current version is older, needs update
  fi
}

# Check if a package is installed and its version
check_installation() {
  local package=$1
  local required_version=${2:-""}
  
  case "$package" in
    node)
      if command_exists node; then
        local current_version=$(node --version | cut -d 'v' -f 2)
        if [ -n "$required_version" ]; then
          check_version "$package" "$current_version" "$required_version"
          return $?
        else
          return 0 # Node exists and no version check needed
        fi
      else
        return 1 # Node not installed
      fi
      ;;
    npm)
      if command_exists npm; then
        local current_version=$(npm --version)
        if [ -n "$required_version" ]; then
          check_version "$package" "$current_version" "$required_version"
          return $?
        else
          return 0 # NPM exists and no version check needed
        fi
      else
        return 1 # NPM not installed
      fi
      ;;
    docker)
      if command_exists docker; then
        local current_version=$(docker --version | cut -d ' ' -f 3 | cut -d ',' -f 1)
        if [ -n "$required_version" ]; then
          check_version "$package" "$current_version" "$required_version"
          return $?
        else
          return 0 # Docker exists and no version check needed
        fi
      else
        return 1 # Docker not installed
      fi
      ;;
    docker-compose)
      if command_exists docker-compose; then
        local current_version=$(docker-compose --version | cut -d ' ' -f 3 | tr -d ',')
        if [ -n "$required_version" ]; then
          check_version "$package" "$current_version" "$required_version"
          return $?
        else
          return 0 # Docker Compose exists and no version check needed
        fi
      else
        return 1 # Docker Compose not installed
      fi
      ;;
    zsh)
      if command_exists zsh; then
        local current_version=$(zsh --version | cut -d ' ' -f 2)
        if [ -n "$required_version" ]; then
          check_version "$package" "$current_version" "$required_version"
          return $?
        else
          return 0 # ZSH exists and no version check needed
        fi
      else
        return 1 # ZSH not installed
      fi
      ;;
    git)
      if command_exists git; then
        local current_version=$(git --version | cut -d ' ' -f 3)
        if [ -n "$required_version" ]; then
          check_version "$package" "$current_version" "$required_version"
          return $?
        else
          return 0 # Git exists and no version check needed
        fi
      else
        return 1 # Git not installed
      fi
      ;;
    warp)
      if command_exists warp; then
        local current_version=$(warp --version 2>/dev/null | head -n 1 | cut -d ' ' -f 2 || echo "")
        if [ -n "$required_version" ]; then
          check_version "$package" "$current_version" "$required_version"
          return $?
        else
          return 0 # Warp exists and no version check needed
        fi
      else
        return 1 # Warp not installed
      fi
      ;;
    code)
      if command_exists code; then
        local current_version=$(code --version | head -n 1)
        if [ -n "$required_version" ]; then
          check_version "$package" "$current_version" "$required_version"
          return $?
        else
          return 0 # VSCode exists and no version check needed
        fi
      else
        return 1 # VSCode not installed
      fi
      ;;
    typescript|tsc)
      if command_exists tsc; then
        local current_version=$(tsc --version | cut -d ' ' -f 2)
        if [ -n "$required_version" ]; then
          check_version "$package" "$current_version" "$required_version"
          return $?
        else
          return 0 # TypeScript exists and no version check needed
        fi
      else
        return 1 # TypeScript not installed
      fi
      ;;
    create-react-app)
      if command_exists create-react-app; then
        local current_version=$(create-react-app --version 2>/dev/null | cut -d ' ' -f 2 || echo "")
        if [ -n "$required_version" ]; then
          check_version "$package" "$current_version" "$required_version"
          return $?
        else
          return 0 # Create React App exists and no version check needed
        fi
      else
        return 1 # Create React App not installed
      fi
      ;;
    gatsby)
      if command_exists gatsby; then
        local current_version=$(gatsby --version 2>/dev/null | head -n 1 | cut -d ' ' -f 2 || echo "")
        if [ -n "$required_version" ]; then
          check_version "$package" "$current_version" "$required_version"
          return $?
        else
          return 0 # Gatsby exists and no version check needed
        fi
      else
        return 1 # Gatsby not installed
      fi
      ;;
    yarn)
      if command_exists yarn; then
        local current_version=$(yarn --version)
        if [ -n "$required_version" ]; then
          check_version "$package" "$current_version" "$required_version"
          return $?
        else
          return 0 # Yarn exists and no version check needed
        fi
      else
        return 1 # Yarn not installed
      fi
      ;;
    react-native)
      if command_exists react-native; then
        local current_version=$(react-native --version 2>/dev/null | cut -d ' ' -f 3 || echo "")
        if [ -n "$required_version" ]; then
          check_version "$package" "$current_version" "$required_version"
          return $?
        else
          return 0 # React Native CLI exists and no version check needed
        fi
      else
        return 1 # React Native CLI not installed
      fi
      ;;
    heroku)
      if command_exists heroku; then
        local current_version=$(heroku --version | head -n 1 | cut -d '/' -f 2 | cut -d ' ' -f 1)
        if [ -n "$required_version" ]; then
          check_version "$package" "$current_version" "$required_version"
          return $?
        else
          return 0 # Heroku CLI exists and no version check needed
        fi
      else
        return 1 # Heroku CLI not installed
      fi
      ;;
    aws)
      if command_exists aws; then
        local current_version=$(aws --version 2>&1 | cut -d ' ' -f 1 | cut -d '/' -f 2)
        if [ -n "$required_version" ]; then
          check_version "$package" "$current_version" "$required_version"
          return $?
        else
          return 0 # AWS CLI exists and no version check needed
        fi
      else
        return 1 # AWS CLI not installed
      fi
      ;;
    kubectl)
      if command_exists kubectl; then
        local current_version=$(kubectl version --client --short | cut -d ' ' -f 3)
        if [ -n "$required_version" ]; then
          check_version "$package" "$current_version" "$required_version"
          return $?
        else
          return 0 # kubectl exists and no version check needed
        fi
      else
        return 1 # kubectl not installed
      fi
      ;;
    spotify)
      if command_exists spotify; then
        return 0 # Spotify exists
      else
        return 1 # Spotify not installed
      fi
      ;;
    google-chrome|google-chrome-stable)
      if command_exists google-chrome || command_exists google-chrome-stable; then
        return 0 # Chrome exists
      else
        return 1 # Chrome not installed
      fi
      ;;
    franz)
      if command_exists franz; then
        return 0 # Franz exists
      else
        return 1 # Franz not installed
      fi
      ;;
    dbeaver)
      if command_exists dbeaver; then
        return 0 # DBeaver exists
      else
        return 1 # DBeaver not installed
      fi
      ;;
    insomnia)
      if command_exists insomnia; then
        return 0 # Insomnia exists
      else
        return 1 # Insomnia not installed
      fi
      ;;
    postbird)
      if command_exists postbird; then
        return 0 # Postbird exists
      else
        return 1 # Postbird not installed
      fi
      ;;
    python3)
      if command_exists python3; then
        local current_version=$(python3 --version 2>&1 | cut -d " " -f 2)
        if [ -n "$required_version" ]; then
          check_version "$package" "$current_version" "$required_version"
          return $?
        else
          return 0 # Python exists and no version check needed
        fi
      else
        return 1 # Python not installed
      fi
      ;;
    conda)
      if command_exists conda; then
        local current_version=$(conda --version | cut -d " " -f 2)
        if [ -n "$required_version" ]; then
          check_version "$package" "$current_version" "$required_version"
          return $?
        else
          return 0 # Conda exists and no version check needed
        fi
      else
        return 1 # Conda not installed
      fi
      ;;
    *)
      if command_exists "$package"; then
        return 0 # Generic check if command exists
      else
        return 1
      fi
      ;;
  esac
}

# ----------------------------------
# Start of the script
# ----------------------------------
clear
echo "${BLUE}Welcome! Let's start setting up your system."
echo "It could take more than 10 minutes, be patient, please 💙 ${NOCOLOR}"
echo ""
echo "${YELLOW}This script will install and configure a complete development environment."
echo "A log file will be created at: $LOG_FILE${NOCOLOR}"
echo ""

# Initial update
show_progress "Updating package lists"
sudo apt-get update 2>&1 | tee -a "$LOG_FILE"
handle_error $? "Failed to update package lists"

# ----------------------------------
# System prerequisites check
# ----------------------------------
show_progress "Checking system prerequisites"
echo "Running system checks to ensure we have all necessary tools..."

# Check if curl is installed, install if missing
if ! command_exists curl; then
  echo "${YELLOW}Curl not found. Installing curl...${NOCOLOR}"
  sudo apt install curl -y
  handle_error $? "Failed to install curl"
else
  echo "${GREEN}✓ Curl is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Python Installation
# ----------------------------------
show_progress "Installing Python and pip"
if ! check_installation python3; then
  echo "${BLUE}Installing Python and development tools...${NOCOLOR}"
  sudo apt-get install python3 python3-dev python3-pip -y
  handle_error $? "Failed to install Python" true
else
  echo "${GREEN}✓ Python is already installed: $(python3 --version)${NOCOLOR}"
fi

# Ensure pip is up to date
echo "${BLUE}Upgrading pip...${NOCOLOR}"
python3 -m pip install --upgrade pip
handle_error $? "Failed to upgrade pip" true

# ----------------------------------
# Anaconda Installation
# ----------------------------------
show_progress "Installing Anaconda"
if ! check_installation conda; then
  echo "${BLUE}Downloading Anaconda installer...${NOCOLOR}"
  ANACONDA_VERSION="2023.09-0"
  wget -O anaconda.sh "https://repo.anaconda.com/archive/Anaconda3-${ANACONDA_VERSION}-Linux-x86_64.sh"
  handle_error $? "Failed to download Anaconda" true
  
  echo "${BLUE}Installing Anaconda...${NOCOLOR}"
  bash anaconda.sh -b -p $HOME/anaconda3
  handle_error $? "Failed to install Anaconda" true
  
  # Add Anaconda to PATH
  echo 'export PATH="$HOME/anaconda3/bin:$PATH"' >> ~/.zshrc
  
  # Initialize conda for zsh
  echo "${BLUE}Initializing conda for zsh...${NOCOLOR}"
  eval "$($HOME/anaconda3/bin/conda shell.zsh hook)"
  $HOME/anaconda3/bin/conda init zsh
  handle_error $? "Failed to initialize conda" true
  
  # Clean up
  rm anaconda.sh
else
  echo "${GREEN}✓ Anaconda is already installed: $(conda --version)${NOCOLOR}"
fi

# ----------------------------------
# Terminal Tools Section
# ----------------------------------

# ----------------------------------
# Warp installation (Modern Terminal)
# ----------------------------------
show_progress "Installing Warp terminal"
if ! check_installation warp; then
  echo "${BLUE}Installing Warp terminal...${NOCOLOR}"
  curl -sSL https://releases.warp.dev/stable/install.sh | bash
  handle_error $? "Failed to install Warp terminal"
else
  echo "${GREEN}✓ Warp terminal is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Git installation
# ----------------------------------
show_progress "Installing Git"
if ! check_installation git; then
  sudo apt install git -y
  handle_error $? "Failed to install Git"
else
  echo "${GREEN}✓ Git is already installed.${NOCOLOR}"
fi

echo "${ORANGE}What name do you want to use in GIT user.name?"
echo "For example, mine will be '${ORANGE}Léu Almeida'${NOCOLOR}"
read git_config_user_name
git config --global user.name "$git_config_user_name"
clear

echo "${ORANGE}What email do you want to use in GIT user.email?"
echo "For example, mine will be '${ORANGE}leo@webid.net.br'${NOCOLOR}"
read git_config_user_email
git config --global user.email $git_config_user_email
clear

echo "${LIGHTGREN}Generating a SSH Key${NOCOLOR}"
ssh-keygen -t rsa -b 4096 -C $git_config_user_email
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub | xclip -selection clipboard

echo "${LIGHTGREEN}Enabling workspaces for both screens${NOCOLOR}"
gsettings set org.gnome.mutter workspaces-only-on-primary false

# ----------------------------------
# ZSH installation
# ----------------------------------
show_progress "Installing ZSH and Oh-My-ZSH"
if ! check_installation zsh; then
  sudo apt-get install zsh -y
  handle_error $? "Failed to install ZSH"
  
  echo "${BLUE}Installing Oh-My-ZSH...${NOCOLOR}"
  sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" "" --unattended
  handle_error $? "Failed to install Oh-My-ZSH"
  
  chsh -s /bin/zsh
else
  echo "${GREEN}✓ ZSH is already installed.${NOCOLOR}"
  
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "${BLUE}Installing Oh-My-ZSH...${NOCOLOR}"
    sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" "" --unattended
    handle_error $? "Failed to install Oh-My-ZSH"
  else
    echo "${GREEN}✓ Oh-My-ZSH is already installed.${NOCOLOR}"
  fi
fi

show_progress "Installing tool to handle clipboard via CLI"
if ! command_exists xclip; then
  sudo apt-get install xclip -y
  handle_error $? "Failed to install xclip"
  
  # Add clipboard aliases to zshrc if they don't exist
  if ! grep -q "alias pbcopy=" ~/.zshrc; then
    echo "alias pbcopy='xclip -selection clipboard'" >> ~/.zshrc
    echo "alias pbpaste='xclip -selection clipboard -o'" >> ~/.zshrc
  fi
else
  echo "${GREEN}✓ xclip is already installed.${NOCOLOR}"
fi

# Source zshrc only if it exists and we're in an interactive shell
if [ -f ~/.zshrc ] && [ -t 0 ]; then
  source ~/.zshrc 2>/dev/null || true
fi

# ----------------------------------
# Development Tools Section
# ----------------------------------

# ----------------------------------
# VsCode installation
# ----------------------------------
show_progress "Installing Visual Studio Code"
if ! command_exists code; then
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
  sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
  sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
  sudo apt-get update
  sudo apt-get install code -y
  handle_error $? "Failed to install Visual Studio Code"
else
  echo "${GREEN}✓ Visual Studio Code is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Spotify installation
# ----------------------------------
show_progress "Installing Spotify 🎵"
if ! check_installation spotify; then
  echo "${BLUE}Installing Spotify...${NOCOLOR}"
  sudo snap install spotify
  handle_error $? "Failed to install Spotify"
else
  echo "${GREEN}✓ Spotify is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Google Chrome installation
# ----------------------------------
show_progress "Installing Google Chrome 🖥"
if ! check_installation google-chrome-stable; then
  echo "${BLUE}Downloading Google Chrome...${NOCOLOR}"
  wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  handle_error $? "Failed to download Google Chrome"
  
  echo "${BLUE}Installing Google Chrome...${NOCOLOR}"
  sudo dpkg -i google-chrome-stable_current_amd64.deb
  handle_error $? "Failed to install Google Chrome" true
  
  # Fix any dependency issues
  sudo apt-get install -f -y
  handle_error $? "Failed to fix Google Chrome dependencies"
  
  # Clean up downloaded file
  rm -f google-chrome-stable_current_amd64.deb
else
  echo "${GREEN}✓ Google Chrome is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Programming Languages & Runtimes Section
# ----------------------------------

# ----------------------------------
# NVM installation
# ----------------------------------
show_progress "Installing NVM (Node Version Manager)"
if [ ! -d "$HOME/.nvm" ]; then
  echo "${BLUE}Getting latest NVM version...${NOCOLOR}"
  LATEST_NVM=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep tag_name | cut -d '"' -f 4)
  echo "${BLUE}Installing NVM version $LATEST_NVM...${NOCOLOR}"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$LATEST_NVM/install.sh | bash
  handle_error $? "Failed to install NVM"
  
  # Set up NVM environment for immediate use
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
else
  echo "${GREEN}✓ NVM is already installed.${NOCOLOR}"
  # Load NVM for immediate use
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

echo '\nexport ANDROID_HOME=~/Android/Sdk\n'
echo '\nexport PATH=$PATH:$ANDROID_HOME/tools\n'
echo '\nexport PATH=$PATH:$ANDROID_HOME/platform-tools\n'

echo '\nexport PATH=/usr/local/share/npm/bin:$PATH\n'

echo '\nexport NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"\n' >> .zshrc

source ~/.zshrc

# ----------------------------------
# Node.js installation
# ----------------------------------
show_progress "Installing Node.js LTS"
# Only run if nvm is available
if command_exists nvm; then
  NODE_LTS_VERSION="20"
  if ! nvm ls $NODE_LTS_VERSION >/dev/null 2>&1; then
    echo "${BLUE}Installing Node.js LTS (v$NODE_LTS_VERSION)...${NOCOLOR}"
    nvm install $NODE_LTS_VERSION
    handle_error $? "Failed to install Node.js LTS"
    nvm alias default $NODE_LTS_VERSION
    echo "${GREEN}Node.js $(node --version) and npm $(npm --version) installed.${NOCOLOR}"
  else
    echo "${GREEN}✓ Node.js LTS is already installed.${NOCOLOR}"
    nvm use $NODE_LTS_VERSION
    echo "${GREEN}Using Node.js $(node --version) and npm $(npm --version).${NOCOLOR}"
  fi
else
  echo "${RED}NVM is not available. Cannot install Node.js.${NOCOLOR}"
  handle_error 1 "NVM is not available" true
fi

# ----------------------------------
# Typescript installation
# ----------------------------------
show_progress "Installing TypeScript"
if command_exists npm; then
  if ! command_exists tsc; then
    echo "${BLUE}Installing TypeScript...${NOCOLOR}"
    npm install -g typescript
    handle_error $? "Failed to install TypeScript"
  else
    echo "${GREEN}✓ TypeScript is already installed: $(tsc --version)${NOCOLOR}"
  fi
else
  echo "${RED}npm is not available. Cannot install TypeScript.${NOCOLOR}"
  handle_error 1 "npm is not available" true
fi

# ----------------------------------
# ReactJS CRA installation
# ----------------------------------
show_progress "Installing Create React App ⚡"
if ! check_installation create-react-app; then
  echo "${BLUE}Installing Create React App...${NOCOLOR}"
  npm install -g create-react-app
  handle_error $? "Failed to install Create React App"
else
  echo "${GREEN}✓ Create React App is already installed.${NOCOLOR}"
fi

# ----------------------------------
# GatsbyJS installation
# ----------------------------------
show_progress "Installing GatsbyJS ⚡"
if ! check_installation gatsby; then
  echo "${BLUE}Installing GatsbyJS...${NOCOLOR}"
  npm install -g gatsby-cli
  handle_error $? "Failed to install GatsbyJS"
else
  echo "${GREEN}✓ GatsbyJS is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Yarn installation
# ----------------------------------
show_progress "Installing Yarn ⚡"
if ! check_installation yarn; then
  echo "${BLUE}Adding Yarn repository...${NOCOLOR}"
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  handle_error $? "Failed to add Yarn GPG key"
  
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt-get update
  
  echo "${BLUE}Installing Yarn...${NOCOLOR}"
  sudo apt install yarn -y
  handle_error $? "Failed to install Yarn"
else
  echo "${GREEN}✓ Yarn is already installed: $(yarn --version)${NOCOLOR}"
fi

# ----------------------------------
# React Native installation
# ----------------------------------
show_progress "Installing React Native CLI 📲"
if ! check_installation react-native; then
  echo "${BLUE}Installing React Native CLI...${NOCOLOR}"
  sudo npm install -g react-native-cli
  handle_error $? "Failed to install React Native CLI"
else
  echo "${GREEN}✓ React Native CLI is already installed.${NOCOLOR}"
fi

show_progress "Installing JDK (Java Development Kit)"
if ! command -v javac > /dev/null 2>&1; then
  echo "${BLUE}Adding OpenJDK repository...${NOCOLOR}"
  sudo add-apt-repository ppa:openjdk-r/ppa -y
  handle_error $? "Failed to add OpenJDK repository"
  
  sudo apt-get update
  
  echo "${BLUE}Installing OpenJDK 8...${NOCOLOR}"
  sudo apt-get install openjdk-8-jdk -y
  handle_error $? "Failed to install OpenJDK"
  
  sudo update-alternatives --config java
else
  echo "${GREEN}✓ Java Development Kit is already installed.${NOCOLOR}"
  java -version
fi

echo ""

echo "${LIGHTRED}Now you will need to install Android Studio manually on https://developer.android.com/studio${NOCOLOR}"

echo "${LIGHTGREEN}Setting graphic libs${NOCOLOR}"
sudo apt-get install gcc-multilib lib32z1 lib32stdc++6

# ----------------------------------
# Franz installation
# ----------------------------------
show_progress "Installing Franz 💬"
if ! check_installation franz; then
  echo "${BLUE}Downloading Franz...${NOCOLOR}"
  wget -q https://github.com/meetfranz/franz/releases/download/v5.1.0/franz_5.1.0_amd64.deb -O franz.deb
  handle_error $? "Failed to download Franz"
  
  echo "${BLUE}Installing Franz...${NOCOLOR}"
  sudo dpkg -i franz.deb
  handle_error $? "Failed to install Franz package" true
  
  # Fix any dependency issues
  sudo apt-get install -y -f
  handle_error $? "Failed to resolve Franz dependencies"
  
  # Clean up downloaded file
  rm -f franz.deb
else
  echo "${GREEN}✓ Franz is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Hyper installation
# ----------------------------------
show_progress "Installing Hyper terminal"
if ! command_exists hyper; then
  if ! command_exists gdebi; then
    echo "${BLUE}Installing gdebi...${NOCOLOR}"
    sudo apt-get install gdebi -y
    handle_error $? "Failed to install gdebi"
  fi
  
  echo "${BLUE}Downloading Hyper...${NOCOLOR}"
  wget -q https://releases.hyper.is/download/deb -O hyper.deb
  handle_error $? "Failed to download Hyper"
  
  echo "${BLUE}Installing Hyper...${NOCOLOR}"
  sudo gdebi -n hyper.deb
  handle_error $? "Failed to install Hyper" true
  
  # Fix any dependency issues
  sudo apt-get install -f -y
  handle_error $? "Failed to fix Hyper dependencies"
  
  # Clean up downloaded file
  rm -f hyper.deb
else
  echo "${GREEN}✓ Hyper terminal is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Docker installation
# ----------------------------------
show_progress "Installing Docker 🐳"
if ! check_installation docker; then
  echo "${BLUE}Removing old Docker versions if present...${NOCOLOR}"
  sudo apt-get remove docker docker-engine docker.io containerd runc -y || true
  
  echo "${BLUE}Installing Docker...${NOCOLOR}"
  sudo apt install docker.io -y
  handle_error $? "Failed to install Docker"
  
  echo "${BLUE}Starting and enabling Docker service...${NOCOLOR}"
  sudo systemctl start docker
  sudo systemctl enable docker
  handle_error $? "Failed to start Docker service"
  
  echo "${BLUE}Setting Docker permissions...${NOCOLOR}"
  sudo chmod 777 /var/run/docker.sock
  handle_error $? "Failed to set Docker socket permissions"
  
  echo "${BLUE}Testing Docker installation...${NOCOLOR}"
  docker run hello-world
  handle_error $? "Docker test failed" true
  
  echo "${GREEN}Docker $(docker --version | cut -d ' ' -f 3 | cut -d ',' -f 1) installed successfully.${NOCOLOR}"
else
  echo "${GREEN}✓ Docker is already installed: $(docker --version | cut -d ' ' -f 3 | cut -d ',' -f 1)${NOCOLOR}"
fi

# ----------------------------------
# Docker Compose installation
# ----------------------------------
show_progress "Installing Docker Compose 🍱"
if ! check_installation docker-compose; then
  echo "${BLUE}Downloading latest Docker Compose...${NOCOLOR}"
  LATEST_COMPOSE=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
  echo "${BLUE}Latest Docker Compose version: $LATEST_COMPOSE${NOCOLOR}"
  
  sudo curl -L "https://github.com/docker/compose/releases/download/$LATEST_COMPOSE/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  handle_error $? "Failed to download Docker Compose"
  
  sudo chmod +x /usr/local/bin/docker-compose
  handle_error $? "Failed to make Docker Compose executable"
  
  echo "${GREEN}Docker Compose $(docker-compose --version | cut -d ' ' -f 3 | tr -d ',') installed successfully.${NOCOLOR}"
else
  echo "${GREEN}✓ Docker Compose is already installed: $(docker-compose --version | cut -d ' ' -f 3 | tr -d ',')${NOCOLOR}"
fi

# ----------------------------------
# Kubectl installation
# ----------------------------------
show_progress "Installing kubectl ⏹"
if ! check_installation kubectl; then
  echo "${BLUE}Downloading kubectl...${NOCOLOR}"
  STABLE_KUBECTL=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
  echo "${BLUE}Latest kubectl version: $STABLE_KUBECTL${NOCOLOR}"
  
  curl -LO "https://storage.googleapis.com/kubernetes-release/release/$STABLE_KUBECTL/bin/linux/amd64/kubectl"
  handle_error $? "Failed to download kubectl"
  
  echo "${BLUE}Installing kubectl...${NOCOLOR}"
  chmod +x kubectl
  sudo mv kubectl /usr/local/bin/
  handle_error $? "Failed to install kubectl"
  
  echo "${GREEN}kubectl $(kubectl version --client --short 2>/dev/null | cut -d ' ' -f 3 || echo 'unknown') installed successfully.${NOCOLOR}"
else
  echo "${GREEN}✓ kubectl is already installed: $(kubectl version --client --short 2>/dev/null | cut -d ' ' -f 3 || echo 'unknown')${NOCOLOR}"
fi

# ----------------------------------
# Heroku CLI installation
# ----------------------------------
show_progress "Installing Heroku CLI 💜"
if ! check_installation heroku; then
  echo "${BLUE}Installing Heroku CLI...${NOCOLOR}"
  curl https://cli-assets.heroku.com/install-ubuntu.sh | sh
  handle_error $? "Failed to install Heroku CLI"
  
  echo "${GREEN}Heroku CLI $(heroku --version 2>/dev/null | head -n 1 | cut -d '/' -f 2 | cut -d ' ' -f 1 || echo 'unknown') installed successfully.${NOCOLOR}"
else
  echo "${GREEN}✓ Heroku CLI is already installed: $(heroku --version 2>/dev/null | head -n 1 | cut -d '/' -f 2 | cut -d ' ' -f 1 || echo 'unknown')${NOCOLOR}"
fi

# ----------------------------------
# AWS CLI installation
# ----------------------------------
show_progress "Installing AWS CLI 💛"
if ! check_installation aws; then
  echo "${BLUE}Installing AWS CLI...${NOCOLOR}"
  sudo apt-get install awscli -y
  handle_error $? "Failed to install AWS CLI"
  
  echo "${BLUE}Installing AWS Session Manager Plugin...${NOCOLOR}"
  curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
  handle_error $? "Failed to download AWS Session Manager Plugin"
  
  sudo dpkg -i session-manager-plugin.deb
  handle_error $? "Failed to install AWS Session Manager Plugin" true
  
  sudo apt-get install -f -y
  
  echo "${GREEN}AWS CLI $(aws --version 2>&1 | cut -d ' ' -f 1 | cut -d '/' -f 2 || echo 'unknown') and Session Manager Plugin $(session-manager-plugin --version 2>/dev/null || echo 'unknown') installed successfully.${NOCOLOR}"
  
  #

# ----------------------------------
# Fzf installation
# ----------------------------------
show_progress "Installing fzf 🔎"
if [ ! -d "$HOME/.fzf" ]; then
  echo "${BLUE}Installing fzf...${NOCOLOR}"
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  handle_error $? "Failed to clone fzf repository"
  
  ~/.fzf/install --all
  handle_error $? "Failed to install fzf"
  
  # Source zshrc only if it exists and we're in an interactive shell
  if [ -f ~/.zshrc ] && [ -t 0 ]; then
    source ~/.zshrc 2>/dev/null || true
  fi
else
  echo "${GREEN}✓ fzf is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Dbeaver installation
# ----------------------------------
show_progress "Installing DBeaver ⌛"
if ! check_installation dbeaver; then
  echo "${BLUE}Installing DBeaver...${NOCOLOR}"
  wget -c https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
  handle_error $? "Failed to download DBeaver"
  
  sudo dpkg -i dbeaver-ce_latest_amd64.deb
  handle_error $? "Failed to install DBeaver package" true
  
  sudo apt-get install -f -y
  handle_error $? "Failed to fix DBeaver dependencies"
  
  rm -f dbeaver-ce_latest_amd64.deb
else
  echo "${GREEN}✓ DBeaver is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Robo3t installation
# ----------------------------------
show_progress "Installing Robo3t 💚"
if ! command_exists robo3t-snap; then
  echo "${BLUE}Installing Robo3t...${NOCOLOR}"
  sudo snap install robo3t-snap
  handle_error $? "Failed to install Robo3t"
else
  echo "${GREEN}✓ Robo3t is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Insomnia installation
# ----------------------------------
show_progress "Installing Insomnia 🎱"
if ! check_installation insomnia; then
  echo "${BLUE}Adding Insomnia repository...${NOCOLOR}"
  echo "deb https://dl.bintray.com/getinsomnia/Insomnia /" | sudo tee -a /etc/apt/sources.list.d/insomnia.list
  handle_error $? "Failed to add Insomnia repository"
  
  wget --quiet -O - https://insomnia.rest/keys/debian-public.key.asc | sudo apt-key add -
  handle_error $? "Failed to add Insomnia GPG key"
  
  sudo apt-get update
  sudo apt-get install insomnia -y
  handle_error $? "Failed to install Insomnia"
else
  echo "${GREEN}✓ Insomnia is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Postbird installation
# ----------------------------------
show_progress "Installing Postbird 🐘"
if ! check_installation postbird; then
  echo "${BLUE}Installing Postbird...${NOCOLOR}"
  yes | sudo snap install postbird
  handle_error $? "Failed to install Postbird"
else
  echo "${GREEN}✓ Postbird is already installed.${NOCOLOR}"
fi

# ----------------------------------
# VLC installation
# ----------------------------------
show_progress "Installing VLC ⏯"
if ! command_exists vlc; then
  echo "${BLUE}Installing VLC...${NOCOLOR}"
  sudo apt install vlc -y
  handle_error $? "Failed to install VLC"
  
  echo "${BLUE}Installing VLC plugins...${NOCOLOR}"
  sudo apt install vlc-plugin-access-extra libbluray-bdj libdvdcss2 -y
  handle_error $? "Failed to install VLC plugins" true
else
  echo "${GREEN}✓ VLC is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Transmission installation
# ----------------------------------
show_progress "Installing Transmission 📩"
if ! command_exists transmission-qt; then
  echo "${BLUE}Adding Transmission repository...${NOCOLOR}"
  sudo add-apt-repository ppa:transmissionbt/ppa -y
  handle_error $? "Failed to add Transmission repository"
  
  sudo apt-get update
  
  echo "${BLUE}Installing Transmission...${NOCOLOR}"
  sudo apt-get install transmission transmission-qt -y
  handle_error $? "Failed to install Transmission"
else
  echo "${GREEN}✓ Transmission is already installed.${NOCOLOR}"
fi

# ----------------------------------
# GIMP installation
# ----------------------------------
show_progress "Installing GIMP 🖼"
if ! command_exists gimp; then
  echo "${BLUE}Adding GIMP repository...${NOCOLOR}"
  yes | sudo add-apt-repository ppa:otto-kesselgulasch/gimp
  handle_error $? "Failed to add GIMP repository"
  
  sudo apt-get update
  
  echo "${BLUE}Installing GIMP and core plugins...${NOCOLOR}"
  sudo apt-get install gimp gimp-gmic gmic -y
  handle_error $? "Failed to install GIMP"
  
  echo "${BLUE}Installing GIMP plugin registry...${NOCOLOR}"
  sudo apt-get install gimp-plugin-registry -y
  handle_error $? "Failed to install GIMP plugin registry" true
else
  echo "${GREEN}✓ GIMP is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Reactotron installation
# ----------------------------------
show_progress "Installing Reactotron ⚛"
if ! command_exists reactotron; then
  echo "${BLUE}Downloading Reactotron...${NOCOLOR}"
  # Get latest version from GitHub API
  LATEST_REACTOTRON_VERSION="v2.17.1"  # Default, but try to get latest
  LATEST_VERSION=$(curl -s https://api.github.com/repos/infinitered/reactotron/releases/latest | grep tag_name | cut -d '"' -f 4 || echo $LATEST_REACTOTRON_VERSION)
  if [ -n "$LATEST_VERSION" ]; then
    LATEST_REACTOTRON_VERSION=$LATEST_VERSION
  fi
  
  echo "${BLUE}Installing Reactotron version $LATEST_REACTOTRON_VERSION...${NOCOLOR}"
  wget -c "https://github.com/infinitered/reactotron/releases/download/$LATEST_REACTOTRON_VERSION/reactotron-app_${LATEST_REACTOTRON_VERSION#v}_amd64.deb" -O reactotron.deb
  handle_error $? "Failed to download Reactotron"
  
  sudo dpkg -i reactotron.deb
  handle_error $? "Failed to install Reactotron" true
  
  # Fix any dependency issues
  sudo apt-get install -f -y
  handle_error $? "Failed to fix Reactotron dependencies"
  
  # Clean up
  rm -f reactotron.deb
else
  echo "${GREEN}✓ Reactotron is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Discord installation
# ----------------------------------
show_progress "Installing Discord 💬"
if ! command_exists discord; then
  echo "${BLUE}Installing Discord...${NOCOLOR}"
  sudo snap install discord --classic
  handle_error $? "Failed to install Discord"
else
  echo "${GREEN}✓ Discord is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Terminalizer installation
# ----------------------------------
show_progress "Installing Terminalizer 💅"
if ! command_exists terminalizer; then
  echo "${BLUE}Installing Terminalizer...${NOCOLOR}"
  npm install -g terminalizer
  handle_error $? "Failed to install Terminalizer"
else
  echo "${GREEN}✓ Terminalizer is already installed.${NOCOLOR}"
fi

cat <<EOF > ~/.terminalizer
command: null
cwd: null
env:
  recording: true
cols: auto
rows: auto
# Amount of times to repeat GIF
# If value is -1, play once
# If value is 0, loop indefinitely
# If value is a positive number, loop n times
repeat: 0
quality: 100
frameDelay: auto
maxIdleTime: 2000
frameBox:
  type: floating
  title: null
  style:
    border: 0px black solid
watermark:
  imagePath: null
  style:
    position: absolute
    right: 15px
    bottom: 15px
    width: 100px
    opacity: 0.9
cursorStyle: block
fontFamily: "Fira Code, Lucida Console, Ubuntu Mono, Monospace"
fontSize: 14
lineHeight: 1
letterSpacing: 0
theme:
  background: "transparent"
  foreground: "#afafaf"
  cursor: "#c7c7c7"
  black: "#232628"
  red: "#fc4384"
  green: "#b3e33b"
  yellow: "#ffa727"
  blue: "#75dff2"
  magenta: "#ae89fe"
  cyan: "#708387"
  white: "#d5d5d0"
  brightBlack: "#626566"
  brightRed: "#ff7fac"
  brightGreen: "#c8ed71"
  brightYellow: "#ebdf86"
  brightBlue: "#75dff2"
  brightMagenta: "#ae89fe"
  brightCyan: "#b1c6ca"
  brightWhite: "#f9f9f4"
EOF

clear

# ----------------------------------
# Expo CLI installation
# ----------------------------------
show_progress "Installing Expo CLI 📱"
if ! command_exists expo; then
  echo "${BLUE}Installing Expo CLI...${NOCOLOR}"
  npm install --global expo-cli
  handle_error $? "Failed to install Expo CLI"
else
  echo "${GREEN}✓ Expo CLI is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Vercel CLI installation
# ----------------------------------
show_progress "Installing Vercel CLI ⬆"
if ! command_exists vercel; then
  echo "${BLUE}Installing Vercel CLI...${NOCOLOR}"
  npm install -g vercel
  handle_error $? "Failed to install Vercel CLI"
else
  echo "${GREEN}✓ Vercel CLI is already installed.${NOCOLOR}"
fi

# ----------------------------------
# OpenOffice installation
# ----------------------------------
show_progress "Installing OpenOffice 📝"
if ! command_exists soffice; then
  echo "${BLUE}Downloading OpenOffice...${NOCOLOR}"
  # Check architecture
  if [ $(getconf LONG_BIT) = "64" ]; then
    wget -q http://ufpr.dl.sourceforge.net/project/openofficeorg.mirror/4.1.6/binaries/pt-BR/Apache_OpenOffice_4.1.6_Linux_x86-64_install-rpm_pt-BR.tar.gz -O openoffice.tar.gz
  else
    wget -q http://ufpr.dl.sourceforge.net/project/openofficeorg.mirror/4.1.6/binaries/pt-BR/Apache_OpenOffice_4.1.6_Linux_x86_install-rpm_pt-BR.tar.gz -O openoffice.tar.gz
  fi
  handle_error $? "Failed to download OpenOffice"
  
  echo "${BLUE}Extracting OpenOffice...${NOCOLOR}"
  tar -vzxf openoffice.tar.gz
  handle_error $? "Failed to extract OpenOffice"
  
  echo "${BLUE}Installing OpenOffice packages...${NOCOLOR}"
  sudo rpm -i pt-BR/RPMS/*.rpm
  handle_error $? "Failed to install OpenOffice packages" true
  
  echo "${BLUE}Installing OpenOffice desktop integration...${NOCOLOR}"
  sudo rpm -i pt-BR/RPMS/desktop-integration/*.rpm
  handle_error $? "Failed to install OpenOffice desktop integration" true
  
  # Cleanup
  rm -rf openoffice.tar.gz pt-BR
else
  echo "${GREEN}✓ OpenOffice is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Optional VSCode settings
# ----------------------------------

echo -n "${YELLOW}Do you want to install the style settings, as VSCode extensions, ZSH plugins and Fira Code font? (y/n)?${NOCOLOR}"
read answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo "${LIGHTGREEN}Adding VSCode settings${NOCOLOR}"
cat <<EOF >  ~/.config/Code/User/settings.json
{
  "terminal.integrated.fontSize": 14,
  "terminal.integrated.fontFamily": "Fira Code, monospace",
  "workbench.iconTheme": "material-icon-theme",
  "workbench.startupEditor": "newUntitledFile",
  "editor.fontSize": 14,
  "editor.fontFamily": "Fira Code, 'JetBrains Mono', Menlo, Monaco, 'Courier New', monospace",
  "editor.fontLigatures": true,
  "editor.bracketPairColorization.enabled": true,
  "editor.guides.bracketPairs": "active",
  "editor.formatOnSave": true,
  "editor.formatOnPaste": true,
  "editor.linkedEditing": true,
  "editor.stickyScroll.enabled": true,
  "editor.inlineSuggest.enabled": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true,
    "source.organizeImports": true
  },
  "explorer.compactFolders": false,
  "editor.renderLineHighlight": "gutter",
  "workbench.editor.labelFormat": "short",
  "workbench.editor.limit.enabled": true,
  "workbench.editor.limit.value": 5,
  "extensions.ignoreRecommendations": true,
  "javascript.updateImportsOnFileMove.enabled": "always",
  "typescript.updateImportsOnFileMove.enabled": "always",
  "typescript.tsdk": "node_modules/typescript/lib",
  "typescript.enablePromptUseWorkspaceTsdk": true,
  "typescript.preferences.importModuleSpecifier": "shortest",
  "typescript.inlayHints.parameterNames.enabled": "all",
  "javascript.inlayHints.parameterNames.enabled": "all",
  "typescript.suggest.completeFunctionCalls": true,
  "typescript.suggest.includeAutomaticOptionalChainCompletions": true,
  "breadcrumbs.enabled": true,
  "editor.parameterHints.enabled": true,
  "explorer.confirmDragAndDrop": false,
  "explorer.confirmDelete": false,
  "editor.rulers": [
    80,
    120
  ],
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[javascriptreact]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[typescriptreact]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[html]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[css]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[scss]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[markdown]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[shellscript]": {
    "editor.defaultFormatter": "foxundermoon.shell-format"
  },
  "files.associations": {
    ".sequelizerc": "javascript",
    ".stylelintrc": "json",
    ".prettierrc": "json",
    "*.tsx": "typescriptreact",
    "*.mdx": "markdown",
    "dockerfile.*": "dockerfile"
  },
  "files.exclude": {
    "**/.git": true,
    "**/.svn": true,
    "**/.hg": true,
    "**/CVS": true,
    "**/.DS_Store": true,
    "**/node_modules": false
  },
  "window.zoomLevel": 0,
  "emmet.syntaxProfiles": {
    "javascript": "jsx"
  },
  "emmet.includeLanguages": {
    "javascript": "javascriptreact",
    "typescript": "typescriptreact",
    "markdown": "html"
  },
  "gitlens.codeLens.recentChange.enabled": false,
  "gitlens.codeLens.authors.enabled": false,
  "gitlens.codeLens.enabled": false,
  "git.enableSmartCommit": true,
  "git.confirmSync": false,
  "terminal.integrated.defaultProfile.linux": "zsh",
  "liveshare.featureSet": "insiders",
  "javascript.suggest.autoImports": true,
  "typescript.suggest.autoImports": true,
  "liveServer.settings.donotShowInfoMsg": true,
  "material-icon-theme.activeIconPack": "nest",
  "screencastMode.onlyKeyboardShortcuts": true,
  "material-icon-theme.folders.associations": {
    "infra": "app",
    "entities": "class",
    "schemas": "class",
    "typeorm": "database",
    "repositories": "mappings",
    "http": "container",
    "migrations": "tools",
    "modules": "components",
    "implementations": "core",
    "dtos": "typescript",
    "fakes": "mock",
    "websockets": "pipe",
    "protos": "pipe",
    "grpc": "pipe",
    "hooks": "hook",
    "providers": "context",
    "contexts": "context",
    "utils": "utils",
    "helpers": "helper",
    "services": "app",
    "prisma": "database",
    "store": "redux-store",
    "constants": "constant"
  },
  "material-icon-theme.files.associations": {
    "ormconfig.json": "database",
    "tsconfig.json": "tune",
    "*.proto": "3d",
    "routes.ts": "routing",
    "*.styles.ts": "styled",
    "*.styles.js": "styled",
    "*.test.ts": "test-ts",
    "*.test.tsx": "test-tsx",
    "*.test.js": "test-js",
    "*.test.jsx": "test-jsx",
    "*.slice.ts": "redux-reducer"
  },
  "workbench.colorTheme": "Omni",
  "workbench.preferredDarkColorTheme": "Omni",
  "github.copilot.enable": {
    "*": true,
    "plaintext": true,
    "markdown": true,
    "yaml": true
  },
  "editor.accessibilitySupport": "off",
  "editor.suggestSelection": "first",
  "editor.tabSize": 2,
  "debug.javascript.autoAttachFilter": "smart",
  "editor.wordWrap": "on",
  "security.workspace.trust.untrustedFiles": "open",
  "telemetry.telemetryLevel": "off",
  "editor.stickyTabStops": true,
  "editor.cursorSmoothCaretAnimation": "on",
  "editor.smoothScrolling": true,
  "editor.minimap.renderCharacters": false,
  "editor.minimap.size": "fit",
  "diffEditor.ignoreTrimWhitespace": false,
  "diffEditor.renderSideBySide": true,
  "typescript.preferences.preferTypeOnlyAutoImports": true,
  "javascript.preferences.preferTypeOnlyAutoImports": true,
  "github.copilot.advanced": {
    "enableAutoCompletions": true,
    "indentationMode": true
  },
  "workbench.tree.indent": 12,
  "workbench.tree.renderIndentGuides": "always",
  "terminal.integrated.shellIntegration.enabled": true,
  "terminal.integrated.gpuAcceleration": "on",
  "remote.SSH.enableDynamicForwarding": true,
  "remote.SSH.useLocalServer": true
}
EOF
    
    # Essential extensions for modern development
    echo "${BLUE}Installing VSCode Extensions...${NOCOLOR}"
    
    # Themes and Icons
    code --install-extension rocketseat.theme-omni
    code --install-extension PKief.material-icon-theme
    
    # Language Support
    code --install-extension dbaeumer.vscode-eslint
    code --install-extension esbenp.prettier-vscode
    code --install-extension streetsidesoftware.code-spell-checker
    code --install-extension silvenon.mdx
    code --install-extension yzhang.markdown-all-in-one
    code --install-extension foxundermoon.shell-format
    
    # React Development
    code --install-extension rocketseat.rocketseatreactjs
    code --install-extension rocketseat.rocketseatreactnative
    code --install-extension dsznajder.es7-react-js-snippets
    code --install-extension styled-components.vscode-styled-components
    code --install-extension wix.vscode-import-cost
    
    # TypeScript Support
    code --install-extension ms-vscode.vscode-typescript-next
    
    # Tools & Utilities
    code --install-extension usernamehw.errorlens
    code --install-extension eamodio.gitlens
    code --install-extension ms-azuretools.vscode-docker
    code --install-extension ms-vsliveshare.vsliveshare
    code --install-extension rangav.vscode-thunder-client
    code --install-extension wayou.vscode-todo-highlight
    code --install-extension SonarSource.sonarlint-vscode
    code --install-extension VisualStudioExptTeam.vscodeintellicode
    
    # AI Assistance
    code --install-extension GitHub.copilot
    code --install-extension GitHub.copilot-chat
    
    # Remote Development
    code --install-extension ms-vscode-remote.remote-ssh
    code --install-extension ms-vscode-remote.remote-containers
    code --install-extension ms-vscode-remote.vscode-remote-extensionpack
    
    # Additional Development Tools
    code --install-extension formulahendry.auto-close-tag
    code --install-extension formulahendry.auto-rename-tag
    code --install-extension christian-kohler.path-intellisense
    code --install-extension naumovs.color-highlight
    code --install-extension EditorConfig.EditorConfig
    
    # Testing
    code --install-extension orta.vscode-jest
    code --install-extension andys8.jest-snippets
    
    # Git
    code --install-extension mhutchie.git-graph
    code --install-extension codezombiech.gitignore
    
    # Code Quality
    code --install-extension stylelint.vscode-stylelint
    
    echo "${LIGHTGREEN}Installing Omni theme${NOCOLOR}"
    git clone https://github.com/getomni/hyper-omni ~/.hyper_plugins/local/hyper-omni
    
    echo "${LIGHTGREEN}Installing Font Ligatures${NOCOLOR}"
    hyper i hyper-font-ligatures
    
    echo "${LIGHTGREEN}Implementing Hyper settings${NOCOLOR}"
cat <<EOF > ~/.hyper.js
module.exports = {
  config: {
    updateChannel: 'stable',
    fontSize: 14,
    fontFamily: 'Fira Code, JetBrains Mono, "DejaVu Sans Mono", Consolas, "Lucida Console", monospace',
    fontWeight: 'normal',
    fontWeightBold: 'bold',
    lineHeight: 1.2,
    letterSpacing: 0,
    cursorColor: 'rgba(248,28,229,0.8)',
    cursorAccentColor: '#000',
    cursorShape: 'BLOCK',
    cursorBlink: false,
    foregroundColor: '#fff',
    backgroundColor: '#000',
    selectionColor: 'rgba(248,28,229,0.3)',
    borderColor: '#333',
    css: `
      .term_fit:not(.term_term) {
        opacity: 0.95;
      }
    `,
    termCSS: `
      x-screen a {
        color: inherit;
        text-decoration: underline;
      }
      x-screen a:hover {
        text-decoration: none;
      }
    `,
    showHamburgerMenu: true,
    showWindowControls: '',
    padding: '12px 14px',
    windowSize: [1080, 720],
    colors: {
      black: '#000000',
      red: '#C51E14',
      green: '#1DC121',
      yellow: '#C7C329',
      blue: '#0A2FC4',
      magenta: '#C839C5',
      cyan: '#20C5C6',
      white: '#C7C7C7',
      lightBlack: '#686868',
      lightRed: '#FD6F6B',
      lightGreen: '#67F86F',
      lightYellow: '#FFFA72',
      lightBlue: '#6A76FB',
      lightMagenta: '#FD7CFC',
      lightCyan: '#68FDFE',
      lightWhite: '#FFFFFF',
    },
    shell: '',
    shellArgs: ['--login'],
    env: {},
    bell: 'SOUND',
    copyOnSelect: false,
    defaultSSHApp: true,
    quickEdit: false,
    macOptionSelectionMode: 'vertical',
    webGLRenderer: true,
    webLinksActivationKey: '',
    disableLigatures: false,
    copyOnSelect: true,
    defaultSSHApp: true,
    quickEdit: true,
    scrollback: 10000,
  },
  plugins: [
    'hyper-font-ligatures',
    'hyper-search',
    'hyper-pane',
    'hypercwd',
    'hyper-statusline'
  ],
  localPlugins: ['hyper-omni'],
  keymaps: {
    'window:toggleFullScreen': 'cmd+enter',
    'window:zoom': 'cmd+0',
    'window:zoomIn': 'cmd+plus',
    'window:zoomOut': 'cmd+minus',
    'pane:splitVertical': 'cmd+d',
    'pane:splitHorizontal': 'cmd+shift+d',
    'pane:close': 'cmd+w',
    'pane:next': 'cmd+]',
    'pane:prev': 'cmd+[',
    'tab:new': 'cmd+t',
  },
};
EOF
    
    
    # ----------------------------------
    # Autosuggestions installation
    # ----------------------------------
    echo "${LIGHTGREEN}Installing Autosuggestions ⌨${NOCOLOR}"
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
    echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
    source ~/.zshrc
    
    # ----------------------------------
    # ZSH Themes installation
    # ----------------------------------
    echo "${LIGHTGREEN}Installing ZSH theme settings${NOCOLOR}"
    sudo apt install fonts-firacode -y
    git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
    ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
    sed -i 's/.*ZSH_THEME=.*/ZSH_THEME="spaceship"/g' ~/.zshrc
    
    echo "${LIGHTGREEN}Setting Spaceship configs${NOCOLOR}"
cat <<EOF >> ~/.zshrc
SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  hg            # Mercurial section (hg_branch  + hg_status)
  exec_time     # Execution time
  line_sep      # Line break
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "
### Added by Zinit's installer
source "${HOME}/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# Modern plugins with zinit
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light agkozak/zsh-z
zinit light jeffreytse/zsh-vi-mode
EOF
    
    echo "${LIGHTGREEN}Installing Zinit and ZSH Plugins${NOCOLOR}"
    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
cat <<EOF >> ~/.zshrc
# Load Zinit plugins
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light agkozak/zsh-z
zinit light jeffreytse/zsh-vi-mode
zinit light zsh-users/zsh-history-substring-search

# Configure plugins
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#5f5f5f,underline"

# Key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Development aliases
alias dc="docker-compose"
alias d="docker"
alias g="git"
alias gs="git status"
alias gl="git log --oneline"
alias gc="git commit -m"
alias npm="pnpm" # Use pnpm for better performance
EOF
    source ~/.zshrc
    
fi

# ----------------------------------
# Finishing installation
# ----------------------------------
echo "${LIGHTGREEN}Commiting changes 🎈${NOCOLOR}"
source ~/.zshrc
sudo dpkg --configure -a
sudo apt-get update --fix-missing
sudo apt-get autoremove

# Install more modern global packages
echo "${LIGHTGREEN}Installing modern global npm packages${NOCOLOR}"
npm install -g pnpm
npm install -g @antfu/ni
npm install -g turbo
npm install -g typescript@latest
npm install -g ts-node
npm install -g nodemon
npm install -g @nestjs/cli
npm install -g serve
npm install -g n8n

clear

echo "                        .-´´´-.               "
echo "                       / .===. \              "
echo "                       \/ 6 6 \/              "
echo "                       ( \___/ )              "
echo "          _________ooo__\_____/____________  "
echo "         /                                  \ "
echo "        |                                    |"
echo "        | All setup, enjoy! 😉                |"
echo "        | If that helped you, please leave   |"
echo "        | a star on github. 💛                |"
echo "        |                                    |"
echo "         \______________________ooo_________/ "
echo "                       |  |  |                "
echo "                       |_ | _|                "
echo "                       |  |  |                "
echo "                       |__|__|                "
echo "                       /-'Y'-\                "
echo "                      (__/ \__)               "
echo ""
echo "${YELLOW}You're welcome to contribute to the project on https://github.com/LeuAlmeida/workstation${NOCOLOR}"
