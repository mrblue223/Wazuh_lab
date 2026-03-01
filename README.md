# Wazuh SOC-Defender Automated Deployment 🛡️

A professional-grade Bash utility designed to automate the installation and configuration of the **Wazuh Security Stack (v4.10.3)**. This script is optimized for SOC Lab environments where resource management and deployment consistency are critical.

## 📋 Project Overview
This project provides a "single-command" deployment solution that handles the Wazuh Indexer, Server, and Dashboard. It ensures that the core analysis engines—including `wazuh-analysisd` and `wazuh-logcollector`—are verified and active upon completion.



---

## 🚀 Deployment Instructions

### Prerequisites
* **System**: Ubuntu 22.04+ (Noble/Jammy).
* **Privileges**: Root/Sudo access (enforced by script).
* **Network**: Active internet connection (Bridge or NAT).

### Usage
1. **Download Repo**:
```bash
sudo https://github.com/mrblue223/Wazuh_lab.git
```

2. **Make it executable:**
```bash
sudo chmod +x setup_wazuh.sh
```
3. **Execute with sudo:**
```bash
sudo ./deploy_wazuh.sh
```

## 🛠️ Common Errors and Fixes

| Symptom / Error | Root Cause | Resolution |
| :--- | :--- | :--- |
| `Unit wazuh-dashboard.service could not be found` | The service is not registered until the very end of the installation. | **Wait for the log finish line.** Monitor progress with `sudo tail -f /var/log/wazuh-install.log`. |
| **Download is extremely slow or "stuck"** | High network latency or hotspot throttling. | Check real-time throughput: `watch -n 2 "ip -s link show enp0s8 \| grep -A 1 RX"`. |
| **System Load Average > 7.0** | Intensive CPU usage during package unpacking and Java/Node.js optimization. | This is normal for single-node installs. Ensure the VM has at least 2 cores and 4GB RAM. |
| **Dashboard "Not Ready" in browser** | The service is running, but internal plugins are still initializing. | Wait 3–5 minutes after the service starts before attempting to log in. |

---

## 💡 Helpful Commands Reference

### 1. Wazuh Service Management
* **Check all internal daemons**: `sudo /var/ossec/bin/wazuh-control status`
* **Check high-level system services**: `systemctl status wazuh-manager wazuh-indexer wazuh-dashboard --short`
* **Restart the Manager core**: `sudo /var/ossec/bin/wazuh-control restart`

### 2. Live Monitoring & Logs
* **Follow installation progress**: `sudo tail -f /var/log/wazuh-install.log`
* **View real-time engine alerts**: `sudo tail -f /var/ossec/logs/alerts/alerts.log`
* **Monitor system resources**: `top` or `htop`

### 3. Network & Connectivity
* **Check IP/Interface status**: `ip a` or `ip -s link`
* **Test external connectivity**: `ping -c 4 google.com`
* **Verify Dashboard is listening (Port 443)**: `sudo ss -tulpn | grep 443`

### 4. Configuration Checks
* **Test Manager config for errors**: `sudo /var/ossec/bin/wazuh-analysisd -t`
* **Verify Filebeat connection**: `filebeat test output`
