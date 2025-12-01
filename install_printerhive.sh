#!/bin/bash

set -e

# 1. Aktualizace systému
sudo apt update
sudo apt upgrade -y

# 2. Instalace potřebných balíčků
sudo apt install -y hostapd dnsmasq iptables python3 python3-flask git libmicrohttpd-dev build-essential unzip

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

# 5. Rozbalení a přesun konfiguračních souborů (pokud je ZIP archiv)
ZIP_FILE=/home/printerhive/printerhive_files.zip
TEMP_DIR=/home/printerhive/printerhive_temp

if [ -f "$ZIP_FILE" ]; then
  mkdir -p "$TEMP_DIR"
  unzip -o "$ZIP_FILE" -d "$TEMP_DIR"
  sudo cp -r "$TEMP_DIR/etc/"* /etc/
  sudo cp -r "$TEMP_DIR/home/"* /home/
  rm -rf "$TEMP_DIR"
fi

# 6. Nastavení práv a povolení služeb
sudo chmod +x /home/printerhive/network_check.sh
sudo systemctl enable wifi-mode-switch.service
sudo systemctl enable wifi-backend.service
sudo systemctl unmask hostapd

echo "Instalace dokončena."
