#!/bin/bash

# ==================================
# macOS Workstation Setup Script
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
TOTAL_STEPS=32
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

# ----------------------------------
# Homebrew Installation
# ----------------------------------
show_progress "Installing Homebrew"
if ! command_exists brew; then
  echo "${BLUE}Installing Homebrew...${NOCOLOR}"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 2>&1 | tee -a "$LOG_FILE"
  handle_error $? "Failed to install Homebrew"
  
  # Add Homebrew to PATH if needed
  if [[ $(uname -m) == "arm64" ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  echo "${GREEN}✓ Homebrew is already installed.${NOCOLOR}"
  brew update 2>&1 | tee -a "$LOG_FILE"
fi

# ----------------------------------
# Xcode Command Line Tools Installation
# ----------------------------------
show_progress "Installing Xcode Command Line Tools"
if ! xcode-select -p &>/dev/null; then
  echo "${BLUE}Installing Xcode Command Line Tools...${NOCOLOR}"
  xcode-select --install
  echo "${YELLOW}Please wait for Command Line Tools to install and press any key when it's completed...${NOCOLOR}"
  read -n 1 -s
else
  echo "${GREEN}✓ Xcode Command Line Tools are already installed.${NOCOLOR}"
fi

# ----------------------------------
# ZSH installation
# ----------------------------------
show_progress "Installing ZSH and Oh-My-ZSH"
if ! check_installation zsh; then
  echo "${BLUE}Installing ZSH...${NOCOLOR}"
  brew install zsh
  handle_error $? "Failed to install ZSH"
  
  echo "${BLUE}Installing Oh-My-ZSH...${NOCOLOR}"
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
  handle_error $? "Failed to install Oh-My-ZSH"
  
  chsh -s /bin/zsh
else
  echo "${GREEN}✓ ZSH is already installed.${NOCOLOR}"
  
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "${BLUE}Installing Oh-My-ZSH...${NOCOLOR}"
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
    handle_error $? "Failed to install Oh-My-ZSH"
  else
    echo "${GREEN}✓ Oh-My-ZSH is already installed.${NOCOLOR}"
  fi
fi

# ----------------------------------
# VsCode installation
# ----------------------------------
show_progress "Installing Visual Studio Code"
if ! command_exists code; then
  echo "${BLUE}Installing Visual Studio Code...${NOCOLOR}"
  brew update
  brew install --cask visual-studio-code
  handle_error $? "Failed to install Visual Studio Code"
else
  echo "${GREEN}✓ Visual Studio Code is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Spotify installation
# ----------------------------------
show_progress "Installing Spotify 🎵"
if ! command_exists spotify; then
  echo "${BLUE}Installing Spotify...${NOCOLOR}"
  brew install --cask spotify
  handle_error $? "Failed to install Spotify"
else
  echo "${GREEN}✓ Spotify is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Google Chrome installation
# ----------------------------------
show_progress "Installing Google Chrome 🖥"
if ! command_exists google-chrome || ! command_exists "Google Chrome"; then
  echo "${BLUE}Installing Google Chrome...${NOCOLOR}"
  brew install --cask google-chrome
  handle_error $? "Failed to install Google Chrome"
else
  echo "${GREEN}✓ Google Chrome is already installed.${NOCOLOR}"
fi

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

cat <<EOF >> ~/.zshrc
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
EOF

# Source zshrc only if it exists and we're in an interactive shell
if [ -f ~/.zshrc ] && [ -t 0 ]; then
  source ~/.zshrc 2>/dev/null || true
fi
clear

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
  echo "${BLUE}Installing Yarn...${NOCOLOR}"
  npm install --global yarn
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
  npm install -g react-native-cli
  handle_error $? "Failed to install React Native CLI"
else
  echo "${GREEN}✓ React Native CLI is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Hyper installation
# ----------------------------------
show_progress "Installing Hyper"
if ! command_exists hyper; then
  echo "${BLUE}Installing Hyper...${NOCOLOR}"
  brew install --cask hyper
  handle_error $? "Failed to install Hyper"
else
  echo "${GREEN}✓ Hyper is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Docker installation
# ----------------------------------
show_progress "Installing Docker 🐳"
if ! check_installation docker; then
  echo "${BLUE}Installing Docker...${NOCOLOR}"
  brew install --cask docker
  handle_error $? "Failed to install Docker"
  
  echo "${BLUE}Starting Docker...${NOCOLOR}"
  open -a Docker
  
  # Wait for Docker to start
  echo "${BLUE}Waiting for Docker to start...${NOCOLOR}"
  while ! docker system info > /dev/null 2>&1; do
    echo -n "."
    sleep 2
  done
  
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
  echo "${BLUE}Installing kubectl...${NOCOLOR}"
  brew install kubectl
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
  brew tap heroku/brew && brew install heroku
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
  brew install awscli
  handle_error $? "Failed to install AWS CLI"
  
  echo "${GREEN}AWS CLI $(aws --version 2>&1 | cut -d ' ' -f 1 | cut -d '/' -f 2 || echo 'unknown') installed successfully.${NOCOLOR}"
else
  echo "${GREEN}✓ AWS CLI is already installed: $(aws --version 2>&1 | cut -d ' ' -f 1 | cut -d '/' -f 2 || echo 'unknown')${NOCOLOR}"
fi

# ----------------------------------
# AWS Elastic Beanstalk CLI installation
# ----------------------------------
show_progress "Installing AWS Elastic Beanstalk CLI 🎯"
if ! command_exists eb; then
  echo "${BLUE}Installing AWS Elastic Beanstalk CLI...${NOCOLOR}"
  brew install awsebcli
  handle_error $? "Failed to install AWS Elastic Beanstalk CLI"
else
  echo "${GREEN}✓ AWS Elastic Beanstalk CLI is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Dbeaver installation
# ----------------------------------
show_progress "Installing DBeaver ⌛"
if ! command_exists dbeaver; then
  echo "${BLUE}Installing DBeaver...${NOCOLOR}"
  brew install --cask dbeaver-community
  handle_error $? "Failed to install DBeaver"
else
  echo "${GREEN}✓ DBeaver is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Sequel Pro installation
# ----------------------------------
show_progress "Installing Sequel Pro 🍯"
if ! command_exists "Sequel Pro"; then
  echo "${BLUE}Installing Sequel Pro...${NOCOLOR}"
  brew install --cask sequel-pro
  handle_error $? "Failed to install Sequel Pro"
else
  echo "${GREEN}✓ Sequel Pro is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Robo3t installation
# ----------------------------------
show_progress "Installing Robo3t 💚"
if ! command_exists robo3t; then
  echo "${BLUE}Installing Robo3t...${NOCOLOR}"
  brew install --cask robo-3t
  handle_error $? "Failed to install Robo3t"
else
  echo "${GREEN}✓ Robo3t is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Insomnia installation
# ----------------------------------
show_progress "Installing Insomnia 🎱"
if ! command_exists insomnia; then
  echo "${BLUE}Installing Insomnia...${NOCOLOR}"
  brew install --cask insomnia
  handle_error $? "Failed to install Insomnia"
else
  echo "${GREEN}✓ Insomnia is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Postbird installation
# ----------------------------------
show_progress "Installing Postbird 🐘"
if ! command_exists postbird; then
  echo "${BLUE}Installing Postbird...${NOCOLOR}"
  brew install --cask postbird
  handle_error $? "Failed to install Postbird"
else
  echo "${GREEN}✓ Postbird is already installed.${NOCOLOR}"
fi

# ----------------------------------
# GIMP installation
# ----------------------------------
show_progress "Installing GIMP 🖼"
if ! command_exists gimp; then
  echo "${BLUE}Installing GIMP...${NOCOLOR}"
  brew install --cask gimp
  handle_error $? "Failed to install GIMP"
else
  echo "${GREEN}✓ GIMP is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Reactotron installation
# ----------------------------------
show_progress "Installing Reactotron ⚛"
if ! command_exists reactotron; then
  echo "${BLUE}Installing Reactotron...${NOCOLOR}"
  brew install --cask reactotron
  handle_error $? "Failed to install Reactotron"
else
  echo "${GREEN}✓ Reactotron is already installed.${NOCOLOR}"
fi

# ----------------------------------
# Discord installation
# ----------------------------------
show_progress "Installing Discord 💬"
if ! command_exists discord; then
  echo "${BLUE}Installing Discord...${NOCOLOR}"
  brew install --cask discord
  handle_error $? "Failed to install Discord"
else
  echo "${GREEN}✓ Discord is already installed.${NOCOLOR}"
fi

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
show_progress "Installing OpenOffice 💻"
if ! command_exists soffice; then
  echo "${BLUE}Installing OpenOffice...${NOCOLOR}"
  brew install --cask openoffice
  handle_error $? "Failed to install OpenOffice"
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
    "workbench.iconTheme": "material-icon-theme",
    "workbench.startupEditor": "newUntitledFile",
    "editor.fontSize": 14,
    "editor.fontFamily": "Fira Code",
    "editor.fontLigatures": true,
    "explorer.compactFolders": false,
    "editor.renderLineHighlight": "gutter",
    "workbench.editor.labelFormat": "short",
    "extensions.ignoreRecommendations": true,
    "javascript.updateImportsOnFileMove.enabled": "always",
    "typescript.updateImportsOnFileMove.enabled": "never",
    "breadcrumbs.enabled": true,
    "editor.parameterHints.enabled": false,
    "explorer.confirmDragAndDrop": false,
    "explorer.confirmDelete": false,
    "editor.rulers": [
      80,
      120
    ],
    "typescript.tsdk": "/usr/local/lib/node_modules/typescript/lib",
    "eslint.alwaysShowStatus": true,
    "[javascript]": {
      "editor.codeActionsOnSave": {
        "source.fixAll.eslint": true,
        "source.fixAll": true
      },
      "editor.defaultFormatter": "esbenp.prettier-vscode",
    },
    "[javascriptreact]": {
      "editor.codeActionsOnSave": {
        "source.fixAll.eslint": true,
        "source.fixAll": true
      },
    },
    "[typescript]": {
      "editor.codeActionsOnSave": {
        "source.fixAll.eslint": true,
        "source.fixAll": true
      },
      "editor.defaultFormatter": "esbenp.prettier-vscode",
    },
    "[typescriptreact]": {
      "editor.codeActionsOnSave": {
        "source.fixAll.eslint": true,
        "source.fixAll": true
      },
      "editor.defaultFormatter": "esbenp.prettier-vscode",
    },
    "files.associations": {
      ".sequelizerc": "javascript",
      ".stylelintrc": "json",
      ".prettierrc": "json",
    },
    "emmet.includeLanguages": {
      "javascript": "javascriptreact"
    },
    "gitlens.codeLens.recentChange.enabled": false,
    "gitlens.codeLens.authors.enabled": false,
    "gitlens.codeLens.enabled": false,
    "git.enableSmartCommit": true,
    "terminal.integrated.shell.osx": "/bin/zsh",
    "liveshare.featureSet": "insiders",
    "typescript.tsserver.log": "verbose",
    "typescript.tsc.autoDetect": "off",
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
      "repository": "mappings",
      "http": "container",
      "migrations": "tools",
      "modules": "components",
      "implementations": "core",
      "dtos": "typescript",
      "fakes": "mock",
      "websockets": "pipe",
      "protos": "pipe",
      "grpc": "pipe",
      "csv-parser": "Lib",
      "constants": "typescript",
      "factory": "typescript",
      "interfaces": "typescript",
      "enums": "typescript",
      "joi": "Json",
      "fake_ftp": "database",
      "entity": "database",   
      "exceptions": "debug",
      ".elasticbeanstalk": "aws",
      "application": "app",
      "domain": "meta",
      "infrastructure": "server",
      ".pgdata": "admin"
    },
    "material-icon-theme.files.associations": {
      "ormconfig.json": "database",
      "tsconfig.json": "tune",
      "*.proto": "3d",
      "routes.ts": "routing",
      ".env.homolog": "tune",
      ".env.hotfix": "tune",
      "knexfile.ts": "database",
      "knexfile.js": "database",
      "ormconfig.js": "database",
      "ormconfig.ts": "database"
    },
    "workbench.colorTheme": "Horizon",
    "[html]": {
      "editor.defaultFormatter": "esbenp.prettier-vscode"
    },
    "eslint.migration.2_x": "off",
    "[shellscript]": {
      "editor.defaultFormatter": "shakram02.bash-beautify"
    },
    "diffEditor.ignoreTrimWhitespace": false,
    "workbench.editor.showTabs": true,
    "sonarlint.ls.javaHome": "/Users/leualmeida/.vscode/extensions/sonarsource.sonarlint_managed-jre/jre/jdk-11.0.10+9-jre/Contents/Home",
    "cSpell.userWords": [
      "plusplus",
      "telemedicinaeinstein"
    ],
    "elixirLS.dialyzerEnabled": false,
    "elixirLS.suggestSpecs": false,
    "[json]": {
      "editor.defaultFormatter": "esbenp.prettier-vscode"
    },
  }
