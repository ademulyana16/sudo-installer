#!/bin/bash

set -e

SUDO_VERSION="1.9.17p1"
SUDO_TAR="sudo-${SUDO_VERSION}.tar.gz"
SUDO_URL="https://www.sudo.ws/dist/${SUDO_TAR}"

echo "[+] Deteksi distro Linux..."
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "[-] Tidak dapat mendeteksi distro Linux."
    exit 1
fi

echo "[+] Update & install dependencies..."
if [[ "$DISTRO" == "ubuntu" || "$DISTRO" == "debian" ]]; then
    sudo apt update
    sudo apt install -y build-essential libpam0g-dev libldap2-dev libssl-dev wget
elif [[ "$DISTRO" == "centos" || "$DISTRO" == "rhel" || "$DISTRO" == "fedora" || "$DISTRO" == "rocky" ]]; then
    sudo dnf groupinstall -y "Development Tools" || sudo yum groupinstall -y "Development Tools"
    sudo dnf install -y pam-devel openldap-devel openssl-devel wget || sudo yum install -y pam-devel openldap-devel openssl-devel wget
else
    echo "[-] Distro tidak didukung oleh script ini."
    exit 1
fi

echo "[+] Download sudo ${SUDO_VERSION}..."
wget ${SUDO_URL}
tar -xzf ${SUDO_TAR}
cd sudo-${SUDO_VERSION}

echo "[+] Kompilasi dan instal sudo ${SUDO_VERSION}..."
./configure
make
sudo make install

echo "[+] Verifikasi versi sudo..."
sudo -V

echo "[✓] Instalasi sudo ${SUDO_VERSION} selesai!"
