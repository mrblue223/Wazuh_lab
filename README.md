# 🛡️ Wazuh-Lab-Orchestrator (MIRS-WAZUH)

**Developed by:** mrblue
**Version:** 2.0.0  
**Target Environment:** Kali Linux / Debian-based Research Labs
**NOTE:** This sript is made for technical, and non technical people to faciliate the use of installing a SIEM whcih can be quite a tedious process.
---

## 📝 Description
The **Wazuh-Lab-Orchestrator** is a simplified, menu-driven deployment utility designed to automate the installation of a full Wazuh central stack. This tool was built to support advanced security research, including APT attack chain simulation, network segmentation monitoring, and integration with tools like **Suricata** and **Wazuh EDR**.

It is specifically designed to be "junior-friendly," allowing non-technical users or students to deploy a professional-grade SIEM/XDR environment with a single command.

---

## 🚀 Features
* **All-in-One Deployment:** Installs the Wazuh Indexer, Server, and Dashboard automatically.
* **Interactive Menu:** Easy-to-use interface for installation, status monitoring, and credential recovery.
* **Dependency Management:** Automatically handles `curl`, `tar`, and permission checks.
* **Lab-Ready:** Ideal for environments involving **TryHackMe** practice, **CEH v13 AI** study, and **Cybersecurity AEC** coursework.

---

## 💻 Installation & Usage

### 1. Create the Script
Ensure you are on a Debian-based system (Kali Linux is recommended).

```bash
nano Wazuh-Lab-Orchestrator.sh
# Paste the script content and save (Ctrl+O, Enter, Ctrl+X)
```

### 2. Set Permissions
```bash
chmod +x Wazuh-Lab-Orchestrator.sh
```

### 3. Run the Orchestrator
```bash
sudo ./Wazuh-Lab-Orchestrator.sh
```

## 🛠️ Menu Options
- **Full Installation:** Downloads the Wazuh assistant and executes a complete unattended installation.
- **Check Status:** Verifies if the wazuh-manager service is active and running.
- **Retrieve Passwords:** Extracts the auto-generated admin credentials from the installation archive.
- **Exit:** Safely exits the orchestrator.

## ⚠️ Requirements & Warnings
- **Hardware:** Minimum 4GB RAM (8GB+ recommended for lab stability).
- **Permissions:** Requires Root/Sudo privileges to modify system services and network sockets.
- **Connectivity:** Requires an active internet connection to fetch the latest Wazuh packages.


