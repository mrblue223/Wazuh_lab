#!/bin/bash

# ==============================================================================
# SCRIPT NAME:  Wazuh-Lab-Orchestrator (MIRS-WAZUH)
# AUTHOR:       mrblue
# VERSION:      2.0.0
# DESCRIPTION:  A simplified, menu-driven deployment script for Wazuh Central.
#               Designed for academic labs and security research environments.
# ==============================================================================

# --- COLORS & UI ---
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

# --- PRE-FLIGHT CHECK ---
check_privileges() {
    if [[ $EUID -ne 0 ]]; then
       echo -e "${RED}[!] ERROR: Administrative privileges required.${NC}"
       echo "Please run this script using: sudo ./wazuh-deploy.sh"
       exit 1
    fi
}

# --- MENU SYSTEM ---
show_menu() {
    clear
    echo -e "${BLUE}${BOLD}====================================================${NC}"
    echo -e "${BLUE}${BOLD}   WAZUH CENTRAL DEPLOYMENT ORCHESTRATOR            ${NC}"
    echo -e "${BLUE}${BOLD}   Developed by: Sammy Roy                          ${NC}"
    echo -e "${BLUE}${BOLD}====================================================${NC}"
    echo -e "1) ${BOLD}Full Installation${NC} (Indexer, Server, Dashboard)"
    echo -e "2) ${BOLD}Check Status${NC} (Verify Wazuh Services)"
    echo -e "3) ${BOLD}Retrieve Passwords${NC} (Show Admin Credentials)"
    echo -e "4) ${BOLD}Exit${NC}"
    echo -ne "\n${YELLOW}Select an option [1-4]: ${NC}"
}

# --- INSTALLATION LOGIC ---
install_wazuh() {
    echo -e "\n${BLUE}[PHASE 1] Preparing Environment...${NC}"
    apt-get update && apt-get install -y curl tar coreutils
    
    echo -e "\n${BLUE}[PHASE 2] Downloading Wazuh Assistant...${NC}"
    curl -sO https://packages.wazuh.com/4.x/wazuh-install.sh
    chmod +x wazuh-install.sh
    
    echo -e "\n${BLUE}[PHASE 3] Executing All-in-One Deployment...${NC}"
    echo -e "${YELLOW}This process can take 5-15 minutes. Please do not close the terminal.${NC}"
    
    bash wazuh-install.sh -a
    
    if [ $? -eq 0 ]; then
        echo -e "\n${GREEN}[SUCCESS] Wazuh is now deployed.${NC}"
        get_passwords
    else
        echo -e "\n${RED}[FAIL] Deployment failed. Check /var/log/wazuh-install.log${NC}"
    fi
    read -p "Press Enter to return to menu..."
}

# --- STATUS CHECK ---
check_status() {
    echo -e "\n${BLUE}--- Current Service Status ---${NC}"
    systemctl status wazuh-manager --no-pager
    read -p "Press Enter to return to menu..."
}

# --- PASSWORD RETRIEVAL ---
get_passwords() {
    echo -e "\n${BLUE}--- Access Credentials ---${NC}"
    if [ -f "wazuh-install-files.tar" ]; then
        sudo tar -axf wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt -O | grep -E "admin|User"
        echo -e "\n${YELLOW}Access URL:${NC} https://localhost"
    else
        echo -e "${RED}[!] Password file not found. Ensure installation was successful.${NC}"
    fi
    read -p "Press Enter to return to menu..."
}

# --- MAIN EXECUTION ---
check_privileges

while true; do
    show_menu
    read choice
    case $choice in
        1) install_wazuh ;;
        2) check_status ;;
        3) get_passwords ;;
        4) exit 0 ;;
        *) echo -e "${RED}Invalid selection.${NC}"; sleep 1 ;;
    esac
done
