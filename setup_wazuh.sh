#!/bin/bash

# ==============================================================================
# SOCDefender Professional Wazuh Deployment Script
# Targeted Version: 4.10.3
# ==============================================================================

# 1. ENSURE SUDO PRIVILEGES
if [[ $EUID -ne 0 ]]; then
   echo -e "\e[31m[ERROR] This script must be run as root (sudo).\e[0m"
   exit 1
fi

# 2. PROFESSIONAL WARNING BLOCK
echo -e "\e[31m"
echo "######################################################################"
echo "# WARNING: CRITICAL SYSTEM MODIFICATION                              #"
echo "# ------------------------------------------------------------------ #"
echo "# This script will download ~500MB of data and install the full      #"
#
echo "# Wazuh Security Stack. This involves modifying system repositories, #"
#
echo "# generating SSL certificates, and binding network services.         #"
echo "######################################################################"
echo -e "\e[0m"

read -p "Do you wish to proceed with the deployment? (y/n): " PROCEED
if [[ $PROCEED != "y" ]]; then
    echo "Deployment aborted by user."
    exit 1
fi

# 3. COLLECT ENVIRONMENT VARIABLES
echo -e "\n--- Configuration Interface ---"
read -p "Enter Target IP for Wazuh Dashboard (e.g., 10.0.2.15): " VM_IP
#
read -p "Enter Secure Admin Password: " ADMIN_PWD

# 4. PRE-FLIGHT CHECKS
echo "[*] Validating network connectivity..."
# Using a small ping to verify the hotspot is active
if ! ping -c 1 google.com &> /dev/null; then
    echo -e "\e[31m[ERROR] No internet connection detected. Check your hotspot.\e[0m"
    exit 1
fi

# 5. CORE INSTALLATION LOGIC
echo "[*] Retrieving Wazuh Installation Assistant..."
curl -sO https://packages.wazuh.com/4.x/wazuh-install.sh
curl -sO https://packages.wazuh.com/4.x/config.yml

echo "[*] Hardening configuration with target IP: $VM_IP"
# This ensures the dashboard binds to the correct interface
sed -i "s/<indexer-node-ip>/$VM_IP/g" config.yml
sed -i "s/<wazuh-manager-ip>/$VM_IP/g" config.yml
sed -i "s/<dashboard-node-ip>/$VM_IP/g" config.yml

echo "[*] Initiating Unattended Installation Mode..."
# Executing full stack with custom password
bash wazuh-install.sh -a -p "$ADMIN_PWD"

# 6. POST-INSTALLATION VALIDATION
echo -e "\n--- Post-Install Service Audit ---"
# Verifying core engine status after script completion
/var/ossec/bin/wazuh-control status

echo -e "\n\e[32m[SUCCESS] Wazuh Deployment Complete.\e[0m"
echo "Access URL: https://$VM_IP"
echo "Credentials: admin / $ADMIN_PWD"
