#!/bin/bash

echo "Welcome! Let's start setting up your system. It could take more than 10 minutes, be patient, please 💙"

sudo apt-get update

echo '[1/31] Installing curl 🔌' 
sudo apt install curl -y


echo '[2/31] Installing git 😻' 
sudo apt install git -y

echo "What name do you want to use in GIT user.name?"
echo "For example, mine will be \"Léu Almeida\""
read git_config_user_name
git config --global user.name "$git_config_user_name"
clear 

echo "What email do you want to use in GIT user.email?"
echo "For example, mine will be \"leo@webid.net.br\""
read git_config_user_email
git config --global user.email $git_config_user_email
clear

echo "Generating a SSH Key"
ssh-keygen -t rsa -b 4096 -C $git_config_user_email
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub | xclip -selection clipboard

echo 'Enabling workspaces for both screens' 
gsettings set org.gnome.mutter workspaces-only-on-primary false

echo '[3/31] Installing zsh ⚡'
sudo apt-get install zsh -y
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
chsh -s /bin/zsh

echo '[4/31] Installing tool to handle clipboard via CLI'
sudo apt-get install xclip -y

export alias pbcopy='xclip -selection clipboard'
export alias pbpaste='xclip -selection clipboard -o'
source ~/.zshrc

echo '[5/31] Installing VsCode 💼'
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get install apt-transport-https -y
sudo apt-get update
sudo apt-get install code -y # or code-insiders


echo 'Adding VSCode settings' 
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

echo 'Installing VSCode Extensions'
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

echo '[6/31] Installing spotify 🎵' 
snap install spotify

echo '[7/31] Installing Google Chrome 🖥' 
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

echo '[8/31] Installing NVM ⏩' 
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

echo "[9/31] Installing Node.js 😎"
nvm --version
nvm install 12.18.2
nvm alias default 12.18.2
node --version
npm --version

echo '[10/31] Installing Typescript ⚡'
npm install -g typescript

echo '[11/31] Installing Create React App ⚡'
npm install -g create-react-app

echo '[12/31] Installing Gatsby ⚡'
npm install -g gatsby-cli

echo '[13/31] Installing Yarn ⚡'
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt install yarn
clear

echo '[14/31] Installing React Native CLI 📲'
sudo npm install -g react-native-cli

echo 'Installing JDK (Java Dvelopment Kit)'
sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get update
sudo apt-get install openjdk-8-jdk
sudo update-alternatives --config java
echo 'Now you will need to install Android Studio manually on https://developer.android.com/studio'

echo 'Setting graphic libs'
sudo apt-get install gcc-multilib lib32z1 lib32stdc++6

echo '[15/31] Installing Autosuggestions ⌨' 
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
source ~/.zshrc

echo '[16/31] Installing theme'
sudo apt install fonts-firacode -y
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
sed -i 's/.*ZSH_THEME=.*/ZSH_THEME="spaceship"/g' ~/.zshrc

echo 'Setting Spaceship configs'
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

echo 'Installing ZSH Plugins'
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
cat <<EOF >> ~/.zshrc
zinit light zdharma/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
EOF
source ~/.zshrc

echo '[17/31] Installing Franz 💬' 
wget https://github.com/meetfranz/franz/releases/download/v5.1.0/franz_5.1.0_amd64.deb -O franz.deb
sudo dpkg -i franz.debchristian-kohler.path-intellisense
sudo apt-get install -y -f 

echo '[18/31] Installing Hyper'
sudo apt-get install gdebi
wget https://hyper-updates.now.sh/download/linux_deb
sudo gdebi linux_deb

echo 'Installing Omni theme'
git clone https://github.com/getomni/hyper-omni ~/.hyper_plugins/local/hyper-omni

echo 'Installing Font Ligatures'
hyper i hyper-font-ligatures

echo 'Implementing Hyper settings'
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

echo '[19/31] Installing Docker 🐳' 
sudo apt-get remove docker docker-engine docker.io
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
docker --version

chmod 777 /var/run/docker.sock
docker run hello-world

echo '[20/31] Installing docker-compose 🍱' 
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

echo '[21/31] Installing kubectl ⏹'
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

echo '[22/31] Installing heroku-cli 💜'
curl https://cli-assets.heroku.com/install-ubuntu.sh | sh
heroku --version

echo '[23/31] Installing aws-cli 💛' 
sudo apt-get install awscli -y
aws --version
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
sudo dpkg -i session-manager-plugin.deb
session-manager-plugin --version

echo '[24/31] Installing fzf 🔎'
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all
source ~/.zshrc

echo '[25/31] Installing dbeaver ⌛'
wget -c https://dbeaver.io/files/6.0.0/dbeaver-ce_6.0.0_amd64.deb
sudo dpkg -i dbeaver-ce_6.0.0_amd64.deb
sudo apt-get install -f
clear

echo '[26/31] Installing Robo3t 💚'
snap install robo3t-snap
clear

echo '[27/31] Installing Insomnia 🎱' 
echo "deb https://dl.bintray.com/getinsomnia/Insomnia /" \
    | sudo tee -a /etc/apt/sources.list.d/insomnia.list
wget --quiet -O - https://insomnia.rest/keys/debian-public.key.asc \
    | sudo apt-key add -
sudo apt-get install insomnia
clear

echo '[28/31] Installing Postbird 🐘'
sudo snap install postbird -y
clear

echo '[29/31] Installing VLC ⏯'
sudo apt install vlc -y
sudo apt install vlc-plugin-access-extra libbluray-bdj libdvdcss2 -y

echo '[30/31] Installing Transmission 📩'
sudo add-apt-repository ppa:transmissionbt/ppa
sudo apt-get update
sudo apt-get install transmission transmission-qt -y
clear

echo '[31/31] Installing GIMP 🖼'
sudo add-apt-repository ppa:otto-kesselgulasch/gimp
sudo apt-get update
sudo apt-get install gimp gimp-gmic gmic -y
sudo apt-get install gimp-plugin-registry -y
clear

echo '[32/31] Installing Reactotron ⚛'
wget -c https://github.com/infinitered/reactotron/releases/download/v2.17.1/reactotron-app_2.17.1_amd64.deb
sudo dpkg -i reactotron-app_2.17.1_amd64.deb
clear

echo '[33/32] Installing Discord 💬'
sudo snap install discord --classic
clear

echo 'Commiting changes 🎈'
source ~/.zshrc
sudo dpkg --configure -a 
sudo apt-get update --fix-missing
sudo apt-get autoremove

clear 

echo 'All setup, enjoy! 😉'
