#!/usr/bin/env bash
set -euo pipefail

mode="${1:-noskia}"

install_deps() {
  if ! command -v apt-get >/dev/null 2>&1; then
    echo "apt-get not found. Please install dependencies manually."
    exit 1
  fi

  sudo apt-get update
  sudo apt-get install -y \
    build-essential \
    cmake \
    ninja-build \
    libfreetype6-dev \
    libpng-dev \
    libtinyxml2-dev
}

case "$mode" in
  core)
    preset="linux-core-rel"
    ;;
  vcpkg)
    preset="linux-vcpkg-rel"
    if [[ -z "${VCPKG_ROOT:-}" ]]; then
      echo "VCPKG_ROOT is not set. Export it before using vcpkg mode."
      exit 1
    fi
    ;;
  noskia)
    preset="linux-no-skia-rel"
    ;;
  install)
    install_deps
    exit 0
    ;;
  *)
    echo "Usage: $0 [core|vcpkg|noskia|install]"
    exit 2
    ;;
esac

cmake --preset "$preset"
cmake --build --preset "$preset" -j