EOF
    
    echo "${LIGHTGREEN}Installing VSCode Extensions${NOCOLOR}"
    code --install-extension akamud.vscode-theme-onedark
    code --install-extension alexcvzz.vscode-sqlite
    code --install-extension basarat.god
    code --install-extension bmewburn.vscode-intelephense-client
    code --install-extension CoenraadS.bracket-pair-colorizer-2
    code --install-extension dbaeumer.vscode-eslint
    code --install-extension DigitalBrainstem.javascript-ejs-support
    code --install-extension dracula-theme.theme-dracula
    code --install-extension eamodio.gitlens
    code --install-extension EditorConfig.EditorConfig
    code --install-extension esbenp.prettier-vscode
    code --install-extension foxundermoon.shell-format
    code --install-extension golang.go
    code --install-extension iampeterbanjo.elixirlinter
    code --install-extension JakeBecker.elixir-ls
    code --install-extension jolaleye.horizon-theme-vscode
    code --install-extension jpoissonnier.vscode-styled-components
    code --install-extension kangping.protobuf
    code --install-extension mikestead.dotenv
    code --install-extension mrorz.language-gettext
    code --install-extension ms-azuretools.vscode-docker
    code --install-extension ms-vscode.vscode-typescript-tslint-plugin
    code --install-extension ms-vsliveshare.vsliveshare
    code --install-extension ms-vsliveshare.vsliveshare-audio
    code --install-extension ms-vsliveshare.vsliveshare-pack
    code --install-extension naumovs.color-highlight
    code --install-extension Perkovec.emoji
    code --install-extension PKief.material-icon-theme
    code --install-extension plex.vscode-protolint
    code --install-extension ritwickdey.LiveServer
    code --install-extension rocketseat.rocketseatreactjs
    code --install-extension rocketseat.rocketseatreactnative
    code --install-extension rocketseat.theme-omni
    code --install-extension shakram02.bash-beautify
    code --install-extension silvenon.mdx
    code --install-extension SonarSource.sonarlint-vscode
    code --install-extension streetsidesoftware.code-spell-checker
    code --install-extension wayou.vscode-todo-highlight
    code --install-extension whizkydee.material-palenight-theme
    code --install-extension wix.vscode-import-cost
    code --install-extension xyc.vscode-mdx-preview
    code --install-extension yzhang.markdown-all-in-one
    
    echo "${LIGHTGREEN}Installing Omni theme on hyper${NOCOLOR}"
    git clone https://github.com/getomni/hyper-omni ~/.hyper_plugins/local/hyper-omni
    
    echo "${LIGHTGREEN}Installing Font Ligatures${NOCOLOR}"
    hyper i hyper-font-ligatures
    
    echo "${LIGHTGREEN}Implementing Hyper settings${NOCOLOR}"
