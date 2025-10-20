#!/usr/bin/env bash

set -e

if [ ! -f /etc/os-release ]; then
    echo "Cannot detect OS (missing /etc/os-release)"
    exit 1
fi

. /etc/os-release

VERSION_CLEAN=$(echo "$VERSION_ID" | cut -d'.' -f1)
PKG_DIST=""

case "$ID-$VERSION_CLEAN" in
    debian-12)  PKG_DIST="debian12";;
    debian-11)  PKG_DIST="debian11";;
    ubuntu-22)  PKG_DIST="ubuntu22.04";;
    ubuntu-24)  PKG_DIST="ubuntu24.04";;
    ubuntu-25)  PKG_DIST="ubuntu25.04";;
    *)
        echo "Unsupported OS: $ID $VERSION_ID"
        exit 1
        ;;
esac

LATEST_TAG=$(curl -s https://api.github.com/repos/RootScopeInc/RootScope/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
PKG="rootscope_${LATEST_TAG}-1.${PKG_DIST}_amd64.deb"
URL="https://github.com/RootScopeInc/RootScope/releases/download/$LATEST_TAG/$PKG"

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
