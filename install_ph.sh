#!/bin/bash

set -e

GITHUB_RAW="https://raw.githubusercontent.com/PavelTajdus/instalace-wifi-skriptu-s-ph/main"
WORK_DIR="/home/printerhive"

# Vytvoření pracovního adresáře
sudo mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

# 1. Aktualizace systému
sudo apt update
sudo apt upgrade -y

# 2. Instalace potřebných balíčků
sudo apt install -y hostapd dnsmasq iptables python3 python3-flask git libmicrohttpd-dev build-essential unzip wget curl libjson-c-dev

# 3. Instalace nodogsplash
cd /home/printerhive
if [ ! -d "nodogsplash" ]; then
  git clone https://github.com/nodogsplash/nodogsplash.git
fi
cd nodogsplash
make
sudo make install

# 4. (Volitelně) Přidání systemd služby pro nodogsplash
if [ -f debian/nodogsplash.service ]; then
  sudo cp debian/nodogsplash.service /lib/systemd/system/
  sudo systemctl enable nodogsplash.service
fi

# 5. Stažení a rozbalení konfiguračních souborů
ZIP_FILE="$WORK_DIR/printerhive_files.zip"
TEMP_DIR="$WORK_DIR/printerhive_temp"

echo "Stahuji konfigurační soubory..."
wget -O "$ZIP_FILE" "$GITHUB_RAW/printerhive_files.zip"

mkdir -p "$TEMP_DIR"
unzip -o "$ZIP_FILE" -d "$TEMP_DIR"
sudo cp -r "$TEMP_DIR/etc/"* /etc/
sudo cp -r "$TEMP_DIR/home/"* /home/
rm -rf "$TEMP_DIR"

# 6. Nastavení práv a povolení služeb
sudo chmod +x /home/printerhive/network_check.sh
sudo systemctl enable wifi-mode-switch.service
sudo systemctl enable wifi-backend.service
sudo systemctl unmask hostapd

# 7. Instalace PrinterHive klienta
echo "Instaluji PrinterHive klienta..."
curl -o /tmp/install-printerhive.sh https://app.printerhive.com/install && bash /tmp/install-printerhive.sh

echo "Instalace dokončena."
