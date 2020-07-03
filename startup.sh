#!/bin/bash

# ----------------------------------
# Colors
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
# Start of the script
# ----------------------------------
echo "${BLUE}Welcome! Let's start setting up your system. "
echo "It could take more than 10 minutes, be patient, please 💙 ${NOCOLOR}"

sudo apt-get update

# ----------------------------------
# Curl installation
# ----------------------------------
echo "${LIGHTGREEN}[1/34] Installing curl 🔌'${NOCOLOR}"
sudo apt install curl -y

# ----------------------------------
# Git installation
# ----------------------------------
echo "${LIGHTGREEN}[2/34] Installing git 😻'${NOCOLOR}"
sudo apt install git -y

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
echo "${LIGHTGREEN}[3/34] Installing zsh ⚡${NOCOLOR}"
sudo apt-get install zsh -y
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
chsh -s /bin/zsh

echo "${LIGHTGREEN}[4/34] Installing tool to handle clipboard via CLI${NOCOLOR}"
sudo apt-get install xclip -y

export alias pbcopy='xclip -selection clipboard'
export alias pbpaste='xclip -selection clipboard -o'
source ~/.zshrc

# ----------------------------------
# VsCode installation
# ----------------------------------
echo "${LIGHTGREEN}[5/34] Installing VsCode 💼${NOCOLOR}"
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get install apt-transport-https -y
sudo apt-get update
sudo apt-get install code -y # or code-insiders

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
}
EOF

echo "${LIGHTGREEN}Installing VSCode Extensions${NOCOLOR}"
code --install-extension alexcvzz.vscode-sqlite
code --install-extension basarat.god
code --install-extension bmewburn.vscode-intelephense-client
code --install-extension CoenraadS.bracket-pair-colorizer-2
code --install-extension dbaeumer.vscode-eslint
code --install-extension dracula-theme.theme-dracula
code --install-extension eamodio.gitlens
code --install-extension EditorConfig.EditorConfig
code --install-extension esbenp.prettier-vscode
code --install-extension jpoissonnier.vscode-styled-components
code --install-extension mikestead.dotenv
code --install-extension mrorz.language-gettext
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-vsliveshare.vsliveshare
code --install-extension ms-vsliveshare.vsliveshare-audio
code --install-extension ms-vsliveshare.vsliveshare-pack
code --install-extension naumovs.color-highlight
code --install-extension Perkovec.emoji
code --install-extension PKief.material-icon-theme
code --install-extension ritwickdey.LiveServer
code --install-extension rocketseat.rocketseatreactjs
code --install-extension rocketseat.rocketseatreactnative
code --install-extension rocketseat.theme-omni
code --install-extension silvenon.mdx
code --install-extension yzhang.markdown-all-in-one

# ----------------------------------
# Spotify installation
# ----------------------------------
echo "${LIGHTGREEN}[6/34] Installing spotify 🎵'${NOCOLOR}"
sudo snap install spotify

# ----------------------------------
# Google Chrome installation
# ----------------------------------
echo "${LIGHTGREEN}[7/34] Installing Google Chrome 🖥'${NOCOLOR}"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

# ----------------------------------
# NVM installation
# ----------------------------------
echo "${LIGHTGREEN}[8/34] Installing NVM ⏩'${NOCOLOR}"
sh -c "$(curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash)"

export NVM_DIR="$HOME/.nvm" && (
git clone https://github.com/creationix/nvm.git "$NVM_DIR"
cd "$NVM_DIR"
git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
) && \. "$NVM_DIR/nvm.sh"

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
echo "${LIGHTGREEN}[9/34] Installing Node.js 😎${NOCOLOR}"
nvm --version
nvm install 12.18.2
nvm alias default 12.18.2
node --version
npm --version

# ----------------------------------
# Typescript installation
# ----------------------------------
echo "${LIGHTGREEN}[10/34] Installing Typescript ⚡${NOCOLOR}"
npm install -g typescript

# ----------------------------------
# ReactJS CRA installation
# ----------------------------------
echo "${LIGHTGREEN}[11/34] Installing Create React App ⚡${NOCOLOR}"
npm install -g create-react-app

# ----------------------------------
# GatsbyJS installation
# ----------------------------------
echo "${LIGHTGREEN}[12/34] Installing GatsbyJS ⚡${NOCOLOR}"
npm install -g gatsby-cli

echo "${LIGHTGREEN}[13/34] Installing Yarn ⚡${NOCOLOR}"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt install yarn
clear

# ----------------------------------
# React Native installation
# ----------------------------------
echo "${LIGHTGREEN}[14/34] Installing React Native CLI 📲${NOCOLOR}"
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
# Autosuggestions installation
# ----------------------------------
echo "${LIGHTGREEN}[15/34] Installing Autosuggestions ⌨${NOCOLOR}"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
source ~/.zshrc

# ----------------------------------
# ZSH Themes installation
# ----------------------------------
echo "${LIGHTGREEN}[16/34] Installing theme${NOCOLOR}"
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

# ----------------------------------
# Franz installation
# ----------------------------------
echo "${LIGHTGREEN}[17/34] Installing Franz 💬'${NOCOLOR}"
wget https://github.com/meetfranz/franz/releases/download/v5.1.0/franz_5.1.0_amd64.deb -O franz.deb
sudo dpkg -i franz.debchristian-kohler.path-intellisense
sudo apt-get install -y -f 

