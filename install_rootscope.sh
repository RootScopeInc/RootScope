#!/usr/bin/env bash

set -e

if [ ! -f /etc/os-release ]; then
    echo "Cannot detect OS (missing /etc/os-release)"
    exit 1
fi

. /etc/os-release

VERSION_CLEAN=$(echo "$VERSION_ID" | cut -d'.' -f1)

case "$ID-$VERSION_CLEAN" in
    debian-12)  PKG="rootscope_1.1.5-1.debian12_amd64.deb";;
    debian-11)  PKG="rootscope_1.1.5-1.debian11_amd64.deb";;
    ubuntu-22)  PKG="rootscope_1.1.5-1.ubuntu22.04_amd64.deb";;
    ubuntu-24)  PKG="rootscope_1.1.5-1.ubuntu24.04_amd64.deb";;
    ubuntu-25)  PKG="rootscope_1.1.5-1.ubuntu25.04_amd64.deb";;
    *)
        echo "Unsupported OS: $ID $VERSION_ID"
        exit 1
        ;;
esac

URL="https://github.com/RootScopeInc/RootScope/releases/download/1.1.5/$PKG"

echo "Detected: $PRETTY_NAME"
echo -e "Downloading $PKG...\n"

if command -v curl > /dev/null 2>&1; then
    curl -L -o "$PKG" "$URL"
elif command -v wget > /dev/null 2>&1; then
    wget -O "$PKG" "$URL"
else
    echo "Neither 'curl' nor 'wget' is installed. Please install one of them and retry this script."
    echo "    sudo apt install curl"
    exit 1
fi

echo "Installing RootScope..."
sudo apt install -y ./"$PKG"