cat <<EOF > ~/.hyper.js
module.exports = {
  config: {
    updateChannel: 'stable',
    fontSize: 12,
    fontFamily: 'Fira Code, "DejaVu Sans Mono", Consolas, "Lucida Console", monospace',
    fontWeight: 'normal',
    fontWeightBold: 'bold',
    lineHeight: 1,
    letterSpacing: 0,
    cursorColor: 'rgba(248,28,229,0.8)',
    cursorAccentColor: '#000',
    cursorShape: 'BLOCK',
    cursorBlink: false,
    foregroundColor: '#fff',
    backgroundColor: '#000',
    selectionColor: 'rgba(248,28,229,0.3)',
    borderColor: '#333',
    css: '',
    termCSS: '',
    showHamburgerMenu: '',
    showWindowControls: '',
    padding: '12px 14px',
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
    webGLRenderer: false,
  },
  plugins: ['hyper-font-ligatures'],
  localPlugins: ['hyper-omni'],
  keymaps: {
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
    brew tap homebrew/cask-fonts
    brew install --cask font-fira-code
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
### Added by Zplugin's installer
source "$HOME/.zplugin/bin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin installer's chunk

zplugin light zdharma/fast-syntax-highlighting
zplugin light zsh-users/zsh-autosuggestions
zplugin light zsh-users/zsh-completions
EOF
    
    echo "${LIGHTGREEN}Installing ZSH Plugins${NOCOLOR}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
cat <<EOF >> ~/.zshrc
zinit light zdharma/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
EOF
    source ~/.zshrc
    
fi

# ----------------------------------
# Finishing installation
# ----------------------------------
echo "${LIGHTGREEN}Commiting changes 🎈${NOCOLOR}"
source ~/.zshrc

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