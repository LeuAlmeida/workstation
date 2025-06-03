#!/bin/bash

# ==================================
# Debian Workstation Setup Script
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
git config
