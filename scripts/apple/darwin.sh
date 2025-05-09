#!/bin/bash

# ==================================
# Darwin Workstation Setup Script
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
# Helper functions
# ----------------------------------

# Check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# ----------------------------------
# Start of the script
# ----------------------------------
clear
echo "${BLUE}Darwin Workstation Setup Check${NOCOLOR}"
echo "${BLUE}==========================================${NOCOLOR}"
echo ""
echo "${YELLOW}This script will perform basic checks and then launch the full macOS setup script.${NOCOLOR}"
echo ""

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
  echo "${RED}Error: This script is only for macOS/Darwin systems.${NOCOLOR}"
  exit 1
fi

# Check for Xcode Command Line Tools
echo "${BLUE}Checking for Xcode Command Line Tools...${NOCOLOR}"
if xcode-select -p &>/dev/null; then
  echo "${GREEN}✓ Xcode Command Line Tools are already installed.${NOCOLOR}"
else
  echo "${YELLOW}! Xcode Command Line Tools are not installed.${NOCOLOR}"
  echo "${YELLOW}  The full installation script will attempt to install them.${NOCOLOR}"
fi

# Check for Homebrew
echo "${BLUE}Checking for Homebrew...${NOCOLOR}"
if command_exists brew; then
  echo "${GREEN}✓ Homebrew is already installed.${NOCOLOR}"
  # Get Homebrew version
  brew_version=$(brew --version | head -1 | cut -d ' ' -f 2)
  echo "${GREEN}  Installed version: $brew_version${NOCOLOR}"
else
  echo "${YELLOW}! Homebrew is not installed.${NOCOLOR}"
  echo "${YELLOW}  The full installation script will attempt to install it.${NOCOLOR}"
fi

# Check for Git
echo "${BLUE}Checking for Git...${NOCOLOR}"
if command_exists git; then
  echo "${GREEN}✓ Git is already installed.${NOCOLOR}"
  # Get Git version
  git_version=$(git --version | cut -d ' ' -f 3)
  echo "${GREEN}  Installed version: $git_version${NOCOLOR}"
else
  echo "${YELLOW}! Git is not installed.${NOCOLOR}"
  echo "${YELLOW}  The full installation script will attempt to install it.${NOCOLOR}"
fi

echo ""
echo "${BLUE}System check complete.${NOCOLOR}"
echo ""

# Ask user if they want to proceed with the full installation
echo -n "${YELLOW}Do you want to proceed with the full macOS workstation setup? (y/n)${NOCOLOR} "
read answer

if [ "$answer" != "${answer#[Yy]}" ]; then
  echo "${BLUE}Starting full installation script...${NOCOLOR}"
  # Execute the macOS setup script
  # Use the absolute path if the script is in a different directory
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  sh "$script_dir/macosx.sh"
else
  echo "${BLUE}Installation cancelled.${NOCOLOR}"
  echo "${GREEN}You can run the full installation script directly with: ./apple/macosx.sh${NOCOLOR}"
fi

