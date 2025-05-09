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
TOTAL_STEPS=37
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
esudo apt install curl -y
handle_error $? "Failed to install curl"

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
echo "${LIGHTGREEN}[6/35] Installing spotify 🎵'${NOCOLOR}"
sudo snap install spotify

# ----------------------------------
# Google Chrome installation
# ----------------------------------
echo "${LIGHTGREEN}[7/35] Installing Google Chrome 🖥'${NOCOLOR}"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

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
echo "${LIGHTGREEN}[11/35] Installing Create React App ⚡${NOCOLOR}"
npm install -g create-react-app

# ----------------------------------
# GatsbyJS installation
# ----------------------------------
echo "${LIGHTGREEN}[12/35] Installing GatsbyJS ⚡${NOCOLOR}"
npm install -g gatsby-cli

echo "${LIGHTGREEN}[13/35] Installing Yarn ⚡${NOCOLOR}"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt install yarn
clear

# ----------------------------------
# React Native installation
# ----------------------------------
echo "${LIGHTGREEN}[14/35] Installing React Native CLI 📲${NOCOLOR}"
sudo npm install -g react-native-cli

echo "${LIGHTGREEN}Installing JDK (Java Dvelopment Kit)${NOCOLOR}"
sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get update
sudo apt-get install openjdk-8-jdk
sudo update-alternatives --config java

echo ""

echo "${LIGHTRED}Now you will need to install Android Studio manually on https://developer.android.com/studio${NOCOLOR}"

echo "${LIGHTGREEN}Setting graphic libs${NOCOLOR}"
sudo apt-get install gcc-multilib lib32z1 lib32stdc++6

# ----------------------------------
# Franz installation
# ----------------------------------
echo "${LIGHTGREEN}[15/35] Installing Franz 💬'${NOCOLOR}"
wget https://github.com/meetfranz/franz/releases/download/v5.1.0/franz_5.1.0_amd64.deb -O franz.deb
sudo dpkg -i franz.debchristian-kohler.path-intellisense
sudo apt-get install -y -f

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
  

# ----------------------------------
# Docker installation
# ----------------------------------
echo "${LIGHTGREEN}[17/35] Installing Docker 🐳'${NOCOLOR}"
sudo apt-get remove docker docker-engine docker.io
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
docker --version

chmod 777 /var/run/docker.sock
docker run hello-world

# ----------------------------------
# Docker Compose installation
# ----------------------------------
echo "${LIGHTGREEN}[18/35] Installing docker-compose 🍱'${NOCOLOR}"
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

# ----------------------------------
# Kubectl installation
# ----------------------------------
echo "${LIGHTGREEN}[19/35] Installing kubectl ⏹${NOCOLOR}"
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

# ----------------------------------
# Heroku CLI installation
# ----------------------------------
echo "${LIGHTGREEN}[20/35] Installing heroku-cli 💜${NOCOLOR}"
curl https://cli-assets.heroku.com/install-ubuntu.sh | sh
heroku --version

# ----------------------------------
# AWS CLI installation
# ----------------------------------
echo "${LIGHTGREEN}[21/35] Installing aws-cli 💛'${NOCOLOR}"
sudo apt-get install awscli -y
aws --version
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
sudo dpkg -i session-manager-plugin.deb
session-manager-plugin --version

# ----------------------------------
# Fzf installation
# ----------------------------------
echo "${LIGHTGREEN}[22/35] Installing fzf 🔎${NOCOLOR}"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all
source ~/.zshrc

# ----------------------------------
# Dbeaver installation
# ----------------------------------
echo "${LIGHTGREEN}[23/35] Installing dbeaver ⌛${NOCOLOR}"
wget -c https://dbeaver.io/files/6.0.0/dbeaver-ce_6.0.0_amd64.deb
sudo dpkg -i dbeaver-ce_6.0.0_amd64.deb
sudo apt-get install -f
clear

# ----------------------------------
# Robo3t installation
# ----------------------------------
echo "${LIGHTGREEN}[24/35] Installing Robo3t 💚${NOCOLOR}"
snap install robo3t-snap
clear

# ----------------------------------
# Insomnia installation
# ----------------------------------
echo "${LIGHTGREEN}[25/35] Installing Insomnia 🎱'${NOCOLOR}"
echo "deb https://dl.bintray.com/getinsomnia/Insomnia /" \
| sudo tee -a /etc/apt/sources.list.d/insomnia.list
wget --quiet -O - https://insomnia.rest/keys/debian-public.key.asc \
| sudo apt-key add -
sudo apt-get install insomnia
clear

# ----------------------------------
# Postbird installation
# ----------------------------------
echo "${LIGHTGREEN}[26/35] Installing Postbird 🐘${NOCOLOR}"
yes | sudo snap install postbird
clear

