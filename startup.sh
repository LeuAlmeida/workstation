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
    echo -ne "${YELLOW}Detectado macOS. Deseja continuar com a instalação? (y/n): ${NOCOLOR}"
    read -r answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        if [[ -f scripts/apple/macosx.sh ]]; then
            bash scripts/apple/macosx.sh
        else
            echo -e "${RED}Script para macOS não encontrado.${NOCOLOR}"
            exit 1
        fi
    else
        echo -e "${LIGHTRED}Instalação abortada.${NOCOLOR}"
        exit 0
    fi
else
    if ! command -v lsb_release &> /dev/null; then
        echo -e "${ORANGE}lsb_release não encontrado. Instalando...${NOCOLOR}"
        sudo apt update && sudo apt install -y lsb-release
    fi

    DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')

    case "$DISTRO" in
        ubuntu)
            echo -ne "${YELLOW}Detectado Ubuntu. Deseja continuar com a instalação? (y/n): ${NOCOLOR}"
            read -r answer
            if [[ "$answer" =~ ^[Yy]$ ]]; then
                if [[ -f scripts/linux/ubuntu.sh ]]; then
                    bash scripts/linux/ubuntu.sh
                else
                    echo -e "${RED}Script para Ubuntu não encontrado.${NOCOLOR}"
                    exit 1
                fi
            else
                echo -e "${LIGHTRED}Instalação abortada.${NOCOLOR}"
                exit 0
            fi
            ;;
        debian)
            echo -ne "${YELLOW}Detectado Debian. Deseja continuar com a instalação? (y/n): ${NOCOLOR}"
            read -r answer
            if [[ "$answer" =~ ^[Yy]$ ]]; then
                if [[ -f scripts/linux/debian.sh ]]; then
                    bash scripts/linux/debian.sh
                else
                    echo -e "${RED}Script para Debian não encontrado.${NOCOLOR}"
                    exit 1
                fi
            else
                echo -e "${LIGHTRED}Instalação abortada.${NOCOLOR}"
                exit 0
            fi
            ;;
        *)
            echo -e "${LIGHTRED}Distribuição '$DISTRO' não suportada por este script.${NOCOLOR}"
            exit 1
            ;;
    esac
fi