# ----------------------------------
# Hyper installation
# ----------------------------------
echo "${LIGHTGREEN}[18/34] Installing Hyper${NOCOLOR}"
sudo apt-get install gdebi
wget https://hyper-updates.now.sh/download/linux_deb
sudo gdebi linux_deb

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
# Docker installation
# ----------------------------------
echo "${LIGHTGREEN}[19/34] Installing Docker 🐳'${NOCOLOR}"
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
echo "${LIGHTGREEN}[20/34] Installing docker-compose 🍱'${NOCOLOR}"
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

# ----------------------------------
# Kubectl installation
# ----------------------------------
echo "${LIGHTGREEN}[21/34] Installing kubectl ⏹${NOCOLOR}"
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

# ----------------------------------
# Heroku CLI installation
# ----------------------------------
echo "${LIGHTGREEN}[22/34] Installing heroku-cli 💜${NOCOLOR}"
curl https://cli-assets.heroku.com/install-ubuntu.sh | sh
heroku --version

# ----------------------------------
# AWS CLI installation
# ----------------------------------
echo "${LIGHTGREEN}[23/34] Installing aws-cli 💛'${NOCOLOR}"
sudo apt-get install awscli -y
aws --version
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
sudo dpkg -i session-manager-plugin.deb
session-manager-plugin --version

# ----------------------------------
# Fzf installation
# ----------------------------------
echo "${LIGHTGREEN}[24/34] Installing fzf 🔎${NOCOLOR}"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all
source ~/.zshrc

# ----------------------------------
# Dbeaver installation
# ----------------------------------
echo "${LIGHTGREEN}[25/34] Installing dbeaver ⌛${NOCOLOR}"
wget -c https://dbeaver.io/files/6.0.0/dbeaver-ce_6.0.0_amd64.deb
sudo dpkg -i dbeaver-ce_6.0.0_amd64.deb
sudo apt-get install -f
clear

# ----------------------------------
# Robo3t installation
# ----------------------------------
echo "${LIGHTGREEN}[26/34] Installing Robo3t 💚${NOCOLOR}"
snap install robo3t-snap
clear

# ----------------------------------
# Insomnia installation
# ----------------------------------
echo "${LIGHTGREEN}[27/34] Installing Insomnia 🎱'${NOCOLOR}"
echo "deb https://dl.bintray.com/getinsomnia/Insomnia /" \
    | sudo tee -a /etc/apt/sources.list.d/insomnia.list
wget --quiet -O - https://insomnia.rest/keys/debian-public.key.asc \
    | sudo apt-key add -
sudo apt-get install insomnia
clear

# ----------------------------------
# Postbird installation
# ----------------------------------
echo "${LIGHTGREEN}[28/34] Installing Postbird 🐘${NOCOLOR}"
yes | sudo snap install postbird
clear

# ----------------------------------
# VLC installation
# ----------------------------------
echo "${LIGHTGREEN}[29/34] Installing VLC ⏯${NOCOLOR}"
sudo apt install vlc -y
sudo apt install vlc-plugin-access-extra libbluray-bdj libdvdcss2 -y

# ----------------------------------
# Transmission installation
# ----------------------------------
echo "${LIGHTGREEN}[30/34] Installing Transmission 📩${NOCOLOR}"
sudo add-apt-repository ppa:transmissionbt/ppa
sudo apt-get update
sudo apt-get install transmission transmission-qt -y
clear

# ----------------------------------
# GIMP installation
# ----------------------------------
echo "${LIGHTGREEN}[31/34] Installing GIMP 🖼${NOCOLOR}"
yes | sudo add-apt-repository ppa:otto-kesselgulasch/gimp
sudo apt-get update
sudo apt-get install gimp gimp-gmic gmic -y
sudo apt-get install gimp-plugin-registry -y
clear

# ----------------------------------
# Reactotron installation
# ----------------------------------
echo "${LIGHTGREEN}[32/34] Installing Reactotron ⚛${NOCOLOR}"
wget -c https://github.com/infinitered/reactotron/releases/download/v2.17.1/reactotron-app_2.17.1_amd64.deb
sudo dpkg -i reactotron-app_2.17.1_amd64.deb
clear

# ----------------------------------
# Discord installation
# ----------------------------------
echo "${LIGHTGREEN}[33/34] Installing Discord 💬${NOCOLOR}"
sudo snap install discord --classic
clear

# ----------------------------------
# Terminalizer installation
# ----------------------------------
echo "${LIGHTGREEN}[34/34] Installing Terminalizer 💅${NOCOLOR}"
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
echo "${LIGHTGREEN}[35/35] Installing Expo 📱${NOCOLOR}"
npm install -g terminalizer
clear

# ----------------------------------
# Finishing installation
# ----------------------------------
echo "${LIGHTGREEN}Commiting changes 🎈${NOCOLOR}"
source ~/.zshrc
sudo dpkg --configure -a 
sudo apt-get update --fix-missing
sudo apt-get autoremove

clear 

echo "${YELLOW}All setup, enjoy! 😉${NOCOLOR}"
echo "${ORANGE}You're welcome to contribute to the project on https://github.com/LeuAlmeida/ubuntu-workstation${NOCOLOR}"