# ----------------------------------
# VLC installation
# ----------------------------------
echo "${LIGHTGREEN}[27/35] Installing VLC ⏯${NOCOLOR}"
sudo apt install vlc -y
sudo apt install vlc-plugin-access-extra libbluray-bdj libdvdcss2 -y

# ----------------------------------
# Transmission installation
# ----------------------------------
echo "${LIGHTGREEN}[28/35] Installing Transmission 📩${NOCOLOR}"
sudo add-apt-repository ppa:transmissionbt/ppa
sudo apt-get update
sudo apt-get install transmission transmission-qt -y
clear

# ----------------------------------
# GIMP installation
# ----------------------------------
echo "${LIGHTGREEN}[29/35] Installing GIMP 🖼${NOCOLOR}"
yes | sudo add-apt-repository ppa:otto-kesselgulasch/gimp
sudo apt-get update
sudo apt-get install gimp gimp-gmic gmic -y
sudo apt-get install gimp-plugin-registry -y
clear

# ----------------------------------
# Reactotron installation
# ----------------------------------
echo "${LIGHTGREEN}[30/35] Installing Reactotron ⚛${NOCOLOR}"
wget -c https://github.com/infinitered/reactotron/releases/download/v2.17.1/reactotron-app_2.17.1_amd64.deb
sudo dpkg -i reactotron-app_2.17.1_amd64.deb
clear

# ----------------------------------
# Discord installation
# ----------------------------------
echo "${LIGHTGREEN}[31/35] Installing Discord 💬${NOCOLOR}"
sudo snap install discord --classic
clear

# ----------------------------------
# Terminalizer installation
# ----------------------------------
echo "${LIGHTGREEN}[32/35] Installing Terminalizer 💅${NOCOLOR}"
npm install -g terminalizer

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
echo "${LIGHTGREEN}[33/35] Installing Expo 📱${NOCOLOR}"
npm install --global expo-cli
clear


# ----------------------------------
# Vercel CLI installation
# ----------------------------------
echo "${LIGHTGREEN}[34/35] Installing Vercel CLI ⬆${NOCOLOR}"
npm install -g vercel
clear


# ----------------------------------
# OpenOffice installation
# ----------------------------------
echo "${LIGHTGREEN}[35/35] Installing OpenOffice 💻${NOCOLOR}"
if [ `getconf LONG_BIT` = "64" ]
then
    wget http://ufpr.dl.sourceforge.net/project/openofficeorg.mirror/4.1.6/binaries/pt-BR/Apache_OpenOffice_4.1.6_Linux_x86-64_install-rpm_pt-BR.tar.gz -O openoffice.tar.gz

else
    wget http://ufpr.dl.sourceforge.net/project/openofficeorg.mirror/4.1.6/binaries/pt-BR/Apache_OpenOffice_4.1.6_Linux_x86_install-rpm_pt-BR.tar.gz -O openoffice.tar.gz
fi

tar -vzxf openoffice.tar.gz
sudo rpm -i pt-BR/RPMS/*.rpm
sudo rpm -i pt-BR/RPMS/desktop-integration/*.rpm
clear

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
  "[javascript]": {
    "editor.codeActionsOnSave": {
      "source.fixAll.eslint": true
    },
    "editor.defaultFormatter": "esbenp.prettier-vscode",
  },
  "[javascriptreact]": {
    "editor.codeActionsOnSave": {
      "source.fixAll.eslint": true
    },
  },
  "[typescript]": {
    "editor.codeActionsOnSave": {
      "source.fixAll.eslint": true
    },
    "editor.defaultFormatter": "esbenp.prettier-vscode",
  },
  "[typescriptreact]": {
    "editor.codeActionsOnSave": {
      "source.fixAll.eslint": true
    },
    "editor.defaultFormatter": "esbenp.prettier-vscode",
  },
  "files.associations": {
    ".sequelizerc": "javascript",
    ".stylelintrc": "json",
    ".prettierrc": "json"
  },
  "window.zoomLevel": 0,
  "emmet.syntaxProfiles": {
    "javascript": "jsx"
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
  },
  "material-icon-theme.files.associations": {
    "ormconfig.json": "database",
    "tsconfig.json": "tune",
    "*.proto": "3d",
    "routes.ts": "routing"
  },
  "workbench.colorTheme": "Omni",
  "[html]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "eslint.migration.2_x": "off",
  "[shellscript]": {
    "editor.defaultFormatter": "shakram02.bash-beautify"
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
    
    echo "${LIGHTGREEN}Installing Omni theme${NOCOLOR}"
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
sudo dpkg --configure -a
sudo apt-get update --fix-missing
sudo apt-get autoremove

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