#!/bin/bash

set -e

echo "Aktualisiere Paketquellen und aktiviere contrib und non-free-firmware..."

# Prüfe, ob contrib und non-free-firmware schon in sources.list sind, wenn nicht, füge sie hinzu
if ! grep -q "contrib" /etc/apt/sources.list || ! grep -q "non-free-firmware" /etc/apt/sources.list; then
  echo "Füge contrib und non-free-firmware zu /etc/apt/sources.list hinzu..."

  sudo sed -i.bak -r 's/^(deb [^ ]+ [^ ]+)( main)(.*)$/\1 main contrib non-free-firmware\3/' /etc/apt/sources.list

  echo "Backup der originalen sources.list in /etc/apt/sources.list.bak erstellt."
else
  echo "contrib und non-free-firmware sind bereits aktiviert."
fi

echo "Update der Paketliste..."
sudo apt update

echo "Installiere firmware-atheros Paket..."
sudo apt install -y firmware-atheros

echo "Lade Kernel-Modul ath9k_htc..."
sudo modprobe ath9k_htc

echo "Prüfe, ob Modul geladen wurde:"
if lsmod | grep -q ath9k_htc; then
  echo "Modul ath9k_htc erfolgreich geladen."
else
  echo "Warnung: Modul ath9k_htc nicht geladen!"
fi

echo "Fertig! Stecke jetzt deinen TP-Link WLAN-Stick ein (falls noch nicht geschehen) und prüfe mit 'ip a' oder 'iwconfig', ob eine WLAN-Schnittstelle angezeigt wird."
