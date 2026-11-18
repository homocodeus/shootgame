#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

fail() {
  printf '\n%s\n' "$1"
  read -r -p 'Press Return to close...' || true
  exit 1
}
trap 'fail "Startup failed. See the error above."' ERR

case "$(uname -m)" in
  arm64) arch=arm64 ;;
  x86_64) arch=x64 ;;
  *) fail 'Unsupported Mac architecture.' ;;
esac

version=v2026.4
folder="goose-${version}-macos-${arch}"
runtime="$PWD/.tools/mac/$folder"
compiler="$runtime/goose"

if [[ ! -x "$compiler" ]]; then
  printf 'Downloading Goose for macOS (%s)...\n' "$arch"
  mkdir -p "$PWD/.tools/mac"
  archive="$PWD/.tools/mac/$folder.tar.gz"
  curl --fail --location --retry 3 "https://github.com/aardappel/goose/releases/download/$version/$folder.tar.gz" --output "$archive"
  tar -xzf "$archive" -C "$PWD/.tools/mac"
  [[ -f "$compiler" ]] || fail "Compiler was not found at $compiler"
  chmod +x "$compiler"
fi

printf 'Starting Star Guard...\n'
"$compiler" run "$PWD/main.goose"
printf '\nGame closed.\n'
read -r -p 'Press Return to close...' || true
