#!/usr/bin/env bash
set -euo pipefail

die() {
    echo "Error: $*" >&2
    exit 1
}

if [ ! -f /etc/os-release ]; then
    die "Cannot detect OS (missing /etc/os-release)"
fi

. /etc/os-release

OS_PRETTY="${PRETTY_NAME:-${NAME:-unknown} ${VERSION_ID:-unknown}}"

VERSION_CLEAN="$(echo "${VERSION_ID:-}" | cut -d'.' -f1)"
PKG_DIST=""

case "${ID:-}-${VERSION_CLEAN}" in
    debian-12)  PKG_DIST="debian12" ;;
    debian-11)  PKG_DIST="debian11" ;;
    ubuntu-22)  PKG_DIST="ubuntu22.04" ;;
    ubuntu-24)  PKG_DIST="ubuntu24.04" ;;
    ubuntu-25)  PKG_DIST="ubuntu25.04" ;;
    rhel-*|rocky-*|ol-*|fedora-*)
        die "RPM-based distro detected (${OS_PRETTY}). RPM packages not supported yet (planned: RHEL/Rocky/Oracle)."
        ;;
    *)
        die "Unsupported OS: ${ID:-unknown} ${VERSION_ID:-unknown}"
        ;;
esac

DOWNLOAD_TOOL=""
if command -v curl >/dev/null 2>&1; then
    DOWNLOAD_TOOL="curl"
elif command -v wget >/dev/null 2>&1; then
    DOWNLOAD_TOOL="wget"
else
    die "Neither 'curl' nor 'wget' is installed. Install one and retry (e.g., sudo apt install curl)."
fi

fetch() {
    local url="$1"
    if [ "$DOWNLOAD_TOOL" = "curl" ]; then
        curl -fsSL "$url"
    else
        wget -qO- "$url"
    fi
}

API_URL="https://api.github.com/repos/RootScopeInc/RootScope/releases/latest"

LATEST_TAG=""
if command -v jq >/dev/null 2>&1; then
    LATEST_TAG="$(fetch "$API_URL" | jq -r '.tag_name')"
else
    echo "Warning: 'jq' not found; falling back to grep parsing." >&2
    LATEST_TAG="$(fetch "$API_URL" | grep -oP '"tag_name"\s*:\s*"\K[^"]+')"
fi

[ -n "$LATEST_TAG" ] || die "Failed to determine latest release tag from GitHub API."

PKG="rootscope_${LATEST_TAG}-1.${PKG_DIST}_amd64.deb"
URL="https://github.com/RootScopeInc/RootScope/releases/download/${LATEST_TAG}/${PKG}"

echo "Detected: ${OS_PRETTY}"
echo
echo "Downloading ${PKG}..."
if [ "$DOWNLOAD_TOOL" = "curl" ]; then
    curl -fL -o "$PKG" "$URL"
else
    wget -O "$PKG" "$URL"
fi

echo "Installing RootScope..."
sudo apt install -y "./$PKG"
