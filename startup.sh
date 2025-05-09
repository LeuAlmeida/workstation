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
# OS Detection
# ----------------------------------
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${GREEN}Detected macOS.${NOCOLOR}"
    echo ""
    echo -e "${BLUE}Choose an installation option:${NOCOLOR}"
    echo -e "${YELLOW}1. Full macOS setup (macosx.sh)${NOCOLOR}"
    echo "   Complete development environment setup with all tools and configurations"
    echo ""
    echo -e "${YELLOW}2. Basic macOS check + setup (darwin.sh)${NOCOLOR}"
    echo "   System compatibility check before running the full setup"
    echo ""
    echo -e "${YELLOW}0. Exit${NOCOLOR}"
    echo ""
    
    read -p "Enter your choice [0-2]: " choice
    
    case $choice in
        1)
            if [[ -f scripts/apple/macosx.sh ]]; then
                bash scripts/apple/macosx.sh
            else
                echo -e "${RED}macOS script not found: scripts/apple/macosx.sh${NOCOLOR}"
                exit 1
            fi
            ;;
        2)
            if [[ -f scripts/apple/darwin.sh ]]; then
                bash scripts/apple/darwin.sh
            else
                echo -e "${RED}Darwin script not found: scripts/apple/darwin.sh${NOCOLOR}"
                exit 1
            fi
            ;;
        0)
            echo -e "${LIGHTBLUE}Exiting. Goodbye!${NOCOLOR}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Exiting.${NOCOLOR}"
            exit 1
            ;;
    esac
else
    if ! command -v lsb_release &> /dev/null; then
        echo -e "${ORANGE}lsb_release not found. Installing...${NOCOLOR}"
        sudo apt update && sudo apt install -y lsb-release
    fi

    DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')

    case "$DISTRO" in
        ubuntu)
            echo -ne "${YELLOW}Detected Ubuntu. Do you want to continue with the installation? (y/n): ${NOCOLOR}"
            read -r answer
            if [[ "$answer" =~ ^[Yy]$ ]]; then
                if [[ -f scripts/linux/ubuntu.sh ]]; then
                    bash scripts/linux/ubuntu.sh
                else
                    echo -e "${RED}Ubuntu script not found.${NOCOLOR}"
                    exit 1
                fi
            else
                echo -e "${LIGHTRED}Installation aborted.${NOCOLOR}"
                exit 0
            fi
            ;;
        debian)
            echo -ne "${YELLOW}Detected Debian. Do you want to continue with the installation? (y/n): ${NOCOLOR}"
            read -r answer
            if [[ "$answer" =~ ^[Yy]$ ]]; then
                if [[ -f scripts/linux/debian.sh ]]; then
                    bash scripts/linux/debian.sh
                else
                    echo -e "${RED}Debian script not found.${NOCOLOR}"
                    exit 1
                fi
            else
                echo -e "${LIGHTRED}Installation aborted.${NOCOLOR}"
                exit 0
            fi
            ;;
        *)
            echo -e "${LIGHTRED}Distribution '$DISTRO' is not supported by this script.${NOCOLOR}"
            exit 1
            ;;
    esac
fi
