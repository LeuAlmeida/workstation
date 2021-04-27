
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

case $OSTYPE in (*darwin*)
    echo "${YELLOW}Are you using MacOS (y/n)?${NOCOLOR}"
    read answer

    if [ "$answer" != "${answer#[Yy]}" ] ;then
        sh scripts/apple/macosx.sh
    fi
esac


OS=$(awk '/DISTRIB_ID=/' /etc/*-release | sed 's/DISTRIB_ID=//' | tr '[:upper:]' '[:lower:]')

if [ -z "$OS" ]; then
    OS=$(awk '{print $1}' /etc/*-release | tr '[:upper:]' '[:lower:]')
fi

case $OS in (*ubuntu*)
    echo -n "${YELLOW}Are you using Ubuntu (y/n)?${NOCOLOR}"
    read answer
    
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        sh scripts/linux/ubuntu.sh
    fi
esac

case $OS in (*debian*)
    echo -n "${YELLOW}Are you using Debian (y/n)?${NOCOLOR}"
    read answer
    
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        sh scripts/linux/debian.sh
    fi
esac