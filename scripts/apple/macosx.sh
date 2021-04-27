#!/bin/bash

# ----------------------------------
# Start of the script
# ----------------------------------
clear
echo "${BLUE}Welcome! Let's start setting up your system. "
echo "It could take more than 10 minutes, be patient, please 💙 ${NOCOLOR}"

# ----------------------------------
# Homebrew Installation
# ----------------------------------
echo "${LIGHTGREEN}[1/32] Installing brew 🍺'${NOCOLOR}"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
clear

# ----------------------------------
# Xcode Installation
# ----------------------------------
echo "${LIGHTGREEN}[2/32] Installing Xcode Command Line Tools 🛠️'${NOCOLOR}"
xcode-select --install
clear

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
clear

# ----------------------------------
# ZSH installation
# ----------------------------------
echo "${LIGHTGREEN}[3/32] Installing zsh ⚡${NOCOLOR}"
brew install zsh
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
chsh -s /bin/zsh
clear

# ----------------------------------
# VsCode installation
# ----------------------------------
echo "${LIGHTGREEN}[5/32] Installing VsCode 💼${NOCOLOR}"
brew update
brew tap caskroom/cask
brew cask search visual-studio-code
brew cask install visual-studio-code
clear

# ----------------------------------
# Spotify installation
# ----------------------------------
echo "${LIGHTGREEN}[6/32] Installing spotify 🎵'${NOCOLOR}"
brew install --cask spotify
clear

# ----------------------------------
# Google Chrome installation
# ----------------------------------
echo "${LIGHTGREEN}[7/32] Installing Google Chrome 🖥'${NOCOLOR}"
brew install --cask google-chrome
clear

# ----------------------------------
# NVM installation
# ----------------------------------
echo "${LIGHTGREEN}[8/32] Installing NVM ⏩'${NOCOLOR}"
cd ~/
git clone https://github.com/nvm-sh/nvm.git .nvm
cd ~/.nvm
git checkout v0.38.0
. ./nvm.sh

cat <<EOF >> ~/.zshrc
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
EOF

source ~/.zshrc
clera

# ----------------------------------
# Node.js installation
# ----------------------------------
echo "${LIGHTGREEN}[9/32] Installing Node.js 😎${NOCOLOR}"
nvm install node
nvm alias default node
clear

# ----------------------------------
# Typescript installation
# ----------------------------------
echo "${LIGHTGREEN}[10/32] Installing Typescript ⚡${NOCOLOR}"
npm install -g typescript
clear

# ----------------------------------
# ReactJS CRA installation
# ----------------------------------
echo "${LIGHTGREEN}[11/32] Installing Create React App ⚡${NOCOLOR}"
npm install -g create-react-app
clear

# ----------------------------------
# GatsbyJS installation
# ----------------------------------
echo "${LIGHTGREEN}[12/32] Installing GatsbyJS ⚡${NOCOLOR}"
npm install -g gatsby-cli
clear

echo "${LIGHTGREEN}[13/32] Installing Yarn ⚡${NOCOLOR}"
npm install --global yarn
clear

# ----------------------------------
# React Native installation
# ----------------------------------
echo "${LIGHTGREEN}[14/32] Installing React Native CLI 📲${NOCOLOR}"
sudo npm install -g react-native-cli
clear

# ----------------------------------
# Hyper installation
# ----------------------------------
echo "${LIGHTGREEN}[15/32] Installing Hyper${NOCOLOR}"
brew install --cask hyper
clear

# ----------------------------------
# Docker installation
# ----------------------------------
echo "${LIGHTGREEN}[16/32] Installing Docker 🐳'${NOCOLOR}"
brew install docker
docker --version

chmod 777 /var/run/docker.sock
docker run hello-world
clear

# ----------------------------------
# Docker Compose installation
# ----------------------------------
echo "${LIGHTGREEN}[17/32] Installing docker-compose 🍱'${NOCOLOR}"
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
clear

# ----------------------------------
# Kubectl installation
# ----------------------------------
echo "${LIGHTGREEN}[18/32] Installing kubectl ${NOCOLOR}"
brew install kubectl 
clear

# ----------------------------------
# Heroku CLI installation
# ----------------------------------
echo "${LIGHTGREEN}[19/32] Installing heroku-cli 💜${NOCOLOR}"
brew tap heroku/brew && brew install heroku
clear

# ----------------------------------
# AWS CLI installation
# ----------------------------------
echo "${LIGHTGREEN}[20/32] Installing aws-cli 💛'${NOCOLOR}"
brew install awscli
clear

# ----------------------------------
# AWS Elastic Beanstalk CLI installation
# ----------------------------------
echo "${LIGHTGREEN}[21/32] Installing awsebcli 🎯'${NOCOLOR}"
brew install awsebcli
clear

# ----------------------------------
# Dbeaver installation
# ----------------------------------
echo "${LIGHTGREEN}[22/32] Installing DBeaver ⌛${NOCOLOR}"
brew install --cask dbeaver-community
clear

# ----------------------------------
# Dbeaver installation
# ----------------------------------
echo "${LIGHTGREEN}[23/32] Installing Sequel Pro 🍯${NOCOLOR}"
brew install --cask sequel-pro
clear

# ----------------------------------
# Robo3t installation
# ----------------------------------
echo "${LIGHTGREEN}[24/32] Installing Robo3t 💚${NOCOLOR}"
brew install --cask robo-3t
clear

# ----------------------------------
# Insomnia installation
# ----------------------------------
echo "${LIGHTGREEN}[25/32] Installing Insomnia 🎱'${NOCOLOR}"
brew install --cask insomnia
clear

# ----------------------------------
# Postbird installation
# ----------------------------------
echo "${LIGHTGREEN}[26/32] Installing Postbird 🐘${NOCOLOR}"
brew install --cask postbird
clear

# ----------------------------------
# GIMP installation
# ----------------------------------
echo "${LIGHTGREEN}[27/32] Installing GIMP 🖼${NOCOLOR}"
brew install --cask gimp
clear

# ----------------------------------
# Reactotron installation
# ----------------------------------
echo "${LIGHTGREEN}[28/32] Installing Reactotron ⚛${NOCOLOR}"
brew install --cask reactotron
clear

# ----------------------------------
# Discord installation
# ----------------------------------
echo "${LIGHTGREEN}[29/32] Installing Discord 💬${NOCOLOR}"
brew install --cask discord
clear

# ----------------------------------
# Expo CLI installation
# ----------------------------------
echo "${LIGHTGREEN}[30/32] Installing Expo 📱${NOCOLOR}"
npm install --global expo-cli
clear

# ----------------------------------
# Vercel CLI installation
# ----------------------------------
echo "${LIGHTGREEN}[31/32] Installing Vercel CLI ⬆${NOCOLOR}"
npm install -g vercel
clear


# ----------------------------------
# OpenOffice installation
# ----------------------------------
echo "${LIGHTGREEN}[32/32] Installing OpenOffice 💻${NOCOLOR}"
brew install --cask openoffice
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