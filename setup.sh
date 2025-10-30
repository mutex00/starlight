#!/usr/bin/env bash
set -euo pipefail

# Install system dependencies required for Rust and Zola if they are missing
if command -v apt-get >/dev/null 2>&1; then
  if command -v sudo >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y curl build-essential pkg-config libssl-dev
  else
    apt-get update
    apt-get install -y curl build-essential pkg-config libssl-dev
  fi
fi

# Install Rust (cargo) if it is not already available
if ! command -v cargo >/dev/null 2>&1; then
  curl https://sh.rustup.rs -sSf | sh -s -- -y
  # shellcheck disable=SC1091
  source "$HOME/.cargo/env"
fi

# Ensure cargo is available in the current shell
if [ -f "$HOME/.cargo/env" ]; then
  # shellcheck disable=SC1091
  source "$HOME/.cargo/env"
fi

# Install Zola via cargo if it is not installed. Fallback to official binaries if cargo install fails.
if ! command -v zola >/dev/null 2>&1; then
  if ! cargo install zola --locked; then
    echo "Failed to install Zola via cargo, attempting to download a prebuilt binary." >&2
    ZOLA_VERSION="${ZOLA_VERSION:-0.21.0}"
    ARCH="$(uname -m)"
    case "$ARCH" in
      x86_64)
        TARGET="x86_64-unknown-linux-gnu"
        ;;
      aarch64|arm64)
        TARGET="aarch64-unknown-linux-gnu"
        ;;
      *)
        echo "Unsupported architecture: $ARCH" >&2
        exit 1
        ;;
    esac

    TMPDIR="$(mktemp -d)"
    TARBALL="zola-v${ZOLA_VERSION}-${TARGET}.tar.gz"
    URL="https://github.com/getzola/zola/releases/download/v${ZOLA_VERSION}/${TARBALL}"
    if command -v curl >/dev/null 2>&1; then
      curl -fsSL "$URL" -o "$TMPDIR/$TARBALL"
    elif command -v wget >/dev/null 2>&1; then
      wget -q "$URL" -O "$TMPDIR/$TARBALL"
    else
      echo "Neither curl nor wget is available to download Zola." >&2
      exit 1
    fi

    tar -xzf "$TMPDIR/$TARBALL" -C "$TMPDIR"
    mkdir -p "$HOME/.cargo/bin"
    install -m 755 "$TMPDIR/zola" "$HOME/.cargo/bin/zola"
    rm -rf "$TMPDIR"
  fi
fi

echo "Rust and Zola are installed. You may need to add \"$HOME/.cargo/bin\" to your PATH."
