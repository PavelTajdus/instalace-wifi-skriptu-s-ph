# Instalace PrinterHive na Raspberry Pi

## Soubory

- [install_printerhive.sh](install_printerhive.sh)
- [printerhive_files.zip](printerhive_files.zip)

## Instalace

1. Přes Filezilla nahrajte oba soubory do home složky v RPI.

2. Spusťte instalační skript:

```bash
chmod +x install_printerhive.sh
sudo ./install_printerhive.sh
```

3. Nainstalujte PrinterHive klienta:

```bash
curl -o install-printerhive.sh https://app.printerhive.com/install && bash install-printerhive.sh
```
