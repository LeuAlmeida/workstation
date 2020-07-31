
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
# Validations
# ----------------------------------

OS=$(awk '/DISTRIB_ID=/' /etc/*-release | sed 's/DISTRIB_ID=//' | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
VERSION=$(awk '/DISTRIB_RELEASE=/' /etc/*-release | sed 's/DISTRIB_RELEASE=//' | sed 's/[.]0/./')

if [ -z "$OS" ]; then
    OS=$(awk '{print $1}' /etc/*-release | tr '[:upper:]' '[:lower:]')
fi

if [ -z "$VERSION" ]; then
    VERSION=$(awk '{print $3}' /etc/*-release)
fi

# echo $OS
# echo $ARCH
# echo $VERSION

# Case the OS Distribution is Ubuntu, will run the ubuntu.sh file
case $OS in (*ubuntu*)
    echo -n "${YELLOW}Are you using Ubuntu (y/n)?${NOCOLOR}"
    read answer
    
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        sh scripts/ubuntu.sh
    fi
esac

case $OS in (*debian*)
    echo -n "${YELLOW}Are you using Debian (y/n)?${NOCOLOR}"
    read answer
    
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        sh scripts/debian.sh
    fi
esac