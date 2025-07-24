#!/bin/bash

set -e

echo "Systemaktualisierung und Installation notwendiger Pakete..."
sudo apt update
sudo apt install -y git dkms build-essential linux-headers-$(uname -r)

echo "Klonen des Treibers von GitHub..."
if [ ! -d rtl8192eu-linux-driver ]; then
  git clone https://github.com/Mange/rtl8192eu-linux-driver.git
fi
cd rtl8192eu-linux-driver

echo "DKMS-Modul hinzufügen und installieren..."
sudo dkms add .
sudo dkms install rtl8192eu/1.0

echo "Kernel-Modul rtl8xxxu deaktivieren..."
echo "blacklist rtl8xxxu" | sudo tee /etc/modprobe.d/rtl8xxxu.conf

echo "Installation abgeschlossen. System wird in 5 Sekunden neu gestartet..."
sleep 5
sudo reboot
